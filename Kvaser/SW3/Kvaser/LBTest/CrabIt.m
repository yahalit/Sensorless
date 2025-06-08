function CrabIt(value  ) 

DataType = GetDataType() ; 

if ~any(value == [-1,0,1]) 
    error ('-1 for left, 0 for straight, 1 for right') ;
end

SendObj( [hex2dec('2207'),38,124] , 0.5 , DataType.float , 'Timeout for crab action' ) ;
try 
    SendObj( [hex2dec('2207'),16] , 0 , DataType.float , 'Shelf mode cmd' ) ;
    SendObj( [hex2dec('2207'),4] , 0 , DataType.float , 'CurvatureCmd') ;
    SendObj( [hex2dec('2207'),10] , value , DataType.float ,'CrabCrawl cmd') ;
    SendObj( [hex2dec('2207'),100] , 1 , DataType.float , 'Start manual ground cmd' ) ;
catch 
    uiwait( errordlg('Robot must be in the operational mode') ) ; 
    Stack = dbstack ; 
    Stack = Stack(1) ; 
    
    errstruct  = struct ('message','Could not load Ground Navigation dialog','identifier','CalibNeck:InitConditions','stack',Stack) ; 

    error(errstruct);    
end 
