%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Program a dynamixel MX430W350 on the 12V net of the PD to have a new ID
% NOTE!!!   
% The dynamixel axis must be ALONE on the network while programming its ID
% PreviousId : Old, known ID of Dynamixel 
% NextId     : The next ID to program this axis
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
PreviousId = 1; 
NextId = 2; 

success = KvaserCom(1) ; 

% Verify communication by correct type ID 
[Rslt,stat] = ReadDxl(PreviousId , 2 , 0 , 12  );
if ( stat ) 
    error ( 'CAN communication with PD failed') ; 
end 
if ~isequal(Rslt,1020) 
    error ( 'Dynamixel did not identify as XM430W350 (type 1020) ') ; 
end 

[Rslt,stat] = ReadDxl(PreviousId , 1 , 7 , 12  );
if ( stat ) 
    error ( 'CAN communication with PD failed') ; 
end 
if ~isequal(Rslt,PreviousId) 
    error ( 'Dynamixel ID did not read back correctly ') ; 
end 


disp( ['Communication established with ID=', num2str(PreviousId)] ) ;

disp ( ['Programming next ID=', num2str(NextId) ]) ; 
stat = CmdDxl( PreviousId , NextId , 1 , 7 , 12  );
if ( stat ) 
    error ( 'CAN communication with PD failed') ; 
end 

disp('Wait two seconds ....' ) ;
pause (2) ; 

disp( ['Verifying the new ID=', num2str(NextId)] ) ;
[Rslt,stat] = ReadDxl(NextId , 1 , 7 , 12  );
if ( stat ) 
    error ( 'CAN communication with PD failed') ; 
end 
if ~isequal(Rslt,NextId) 
    error ( 'Dynamixel ID verification failed ') ; 
end 

disp( ['Communication verified with new ID=', num2str(NextId)] ) ;

