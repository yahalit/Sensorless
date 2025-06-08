function  SetCalibPar(name,value )
% function SetCalibPar(name,value )
% Set the value of a specific calibration parameter - to RAM only.
% name : name of the parameters (see CalibDefs.h) 
% value: value to set 
% Warning: 
% Any existing "CalibProg" setting will be over-written
global CalibTable %#ok<GVMIS> 
    
    DataType = GetDataType() ; 
    CalibObj = hex2dec('2302') ; 
    
    name = lower(name) ; 
    CalibNames = cell(1,length(CalibTable) ) ; 
    nCalibPars = length(CalibNames); 
    IsFound = 0 ; 
    for cnt = 1:nCalibPars
        next        = CalibTable{cnt} ; 
        nextname    = next{2}; 
        if isequal(lower(nextname),name) 
            name = nextname ; 
            IsFound = 1;
            break ;
        end
    end 
    if ~IsFound
        error(['Parameter :',name,' Not found']) ; 
    end 
    
    % Reset the CalibProg array from Calib contents 
    SendObj( [CalibObj,248] , 1 , DataType.long , nextname) ;

    if next{1}.IsFloat 
        SendObj( [CalibObj,cnt] , value , DataType.float , nextname) ;
    else
        SendObj( [CalibObj,cnt] , value , DataType.long , nextname ) ;
    end

    % Apply calibration 
    SendObj( [CalibObj,249] , 1 , DataType.long , nextname) ;

end 


