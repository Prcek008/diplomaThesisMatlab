function engine = getEngine(fs, varargin)
%GETENGINE(fs, varargin) Select, initialize and return the computational engine of chosen method of objective quality evaluation and its properties.
%   
%   engine = getEngine(fs) return default engine passing sampling frequency of 'fs' for initialization
%
%       getEngine(___, 'method', OpenQual.Methods.<method>, 'model', OpenQual.Models.<model>) specify one of the available evaluation methods (and its model if applicable) from the OpenQual freamwork
%           'Method' = [ OpenQual.Methods.Pemoq (default) ]
%           'Models' = [ OpenQual.Models.Pemo (default) ]
%               If chosen model is not applicable for chosen method, an error is thrown.
%   


    p = inputParser;
    addRequired(p, 'fs', @(x) isnumeric(x) && isscalar(x) && (x > 0) && (uint16(x)==x));
    addParameter(p, 'method', OpenQual.Methods.Pemoq);
    addParameter(p, 'model', OpenQual.Models.Pemo);

    parse(p, fs, varargin{:});
    
    fs = uint16(p.Results.fs);

    if p.Results.method == OpenQual.Methods.Pemoq
        if p.Results.model == OpenQual.Models.Pemo
            engine = OpenQual.PemoQ(fs, 'model', p.Results.model);
        else
            error('Unknown model %s', char(p.Results.model));
        end
    else
        error('Unknown method %s', char(p.Results.Method));
    end
end