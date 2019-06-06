function displayPlot(profile,mode,method,fileName)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here

load(fileName,'odg');
% load(['odg_',profile,'_',mode,'_',method,'.mat'],'odg');

% if strcmp(method,'visqol')
%     odg = moslqoToOdg(odg);
% end

if strcmp(profile,'lc')
    bitrate = 12:4:256;
    name = 'AAC_LC';
elseif strcmp(profile,'he')
    bitrate = 16:4:128;
    name = 'HE_AAC_v1';
elseif strcmp(profile,'hev2')
    bitrate = 12:4:64;
    name = 'HE_AAC_v2';
elseif strcmp(profile,'mp2')
    bitrate = [56, 64, 80, 96, 112, 128, 160, 192, 224, 256, 320, 384];
    name = 'MPEG_Layer_II';
elseif strcmp(profile,'opus')
    bitrate = 8:4:128;
    name = 'opus';
elseif strcmp(profile,'xhe')
    bitrate = [8,12];
    name = 'xHE_AAC';
else
    disp('wrong profile')
end

figure

if strcmp(profile,'xhe')
    plot(bitrate,odg,'+','LineWidth',3)
    legend('mixed','muxic','speech','Location','northwest')
    xlim([6,14])
else
plot(bitrate,odg)
end
hold on
title([name,'_',mode,'_',method],'Interpreter', 'none')
xlabel('bitrate')
ylabel('ODG')
ylim([-4,0.5])
if strcmp(method,'visqol')
    ylim([0,5])
end
grid on
hold off
saveas(gcf,['all_samples_',name,'_',mode,'_',method,'_',num2str(datenum(datetime)),'.png'])



if ~strcmp(profile,'xhe')
    
    figure    
    plot(bitrate,mean(odg([2 4 9],:)))
    hold on
    title([name,'_speech_music_comparsion_',mode,'_',method],'Interpreter', 'none')
    xlabel('bitrate')
    ylabel('ODG')
    ylim([-4,0.5])
    if strcmp(method,'visqol')
        ylim([0,5])
    end
    grid on
    plot(bitrate,mean(odg([1 3 5 6 7 8 10],:)))
    % plot(bitrate,mean(odg(11,:)))
    legend('Spoken Word','Music','Location','southeast')
    hold off
    saveas(gcf,['speech_music_comparsion_',name,'_',mode,'_',method,'_',num2str(datenum(datetime)),'.png'])
    
end

end

