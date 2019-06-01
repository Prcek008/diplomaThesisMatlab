function fromMp2(pathRoot,pathInput,pathOutput)

mkdir([pathRoot,pathOutput]);

inputFileNameArray = ls([pathRoot, pathInput]);
inputFileNameArray = inputFileNameArray(3:end,:);
[noOfFiles, lengthOfFilenames] = size(inputFileNameArray);
for fileI = 1:noOfFiles
    
    inputFilename = inputFileNameArray(fileI,:);
    inputFilename = inputFilename(inputFilename~=' ');
    outputFilename = [inputFilename(1:end-4),'.wav'];
    
    command = [pwd,'\scripts\makeWav\ffmpeg.exe -i "',pathRoot,pathInput,inputFilename,'" "',pathRoot,pathOutput, outputFilename,'" -ar 48000'];
    system(command);
end

end