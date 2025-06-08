function  Calib = ProgCalibPD(fname, burn , fieldNames )
% function  Calib = ProgCalibPD(fname, burn , fieldNames )
% Read calibration from a file, and optionally burn it into the robot 
% fname : Name of file 
% 1     : 1 if to burn it into flash 
% fieldNames: Names of fields for calibration struct members 
% Returns: 
% Struct with the parameters that where in the file 
global TargetCanId 
global DataType

if nargin < 2 || isempty(burn)   
    burn = 0 ; 
end 

if nargin < 3  
    fieldNames = {'RDoorCenter' , 'RDoorGainFac' , 'LDoorCenter' , 'LDoorGainFac' ,'ShoulderCenter' , 'ElbowCenter' , 'WristCenter' ,...
    'V36Gain','V36Offset', ...
     'Spare10' , 'Spare11' , 'Spare12' , 'Spare13','Spare14','Spare15','Spare16','Spare17','Spare18'} ;
end 

% Open and read the file 
fi = fopen( fname,'r') ;
if isequal( fi, -1) 
    error ( ['Could not open file [',fname,'] for read']) ; 
end
json_string = fread( fi , inf , 'uint8=>char') ;  

fclose( fi) ; 
json2data=loadjson(transpose(json_string(:))); 

Calib = json2data.Calib ; 

if ( burn == 0 )  
    return ; 
end 

fields = [fieldNames ,{'CalibDate','CalibData'}] ; 
junk = isfield( Calib, fields ) ; 

if ( any ( junk ==0 ) ) 
    disp ( fields(find(junk==0) ) ) ;  %#ok<FNDSB>
    error ('Field is missing in the JSON data') ;
end 

SendObj( [hex2dec('2302'),1] , hex2dec('12345678') , DataType.long , 'Flash op password' ) ;
for cnt = 1 : length(fieldNames) 
    SendObj( [hex2dec('2302'),1+cnt] , Calib.(fieldNames{cnt}) , DataType.float , ['Set calib par [',fieldNames{cnt},']'] ) ;
end

stat = KvaserCom( 7 , [1536+TargetCanId ,1408+TargetCanId ,hex2dec('2302') ,20,DataType.long,0,100], Calib.CalibDate  );  
if stat , error ('Sdo CalibDate failure') ; end 

stat = KvaserCom( 7 , [1536+TargetCanId ,1408+TargetCanId ,hex2dec('2302') ,21,DataType.long,0,100], Calib.CalibData  );  
if stat , error ('Sdo CalibData failure') ; end 

SendObj( [hex2dec('2302'),33] ,Calib.CalibData  , DataType.long , 'Sdo Burn calib failure' ,[] , 300) ;

end 


