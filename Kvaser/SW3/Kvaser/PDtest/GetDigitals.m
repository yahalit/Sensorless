function s = GetDigitals() 
global TargetCanId;
s = struct() ;
DataType=struct( 'long' , 0 , 'float', 1 , 'short' , 2 , 'char' , 3 ,'string', 9 ,'lvec' , 10 ,'fvec' , 11 , 'ulvec' , 20 ) ; 

val = KvaserCom( 8 , [1536+TargetCanId ,1408+TargetCanId ,hex2dec('2005') ,41,DataType.short,0,100] ); % Get records
if ~isempty(val) 
    s.MushroomDepressed = 1-val ; 
else
    error ('CAN read failed for MushroomDepressed' ); 
end 

% val = KvaserCom( 8 , [1536+TargetCanId ,1408+TargetCanId ,hex2dec('2204') ,2,DataType.short,0,100] ); % Get records
% if ~isempty(val) 
%     s.GPBDAT = val ; 
% else
%     error ('CAN read failed for GPBDAT' ); 
% end 

% 
% val = KvaserCom( 8 , [1536+TargetCanId ,1408+TargetCanId ,hex2dec('2204') ,3,DataType.short,0,100] ); % Get records
% if ~isempty(val) 
%     s.GPCDAT = val ; 
% else
%     error ('CAN read failed for GPCDAT' ); 
% end
% 
% 
% val = KvaserCom( 8 , [1536+TargetCanId ,1408+TargetCanId ,hex2dec('2204') ,4,DataType.float,0,100] ); % Get records
% if ~isempty(val) 
%     s.GPDDAT = val ; 
% else
%     error ('CAN read failed for GPDDAT' ); 
% end 


