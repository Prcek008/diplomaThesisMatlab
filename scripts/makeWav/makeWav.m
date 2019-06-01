function makeWav(pathRoot,pathInput,pathOutput,profile)

if strcmp(profile,'lc')
    
    fromAac(pathRoot,pathInput,pathOutput)
    
elseif strcmp(profile,'he')
    
    fromAac(pathRoot,pathInput,pathOutput)
    
elseif strcmp(profile,'hev2')
    
    fromAac(pathRoot,pathInput,pathOutput)
    
elseif strcmp(profile,'mp2')
    
    fromMp2(pathRoot,pathInput,pathOutput)
    
elseif strcmp(profile,'opus')
    
    fromOpus(pathRoot,pathInput,pathOutput)
    
else
    disp('wrong profile')
end

end

