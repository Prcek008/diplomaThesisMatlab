clc,clear,close all;
set(0,'defaultTextInterpreter','latex')
set(0, 'defaultAxesTickLabelInterpreter','latex');
set(0, 'defaultLegendInterpreter','none');
currentFolder = [pwd,'\results\'];

try
    delete([currentFolder,'desktop.ini'])
end

folderContent = dir(currentFolder);
folderContent = folderContent(3:end);
numOfFiles = length(folderContent);

plotLegend = {'128 MP2.wav','24 opus.wav','32 HE-AAC v2.wav','32 opus.wav','48 HE-AAC v1.wav','48 HE-AAC v2.wav',...
    '64 HE-AAC v1.wav','64 LC-AAC.wav','96 MP2.wav','hidden ref.wav','lp35.wav'};


for index = 1:numOfFiles % average over listeners
    cellName = {folderContent.name};
    load([currentFolder,cellName{index}],'dataToSave');
%     if mean(dataToSave.quality(:,10)) < 90 || mean(dataToSave.quality(:,9)) > 50 || mean(dataToSave.quality(:,2)) < 45
%         dataToSave.name 
        disp('No Post Screening')
%         continue
%     end
    meanQuality(index,:) = mean(dataToSave.quality);
    out(:,:,index) = dataToSave.quality; %save for future uses
    %     maxQuality(index,:) = max(dataToSave.quality)
    %     minQuality(index,:) = min(dataToSave.quality);
    musicMeanQuality(index,:) = mean(dataToSave.quality([1 2 4],:));
    speechMeanQuality(index,:) = (dataToSave.quality(3,:));
    mixedMeanQuality(index,:) = (dataToSave.quality(5,:));
end

%%delete zeros
meanQuality = meanQuality(any(meanQuality,2),:);
musicMeanQuality = musicMeanQuality(any(musicMeanQuality,2),:);
speechMeanQuality = speechMeanQuality(any(speechMeanQuality,2),:);
mixedMeanQuality = mixedMeanQuality(any(mixedMeanQuality,2),:);
out = out(:,:,any(any(out,2)));



[~,tmp] = size(meanQuality);
x = 1:tmp;

yMean = mean(meanQuality);
dataOut(1,:) = yMean(1:end-2);
% dataOut = out;

y = [mean(musicMeanQuality)',mean(speechMeanQuality)',mean(mixedMeanQuality)'];
err = [interval(musicMeanQuality)',interval(speechMeanQuality)',interval(mixedMeanQuality)'];
errMean = interval(meanQuality);

dataOut(2,:) = errMean(1:end-2);

bar(yMean)
xticklabels(plotLegend)
xtickangle(30)
colormap('autumn')
grid on
hold on
errorbar(x,yMean,errMean,'k.');
hold off

grid on
ylabel('Subjektivn{\''i} kvalita (\%)')
ylim([0 100])
width=1000;
height=700;
paperwidth = 20;
paperheight = paperwidth * height/width;
x0=50;
y0=50;
set(gcf,'position',[x0,y0,width,height])
set(gcf, 'PaperPosition', [0 0 paperwidth paperheight]);
set(gcf, 'PaperSize', [paperwidth paperheight]);
% saveas(gcf,'mushra1Mean.pdf')

figure

bar(y)
xticklabels(plotLegend)
xtickangle(30)
colormap('autumn')
grid on
hold on
% errorbar(x,y,errNeg,errPos,'k.');

ngroups = size(y, 1);
nbars = size(y, 2);
% Calculating the width for each bar group
groupwidth = min(0.8, nbars/(nbars + 1.5));
for i = 1:nbars
    x = (1:ngroups) - groupwidth/2 + (2*i-1) * groupwidth / (2*nbars);
    errorbar(x, y(:,i), err(:,i), 'k.');
end
hold off


% legend('hudba','øeè','mix','prùmìr + smìrodatná odchylka','Location','best')
legend('hudba','øeè','mix','Location','best')


grid on
ylabel('Subjektivn{\''i} kvalita (\%)')
ylim([0 100])
width=1000;
height=700;
paperwidth = 20;
paperheight = paperwidth * height/width;
x0=50;
y0=50;
set(gcf,'position',[x0,y0,width,height])
set(gcf, 'PaperPosition', [0 0 paperwidth paperheight]);
set(gcf, 'PaperSize', [paperwidth paperheight]);
% saveas(gcf,'mushra1.pdf')

save('dataOut1.mat','dataOut');


[mean(meanQuality);errMean;mean(musicMeanQuality);interval(musicMeanQuality);mean(speechMeanQuality);interval(speechMeanQuality);mean(mixedMeanQuality);interval(mixedMeanQuality)];

function y = interval(x)
    t = 2;
    y = t*std(x)/sqrt(8);
end
