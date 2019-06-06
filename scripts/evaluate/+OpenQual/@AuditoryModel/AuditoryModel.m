classdef (Abstract) AuditoryModel < handle
%AUDITORY MODEL abstract class/interface describes basic functionality every human auditory (processing) model has to have.
%
%   author:     Jan Novák (novak110@fel.cvut.cz, officialjannovak@gmail.com)
%   created:  28-Nov-2017T14:32 UTC+01:00
    
    properties (Abstract, Constant, GetAccess = public)
        modelName@OpenQual.Models scalar;
    end

    properties (Abstract, SetAccess = protected, GetAccess = public)
        fs@double property;         % sampling frequency of signal
    end

    methods (Abstract, Access = public)
        % conveniently passes internal representation as is needed by acompanying evaluation method
        processedSignal = processSignal(obj, signal);   
    end

end