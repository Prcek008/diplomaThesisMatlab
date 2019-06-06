function quality = objquality(test_sig, ref_sig, test_sig_num_samples, FS)
%OBJQUALITY Evaluate objective quality of given test signal (auditory model internal representation) against reference signal (auditory model internal representation).
% quality_struct = objquality(tested_sig, referencde_sig, tested_sig_len_in_samples, fs_in_hz)
%   
%   Author: Ing. Martin Zalabák, FEL ČVUT (Czech Technical University in Prague)
%
%   changes:    
%           Aug - Nov 2017: Jan Novák
%                               - verify functionality, improve readability
%                               - update to Matlab R2017a
%                               - minor refactoring
%           03-Dec-2017 16:40 +0100 Jan Novák
%                               - major refactoring
%                               - rewriten 5th quantile selection
%                               - respect OpenQual package integration syntax


    test_sig_assim = cellfun(@OpenQual.PemoQ.back_assim, test_sig, ref_sig, 'UniformOutput', false); % asimilace
    
    xcorr_mod_channels = cellfun(@OpenQual.PemoQ.back_xcorrrm, test_sig_assim, ref_sig, 'UniformOutput', false); % cross-korelace
    
    y_sqrsums_per_mod_ch = cellfun(@OpenQual.PemoQ.back_sqsum, test_sig_assim); % vypocet sumy kvadratu (pro vahovani cross-korelace)
    y_sqrsum_all_mod_ch = sum(y_sqrsums_per_mod_ch);
    weights_mod_channels = y_sqrsums_per_mod_ch./y_sqrsum_all_mod_ch; % vypocet vahovacich koeficientu
    

    % PSM ---------------------------------------------------------------------------------------------------
    quality.psm = cell2mat(xcorr_mod_channels) * weights_mod_channels';
    

    % PSMt --------------------------------------------------------------------------------------------------
    %priprava ramcu pro kratkocasovou cross-korelaci
    t_secs = test_sig_num_samples/FS;
    t_secs_cell = num2cell(ones(1, length(test_sig)).*t_secs);
    
    iact = cellfun(@OpenQual.PemoQ.back_iact, test_sig, t_secs_cell, 'UniformOutput', false); % "okamzita aktivita"
    
    iaq = cellfun(@OpenQual.PemoQ.back_iaq, test_sig_assim, ref_sig, t_secs_cell, 'UniformOutput', false); % "okamzita kvalita"
    
    
    % xcorr weighing, 5th quantile selection, PSMt
    y_squared_sum_st = cellfun(@OpenQual.PemoQ.back_sqsumst, test_sig_assim, t_secs_cell, 'UniformOutput', false);
    wmst = cell2mat(y_squared_sum_st');
    wmst = wmst./repmat(sum(wmst), length(y_squared_sum_st), 1);
        
    buf_iact = sum(cell2mat(iact')) ./ length(iact);
    buf_iaql = sum(cell2mat(iaq') .* wmst);
    
    % 5th quantile of CUMULATIVE intermediate ACTIVITY distribution, index then used to select value from
    % the distribution of intermediate audio QUALITY
    sorted = sortrows([buf_iaql', buf_iact'], [1 2], 'ascend');
    iaql_sorted = sorted(:,1);
    iact_sorted = sorted(:,2);
    
    weighted_sum = sum(iact_sorted);
    fifth_perc_val = 0.05 * weighted_sum;
       
    index = 0;
    value = 0;
    while(value < fifth_perc_val)
        index = index + 1;
        value = value + iact_sorted(index); 
    end
    if index == 0
        psmt_value = iaql_sorted(1);
    else
        psmt_value = iaql_sorted(index);
    end
    
    quality.psmt = psmt_value;

    psmtSequence = cell2mat(iaq');
    quality.psmtSeqence = psmtSequence(:);


    % PSMt -> ODG MAPPING -----------------------------------------------------------------------------------
    ODG_a = -0.22;
    ODG_b = 0.98;
    ODG_c = -4.13;
    ODG_d = 16.4;
    ODG_x0 = 0.864;

    if (quality.psmt<ODG_x0)
      quality.odg = max(-4, ((ODG_a/(quality.psmt - ODG_b))) + ODG_c);
    else
      quality.odg = (ODG_d * quality.psmt) - ODG_d;
    end

end