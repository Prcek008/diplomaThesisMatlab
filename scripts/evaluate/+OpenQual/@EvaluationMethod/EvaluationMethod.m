classdef (Abstract) EvaluationMethod < handle
%EVALUATION METHOD abstract class/interface describes core of audio quality evaluation methods (such as PEMO-Q, PEAQ, PESQ) and exposes
% it to the OpenQual evaluation framework 'OpenQual'.
%
%Evaluation methods themselves can (and usually do) depend on external (Human) Auditory Models
% such as PEMO (Tau et. al) or CASP found in PEMO-Q evaluation method.
% Those auditory models are abstracted out of the core of evaluation methods as class
% AuditoryModel (and its derivates) to:
%    1) provide standalone way for human audio processing and enable future research and development,
%    2) enable an evaluation method to use different auditory models, if designed to.
%
%   author:     Jan Novák (novak110@fel.cvut.cz, officialjannovak@gmail.com)
%

    properties (Abstract, Constant, GetAccess = public)
        methodName@OpenQual.Methods scalar;
        requiresAuditoryModel@logical scalar;
    end

    methods (Abstract, Access = public)
        resultsCell = evalObjQuality(obj, varargin);
    end
end