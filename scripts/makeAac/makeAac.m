function listOfnames = makeAac(pathRoot,pathInput,pathOutput,profile,bitrates)

delete([pathRoot, pathInput,'desktop.ini']); % made by explorer.exe, messes with the order
listOfnames = cell(0);

inputFileNameArray = ls([pathRoot,pathInput])
inputFileNameArray = inputFileNameArray(3:end,:)
[noOfFiles, lengthOfFilenames] = size(inputFileNameArray)


if strcmp(profile,'lc')

    profileName = 'LC_AAC';

elseif strcmp(profile,'he')

    profileName = 'HE_AAC_v1';

elseif strcmp(profile,'hev2')

    profileName = 'HE_AAC_v2';

else
    disp('wrong profile')
end

mkdir([pathRoot,'\samples\',pathOutput]);


for fileI = 1:noOfFiles
    for bitrateI = 1:length(bitrates)
        
        inputFilename = inputFileNameArray(fileI,:);
        inputFilename = inputFilename(inputFilename~=' ');
        outputFilename = [inputFilename(1:end-4),'_',num2str(bitrates(bitrateI)),'_',profileName];
        listOfnames{end+1} = outputFilename;
        
        command = [pwd,'\scripts\makeAac\neroAacEnc.exe -',profile,' -br ',num2str(1024*bitrates(bitrateI)),' -if "',pathRoot,pathInput,inputFilename,'" -of "',pathRoot,'\samples',pathOutput,outputFilename,'.m4a"']
        system(command);
        
    end
end