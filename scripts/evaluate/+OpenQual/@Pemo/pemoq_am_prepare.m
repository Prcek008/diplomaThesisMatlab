function filters_struct = pemoq_am_prepare(fs)
%PEMOQ_AM_PREPARE Precompute gammatone filter bank, modulation filter bank and rest of PEMOQ's auditory model params for given sampling frequency fs (PEMO-Q)
% 
% Usage:  filters_struct = pemoq_am_prepare(fs)
%     filters_struct = struct[
%                          nc: [1x1 double] - number of channels for band separation using gammatone filtering
%                          fc: [35x1 double] - vector of central frequencies corresponding to gammatone filters
%                      gfilts: {35x1 cell} - gammatone filters coefficients
%                          bl: [1x1 double] - b coeff of 1kHz lowpass filter for haircell modelling
%                          al: [1x1 double] - a coeff of 1kHz lowpass filter for haircell modelling
%                      minval: [1x1 double] - min value (threshold) for adaptloop
%                    filtersb: {1x8 cell} - b coeffs of modulation filterbank
%                    filtersa: {1x8 cell} - a coeffs of modulation filterbank
%                       fsdec: [1x8 double] - target sampling frequencies of final output channels of internal repr.
%                            ]
%   author: Ing. Martin Zalabák, FEL ČVUT
%   changes:
%       Aug - Nov 2017: Jan Novák (novak110@fel.cvut.cz)
%                       - minor refactoring, increase readability, functionality unchanged
%                       - add input validation
%       03-Dec-2017 16:25 +0100 Jan Novák
%                       - respect integration to OpenQual package


    % Handle input
    narginchk(1, 1);

    if ~(isscalar(fs) && isnumeric(fs))
      error('Input sampling frequency "fs" must be a scalar number!');
    end

    fs = double(fs);    % support complex arithmetic operations
    
    % Init output
    filters_struct = struct();

    % ===========================================================================================
    % Gammatone filter bank
    %---banka filtru--- (x=>bm) [PEMOQ][Slaney]
    % hodnoty/konstanty pro vypocty filtru [Slaney]
    % //* TERMINOLOGY
    % //* ERB = equivalent rectangular band
    % //* fc = central frequency of generated gammatone filter

    EarQ = 9.26449;         % //* quality factor of human ear viewed as a filter 
    minBW = 24.7;           % //* minimal bandwidth (ERB) of generated gammatone filter
    order = 4;              % //* filter order factor

    %meze pasem (fc dale vyhovuji prilehajicim pasmum 1ERB) [PEMOQ] [Slaney]
    fmin = 235;             % //* lower band boundary
    fmax = 14500;           % //* upper band boundary
    filters_struct.nc = 35; % // num channels
    decfmultiplier = 10;    % // decimation factor multiplier

    % generovani strednich kmitoctu gammatonovych filtru 4. radu [Slaney]
    % result = 
    filters_struct.fc = -(EarQ*minBW) ...
             + exp( ... 
                    (1:filters_struct.nc)' * (-log(fmax + EarQ*minBW) + log(fmin + EarQ*minBW)) / filters_struct.nc ...
                  ) ...
             * (fmax + EarQ*minBW);

    ERB = ((filters_struct.fc/EarQ).^order + minBW^order).^(1/order);

    filters_struct.gfilts = cell(filters_struct.nc , 1);

    % sestaveni gammatonovych filtru
    % na nejnizsich kmitoctovych pomerech se Slaneyho algoritmus nechova dle predpokladu (vznikaji obrovske rezonance)
    % a tak je pro kmitocty fc/fs<1/4 krok obklopen decimaci/interpolaci
    for i = 1:filters_struct.nc
        filters_struct.gfilts{i} = struct();

        % //? sampling frequency separation, how can we remove this?
        % // not for now, different gammatone filters preparation algorithm needst to be used
        if (filters_struct.fc(i)<fs/4)
             [filters_struct.gfilts{i}.b, filters_struct.gfilts{i}.a] = OpenQual.Pemo.mod_gammafilt(filters_struct.fc(i),ERB(i),fs/2);
        else
             [filters_struct.gfilts{i}.b, filters_struct.gfilts{i}.a] = OpenQual.Pemo.mod_gammafilt(filters_struct.fc(i),ERB(i),fs);
        end
    end
    
    
    % [PEMO-Q]
    %lowpass filtr - 1kHz lowpass 1st order filter
    K = tan(pi*1000/fs);    % //
    filters_struct.bl = K/(K+1);       % //* a coeff of lowpass filter
    filters_struct.al = (K-1)/(K+1);   % //* b coeff of lowpass filter

    
    filters_struct.minval = 1e-5; % minimum pro adaptivni smycku


    % ===========================================================================
    % Modulation filterbank
    % Filtry modulacni banky
    [fmodb, fmoda] = butter(2,2.5/(fs/2));    % first filter
    fcmod = [5 10];                           % the rest of filters

    tmp_fc = 0;
    tmp_f1 = fcmod(2)+(fcmod(2)/4);
    maxfc = 129;
    while round(tmp_fc)<maxfc
      tmp_f2 = 5*tmp_f1/3;
      tmp_fc = (tmp_f2+tmp_f1)/2;
      fcmod = [fcmod tmp_fc];
      tmp_f1 = tmp_f2;
    end
    filters_struct.filtersb = cell(1,length(fcmod+1));
    filters_struct.filtersa = cell(1,length(fcmod+1));
    filters_struct.filtersb{1} = fmodb;
    filters_struct.filtersa{1} = fmoda;
    for n = 1:length(fcmod)
      w0 = 2*pi*fcmod(n)/fs;
      Q = 1+(n>1);
      e0 = exp(-(w0/Q)/2);
      filters_struct.filtersb{n+1} = 1-e0;
      filters_struct.filtersa{n+1} = [1, -e0*exp(1i*w0)];
    end

    %hodnoty pro decimaci
    filters_struct.fsdec = decfmultiplier.*[2.5 fcmod];

end