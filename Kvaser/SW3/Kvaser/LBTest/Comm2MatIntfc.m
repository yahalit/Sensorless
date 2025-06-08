function [RetVal,err]= Comm2MatIntfc( Service , pars  )
if ( Service == 8 ) % Get function 
    Index = pars(3) ; 
    SubIndex = pars(4) ; 
    DataType = pars(5) ; 
    [RetVal,err] = MatIntfc( 7 , [Index,SubIndex,DataType] ) ; 
    if ( isempty(err) ) 
        return ;
    end
    if nargout < 2 
        error( err ) ; 
        return ; 
    end 
end

