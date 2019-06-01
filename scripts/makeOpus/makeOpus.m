function listOfnames = makeMp2(pathRoot,pathInput,pathOutput,profile,bitrates)

delete([pathRoot, pathInput,'desktop.ini']); % made by explorer.exe, messes with the order
listOfnames = cell(0);

inputFileNameArray = ls([pathRoot, pathInput]);
inputFileNameArray = inputFileNameArray(3:end,:);
[noOfFiles, lengthOfFilenames] = size(inputFileNameArray);


profileName = 'opus';


for fileI = 1:noOfFiles
    for bitrateI = 1:length(bitrates)
        
        inputFilename = inputFileNameArray(fileI,:);
        inputFilename = inputFilename(inputFilename~=' ');
        outputFilename = [inputFilename(1:end-4),'_',num2str(bitrates(bitrateI)),'_',profileName];
        listOfnames{end+1} = outputFilename;
        command = [pwd,'\scripts\makeOpus\opusenc.exe --bitrate ',num2str(bitrates(bitrateI)),' "',pathRoot,pathInput,inputFilename,'" "',pathRoot,pathOutput,outputFilename,'.ogg"']
        system(command);
        
    end
end