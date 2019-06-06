function [b, a] = mod_gammafilt(fc,  bw, fs)
%MOD_GAMMAFILT Return coefficients of normalized gammatone filter with given parameters using Macolm Slaney's algorithm (stripped down)
% [b, a] = mod_gammafilt(fc,  bw, fs)
%          fc: central frequency
%          bw: bandwidth (ERB)
%          fs: sampling frequency
% 
%   
%   author: Ing. Martin Zalabák, FEL ČVUT
%       based on: Malcolm Slaney et al. - An efficient implementation of the patterson-holdsworth auditory filter bank. Apple Computer, Perception Group, Tech. Report #35
%   changes:
%       August-2017:    Jan Novák (novak110@fel.cvut.cz)
%                        - add input validation, update to Matlab R2017a (ver. 9.2)

% Handle input
narginchk(3, 3)

if (~isscalar(fc) || ~isnumeric(fc))
    error('given central frequency "fc" must be a number')
end

if (~isscalar(fs) || ~isnumeric(fs))
    error('given sampling frequency "fs" must be a positive number')
end

if (~isscalar(bw) || ~isnumeric(bw))
    error('given bandwidth "bw" must be a positive number')
end


fs = double(fs);  % support complex arithmetic operations

T=1/fs;
B=1.019*2*pi*bw;
gain = abs((-2*exp(4*1i*fc*pi*T)*T + ...
    2*exp(-(B*T) + 2*1i*fc*pi*T).*T.* ...
    (cos(2*fc*pi*T) - sqrt(3 - 2^(3/2))* ...
    sin(2*fc*pi*T))) .* ...
    (-2*exp(4*1i*fc*pi*T)*T + ...
    2*exp(-(B*T) + 2*1i*fc*pi*T).*T.* ...
    (cos(2*fc*pi*T) + sqrt(3 - 2^(3/2)) * ...
    sin(2*fc*pi*T))).* ...
    (-2*exp(4*1i*fc*pi*T)*T + ...
    2*exp(-(B*T) + 2*1i*fc*pi*T).*T.* ...
    (cos(2*fc*pi*T) - ...
    sqrt(3 + 2^(3/2))*sin(2*fc*pi*T))) .* ...
    (-2*exp(4*1i*fc*pi*T)*T+2*exp(-(B*T) + 2*1i*fc*pi*T).*T.* ...
    (cos(2*fc*pi*T) + sqrt(3 + 2^(3/2))*sin(2*fc*pi*T))) ./ ...
    (-2 ./ exp(2*B*T) - 2*exp(4*1i*fc*pi*T) + ...
    2*(1 + exp(4*1i*fc*pi*T))./exp(B*T)).^4);
a=zeros(1, 9);
b=zeros(1, 5);
b(1) = T^4 ./ gain;
b(2) = -4*T^4*cos(2*fc*pi*T)./exp(B*T)./gain;
b(3) = 6*T^4*cos(4*fc*pi*T)./exp(2*B*T)./gain;
b(4) = -4*T^4*cos(6*fc*pi*T)./exp(3*B*T)./gain;
b(5) = T^4*cos(8*fc*pi*T)./exp(4*B*T)./gain;
a(1) = 1;
a(2) = -8*cos(2*fc*pi*T)./exp(B*T);
a(3) = 4*(4 + 3*cos(4*fc*pi*T))./exp(2*B*T);
a(4) = -8*(6*cos(2*fc*pi*T) + cos(6*fc*pi*T))./exp(3*B*T);
a(5) = 2*(18 + 16*cos(4*fc*pi*T) + ...
    cos(8*fc*pi*T))./exp(4*B*T);
a(6) = -8*(6*cos(2*fc*pi*T) + cos(6*fc*pi*T))./exp(5*B*T);
a(7) = 4*(4 + 3*cos(4*fc*pi*T))./exp(6*B*T);
a(8) = -8*cos(2*fc*pi*T)./exp(7*B*T);
a(9) = exp(-8*B*T);
