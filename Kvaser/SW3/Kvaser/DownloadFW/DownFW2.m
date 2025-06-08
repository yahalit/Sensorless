global messageFig;

messageFig = figure;
version = '1.3'; %forgot to raise to 1.2
UpdateTxtBox({['SW version: ', version], 'Initializing...'});

if ~isdeployed()
    ProjectHexLoc  = '..\..\Exe\' ; 
else
    ProjectHexLoc = '..\..\LP files\Exe\'; 
end

HexName = 'BolshoyManip.hex';

CodeStartAddress = hex2dec('86000') ; 
CreateStruct =  struct('Interpreter','tex','WindowStyle' , 'modal') ; 

tic
AtpStartCom ;

if isequal(AtpCfg.CommType,'UDP') 
    msgbox({'\fontsize{14}Download firmware is only available through CAN','Use CommSetup for setup to CAN'},CreateStruct); 
    errorClose({'Download firmware is only available through CAN','Use CommSetup for setup to CAN'}, messageFig);
    return ; 
end 

if ~(TargetCanId==124) 
    errorClose('Target CAN ID should be 124 for second core download', messageFig) ; 
end 

uiwait(msgbox({'Verify connection to CAN #1','Press mushroom','Power cycle the robot','And press OK'})) ; 


FlashSecStarts = [ hex2dec('82000'),hex2dec('84000'),hex2dec('86000'),hex2dec('88000'),hex2dec('90000'),hex2dec('98000'),...
    hex2dec('A0000'),hex2dec('A8000'),hex2dec('B0000'),hex2dec('B8000') ,hex2dec('Ba000'),hex2dec('Bc000'),hex2dec('Be000')];
GamiliAddress  = FlashSecStarts(end) ;
AddressFinal = GamiliAddress ;

% The (max address + 1 )  must divide neatly in 2048 
nbytesmod = 8192 ; % 2048 longs per buffer  = 8192 bytes 
ProgBufLenLimits = [2048,8192] ; 
GamiliSector = 13 ; 
ProgChunkSize = 2048 ;

SdoGetId = 1536 + TargetCanId ; 
SdoSetId = 1408 + TargetCanId ; 
LpSdoGetId = 1536 + TargetCanId ; 
LpSdoSetId = 1408 + TargetCanId ; 
SdoGetId2 = 1536 + TargetCanId2 ; 
SdoSetId2 = 1408 + TargetCanId2 ; 

% fname = [ProjectRoot,'Debug\',HexName] ; 
%fname = [ProjectHexLoc2,'\',HexName2] ;   
% if ( contains(HexName,'PD') ) 
%     errordlg({'For downloading PD software', 'please use DownFWPD'}) ;
%     return ; 
% end 

Initials = HexName(1:end-4);
defaultName = [ProjectHexLoc, FindLatestFile(ProjectHexLoc, Initials)];

[filename, pathname] = ...
     uigetfile({'*.hex'},'Select FW file',defaultName);
 
fname = [pathname,filename] ; % [ProjectRoot,'Debug\',HexName] ; 

ButtonName = questdlg({'Is this FW file correct?';fname}, ...
                         'Please approve', ...
                         'Approve', 'Reject', 'Reject');
if ~isequal(ButtonName,'Approve')
    %disp( ['Downloading FW from file [',fname,'] has been rejected'] ) ; 
    UpdateTxtBox( ['Downloading FW from file [',fname,'] has been rejected'] ) ; 
    return ; 
end 



%disp( ['Reading the project HEX file ', fname] ) ; 
UpdateTxtBox( ['Reading the project HEX file ', fname] ) ; 


EndIsNext = 0 ; 
fid = fopen( fname ) ; 

if isequal(fid,-1) 
    errorClose (['Cant find .hex file [',fname,']'] , messageFig) ; 
end

minadd = 2^32 ; 
maxadd = -minadd ; 
cnttest = 840 ; 

for cnt = 1:1000000 
          
    tline = fgets( fid) ; 
    if isequal( tline , -1)
        if ( ~EndIsNext ) 
            errorClose ('Premature end of file' , messageFig) ; 
        end 
        break;
    else
        if EndIsNext 
            if tline(1) == '%'
                errorClose ('Expected end of file' , messageFig) ; 
            end 
        else
            if ~( tline(1) == '%')
                errorClose ('First character must be a percent sign' , messageFig) ; 
            end 
        end
    end 
    tline = deblank(tline) ; 
    
    reclen   = hex2dec( tline(2:3) ); 
    linetype = tline(4); 
    if ( linetype == '8' ) 
        EndIsNext = 1; 
        continue ; 
    else
        if ~( linetype == '6' ) 
            errorClose ( 'Expected a data line ', messageFig) ; 
        end
    end
    csum  = hex2dec( tline(5:6) ); 
    if ~( tline(7) == '8')
        errorClose ( 'Address number of digits should be 8', messageFig) ; 
    end
    if  ~( reclen == length( tline)-1 ) 
        errorClose ( 'Unexpected line length', messageFig) ; 
    end 
    
    address = hex2dec( tline(8:15) ); 
    nbytes  = (reclen - 14)/2 ; 
    
    minadd = min( minadd , address ) ;
    if ( address < AddressFinal ) 
        % Last sector is only for password, checksums, etc. , avoid it 
        maxadd = max( maxadd , address + nbytes - 1) ; 
    end 
    
    if ~(nbytes == fix(nbytes)) 
          errorClose ('Record should contain only full bytes', messageFig) ;
    end 
    
    cs = hex2dec(tline(2))+hex2dec(tline(3))+hex2dec(tline(4))  ; 
    ind = 16 ; 
    
    for c1 = 7:length(tline) 
        cs  = cs + hex2dec( tline(c1) )  ; 
    end 
    if ~( mod(cs,256) == csum ) 
        errorClose ( 'Checksum error', messageFig) ; 
    end  
end

fclose(fid ) ; 

n = fix( (maxadd+1) /nbytesmod) ; 
if ( n * nbytesmod ~= (maxadd+1) )
    maxadd = nbytesmod * (n+1) - 1 ;  
end 

space = ones( 1 , (maxadd - minadd + 1)*2  ) * 255 ; 
fid = fopen( fname ) ; 

for cnt = 1:1000000 
    tline = fgets( fid) ; 
    tline = deblank(tline) ; 

    reclen   = hex2dec( tline(2:3) ); 
    linetype = tline(4); 
    if ( linetype == '8' ) 
        break ; 
    end
    
    address = hex2dec( tline(8:15) ); 
    
    if address >= AddressFinal  
        % Disregard password and checksum info 
        continue ; 
    end 
    
    nbytes  = (reclen - 14)/2 ; 

    for c1 = 1:2:nbytes
       reladd = ( address - minadd ) * 2 ; % Take the relative address to bytes , as "space" is byte-wise 
       space( reladd + 1) = hex2dec( tline( 14+c1*2:15+c1*2) ) ; 
       space( reladd + 2) = hex2dec( tline( 16+c1*2:17+c1*2) ) ; 
       address = address + 1 ;
    end 
end
fclose(fid ) ; 

% Here space is a linear span of the entire program
% The words are arranged in little endian (first is the most significant byte)
% We discard bytes in the range 0x80000 to 0x83fff, because these belong to
% the boot
%MinAddress = hex2dec('84000') ; 
MinAddress = CodeStartAddress ;
if ( minadd > MinAddress ) 
    errorClose ( 'Code must start at the beginning of sector C', messageFig) ; 
end 
if ( minadd < MinAddress ) 
    space (1:((MinAddress-minadd)*2)) = [] ;  
    minadd = MinAddress ; 
end

% Verify again that length of space divides neatly in 4
nspace = length( space) ; 
nblocks = fix( nspace/nbytesmod);
if  nblocks * nbytesmod ~= nspace  
    errorClose ( ['Space length must divide neatly in ',num2str(nbytesmod)] , messageFig) ; 
end 

% Deal endianess and generate buffer of longs 
s1 = space(1:4:nspace) ; 
s2 = space(2:4:nspace) ; 
s3 = space(3:4:nspace) ; 
s4 = space(4:4:nspace) ; 

spacel = ( s1 * 256 + s2 )  +  (s3 * 256 + s4)* 65536 ;

% Get CS start, CS end, and CS 
CsStart = minadd ; 
CsEnd   = minadd + length(spacel) * 2 - 1 ; 
CSum    = 2^32 - mod ( sum(spacel) , 2^32 ) ; 
%disp ( ['Code start = 0x', dec2hex(CsStart) , '  Code last=0x' , dec2hex(CsEnd) , '  Checksum=0x', dec2hex(CSum) ]) ; 
UpdateTxtBox ( ['Code start = 0x', dec2hex(CsStart) , '  Code last=0x' , dec2hex(CsEnd) , '  Checksum=0x', dec2hex(CSum) ]) ; 

% Find sectors for erasure 
FlashSegMax = max( find ( maxadd  >= FlashSecStarts ) ) ;  %#ok<*MXFND>

FlashSegMin = ( minadd  >= FlashSecStarts ); 
if ~any( FlashSegMin ) 
    errorClose ( 'Program starts too early', messageFig) ; 
end 
FlashSegMin = max( find ( minadd  >= FlashSecStarts ) ) ; 

if ( FlashSegMax >= length(FlashSecStarts) ) 
    errorClose ( 'Program is too big', messageFig) ; 
end 

%%%%%%%% PROGRAMMING %%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%disp( 'Reading project identity ...' ) ; 
UpdateTxtBox( 'Reading project identity ...' ) ; 


% Just clear the state of the SDO machine by dummy read
KvaserCom( 8 , [SdoGetId ,SdoSetId ,hex2dec('2300') ,0,DataType.long,0,100] ); 

% Read the length of programming buffer
ProgBufLen = KvaserCom( 8 , [SdoGetId ,SdoSetId ,hex2dec('2301') ,3,DataType.long,0,100] );

if isempty(ProgBufLen) 
    errorClose ( 'Cannot establish CAN communication with target', messageFig) ; 
end

if  (ProgBufLen < ProgBufLenLimits(1)) || ( ProgBufLen > ProgBufLenLimits(2)) 
    errorClose ( 'Bad length for programming buffer', messageFig) ; 
end

% FwVer       = KvaserCom( 8 , [SdoGetId ,SdoSetId ,hex2dec('2301') ,4,DataType.long,0,100] );
ProjType    = KvaserCom( 8 , [SdoGetId ,SdoSetId ,hex2dec('2301') ,5,DataType.long,0,100] );

% NewBoot     = 0 ; 
if ProjType == hex2dec('8180') 
   %disp('Loader works through LB CPU operational software' ) ; 
   UpdateTxtBox('Loader works through LB CPU operational software' ) ; 
else
    errorClose ('SW of CPU 2 must be loaded using standard operational SW', messageFig) ; 
end
ProjType2 = KvaserCom( 8 , [SdoGetId2 ,SdoSetId2 ,hex2dec('2301') ,5,DataType.long,0,100] ); 
ProjType2 = bitand( ProjType2 + 2^16 , 2^16-1);
switch  ProjType2
    case hex2dec('8081') 
        Operational = 0 ; 
        %disp('Found CORE2 boot software' ) ; 
        UpdateTxtBox('Found CORE2 boot software' ) ; 
    case hex2dec('8580') 
        Operational = 1 ; 
        %disp('Found CORE2 operational software' ) ; 
        UpdateTxtBox('Found CORE2 operational software' ) ; 
%     case hex2dec('8680') 
%         Operational = 1 ; 
%         disp('Found CORE2 operational software' ) ; 
    otherwise
        errorClose('Cannot identify project type of CPU2', messageFig) ; 
end
 
% Set authority 
KvaserCom( 7 , [SdoGetId ,SdoSetId ,hex2dec('2220'),5,DataType.short,0,100], hex2dec('1234')) ; 


% Verify PD is absent or mushroom depressed 
val = KvaserCom( 8 , [SdoGetId ,SdoSetId ,hex2dec('2220') ,100,DataType.long,0,100] ); % Get status 
PdAbsent = bitget( val , 3) ; 
MushroomDepressed = bitget( val , 19) ; 

if ( PdAbsent == 0 ) 
    if ( MushroomDepressed == 0 ) 
        mushAns = questdlg({'The Mushroom emergency switch must be depressed on SW download','Proceed?'}, 'Decision', 'Yes', 'No', 'No');
        if ~isequal(mushAns,'Yes')
            errorClose ( 'The Mushroom emergency switch must be depressed on SW download', messageFig) ; 
        end
    end 
    % Kill PD-LP communication. It wont harm anyway 
    stat = KvaserCom( 7 , [LpSdoGetId ,LpSdoSetId ,hex2dec('2220'),1,DataType.short,0,100], 1) ; 
    if stat 
        %disp('Maybe you are connected to CAN2? ') ; 
        errorClose ('Could not kill PD commmunication', messageFig) ; 
    end
end     



% Kill servo 
KvaserCom( 7 , [SdoGetId ,SdoSetId ,hex2dec('2220'),13,DataType.short,0,100], 1) ; 

% Make CPU1 relinquish flash pumps 
KvaserCom( 7 , [SdoGetId ,SdoSetId ,hex2dec('2301'),132,DataType.long,0,100], 1234) ; 

% Set the password for flash operations and initialize flash 
stat = KvaserCom( 7 , [SdoGetId2 ,SdoSetId2 ,hex2dec('2301'),1,DataType.long,0,100], hex2dec('12345678') ); 
if stat , errorClose ('Could not initialize flash memory', messageFig) ; end     

if Operational 
    % Clear sector N 
    stat = KvaserCom( 7 , [SdoGetId2 ,SdoSetId2 ,hex2dec('2301'),130,DataType.long,0,100], GamiliSector ); 
    if stat , errorClose ('Could not clear management sector ', messageFig) ; end     
 
    % Go to boot 
    % CAN transaction may fail because FW perishes before answering
    try
        KvaserCom( 7 , [SdoGetId2 ,SdoSetId2 ,hex2dec('2301'),244,DataType.long,0,100], 1234 ); 
    catch 
    end 
    
    %disp( 'Waiting 1 sec for reboot') ; 
    pause(1) ; 
    
    % Refresh flash initialization after reboot 
    stat = KvaserCom( 7 , [SdoGetId2 ,SdoSetId2 ,hex2dec('2301'),1,DataType.long,0,100], hex2dec('12345678') ); 
    if stat , errorClose ('Could not initialize flash memory', messageFig) ; end     
    
    % Verify we work against the boot 
    ProjType2 = KvaserCom( 8 , [SdoGetId ,SdoSetId ,hex2dec('2301') ,6,DataType.long,0,100] ) ;
    ProjType2 =  bitand( ProjType2 + 2^16 , 2^16-1);
    if ~ProjType2 == hex2dec('8500') 
        errorClose ('Expected to find boot SW for CPU2', messageFig); 
    end 
end 


% First to clear is the password segment Flash  
FlashSects2Clear = [ GamiliSector , (FlashSegMin : FlashSegMax)] ; 
for cnt = 1:length(FlashSects2Clear) 
    NextSec =FlashSects2Clear(cnt) ; 
    stat = KvaserCom( 7 , [SdoGetId2 ,SdoSetId2 ,hex2dec('2301'),130,DataType.long,0,100], NextSec ); 
    if stat
        errorClose (['Could not clear sector ', num2str(NextSec) ], messageFig) ; 
    end     
end 

%disp( 'Cleared all the relevant sectors...') ; 
UpdateTxtBox( 'Cleared all the relevant sectors...') ; 

BlockSize = nbytesmod / 4 ; 
BaseAddress = minadd ;

tburnall = clock () ;

disp( ['programming ',num2str(nblocks),'  Blocks']) ; 
% Program in the reverse order so that last to program is the code start 
for blcnt = nblocks:-1:1  
    StartAdd = (blcnt-1)*BlockSize*2 + minadd; 
    NextBlock = spacel(1+(blcnt-1)*BlockSize:blcnt*BlockSize) ; 
    if all( NextBlock == 4294967295 ) 
        % page does not contain any info 
        %disp( ['Skipping empty block at 0x',dec2hex(StartAdd)]) ; 
        UpdateTxtBox( ['Skipping empty block at 0x',dec2hex(StartAdd)],0) ; 
        continue ;
    end 
    
    % Set the flash address 
    stat = KvaserCom( 7 , [SdoGetId2 ,SdoSetId2 ,hex2dec('2301'),100,DataType.long,0,100], StartAdd  );
    if stat , errorClose ('Couldnt program flash page address ', messageFig) ; end 

    % Set the data in the flash buffer 
    tt = clock () ;
    InternalBufOffset = 0; 
    
    %disp( ['Programming internal block, start at 0x',dec2hex(StartAdd), '  Wait: Block takes about 1.3 sec' ]) ; 
    UpdateTxtBox( {['Programming internal block, start at 0x',dec2hex(StartAdd)], ['  Wait: Block takes about 1.3 sec',''] },0) ; 

    % Note that after upload the buffer simply resides at CPU1 
    stat = KvaserCom( 20 , [SdoGetId  ,SdoSetId  ,hex2dec('2303'),0,DataType.long,0,100], NextBlock(1:ProgBufLen)  ); 
    if stat , errorClose ('Could not program internal buffer in block mode', messageFig) ; end 
    %disp( ['Page programming time: ' , num2str(etime( clock() , tt ) ) ] ) ; 
    %disp( ['Burn to flash, start at 0x',dec2hex(StartAdd) ]) ; 
    UpdateTxtBox ({['Page programming time: ' , num2str(etime( clock() , tt ) ) ] , ['Burn to flash, start at 0x',dec2hex(StartAdd) ]},0);
    
    % Instruct CPU1 to pass the buffer into CPU2
    SendObj([hex2dec('2301'),151,TargetCanId], 1234,DataType.long,'copy buffer to CPU2') ; 
%     stat = KvaserCom( 7 , [SdoGetId ,SdoSetId ,hex2dec('2301'),151,,0,100] ); 
%             if stat , error ('Could not copy buffer to CPU2') ; end 
    
            
    % Instruct CPU2 to burn program chunk
    stat = KvaserCom( 7 , [SdoGetId2 ,SdoSetId2 ,hex2dec('2301'),131,DataType.long,0,100], 1234 ); 
            if stat , errorClose ('Could not burn to flash', messageFig) ; end 
end 

% .. Statistics to sector N 
%disp( 'Download flash statistics' ) ; 
UpdateTxtBox( 'Download flash statistics' ) ; 

stat = KvaserCom( 7 , [SdoGetId2 ,SdoSetId2 ,hex2dec('2301'),100,DataType.long,0,100], GamiliAddress  ); % Flash address 
            if stat , errorClose ('Could not program statistics section start', messageFig) ; end 
stat = KvaserCom( 7 , [SdoGetId2 ,SdoSetId2 ,hex2dec('2301'),2,DataType.long,0,100], 0 ); % Internal offset 
            if stat , errorClose ('Could not program statistics section offset', messageFig) ; end 



% if stat , error ('Could not program internal buffer offset') ; end 
NextChunk = ones( 1, ProgChunkSize ) * (2^32-1) ; 
NextChunk(1) = ShuffleLong( hex2dec('12345678') ) ; 
NextChunk(2) = ShuffleLong( CsStart )  ;
NextChunk(3) = ShuffleLong(CsEnd) ;
NextChunk(4) = ShuffleLong(CSum)  ; 

for cnt = 1:256  
    stat = KvaserCom( 7 , [SdoGetId2 ,SdoSetId2 ,hex2dec('2300'),cnt-1,DataType.long,0,100], NextChunk(cnt) ); 
    if stat , errorClose ('Could not program internal buffer data', messageFig) ; end 
end 
%disp( ['Burn statistics to flash, start at 0x', dec2hex(GamiliAddress) ]) ; 
UpdateTxtBox( {'Burn statistics to flash, start at 0x', dec2hex(GamiliAddress) }) ; 

stat = KvaserCom( 7 , [SdoGetId2 ,SdoSetId2 ,hex2dec('2301'),131,DataType.long,0,100], 1234 ); 
            if stat , errorClose ('Could not burn to flash', messageFig) ; end 

%disp( ['Entire programming time: ' , num2str(etime( clock() , tburnall ) ) ] ) ; 
UpdateTxtBox( ['Entire programming time: ' , num2str(etime( clock() , tburnall ) ) ] ) ; 

% CreateStruct.Interpreter = 'tex';
% CreateStruct.WindowStyle = 'modal';
uiwait( msgbox({'PLEASE POWER CYCLE THE ENTIRE ROBOT','Release the mushroom','Press enter when brake realease is heard'}) )  ;

disp('Waiting:') ; 
UpdateTxtBox('Waiting:') ; 

pause (2); 

% 
% disp('Reboot... Wait 1 sec ' ) ;
% try 
%     % Ask reboot (also of CPU1!), no answer is expected, so response shall be a "Failure",
%     % thus the try...catch 
%     KvaserCom( 7 , [SdoGetId ,SdoSetId ,hex2dec('2301'),244,DataType.long,0,100], 0  );
% catch 
% end 
% pause (1); 
% disp('PLEASE POWER CYCLE THE ENTIRE ROBOT' ) ; 
% disp('FOR RE_ESTABLISHING SYNCHRONISATION BETWEEN ROBOT parts' ) ; 

FwVer       = KvaserCom( 8 , [SdoGetId ,SdoSetId ,hex2dec('2301') ,4,DataType.long,0,100] );
if isempty(FwVer) 
    errorClose ('Reboot failed after downloading firmware', messageFig ) ; 
end

ProjType2 = KvaserCom( 8 , [SdoGetId ,SdoSetId ,hex2dec('2301') ,6,DataType.long,0,100] ) ;
ProjType2 = bitand( ProjType2 + 2^16 , 2^16-1);
if ~(ProjType2== hex2dec('8580'))
    if (ProjType2== hex2dec('8500'))
        errorClose ('Could not wake CPU2: It remained in boot mode', messageFig) ; 
    else
        errorClose ('Could not wake CPU2', messageFig) ; 
    end
end

toc

UpdateTxtBox('Done.');
questdlg('Successful Calibration download.', 'Notificatoin','Close', struct ('Default','Close','Interpreter','tex') ); 

% if ~exist('cfg','var') || isempty(cfg) || isfield ( cfg,'NoDoneMsg')
%     close all force;
% end

close(messageFig);





