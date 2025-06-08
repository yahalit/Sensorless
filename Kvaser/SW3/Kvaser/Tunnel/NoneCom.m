function [RetVal,err] = NoneCom(~ , ~ , ~ ) 
    err = 'No communication channel is defined' ; 
    RetVal = -1 ; 
    if nargout < 2 
        error( err) ; 
    end
end 