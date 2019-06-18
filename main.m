clc; clear; close all;

data = struct;
data.name = {};


%% set folders

mkdir('samples');
mkdir('results');
mkdir([pwd,'\samples\original'])
addpath(genpath(pwd));

pathRoot = pwd;
pathInput = '\samples\original\';
mode = 'stereo'; % mono,stereo

%% by unncommenting lines choose profile in wihich you whish to generate samples and mehod of assassment

% profile = 'lc';
% [pathOutput,profileName,bitrates] = profileSelection(profile);
% listOfnames = makeAac(pathRoot,pathInput,pathOutput,profile,bitrates);
% data.name = listOfnames;
% pathCompressed = ['\samples\',profile,'\compressed'];
% pathWaveform = ['\samples\',profile,'\wav'];
% makeWav(pathRoot,pathCompressed,pathWaveform,profile)
% data.odgPeaqBasic = objectiveTest(pathRoot,pathInput,mode,'peaq',profile);
% data.odgPeaqAdvanced = objectiveTest(pathRoot,pathInput,mode,'peaqAdvanced',profile);
% data.odgPemoq = objectiveTest(pathRoot,pathInput,mode,'pemoq',profile);
% data.odgVisqol = objectiveTest(pathRoot,pathInput,mode,'visqol',profile);

% profile = 'he';
% [pathOutput,profileName,bitrates] = profileSelection(profile);
% listOfnames = makeAac(pathRoot,pathInput,pathOutput,profile,bitrates);
% data.name = [data.name,listOfnames];
% pathCompressed = ['\samples\',profile,'\compressed\'];
% pathWaveform = ['\samples\',profile,'\wav\'];
% makeWav(pathRoot,pathCompressed,pathWaveform,profile)
% data.odgPeaqBasic = objectiveTest(pathRoot,pathInput,mode,'peaq',profile);
% data.odgPeaqAdvanced = objectiveTest(pathRoot,pathInput,mode,'peaqAdvanced',profile);
% data.odgPemoq = objectiveTest(pathRoot,pathInput,mode,'pemoq',profile);
% data.odgVisqol = objectiveTest(pathRoot,pathInput,mode,'visqol',profile);


profile = 'hev2';
[pathOutput,profileName,bitrates] = profileSelection(profile);
listOfnames = makeAac(pathRoot,pathInput,pathOutput,profile,bitrates);
data.name = [data.name,listOfnames];
pathCompressed = ['\samples\',profile,'\compressed\'];
pathWaveform = ['\samples\',profile,'\wav\'];
makeWav(pathRoot,pathCompressed,pathWaveform,profile)
data.odgPeaqBasic = objectiveTest(pathRoot,pathInput,mode,'peaq',profile);
% data.odgPeaqAdvanced = objectiveTest(pathRoot,pathInput,mode,'peaqAdvanced',profile);
% data.odgPemoq = objectiveTest(pathRoot,pathInput,mode,'pemoq',profile);
data.odgVisqol = objectiveTest(pathRoot,pathInput,mode,'visqol',profile);


% profile = 'mp2';
% [pathOutput,profileName,bitrates] = profileSelection(profile);
% listOfnames = makeMp2(pathRoot,pathInput,pathOutput,profile,bitrates);
% data.name = [data.name,listOfnames];
% pathCompressed = ['\samples\',profile,'\compressed\'];
% pathWaveform = ['\samples\',profile,'\wav\'];
% makeWav(pathRoot,pathCompressed,pathWaveform,profile)
% data.odgPeaqBasic = objectiveTest(pathRoot,pathInput,mode,'peaq',profile);
% data.odgPeaqAdvanced = objectiveTest(pathRoot,pathInput,mode,'peaqAdvanced',profile);
% data.odgPemoq = objectiveTest(pathRoot,pathInput,mode,'pemoq',profile);
% data.odgVisqol = objectiveTest(pathRoot,pathInput,mode,'visqol',profile);


% profile = 'opus';
% [pathOutput,profileName,bitrates] = profileSelection(profile);
% listOfnames = makeOpus(pathRoot,pathInput,pathOutput,profile,bitrates);
% data.name = [data.name,listOfnames];
% pathCompressed = ['\samples\',profile,'\compressed\'];
% pathWaveform = ['\samples\',profile,'\wav\'];
% makeWav(pathRoot,pathCompressed,pathWaveform,profile)
% data.odg  = objectiveTest(pathRoot,pathInput,mode,method,profile);
% data.odgPeaqBasic = objectiveTest(pathRoot,pathInput,mode,'peaq',profile);
% data.odgPeaqAdvanced = objectiveTest(pathRoot,pathInput,mode,'peaqAdvanced',profile);
% data.odgPemoq = objectiveTest(pathRoot,pathInput,mode,'pemoq',profile);
% data.odgVisqol = objectiveTest(pathRoot,pathInput,mode,'visqol',profile);

save('data01.m','data');

%%

rmpath(genpath(pwd));

%% functions


function [pathOutput,profileName,bitrates] = profileSelection(profile)

if strcmp(profile,'lc')
    pathOutput = '\lc\compressed\';
    profileName = 'LC_AAC';
    bitrates = 12:4:256;
elseif strcmp(profile,'he')
    pathOutput = '\he\compressed\';
    profileName = 'HE_AAC_v1';
    bitrates = 16:4:128;
elseif strcmp(profile,'hev2')
    pathOutput = '\hev2\compressed\';
    profileName = 'HE_AAC_v2';
    bitrates = 12:4:64;
elseif strcmp(profile,'mp2')
    pathOutput = '\mp2\compressed\';
    profileName = 'HE_AAC_v2';
    bitrates = [56, 64, 80, 96, 112, 128, 160, 192, 224, 256, 320, 384];
elseif strcmp(profile,'opus')
    pathOutput = '\opus\compressed\';
    profileName = 'Opus';
    bitrates = 8:4:128;
else
    disp('wrong profile')
end

end

function odg = objectiveTest(pathRoot,pathInput,mode,method,profile)

if strcmp(profile,'lc')
    pathTest = '\samples\lc\wav\';
elseif strcmp(profile,'he')
    pathTest = '\samples\he\wav\';
elseif strcmp(profile,'hev2')
    pathTest = '\samples\hev2\wav\';
elseif strcmp(profile,'mp2')
    pathTest = '\samples\mp2\wav\';
elseif strcmp(profile,'opus')
    pathTest = '\samples\opus\wav\';
elseif strcmp(profile,'xhe')
    pathTest = '\samples\xhe\wav\';    
else
    disp('wrong profile')
end

odg = evaluate(pathRoot,pathInput,pathTest,profile,mode,method,0);
fileName = [pathRoot,'\results\odg_',profile,'_',mode,'_',method,'.mat'];
save(fileName,'odg');
% displayPlot(profile,mode,method,fileName);

end