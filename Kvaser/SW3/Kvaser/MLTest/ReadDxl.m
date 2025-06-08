function [Rslt,stat] = ReadDxl( ID , bytes , Offset , net  )
% function stat = CmdDxl( ID , Payload , bytes , Offset  )
% Command and axis: 
% ID: 1 to 3 for shoulder, elbow, wrist 
% Payload - data to send (no size checking is made) 
% Bytes   - Size of data in the Dynamixel control table 
% Offset  - Offset of payload, where to put in control table 
global TargetCanId 

if nargin < 4
    net = 24 ; 
end

DataType=struct( 'long' , 0 , 'float', 1 , 'short' , 2 , 'char' , 3 ,'string', 9 ,'lvec' , 10 ,'fvec' , 11 , 'ulvec' , 20 ) ; 

switch net
    case 12, 
        nobj = 8192+257 ; 
    case 24, 
        nobj = 8192+256 ; 
    otherwise, 
        error ('Unrecognized net' ) ; 
end 
switch bytes, 
    case 1, 
        dt = DataType.char ; 
    case 2, 
        dt = DataType.short ; 
    case 4, 
        dt = DataType.long ; 
    otherwise, 
        error ('Unrecognized payload length' ) ; 
end        
Rslt = [] ; 


% Set mode to 10 ( manual commands) 
stat = KvaserCom( 7 , [1536+TargetCanId ,1408+TargetCanId ,nobj,1,DataType.short,0,100], 10 ); % mode = 10 ; 
if stat , if nargout < 2 , error ('Sdo failure') ; end ; return ; end  

% Set offset in  bytes  
stat = KvaserCom( 7 , [1536+TargetCanId ,1408+TargetCanId ,nobj,2,DataType.short,0,100], Offset ); % Set bytes offset 
if stat , if nargout < 2 , error ('Sdo failure') ; end ; return  ; end 

% Set number of bytes 
stat = KvaserCom( 7 , [1536+TargetCanId ,1408+TargetCanId ,nobj,3,DataType.short,0,100], bytes ); % Set bytes number 
if stat , if nargout < 2 , error ('Sdo failure') ; end ; return ; end  

% Transmit
IdOut = 0 ; 
nId = length(ID) ;
for cnt = 1:nId 
   IdOut = IdOut + 256^(cnt-1) * ID(cnt) ; 
end 

stat = KvaserCom( 7 , [1536+TargetCanId ,1408+TargetCanId ,nobj,101,DataType.long,0,100], IdOut ); % Set bytes offset 
if stat , if nargout < 2 , error ('Sdo failure') ; end  ; return  ; end

% Get the result 
Rslt = zeros(1,nId) ; 
for cnt = 1:nId
    pause(0.001) ;
    r = KvaserCom( 8 , [1536+TargetCanId ,1408+TargetCanId ,nobj,ID(cnt),dt,0,100] ); % Get record
    if isempty(r) , 
        error ( 'Could not read result') ; 
    end
    Rslt(cnt) = r ; 
end

end


