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

plotLegend = {'12 Opus.wav' '12 xHE AAC.wav' '24 HE AAC v2.wav' '24 Opus.wav' '48 HE AAC v2.wav' '64 HE AAC v2.wav' '8 xHE AAC.wav' 'hidden.wav' 'lp35.wav'};


for index = 1:numOfFiles
    cellName = {folderContent.name};
    load([currentFolder,cellName{index}],'dataToSave');
        if mean(dataToSave.quality(:,8)) < 90 || mean(dataToSave.quality(:,9)) > 50 || mean(dataToSave.quality(:,5)) > 90 || mean(dataToSave.quality(:,4)) > 80
%         dataToSave.name    
%         disp('Unreliable')
        continue
    end
    meanQuality(index,:) = mean(dataToSave.quality);
        out(:,:,index) = dataToSave.quality;
%     maxQuality(index,:) = max(dataToSave.quality)
%     minQuality(index,:) = min(dataToSave.quality);
musicMeanQuality(index,:) = (dataToSave.quality([1],:));
speechMeanQuality(index,:) = (dataToSave.quality([2],:));
mixedMeanQuality(index,:) = (dataToSave.quality([3],:));

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
% dataOut = (out);

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
saveas(gcf,'mushra2Mean.png')

figure

bar(y)
xticklabels(plotLegend)
xtickangle(30)
colormap('autumn')

hold on
% errorbar(x,y,errNeg,errPos,'k.');
% errorbar(x,yMean,err,'kx');

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
saveas(gcf,'mushra2.png')

save('dataOut2.mat','dataOut');


[mean(meanQuality);errMean;mean(musicMeanQuality);interval(musicMeanQuality);mean(speechMeanQuality);interval(speechMeanQuality);mean(mixedMeanQuality);interval(mixedMeanQuality)];

function y = interval(x)
    t = 2;
    y = t*std(x)/sqrt(8);
end
