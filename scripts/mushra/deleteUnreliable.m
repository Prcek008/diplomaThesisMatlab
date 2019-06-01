function x = deleteUnreliable(x)
    
type = size(x);
    
    if type(2) == 11
    x = x(:,:,mean(x(:,10,:))>90);
    x = x(:,:,mean(x(:,11,:))<30);
    size(x)
    
    elseif type(2) == 9
    x = x(:,:,mean(x(:,8,:))>90);
    x = x(:,:,mean(x(:,9,:))<30);
    else
        
       disp('problem')
    end
    
    size(x)
end