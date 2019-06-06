function [ sigRefOut, sigTestOut ] = pemoq_preproc_signalpair( sigRef, sigTest, FS, removeSilence, sync, normalizeReference)
%[ sigRefInternal, sigTestInternal] = pemoq_preproc_signalpair(sigRef, sigTest, FS)
%   Preprocess tested signal pair in time and level for PEMO-Q method of objective audio quality evalutation.
%   Always returns twi signals of the same length in samples (shortened to the length of shortest signal) aligned in overall RMS level
%   
%   [ sigRefInternal, sigTestInternal] = pemoq_preproc_signalpair(sigRef, sigTest, FS)
%       sigRef: one channel (vector of double values) of reference audio
%       sigTest: one channel (vector of double values) of tested (degraded) audio
%       FS: common sampling frequency of both signals
%
%   pemoq_preproc_signalpair(___, removeSilence, sync, normalizeReference)
%       removeSilence: [ true (default) | false] -> shorten parts under hearing treshold (-70 dBFS) to max 200 ms
%       sync: [ true (default) | false ] -> attemt to synchronize passed signals using cross correlation of both signals
%       normalizeReference: [ true (default) | false ] -> normalize reference signal (prior to signal levels alingments) to max amplitude value of 1 
%                                                           (reults to boosting of simple sinusiodal signal to -3 dBFS, rectangular pulse signal with duty cycle of 50%  to 0 dBFS)
%   
%
%   author:     Jan Novák, novak110@fel.cvut.cz, officialjannovak@gmail.com
%

    narginchk(3, 6);
    if ~(isnumeric(sigRef) && isnumeric(sigTest))
       error('Inputs must be numeric vectors'); 
    end
    if ~(isvector(sigRef) && isvector(sigTest))
        error('Inputs must be numeric vectors'); 
    end

    if nargin < 6
        normalizeReference = true;
    end
    if nargin < 5
        sync = true;
    end
    if nargin < 4
        removeSilence = true;
    end

    FS = double(FS);    % explicitly ensure proper double precision arithmetic operations
    
    sigRefTemp = sigRef;
    sigTestTemp = sigTest;
    
    % ---------------------------------------------------------------------------------------------
    % BASIC LEVEL ALIGNMENT
    % requires 'Signal Processing Toolbox' component installed
       
    NORMALIZE_REF = logical(normalizeReference);
    [sigRefTemp, sigTestTemp] = alignRMStoFirst(sigRefTemp, sigTestTemp, NORMALIZE_REF);
    
    
    % ---------------------------------------------------------------------------------------------
    % SIMPLE TIME ALIGNMENT
    % requires 'Signal Processing Toolbox' component installed
    % does NOT handle nonuniformly stretched signals

    if (sync || removeSilence)
        [sigRefTemp, sigTestTemp] = alignsignals(sigRefTemp, sigTestTemp, [], 'truncate');
    end

    if length(sigRefTemp) < length(sigTestTemp)
        sigTestTemp = sigTestTemp(1:length(sigRefTemp));
    elseif length(sigRefTemp) > length(sigTestTemp)
        sigRefTemp = sigRefTemp(1:length(sigTestTemp));
    end
    
    
    % ---------------------------------------------------------------------------------------------
    % ADVANCED LEVEL ALINGMENT
    NORMALIZE_REF = 1;
    [sigRefTemp, sigTestTemp] = alignRMStoFirstsMedian(sigRefTemp, sigTestTemp, NORMALIZE_REF);
    
    
    % ---------------------------------------------------------------------------------------------
    % SHORTEN PAUSES
  
    if (removeSilence)
        HEARING_THRESHOLD_DB = -70;
        HEARING_THRESHOLD = 10.^(HEARING_THRESHOLD_DB / 20);
        [sigRefTemp, sigTestTemp] = shortenPauses(sigRefTemp, sigTestTemp, FS, HEARING_THRESHOLD);
    end
    
    % ---------------------------------------------------------------------------------------------
    % FINAL ADVANCED LEVEL ALINGMENT
    NORMALIZE_REF = 1;
    [sigRefTemp, sigTestTemp] = alignRMStoFirstsMedian(sigRefTemp, sigTestTemp, NORMALIZE_REF);
    
    
    
    sigRefOut = sigRefTemp;
    sigTestOut = sigTestTemp;
    
    % output validation
    mustBeNonNan(sigRefOut); mustBeNonNan(sigTestOut);
    mustBeFinite(sigRefOut); mustBeFinite(sigTestOut);
    
end


function [sig1, sig2] = shortenPauses(sig1, sig2, fs, HEARING_THRESHOLD)
% shorten passages below HEARING_THRESHOLD to about 200ms
    
    % preffered chunk time is 10 ms, but let's operate on next closest power of two of samples
    chunkSize = 2.^(nextpow2(ceil(0.01 * fs)));     

    % first, construct maps of RMS values in chunks and create map of common chunks with RMS below threshold for both 
    % signals
    [sig1, sig1RMSMap] = mapRMS(sig1, chunkSize);
    [sig2, sig2RMSMap] = mapRMS(sig2, chunkSize);
    
    sig1PauseMap = sig1RMSMap <= HEARING_THRESHOLD;
    sig2PauseMap = sig2RMSMap <= HEARING_THRESHOLD;
    
    commonPauseMap = and(sig1PauseMap, sig2PauseMap);
    
    % next, identify, which parts of silence are longer than 200 ms and mark them for deletion
    chunkTime = chunkSize/fs;
    minNumConsecChunks = ceil(0.200/chunkTime);
    chunkToDelMap = zeros(1, length(commonPauseMap));
    for k = 1:(length(commonPauseMap) - minNumConsecChunks + 1)
        % detect if current chunk + minNumChunks forward are pauses
        if commonPauseMap(k:k + minNumConsecChunks - 1)
            %if all forward chunks are pauses, mark them to be deleted
            chunkToDelMap(k:k + minNumConsecChunks - 1) = 1;
        else
            % if all following chunks are not pauses, do not mark anything for removal
            chunkToDelMap(k:k + minNumConsecChunks - 1) = 0;
        end
    end
    
    % detect trailing silence to remove it as well
    k = 0;
    while commonPauseMap(length(commonPauseMap) - k)
        chunkToDelMap(length(commonPauseMap) - k) = 1;
        k = k + 1;
    end
       
    % shorten both signals
    m = 1;
    n = chunkSize;
    sig1Final = zeros(1, (length(chunkToDelMap) - sum(chunkToDelMap)) * chunkSize);
    sig2Final = zeros(1, (length(chunkToDelMap) - sum(chunkToDelMap)) * chunkSize);
    for k = 1:length(chunkToDelMap)
        if ~chunkToDelMap(k)
            sig1Final(m:n) = sig1(((k - 1) * chunkSize + 1):(k * chunkSize));
            sig2Final(m:n) = sig2(((k - 1) * chunkSize + 1):(k * chunkSize));
            
            m = m + chunkSize;
            n = n + chunkSize;
        end        
    end
    
    sig1 = sig1Final;
    sig2 = sig2Final;
    
end


function [lenghtenedSig, rmsMAP] = mapRMS(sig, chunkSize)
% produce map of RMS values of sig in time and lenghtens sig to be a multiple of chunkSize long, assumes vector as input

    norm_length = ceil(length(sig)/chunkSize) * chunkSize;
    sig = [sig, zeros(1, norm_length - length(sig))];
    rmsMAP = zeros(1, length(sig)/chunkSize);
    for k = 1:length(rmsMAP)
        chunk = sig((1 + ((k-1) * chunkSize)):(k * chunkSize));
        chunkRMS = sqrt(sum(chunk.^2) ./ length(chunk));
        rmsMAP(k) = chunkRMS;        
    end
    
    % output validation
    mustBeNonNan(rmsMAP);
    mustBeFinite(rmsMAP);
    
    lenghtenedSig = sig;
    
end


function [sig1, sig2] = alignRMStoFirst(sig1, sig2, normalize)
% get average RMS values of both signals and scale sig2 to match sig1's RMS
    narginchk(2,3);
    if nargin < 3
        normalize = 0;
    end
    
    sig1 = sig1(:)'; % make always row vector
    sig2 = sig2(:)'; % make always row vector
    
    if normalize
       sig1 = sig1 ./ max(abs(sig1)); 
    end
        
    rmsS1 = sqrt(sum(sig1.^2)/length(sig1));
    rmsS2 = sqrt(sum(sig2.^2)/length(sig2));
    sig2 = sig2 .* (rmsS1 / rmsS2);
end


function [sig1, sig2] = alignRMStoFirstsMedian(sig1, sig2, normalize, chunk_length)
    narginchk(2,4);
    if nargin < 3
        normalize = 0;
    end
    if nargin < 4
        chunk_length = 1024;
    end
    
    if ~(length(sig1) == length(sig2))
       error('Input signals for level alignment based on RMS median have to be of the SAME length!'); 
    end
    
    sig1 = sig1(:)'; % make always row vector
    sig2 = sig2(:)'; % make always row vector
    
    if normalize
       sig1 = sig1 ./ max(abs(sig1)); 
    end
    
    
    % make num of signal samples a multiple of 1024 (or chunk_length)
    new_length = ceil(length(sig1)/chunk_length)*chunk_length;
    zeros_to_add = new_length - length(sig1);
    
    sig1 = [sig1, zeros(1, zeros_to_add)];
    sig2 = [sig2, zeros(1, zeros_to_add)];
    
    
    sig1RMSVals = zeros(1, length(sig1)/chunk_length);
    for k = 1:length(sig1RMSVals)
       chunk =  sig1( (1 + (k-1)*chunk_length): (k * chunk_length));
       chunkRMS = sqrt(sum(chunk.^2)/length(chunk));
       sig1RMSVals(k) = chunkRMS;        
    end
    medianRMSsig1 = median(sig1RMSVals);
    
    
    sig2RMSVals = zeros(1, length(sig1)/chunk_length);
    for k = 1:length(sig2RMSVals)
       chunk =  sig2( (1 + (k-1)*chunk_length): (k * chunk_length));
       chunkRMS = sqrt(sum(chunk.^2)/length(chunk));
       sig2RMSVals(k) = chunkRMS;        
    end
    medianRMSsig2 = median(sig2RMSVals);
    
    
    
    sig2 = sig2 .* (medianRMSsig1 / medianRMSsig2);
end