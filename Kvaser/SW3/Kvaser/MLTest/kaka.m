%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Program a dynamixel MX430W350 on the 12V net of the PD to have a new ID
% NOTE!!!   
% The dynamixel axis must be ALONE on the network while programming its ID
% PreviousId : Old, known ID of Dynamixel 
% NextId     : The next ID to program this axis
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
success = KvaserCom(1) ; 

% Verify model number  
DxId = 3; 
[Rslt,stat] = ReadDxl(DxId , 2 , 0 , 24  );
if ( stat ) 
    error ( 'CAN communication with PD failed') ; 
end 
disp( ['Dynamixel pro [',num2str(DxId),'] found as model number [',num2str(Rslt) ,']']) ; 
DxId = 4; 
[Rslt,stat] = ReadDxl(DxId , 2 , 0 , 24  );
if ( stat ) 
    error ( 'CAN communication with PD failed') ; 
end 
disp( ['Dynamixel pro [',num2str(DxId),'] found as model number [',num2str(Rslt) ,']']) ; 
DxId = 5; 
[Rslt,stat] = ReadDxl(DxId , 2 , 0 , 24  );
if ( stat ) 
    error ( 'CAN communication with PD failed') ; 
end 
disp( ['Dynamixel pro [',num2str(DxId),'] found as model number [',num2str(Rslt) ,']']) ; 

DxId = 6; 
try
    [Rslt,stat] = ReadDxl(DxId , 2 , 0 , 24  );
    disp( ['Dynamixel pro [',num2str(DxId),'] found as model number [',num2str(Rslt) ,']']) ; 
catch  
    disp( ['Dynamixel pro [',num2str(DxId),'] Not responsive']) ; 
end 
