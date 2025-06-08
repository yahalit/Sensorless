function stat = CmdDxl( ID , Payload , bytes , Offset , net  )
% function stat = CmdDxl( ID , Payload , bytes , Offset  )
% Command and axis: 
% ID: 1 to 3 for shoulder, elbow, wrist 
% Payload - data to send (no size checking is made) 
% Bytes   - Size of data in the Dynamixel control table 
% Offset  - Offset of payload, where to put in control table 

if nargin < 5 , 
    error (' CmdDxl( ID , Payload , bytes , Offset , net  )' ) ; 
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

% switch bytes
%     case 1, 
%         dtype = DataType.char ; 
%     case 2, 
%         dtype = DataType.short ; 
%     case 4, 
%         dtype = DataType.long ; 
%     otherwise, 
%         error ('Unknown number of bytes to send' )  ; 
% end 

% Set mode to 10 ( manual commands) 
stat = KvaserCom( 7 , [1536+124 ,1408+124 ,nobj,1,DataType.short,0,100], 10 ); % mode = 10 ; 
if stat , if nargout < 1 , error ('Sdo failure') ; end ; return ; end  

% Set offset in  bytes  
stat = KvaserCom( 7 , [1536+124 ,1408+124 ,nobj,2,DataType.short,0,100], Offset ); % Set bytes offset 
if stat , if nargout < 1 , error ('Sdo failure') ; end ; return  ; end 

% Set number of bytes 
stat = KvaserCom( 7 , [1536+124 ,1408+124 ,nobj,3,DataType.short,0,100], bytes ); % Set bytes number 
if stat , if nargout < 1 , error ('Sdo failure') ; end ; return ; end  

% Set payload
for cnt = 1:length( Payload) 
    stat = KvaserCom( 7 , [1536+124 ,1408+124 ,nobj,19+cnt,DataType.long,0,100], fix(Payload(cnt)) ); % Set bytes offset 
end
if stat , if nargout < 1 , error ('Sdo failure') ; end  ; return ; end 

% Transmit
IdOut = 0 ; 
for cnt = 1:length(ID) 
   IdOut = IdOut + 256^(cnt-1) * ID(cnt) ; 
end 

stat = KvaserCom( 7 , [1536+124 ,1408+124 ,nobj,100,DataType.long,0,100], IdOut ); % Set bytes offset 
if stat , if nargout < 1 , error ('Sdo failure') ; end  ; return  ; end

end

