function fromOpus(pathRoot,pathInput,pathOutput)

inputFilenameArray = string(ls([pathRoot,pathInput]));
inputFilenameArray = inputFilenameArray(3:end,:);
[noOfFiles, ~] = size(inputFilenameArray);

%%


for fileI = 1:noOfFiles
    
    inputFilename = char(inputFilenameArray(fileI));
    inputFilename = inputFilename(inputFilename~=' ');
    
    outputFilename = [inputFilename(1:end-4),'.wav'];
    command = ['"',pwd,'\scripts\makeWav\opusdec.exe" "',pathRoot,pathInput,inputFilename,'" "',pathRoot,pathOutput,outputFilename,'"'];
    system(command);
end

end