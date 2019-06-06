function compareResults(profile,mode,method1,method2)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

load(['odg_',profile,'_',mode,'_',method1,'.mat'],'odg');
odg1 = odg;
load(['odg_',profile,'_',mode,'_',method2,'.mat'],'odg');
odg2 = odg;

if strcmp(profile,'lc')
    bitrate = 32:4:256;
    name = 'AAC_LC';
elseif strcmp(profile,'he')
%     bitrate = 12:4:144;
    bitrate = [12 16 20 24 32 36 40 44 52 56 60 64 72 76 92 96 100 104 112 116 120 124 132 136 140 144];
    name = 'HE_AAC_v1';
elseif strcmp(profile,'hev2')
    bitrate = 8:4:68;
    name = 'HE_AAC_v2';
elseif strcmp(profile,'mp2')
    bitrate = [56, 64, 80, 96, 112, 128, 160, 192, 224, 256, 320, 384];
    name = 'MPEG_Layer_II';
else
    disp('wrong profile')
end

figure

plot(bitrate,odg1-odg2)
hold on
title([name,'_',mode,'_',method1,'_and_',method2,'_difference'],'Interpreter', 'none')
xlabel('bitrate')
ylabel('ODG')
ylim([-4,0.5])
grid on
% legend('southeast')
hold off
saveas(gcf,['method_comparsionall_samples_',name,'_',mode,'_',method1,'_and_',method2,'_difference',datestr(datetime),'.png'])

figure

plot(bitrate,mean(odg1([1 4 8],:)-odg2([1 4 8],:)))
hold on
title([name,'method_comparsion_speech_music','_',mode,'_',method1,'_and_',method2,'_difference'],'Interpreter', 'none')
xlabel('bitrate')
ylabel('ODG')
ylim([-4,0.5])
grid on
plot(bitrate,mean(odg1([2 3 5 6 7 9 10 11],:)-odg2([2 3 5 6 7 9 10 11],:)))
legend('Spoken Word','Music','Location','southeast')
hold off
saveas(gcf,['method_comparsion_speech_music',name,'_',mode,'_',method1,'_and_',method2,datestr(datetime),'_difference','.png'])



end

