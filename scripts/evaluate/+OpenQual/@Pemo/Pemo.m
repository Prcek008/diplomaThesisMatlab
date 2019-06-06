classdef (Sealed) Pemo < OpenQual.AuditoryModel
% PEMO: Represents human auditory model as descibed by Tau et al. and used by PEMO-Q objective audio quality
%   assessment method to provide model of human auditory signal processing.
%   
%   To process a signal:
%      model = Pemo('fs', samplingFrequency);
%      internalRepresentationOfProcessedSignal = model.processSignal(signal);
%
% author:   Jan Nov�k (novak110@fel.cvut.cz, officialjannovak@gmail.com)
% created:  28-Nov-2017T15:06 UTC+01:00

    properties (Constant, GetAccess = public)
        modelName@OpenQual.Models scalar = OpenQual.Models.Pemo;
    end

    properties (SetAccess = protected, GetAccess = public)
        fs@double property;         % common sampling frequency of signals
        modelParams@struct;         % internal model state
    end

    methods (Access = public)
        function obj = Pemo(fs)
        % PEMO(fs)
        %   initialize the 'Pemo' human auditory model  by Tau et. al from PEMO-Q obj. quality evaluation method
        %   fs ... sampling frequency to use to initialize internal state of the model
            p = inputParser();
            addRequired(p, 'fs', @(x) isnumeric(x) && isscalar(x) && (uint64(x)==x) && (x > 0));
            parse(p, fs);
            
            obj.fs = double(p.Results.fs);
            obj.modelParams = obj.prepareModelParams();
        end

        function processedSignal = processSignal(obj, signal, adaptLoopMax, adaptLoopMin)
        % processSignal = processSignal(signal)
        %   process given signal and return its internal representation in the Pemo human auditory model
        %   
        %   processSignal(___, adaptLoopMax, adaptLoopMin)
        %       adaptLoopMax - specify higher limitation of adaptloop overhoot, default = 50
        %   	adaptLoopMin - specify lower adaptloop limit (thershold), default = 1e-5

            if nargin < 4
                adaptLoopMin = 1e-5;
            end
            if nargin < 3
                adaptLoopMax = 0.5;
            end
            processedSignal = obj.pemoq_am(signal, obj.fs, adaptLoopMax, adaptLoopMin);
        end
    end

    methods (Access = private)
        % wrappers for original static methods
        function modelDescriptorStruct = prepareModelParams(obj)
            modelDescriptorStruct = obj.pemoq_am_prepare(obj.fs);
        end
    end

    methods (Static = true, Access = public)
        inoutsig = adaptloop(inoutsig,fs,limit,minlvl,tau);
        inoutsig = comp_adaptloop(inoutsig,fs,limit,minlvl);
        [b, a] = mod_gammafilt(fc,  bw, fs);
        pemo_model_params = pemoq_am_prepare(fs);
        out = pemoq_am(x, fs, adaptLoopMax, adaptLoopMin);
        y = mod_packfilter(b,a,x,fs,fdem);
    end
end
