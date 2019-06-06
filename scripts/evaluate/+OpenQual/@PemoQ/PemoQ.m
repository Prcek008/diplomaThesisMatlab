classdef PemoQ < OpenQual.EvaluationMethod
% PEMO-Q model representation
%
%   author:     Jan Nov�k (novak110@fel.cvut.cz, officialjannovak@gmail.com)
%

    properties (Constant, GetAccess = public)
        methodName@OpenQual.Methods scalar = OpenQual.Methods.Pemoq;
        requiresAuditoryModel@logical scalar = true;
        acceptedAuditoryModels = {OpenQual.Models.Pemo};
    end

    properties (SetAccess = protected, GetAccess = public)
        fs@double property;
        auditoryModel@OpenQual.AuditoryModel scalar;
        modelName@OpenQual.Models;
        model@OpenQual.AuditoryModel;
    end

    methods (Access = public)
        function obj = PemoQ(fs, varargin)
        % PEMOQ(fs) initialize PEMO-Q method with included human auditory model
        %   fs - sampling frequency used to initialize internal state of human auditory model
        %   PEMOQ(___, modelSpec)
        %       name-value pair 'Model', OpenQual.Models.<model_name> (PEMO is default)
        %       
            p = inputParser;
            addRequired(p, 'fs', @(x) (isnumeric(x) && isscalar(x) && (x > 0) && (uint64(x)==x)));
            addParameter(p, 'model', OpenQual.Models.Pemo);
            parse(p, fs, varargin{:});

            obj.fs = double(p.Results.fs);
            obj.modelName = p.Results.model;

            if obj.modelName == OpenQual.Models.Pemo
                obj.model = OpenQual.Pemo(obj.fs);
            else
                error('Could not construct auditory model, unknown model or invalid name: %s', class(obj.modelName));
            end
        end

        function [resultsContainerCell, internalRefCell, internalTestCell] = evalObjQuality(obj, refSig, testSig, varargin)
        % PEMOQ.EVALOBJQUALITY() Evalutate objective audio quality of passed signals
        %   [resultsContainerCell, internalRefCell, internalTestCell] = evalObjQuality(refSig, testSig)
        %       Evalutate objective audio quality of passed refSig and testSig (each channel of referenceSignal or testedSignal expected to be a column vector of reference/test signals)
        %   
        %   evalObjQuality(___, evalSpec)
        %       'refInternalSig' ... precomputed internal representation of reference signal processed by human auditory model to use
        %       'testfInternalSig' ... precomputed internal representation of tested signal processed by human auditory model to use
        %       'channels' ... vector of channel numbers to process (default = [ 1 ])
        %       'sync' [ true (defautl) | false ] ... sync signals in preprocessing stage using cross correlation
        %       'removeSilence' [ true (defautl) | false ] ... shorten parts in both signals that are below hearing threshold (-70 dBFS) to max 200 ms during preprocessing stage
        %       'normalizeReference' [true (default) | false ] ... normalize reference signal max value to 1 prior to preprocessing stage
        %       'resultsInterpretationStrategy' ... specify, how to interpret results if multiple channels defined for evaluation
        %               'worst' -> return only worst resutls
        %               'perChannel' (default) -> return cell array of results for each channel
        %               'downMix' -> trivialy downMix specified channels to one signal prior to evaluation (result amplitude = sum of amplitudes divided by num of channels in single time frime)
        %       'adaptLoopMax' -> specify higher limitation of adaptloop overshoot (default = 50)
        %       'adaptLoopMin' -> specify lower value of adaptloop limitation (threshold), default = 1e-5

            strategyOpt = struct('WORST', 'worst', 'PERCHANNEL', 'perChannel', 'DOWNMIX', 'downMix');
            
            p = inputParser;
            addRequired(p, 'referenceSignal', @(x) validateattributes(x, {'numeric'}, {'nonempty'}));
            addRequired(p, 'testedSignal', @(x) validateattributes(x, {'numeric'}, {'nonempty'}));
            addParameter(p, 'channels', 1, @(x) validateattributes(x, {'numeric'}, {'positive', 'integer'}));
            addParameter(p, 'resultsInterpretationStrategy', strategyOpt.WORST, @(x) any(validatestring(x, {strategyOpt.WORST, strategyOpt.PERCHANNEL, strategyOpt.DOWNMIX})));
            addParameter(p, 'sync', true, @(x) (x == logical(x)));
            addParameter(p, 'removeSilence', true, @(x) (x == logical(x)));
            addParameter(p, 'refInternalSig', {}, @(x) iscell(x));
            addParameter(p, 'testfInternalSig', {}, @(x) iscell(x));
            addParameter(p, 'adaptLoopMax', 50, @(x) validateattributes(x, {'numeric'}, {'positive'}));
            addParameter(p, 'adaptLoopMin', 1e-5, @(x) validateattributes(x, {'numeric'}, {'positive'}));
            addParameter(p, 'normalizeReference', true, @(x) (x == logical(x)));
            parse(p, refSig, testSig, varargin{:});

            refSig = p.Results.referenceSignal;
            testSig = p.Results.testedSignal;
            channels = p.Results.channels;
            strategy = p.Results.resultsInterpretationStrategy;
            sync = logical(p.Results.sync);
            removeSilence = logical(p.Results.removeSilence);
            refInternal = p.Results.refInternalSig;
            testInternal = p.Results.testfInternalSig;
            adaptLoopMax = p.Results.adaptLoopMax;
            adaptLoopMin = p.Results.adaptLoopMin;
            normalizeReference = p.Results.normalizeReference;


            if ~isempty(refInternal) || ~isempty(testInternal)
                sync = false;
                removeSilence = false;
            end

            if strcmpi(strategy, strategyOpt.DOWNMIX)
                refTemp = zeros(length(refSig), 1);
                testTemp = zeros(length(testSig), 1);
                
                for k = 1:length(channels)
                    refTemp = refTemp + refSig(:,channels(k));
                    testTemp = testTemp + testSig(:,channels(k));
                end

                refSig = refTemp ./ length(channels);
                testSig = testTemp ./ length(channels);
                channels = 1;
                strategy = strategyOpt.PERCHANNEL;
            end    

            if ~isempty(refInternal)
                [r, c] = size(refInternal);
                if r ~= length(channels)
                    error('Number of passed internal representations of reference signal has to corespond to number of channels to evaluate!');
                end
                if c ~= 1
                    error('Passed internal representation od reference signal has to be a cell array with exactly one column!');
                end
            end

            if ~isempty(testInternal)
                [r, c] = size(testInternal);
                if r ~= length(channels)
                    error('Number of passed internal representations of tested signal has to corespond to number of channels to evaluate!');
                end
                if c ~= 1
                    error('Passed internal representation od tested signal has to be a cell array with exactly one column!');
                end
            end

            resultsContainerCell = cell(length(channels), 1);
            internalRefCell = cell(length(channels), 1);
            internalTestCell = cell(length(channels), 1);

            for k = 1:length(resultsContainerCell)
                channelNum = channels(k);
                if (channelNum > size(refSig, 2)) || (channelNum > size(refSig, 2))
                    error('Channel #%d not found in given signals!', channels(k));
                end
                wRefSig = refSig(:, channelNum)';
                wTestSig = testSig(:, channelNum)';

                [preprocRef, preprocTest] = obj.pemoq_preproc_signalpair(wRefSig(:), wTestSig(:), obj.fs, removeSilence, sync, normalizeReference);  

                if isempty(refInternal)
                    % most expensive operation
                    internalRef = obj.model.processSignal(preprocRef, adaptLoopMax);
                else
                    internalRef = refInternal{k};
                end

                if isempty(testInternal)
                    % most expensive operation
                    internalTest = obj.model.processSignal(preprocTest, adaptLoopMax, adaptLoopMin);
                else
                    internalTest = testInternal{k};
                end

                quality = obj.objquality(internalTest, internalRef, length(preprocTest), obj.fs);

                resultsContainerCell{k} = quality;
                internalRefCell{k} = internalRef;
                internalTestCell{k} = internalTest;
            end

            if strcmpi(strategy, strategyOpt.WORST)
                resArray = cell2mat(resultsContainerCell);

                [minPSM, ~] = min([resArray.psm]);
                [minPSMt, index] = min([resArray.psmt]);
                [minODG, ~] = min([resArray.odg]);

                minPSMtSequence = resArray(index).psmtSeqence;

                resultsContainerCell = {struct('psm', minPSM, ...
                                               'psmt', minPSMt, ...
                                               'psmtSequence', minPSMtSequence, ...
                                               'odg', minODG)};

            elseif strcmpi(strategy, strategyOpt.PERCHANNEL)
                % do nothing, already have all results in resutlsContainerCell
            else
                % unknown strategy, that wasn't caught by input validation using input parser
                error('Unknown results interpretation strategy %s!', strategy);
            end
        end
    end
    
    methods (Static = true, Access = public)
        
        [ sigRefOut, sigTestOut ] = pemoq_preproc_signalpair( sigRef, sigTest, FS, removeSilence, sync, normalizeReference);
        quality = objquality(test_sig, ref_sig, test_sig_num_samples, FS);
        
        function rm_coeff = back_xcorrrm(ytf, xtf)
        %cross-korelace [PEMOQ]
        %
        %   author: Martin Zalab�k, FEL ?VUT (Czech Technical University in Prague)

            coeff1 = xtf-mean(xtf(:));
            coeff2 = ytf-mean(ytf(:));
            buf1 = coeff1.*coeff2;
            buf2 = coeff1.^2;
            buf3 = coeff2.^2;
            rm_coeff = sum(buf1(:))/sqrt(sum(buf2(:))*sum(buf3(:)));

        end

        
        function y = back_sqsumst(x, tlen)
        %suma kvadratu - short time ramcova verze
        %
        %   author: Martin Zalab�k, FEL ?VUT (Czech Technical University in Prague)

            flen = 0.01;
            y = zeros(1, ceil(tlen/flen));
            tbegin = 0;
            yi = 1;
            fs = size(x, 2)/tlen;

            while (tbegin<tlen)
                buf = x(:, floor(tbegin*fs+1):min(ceil((tbegin+flen)*fs+1), end));
                buf = buf(:).^2;
                y(yi) = sum(buf);
                tbegin = tbegin+flen;
                yi = yi+1;
            end

        end
        
        function y = back_sqsum(x)
        %BACK_SQSUM 
        % Returns sum of (each value squared)
        %
        %   author: Martin Zalabák, FEL ČVUT (Czech Technical University in Prague)

            buf = x.^2;
            y = sum(buf(:));

        end
                
        function y = back_iact(x, tlen)
        %BACK_IACT intermediate activity in 'tlen' long frame of signal 'x'
        %   
        %   author: Martin Zalab�k, FEL ?VUT (Czech Technical University in Prague)

            flen = 0.01;
            y = zeros(1, ceil(tlen/flen));
            tbegin = 0;
            yi = 1;
            fs = size(x, 2)/tlen;
            while (tbegin<tlen)
                buf = x(:, floor(tbegin*fs+1):min(ceil((tbegin+flen)*fs+1), end));
                buf = buf(:);
                y(yi) = sum(buf)/length(buf);
                tbegin = tbegin+flen;
                yi = yi+1;
            end

        end

        function y = back_iaq(ytfm, xtfm, tlen)
        %BACK_IAQ intermediate audio quality of signal 'XTFM' against refernce signal 'YTFM' using frame lenght 'TLEN'
        % "okamzita audio kvalita" - deleni na ramce a spocteni cross - korelace [PEMOQ]
        %
        %   author: Martin Zalab�k, FEL ?VUT (Czech Technical University in Prague)

            flen=0.01;
            y=zeros(1, ceil(tlen/flen));
            tbegin=0;
            yi=1;
            fs=size(xtfm, 2)/tlen;
            while (tbegin<tlen)
                bufx=xtfm(:, floor(tbegin*fs+1):min(ceil((tbegin+flen)*fs+1), end));
                bufy=ytfm(:, floor(tbegin*fs+1):min(ceil((tbegin+flen)*fs+1), end));
                y(yi)=OpenQual.PemoQ.back_xcorrrm(bufy, bufx);
                tbegin=tbegin+flen;
                yi=yi+1;
            end

        end

        function out = back_assim(y, x)
        %BACK_ASSIM backward assimilation
        %   asimilace [PEMOQ] ve smyslu  out = max(y, avg(x + y));
        %
        %   author: Martin Zalab�k, FEL ?VUT (Czech Technical University in Prague)

            out = y + ( + (y < x) .* (( x - y ) ./ 2 )); % y pro y>=x, y+((x-y)/2)=(x+y)/2 pro y<x

        end

    end
end