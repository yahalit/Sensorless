% function KillLpResponse( ) 
% Kill LP
global DataType 
    SendObj( [hex2dec('2103'),201] , 1 , DataType.long , 'Disable response to LP commands' ) ;

%     Bypass local supplies
    SendObj( [hex2dec('2004'),106] , 1 , DataType.short , 'Bypass 12V VDC' ) ;
    SendObj( [hex2dec('2004'),107] , 1 , DataType.short , 'Bypass 24V VDC' ) ;
%     SendObj( [hex2dec('2004'),108] , 1 , DataType.short , 'Bypass 12V net initialization' ) ;

    
    % Inhibit locks
    SendObj( [hex2dec('2103'),201] , 1 , DataType.long , 'Inhibit locks' ) ;

    % Restart man
    SendObj( [hex2dec('2004'),4] , 1,DataType.short ,'Restart stop shelves comm'); % Set Manipulator network on  
    SendObj( [hex2dec('2004'),5] , 1,DataType.short ,'Restart manipulator comm'); % Set Manipulator network on  
    
    SendObj( [hex2dec('2003'),4] , 1,DataType.short ,'Set laser PS on'); 
  
    return 
    
    %Motor on shoulder
    SendObj( [hex2dec('2103'),10] , 1 , DataType.long , 'Shoulder ON' ) ;
    SendObj( [hex2dec('2103'),20] , 1 , DataType.long , 'Elbow ON' ) ;
    SendObj( [hex2dec('2103'),30] , 1 , DataType.long , 'Wrist ON' ) ;

    pause(0.1) ; 
    
    % Program dead as duck 
%     SendObj( [hex2dec('2103'),203] , 1 , DataType.long , 'Dead duckling' ) ;
    
    
    % Program x and y targets 2209(60) : x  , 2209:61: y , 2209:62: ds 
    SendObj( [hex2dec('2209'),1] , 2 , DataType.float , '1: Left , 2: right' ) ;
    SendObj( [hex2dec('2209'),60] , -0.3 , DataType.float , 'X target' ) ;
    SendObj( [hex2dec('2209'),61] ,0.5 , DataType.float , 'Y target' ) ;
    SendObj( [hex2dec('2209'),62] , 0.2    , DataType.float , 'Coordinated Line speed' ) ;
    
    pause(2.5) ; 
    % Init profile: 2209(70) , go to target: 2209 (71) 
    SendObj( [hex2dec('2209'),70] , 1.0    , DataType.float ,'Init coordinated profile' ) ;
    SendObj( [hex2dec('2103'),203] , 0 , DataType.long , 'Dead duckling' ) ;

    SendObj( [8192,100],1,DataType.short ,'Set recorder on' ); % Set the recorder on
    SendObj( [hex2dec('2209'),71] , 1.0    , DataType.float ,'Run coordinated profile' ) ;
    
    return 
    
    
    
% Recorder
%     SendObj( [8192,100],1,DataType.short ,'Set recorder on' ); % Set the recorder on

    % Send shoulder
    SendObj( [hex2dec('2103'),11] , 600 , DataType.long , 'Shoulder ref' ) ;    
    SendObj( [hex2dec('2103'),21] , -1000 , DataType.long , 'Elbow ref' ) ;  
    
    SendObj( [8192,100],1,DataType.short ,'Set recorder on' ); % Set the recorder on
    SendObj( [hex2dec('2103'),31] ,1000 , DataType.long , 'Wrist ref' ) ;    