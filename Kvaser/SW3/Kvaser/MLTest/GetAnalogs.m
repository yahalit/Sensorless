function s = GetAnalogs() 
global TargetCanId ;

s = struct() ;
DataType=struct( 'long' , 0 , 'float', 1 , 'short' , 2 , 'char' , 3 ,'string', 9 ,'lvec' , 10 ,'fvec' , 11 , 'ulvec' , 20 ) ; 

val = KvaserCom( 8 , [1536+TargetCanId ,1408+TargetCanId ,hex2dec('2204') ,1,DataType.float,0,100] ); % Get records
if ~isempty(val) 
    s.Volts24 = val ; 
else
    error ('CAN read failed for Volts24' ); 
end 

val = KvaserCom( 8 , [1536+TargetCanId ,1408+TargetCanId ,hex2dec('2204') ,2,DataType.float,0,100] ); % Get records
if ~isempty(val) 
    s.VServo = val ; 
else
    error ('CAN read failed for VServo' ); 
end 


val = KvaserCom( 8 , [1536+TargetCanId ,1408+TargetCanId ,hex2dec('2204') ,3,DataType.float,0,100] ); % Get records
if ~isempty(val) 
    s.CurServo = val ; 
else
    error ('CAN read failed for CurServo' ); 
end


val = KvaserCom( 8 , [1536+TargetCanId ,1408+TargetCanId ,hex2dec('2204') ,4,DataType.float,0,100] ); % Get records
if ~isempty(val) 
    s.CurAirPump1 = val ; 
else
    error ('CAN read failed for CurAirPump1' ); 
end 

val = KvaserCom( 8 , [1536+TargetCanId ,1408+TargetCanId ,hex2dec('2204') ,5,DataType.float,0,100] ); % Get records
if ~isempty(val) 
    s.CurAirPump2 = val ; 
else
    error ('CAN read failed for CurAirPump2 ' ); 
end 


val = KvaserCom( 8 , [1536+TargetCanId ,1408+TargetCanId ,hex2dec('2204') ,6,DataType.float,0,100] ); % Get records
if ~isempty(val) 
    s.CurAirPump3 = val ; 
else
    error ('CAN read failed for CurAirPump3' ); 
end 

val = KvaserCom( 8 , [1536+TargetCanId ,1408+TargetCanId ,hex2dec('2204') ,7,DataType.float,0,100] ); % Get records
if ~isempty(val) 
    s.V36 = val ; 
else
    error ('CAN read failed for V36' ); 
end 


val = KvaserCom( 8 , [1536+TargetCanId ,1408+TargetCanId ,hex2dec('2204') ,8,DataType.float,0,100] ); % Get records
if ~isempty(val) 
    s.VBat54_1 = val ; 
else
    error ('CAN read failed for VBat54_1' ); 
end 

val = KvaserCom( 8 , [1536+TargetCanId ,1408+TargetCanId ,hex2dec('2204') ,9,DataType.float,0,100] ); % Get records
if ~isempty(val) 
    s.VBat54_2 = val ; 
else
    error ('CAN read failed for VBat54_2' ); 
end

val = KvaserCom( 8 , [1536+TargetCanId ,1408+TargetCanId ,hex2dec('2204') ,10,DataType.float,0,100] ); % Get records
if ~isempty(val) 
    s.Volts12_1 = val ; 
else
    error ('CAN read failed for Volts12_1' ); 
end

val = KvaserCom( 8 , [1536+TargetCanId ,1408+TargetCanId ,hex2dec('2204') ,11,DataType.float,0,100] ); % Get records
if ~isempty(val) 
    s.Volts12_2 = val ; 
else
    error ('CAN read failed for Volts12_2' ); 
end

% val = KvaserCom( 8 , [1536+TargetCanId ,1408+TargetCanId ,hex2dec('2204') ,3,DataType.float,0,100] ); % Get records
% if ~isempty(val) 
%     s.CurServo = val ; 
% else
%     error ('CAN read failed for Cur5' ); 
% end

val = KvaserCom( 8 , [1536+TargetCanId ,1408+TargetCanId ,hex2dec('2204') ,13,DataType.float,0,100] ); % Get records
if ~isempty(val) 
    s.Volts5 = val ; 
else
    error ('CAN read failed for Volts5' ); 
end 
val = KvaserCom( 8 , [1536+TargetCanId ,1408+TargetCanId ,hex2dec('2204') ,14,DataType.float,0,100] ); % Get records

if ~isempty(val) 
    s.IShunt = val ; 
else
    error ('CAN read failed for IShunt' ); 
end

val = KvaserCom( 8 , [1536+TargetCanId ,1408+TargetCanId ,hex2dec('2204') ,15,DataType.float,0,100] ); % Get records
if ~isempty(val) 
    s.Cur24 = val ; 
else
    error ('CAN read failed for Cur24' ); 
end

val = KvaserCom( 8 , [1536+TargetCanId ,1408+TargetCanId ,hex2dec('2204') ,16,DataType.float,0,100] ); % Get records
if ~isempty(val) 
    s.Cur12 = val ; 
else
   % error ('CAN read failed for Cur12' ); 
end 

val = KvaserCom( 8 , [1536+TargetCanId ,1408+TargetCanId ,hex2dec('2204') ,17,DataType.float,0,100] ); % Get records
if ~isempty(val) 
    s.PumpC1 = val ; 
else
    error ('CAN read failed for PumpC1' ); 
end

val = KvaserCom( 8 , [1536+TargetCanId ,1408+TargetCanId ,hex2dec('2204') ,18,DataType.float,0,100] ); % Get records
if ~isempty(val) 
    s.PumpC2 = val ; 
else
    error ('CAN read failed for PumpC2' ); 
end


