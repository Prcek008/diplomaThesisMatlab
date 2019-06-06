clc,clear,close all;

[y,fs] = audioread('orig.wav');
y1 = audioread('test.wav');


engineInstance = OpenQual.getEngine(fs);
%%
engineInstance.evalObjQuality(y,y1);
% 
save('engine.mat')