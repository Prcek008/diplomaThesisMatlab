function FromAac(pathRoot,pathInput,pathOutput)

mkdir([pathRoot,pathOutput]);

inputFileNameArray = ls([pathRoot, pathInput]);
inputFileNameArray = inputFileNameArray(3:end,:);
[noOfFiles, lengthOfFilenames] = size(inputFileNameArray);
for fileI = 1:noOfFiles
    
    inputFilename = inputFileNameArray(fileI,:);
    inputFilename = inputFilename(inputFilename~=' ');
    outputFilename = [inputFilename(1:end-4),'.wav'];
    
    command = [pwd,'\scripts\makeWav\neroAacDec.exe -if "',pathRoot,pathInput,inputFilename,'" -of "',pathRoot,pathOutput, outputFilename,'"']
    system(command);
end

end