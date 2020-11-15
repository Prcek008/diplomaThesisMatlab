function odg = evaluate(pathRoot,pathOrig,pathTest,profile,mode,method,continuing)
%EVALUATE Summary of this function goes here
%   Detailed explanation goes here

if strcmp(profile,'lc') % choise of codec
    noOfBitrates = 62;
elseif strcmp(profile,'he')
    noOfBitrates = 29;
elseif strcmp(profile,'hev2')
    noOfBitrates = 14;
elseif strcmp(profile,'mp2')
    noOfBitrates = 12;
elseif strcmp(profile,'opus')
    noOfBitrates = 31;
elseif strcmp(profile,'xhe')
    noOfBitrates = 2;
else
    disp('wrong profile')
end

if strcmp(method,'pemoq') % because of setting up OpenQual
    load('engine.mat');
end

fileNameProgram = 'C:\programme\opera\opera.exe';

fileNameOutput = ['"',pwd,'\operaOutput.txt"'];

delete([pathRoot, pathOrig,'desktop.ini']); % made by explorer.exe, messes with the order
delete([pathRoot,pathTest,'desktop.ini']);

origFilenameArray = string(ls([pathRoot,pathOrig])); % read the folder content
origFilenameArray = sort_nat(origFilenameArray(3:end,:));
[noOfOrigFiles,~] = size(origFilenameArray);

testFilenameArray = string(ls([pathRoot,pathTest]));
testFilenameArray = sort_nat(testFilenameArray(3:end,:));
[noOfTestFiles,~] = size(testFilenameArray);

if continuing % for continuing previously canceled evaluation
    load('continue.mat','lastProcessed','odg');
    lastProcessed = lastProcessed + 1;
else
    lastProcessed = 1;
    odg = zeros(noOfOrigFiles,noOfBitrates);
end

for fileIndex = lastProcessed:noOfTestFiles
    % for fileIndex = 1:2
    
    fileNameTest = testFilenameArray(fileIndex);
    posOfSpace = strfind(fileNameTest,'_');
    
    if(~isempty(posOfSpace))
        fileNameTest = char(fileNameTest);
        fileNameOrig = fileNameTest(1:(posOfSpace(1)-1));
        index = find(contains(origFilenameArray,fileNameOrig));
        
        fileNameOrig = [fileNameOrig(fileNameOrig~=' '),'.wav'];
        fileNameTest = fileNameTest(fileNameTest~=' ');
        
        y = audioread([pathRoot,pathOrig,fileNameOrig]);
        y1 = audioread([pathRoot,pathTest,fileNameTest]);
        
        shift = finddelay(y(:,1),y1(:,1));
        
        if shift > 0 % correcting of time shift
            y1 = y1(abs(shift):end,:);
            if length(y) > length(y1)
                y = y(1:length(y1),:);
            else
                y1 = y1(1:length(y),:);
            end
        elseif shift < 0
            y = y(abs(shift):end,:);
            if length(y) > length(y1)
                y = y(1:length(y1),:);
            else
                y1 = y1(1:length(y),:);
            end
        else
            disp('No shift!');
        end
        
        Y = resample(y,480,441); % resampling to 48000 (PeaQ requirement)
        Y1 = resample(y1,480,441);
        
        if strcmp(mode,'stereo')
            audiowrite('orig.wav',Y,48000);
            audiowrite('test.wav',Y1,48000);
        else
            audiowrite('orig.wav',sum(Y')',48000);
            audiowrite('test.wav',sum(Y1')',48000);
        end
        
        if strcmp(method,'eaqual')
            command = 'EAQUAL -blockout ODG odg_temp.txt -fref orig.wav -ftest test.wav';
            disp(command);
            system(command);
            dataStruct = importdata('odg_temp.txt');
            odg(index,1 + mod(fileIndex-1,noOfBitrates)) = mean(dataStruct.data);
        elseif strcmp(method,'peaq')
            odg(index,1 + mod(fileIndex-1,noOfBitrates)) = PQevalAudio('orig.wav','test.wav');
        elseif strcmp(method,'peaqAdvanced')
            
            fileNameOrig = ['"',pwd,'\orig.wav"'];
            fileNameTest = ['"',pwd,'\test.wav"'];
            command = ['cmd /C ',fileNameProgram,' -Exec -Algorithm Name=PEAQ Settings "Version=1" -Input Inp=0 File=',fileNameOrig,'Inp=1 File=',fileNameTest,' -Mux InpRefLeft=0 ChannelRefLeft=0 InpRefRight=0 ChannelRefRight=1 InpTestLeft=1 ChannelTestLeft=0 InpTestRight=1 ChannelTestRight=1 -Delay Channel 0 -Out=',fileNameOutput,'  -Append -PassThrough'];
            system(command);
            data = importdata('operaOutput.txt');
            splitedData = strsplit(data{2});
            odg(index,1 + mod(fileIndex-1,noOfBitrates)) = str2num(splitedData{10});
            delete('operaOutput.txt');
        elseif strcmp(method,'pemoq')
            temp = engineInstance.evalObjQuality(y,y1);
            odg(index,1 + mod(fileIndex-1,noOfBitrates)) = temp{1}.odg;
        elseif strcmp(method,'visqol')
            [odg(index,1 + mod(fileIndex-1,noOfBitrates)),~,~] = visqol('orig.wav','test.wav','ASWB');
        else
            disp('wrong profile')
        end
        
        disp(num2str(round(100*fileIndex/noOfTestFiles))+"%")
        lastProcessed = fileIndex;
        save('continue.mat','lastProcessed','odg');
        
    end
end
end

