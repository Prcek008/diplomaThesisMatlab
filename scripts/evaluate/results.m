clc,clear,close all;


mode = 'stereo'; % mono,stereo
% method = 'peaqAdvanced'; % peaq, eaqual, pemoq, visqol, peaqAdvanced
% profile = 'mp2'; % mp2,lc,he,hev2,opus,xhe

% do(mode,method,'mp2');
% do(mode,method,'lc');
% do(mode,method,'he');
% do(mode,method,'hev2');
% do(mode,method,'opus');
% do(mode,method,'xhe');

% method = 'peaq';
% 
% do(mode,method,'mp2');
% do(mode,method,'lc');
% do(mode,method,'he');
% do(mode,method,'hev2');
% do(mode,method,'opus');
% do(mode,method,'xhe');

method = 'visqol';

do(mode,method,'mp2');
do(mode,method,'lc');
do(mode,method,'he');
do(mode,method,'hev2');
do(mode,method,'opus');
do(mode,method,'xhe');

method = 'pemoq';

% do(mode,method,'mp2');
do(mode,method,'lc');
do(mode,method,'he');
do(mode,method,'hev2');
do(mode,method,'opus');
do(mode,method,'xhe');


function do(mode,method,profile)

pathRoot = [fileparts(pwd),'\samples\'];
pathOrig = 'original\';

if strcmp(profile,'lc')
    pathTest = 'lc\wav\';
elseif strcmp(profile,'he')
    pathTest = 'he\wav\';
elseif strcmp(profile,'hev2')
    pathTest = 'hev2\wav\';
elseif strcmp(profile,'mp2')
    pathTest = 'mp2\wav\';
elseif strcmp(profile,'opus')
    pathTest = 'opus\wav\';
elseif strcmp(profile,'xhe')
    pathTest = 'xhe\wav\';    
else
    disp('wrong profile')
end

odg = evaluate(pathRoot,pathOrig,pathTest,profile,mode,method,0);
fileName = ['odg_',profile,'_',mode,'_',method,num2str(datenum(datetime)),'.mat'];
save(fileName,'odg');
% displayPlot(profile,mode,method,fileName);

end