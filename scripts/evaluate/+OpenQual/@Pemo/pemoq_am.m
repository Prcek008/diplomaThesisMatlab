function out = pemoq_am(x, fs, adaptLoopMax, adaptLoopMin)
%pemoq_am(sig, fs)
% Apply model of human auditory system from PEMO-Q to input signal x, with sampling frequency fs
% 
% internalRepres = pemoq_am(sig, fs)
%                = pemoq_am(__, DEBUG) ... DEBUG = true/false - enable verbose debug logging
%                                      ...  by default, DEBUG = false
%
%   Human Auditory Model from PEMO-Q method (PEMO, from Tau et al.) is synthesized and than applied to given signal sig
%
%
%   author: Ing. Martin Zalabák, FEL ČVUT
%   changes:
%       Aug - Oct 2017: Jan Novák (novak110@fel.cvut.cz)
%                       - major refactoring and cleanup, significantly improve readability
%                       - update to Matlab R2017a (ver. 9.2)
%                       - add input validation
%                       - unify logging (can be triggered by defining global DEBUG = 1 elswhere)
%       03-Dec-2017 16:25 +0100 Jan Novák
%                       - respect integration to OpenQual package
%       23-Dec-2017 18:30 +0100 Jan Novák
%                       - remove unnecessary logging
%                       - allow to pass adapt loop limitation


    % ---------------------------------------------------------------------------------------
    % input handling
    % ---------------------------------------------------------------------------------------
    narginchk(2, 4);
    if (nargin < 4)
        adaptLoopMin = 1e-5;
    end
    if (nargin < 3)
        adaptLoopMax = 0.5;
    end

    % =======================================================================================
    % Human Auditory Model preparation
    % =======================================================================================
    init = OpenQual.Pemo.pemoq_am_prepare(fs);

    % =======================================================================================
    % GAMMATONE FILTERING - BAND SEPARATION
    % =======================================================================================
    
    % prepare num_gammatone_bands x num_samples zero vector [rows x columns]
    gammatone_bands = zeros(init.nc, length(x));
    
    % decimate the whole signal to half the FS to counter resonations in Slanye's gammtone filtering method
    xd = decimate(x, 2);
    
    % separate input signal to 35 bands using gammatone filter bank [PEMO]
    for i = 1:init.nc
        
        % when central freq of given band fc is under FS/4, work on decimated signal
        if (init.fc(i) < fs/4) 
            
            % do the filtering, resulting size(buf) = [1 x length(x)]
            buf = filter(init.gfilts{i}.b, init.gfilts{i}.a, xd);
            % interpolate result back to original sampling frequency
            gammatone_bands(i,:) = interp(buf(:), 2);
            clear buf;
        else
            % do the filtering, resulting size(gammatone_bands(I,:) = [1 x length(x)]
            gammatone_bands(i,:) = filter(init.gfilts{i}.b, init.gfilts{i}.a, x(:));
        end
        
    end

    % =======================================================================================
    % CAPILLARY SYSTEM AND HAIR CELL MODELLING
    % =======================================================================================
    % half wave rectification [PEMO]
    gammatone_bands_rectified = gammatone_bands .* (gammatone_bands > 0);
    clear gammatone_bands;
    
    % 1 kHz 1st order low pass filtering [PEMO]
    hair_cell_sigs = filter([init.bl init.bl], [1 init.al], gammatone_bands_rectified, [], 2);
    clear gammatone_bands_rectified;
    
    % =======================================================================================
    % ADAPTATION (hair_cell_sigs=>adapt)
    % =======================================================================================
    
    %definice filtru z casovych konstant tau [PEMOQ][CASP]
    
    ADAPTLOOP_LIMIT = adaptLoopMax;    % 0 < x < 1 -> overshoot limitation disabled
    ADAPTLOOP_MIN = adaptLoopMin;
    adapt_sig = OpenQual.Pemo.adaptloop(hair_cell_sigs', fs, ADAPTLOOP_LIMIT, ADAPTLOOP_MIN)';
    clear hair_cell_sigs;
    
    % =======================================================================================
    % MODULATION FILTERING [PEMOQ][CASP]
    % =======================================================================================
    
    out = cell(1, length(init.fsdec));
    for i = 1:length(init.fsdec)
        out{i} = OpenQual.Pemo.mod_packfilter(init.filtersb{i}, init.filtersa{i}, adapt_sig, fs, init.fsdec(i));
    end


end