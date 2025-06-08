AtpStart;
global TargetCanId

data = ones( 1, 2048  ) ; 
Set2FlashData = cumsum( data * 8) ; 

FlashProgSize = length(data) 
FlashProgAdd = hex2dec('B0000');
SdoGetId = 1536 + TargetCanId ; 
SdoSetId = 1408 + TargetCanId ; 


FlasgSecStarts = [ hex2dec('82000'),hex2dec('84000'),hex2dec('86000'),hex2dec('88000'),hex2dec('90000'),hex2dec('98000'),hex2dec('A0000'),hex2dec('A8000'),hex2dec('B0000') ];
FlashSegIndex = max( find ( FlashProgAdd >= FlasgSecStarts ) ) ; 




% Just clear the state of the SDO machine by dummy read
KvaserCom( 8 , [SdoGetId ,SdoSetId ,hex2dec('2300') ,0,DataType.long,0,100] ); 

% Read the length of programming buffer
ProgBufLen = KvaserCom( 8 , [SdoGetId ,SdoSetId ,hex2dec('2301') ,3,DataType.long,0,100] );  
if isempty(ProgBufLen) || (ProgBufLen < 2048) || ( ProgBufLen > 8192) 
    error ( 'Bad length for programming buffer') ; 
end 

% Set the password
stat = KvaserCom( 7 , [SdoGetId ,SdoSetId ,hex2dec('2301'),1,DataType.long,0,100], hex2dec('12345678') ); % Recorder gap 
if stat , error ('Sdo failure') ; end 

% Set the flash address 
stat = KvaserCom( 7 , [SdoGetId ,SdoSetId ,hex2dec('2301'),100,DataType.long,0,100], FlashProgAdd  );
if stat , error ('Sdo failure') ; end 

% Set the data in the flash buffer 
tt = clock () ;
InternalBufOffset = 0; 
while ( InternalBufOffset < ProgBufLen ) 
    disp ( 'Downloading 256...') ; 
    stat = KvaserCom( 7 , [SdoGetId ,SdoSetId ,hex2dec('2301'),2,DataType.long,0,100], InternalBufOffset ); 
    if stat , error ('Sdo failure') ; end 
    
    NextChunk = Set2FlashData( 1 + InternalBufOffset : 256 + InternalBufOffset ) ;
    for cnt = 1:256 , 
        stat = KvaserCom( 7 , [SdoGetId ,SdoSetId ,hex2dec('2300'),cnt-1,DataType.long,0,100], NextChunk(cnt) ); 
        if stat , error ('Sdo failure') ; end 
    end 
    
    InternalBufOffset = InternalBufOffset + 256 ;
end
etime( clock() , tt ) 


% Erase sector
stat = KvaserCom( 7 , [SdoGetId ,SdoSetId ,hex2dec('2301'),130,DataType.long,0,100], FlashSegIndex  );
if stat , error ('Sdo failure') ; end 

% Burn new data 
stat = KvaserCom( 7 , [SdoGetId ,SdoSetId ,hex2dec('2301'),131,DataType.long,0,100], FlashProgSize * 2  );
if stat , error ('Sdo failure') ; end 



