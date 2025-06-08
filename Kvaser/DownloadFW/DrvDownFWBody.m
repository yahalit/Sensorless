global TargetCanId %#ok<GVMIS> 
global msgboxHandle;
global errorDialogHandle;
global messageFig;
global ann;

if ~isdeployed()
    %EntityDir = '..\..\Entity\'; 
    ExeDir   = '..\..\Exe\'; 
else
    ExeDir = '..\..\Drivers Files\Exe\'; 
end

messageFig = figure;
version = '1.1';

LpCanId = 124 ; 
CreateStruct =  struct('Interpreter','tex','WindowStyle' , 'modal') ; 
tic
if exist('AtpCfg','var') && isa(AtpCfg,'struct') 
    AtpCfg.Done = 0 ;
end

try
    AtpStart ;
catch me
    msgbox(me.message) ; 
    msgbox(me.stack) ; 
    %UpdateTxtBox(me.message) ; 
    %UpdateTxtBox(me.stack) ; 
    errorClose('Could not resolve targets for firmware downloading', messageFig) ; 
end 

try
    stat = SendObj( [hex2dec('2220'),3, 124] , hex2dec('1234') , DataType.short ,'Shut CAN activity') ;  %tells CAN1 to stop transmitting
catch
end


try 
% Be a master blaster
SendObj([hex2dec('2220'),5,LpCanId],hex2dec('1234'),DataType.long,'Master blaster') ; 
% Block servo communication 
SendObj([hex2dec('2220'),13,LpCanId],1,DataType.long,'Block servo communication') ; 
catch 
end

BootCanId = TargetCanId ; 

% Just clear the state of the SDO machine by dummy read
try
    FetchObj( [hex2dec('2301') ,5],DataType.long,'Get Project type' ) ;
catch 
end

UpdateTxtBox({['SW version: ', version], ['Interrogating project type ...']});

try 
    ProjId = FetchObj( [hex2dec('2301') ,5],DataType.long,'Get Project type' ); 
    if ~isequal(RecStruct.ProjId,ProjId) 
        errordlg ('Proj ID toes not identify with target detection. ') ;         
    end 
catch 
    errorClose ('Cannot establish communication to resolve project Id. ', messageFig) ; 
end

[ProjType,IsOperational]    = GetProjTypeString( ProjId ) ;

if IsOperational 
    % Try set the motor off
    % Set to manual mode
    % Interface cards do not need the MotorOff bulshit. The moment they 
    % are reset the motors shall kill themselves automatically
    
    % Set motor off 
    %vSendObj([hex2dec('2220'),4,TargetCanId],0,DataType.long,'Set motor enable/disable') ;
    
    % Stop PDO activity and Set motor off  
    SendObj([hex2dec('2220'),18,TargetCanId],1234,DataType.long,'Set motor off and stop CAN node',[],100) ;
    %KvaserCom( 7 , [SdoGetId ,SdoSetId ,hex2dec('2220'),18,DataType.long,0,100], 1234 ); 

    switch ProjId  
        case hex2dec('9900')
        otherwise
            SendObj([hex2dec('2223'),3,TargetCanId],1,DataType.long,'Ignore host CW') ;
            SendObj([hex2dec('2220'),12,TargetCanId],RecStruct.Enums.SysModes.E_SysMotionModeManual,DataType.long,'Set system mode to manual') ;
            s = SGetState() ;
        
            if s.Bit.MotorOn 

                % Set motor off 
                SendObj([hex2dec('2220'),4,TargetCanId],0,DataType.long,'Set motor enable/disable') ;
                
                s = SGetState() ;
                if s.Bit.MotorOn 
                    % Cant shut the motor 
                    errordlg ('Motor must be off. ') ; 
                    return
                end
            end
    end
end

if isvalid(findall(0,'Name','WheelDrv'))
    errordlg ('Close WheelDrv before. ') ; 
    return
end

% Get the "post load" expected project type 
ProjIdAfter =  floor(( ProjId + 128 ) /256) * 256 ; 
InitialDetectedSlaves = KvaserCom(32);
[nDetectedSlaves,~] = size(GetDetectedSlavePars(InitialDetectedSlaves)) ; 
InitialDetectedSlaves = InitialDetectedSlaves(1,:) ; % Discard SW versions, leave project descriptors

if IsOperational
    UpdateTxtBox({['SW version: ', version], ['Found Project type: ',ProjType, ':Operational']} ) ; 
else
    UpdateTxtBox({['SW version: ', version], ['Found Project type: ',ProjType, ':Boot']} ) ; 
end

% NeckDrvBootProjId   = hex2dec('92f0') ;
% NeckDrvOpProjId   = hex2dec('9300') ;
% IntfcDrvBootProjId   = hex2dec('98f0') ;
% IntfcDrvOpProjId   = hex2dec('9900') ;
% WheelDrvBootProjId   = hex2dec('93f0') ;
% WheelDrvOpProjId   = hex2dec('9400') ;
% SteerDrvBootProjId   = hex2dec('94f0') ;
% SteerDrvOpProjId   = hex2dec('9500') ;

switch ProjId 
    case AtpCfg.HwProjectsList.NeckDrvBootProjId
        IsDirectCommunication = 1 ;
        HexName = 'NeckDrive.Hex' ; 
%         ProjectHexLoc = [NeckRoot,'Flash_Lib'];
%         fname = [ProjectHexLoc,'\',HexName] ;  
    case AtpCfg.HwProjectsList.NeckDrvOpProjId
        IsDirectCommunication = 1 ;
        HexName = 'NeckDrive.Hex' ; 
%         ProjectHexLoc = [NeckRoot,'Flash_Lib'];
%         fname = [ProjectHexLoc,'\',HexName] ;  
    case AtpCfg.HwProjectsList.IntfcDrvBootProjId
        IsDirectCommunication = 1 ;
        HexName = 'WheelInterface.Hex' ; 
%         ProjectHexLoc = [IntfcRoot,'CPU1_FLASH'];
%         fname = [ProjectHexLoc,'\',HexName] ;  
    case AtpCfg.HwProjectsList.IntfcDrvOpProjId
        IsDirectCommunication = 1 ;
        HexName = 'WheelInterface.Hex' ; 
%         ProjectHexLoc = [IntfcRoot,'CPU1_FLASH'];
%         fname = [ProjectHexLoc,'\',HexName] ;  
    case AtpCfg.HwProjectsList.WheelDrvBootProjId
        IsDirectCommunication = 0 ;
        HexName = 'WheelPower.Hex' ; 
%         ProjectHexLoc = [WheelRoot,'Flash_Lib'];
%         fname = [ProjectHexLoc,'\',HexName] ;  
    case AtpCfg.HwProjectsList.WheelDrvOpProjId
        IsDirectCommunication = 0 ;
        HexName = 'WheelPower.Hex' ; 
%         ProjectHexLoc = [WheelRoot,'Flash_Lib'];
%         fname = [ProjectHexLoc,'\',HexName] ;  
    case AtpCfg.HwProjectsList.SteerDrvBootProjId
        IsDirectCommunication = 0 ;
        HexName = 'WheelPower.Hex' ; 
%         ProjectHexLoc = [WheelRoot,'Flash_Lib'];
%         fname = [ProjectHexLoc,'\',HexName] ;  
    case AtpCfg.HwProjectsList.SteerDrvOpProjId
        IsDirectCommunication = 0 ;
        HexName = 'WheelPower.Hex' ; 
%         ProjectHexLoc = [WheelRoot,'Flash_Lib'];
%         fname = [ProjectHexLoc,'\',HexName] ;  
    otherwise
        errorClose('Boot not yet developed for this project type', messageFig) ; 
end 
fname = [ExeDir,HexName] ;  

if ~IsDirectCommunication
    % Stop all the sync activity
    KvaserCom(33) ;  
end 
% if isequal(RecStruct.Proj ,'Single') 
% else
%     errorClose('Boot not yet developed for this project type') ; 
% end 


nFlashSec = 26 ; 
FlashSecStarts = zeros(1,nFlashSec); 
for cnt = 1:nFlashSec
    FlashSecStarts(cnt) = hex2dec('80000') + cnt * hex2dec('1000') ; 
end

GamiliAddress= hex2dec('9f000') ;
AddressFinal = GamiliAddress ; 
CodeStartAddress = hex2dec('83000') ; 
% The (max address + 1 )  must divide neatly in 1024 * 4 
nbytesmod = 2048  ; % 512 longs per buffer  = 2048 bytes 
ProgBufLenLimits = [1024,4096] ; 
GamiliSector = 31 ; 
ProgChunkSize = 1024 ;

SdoGetId = 1536 + TargetCanId ; 
SdoSetId = 1408 + TargetCanId ; 
BootSdoGetId = 1536 + BootCanId ; 
BootSdoSetId = 1408 + BootCanId ; 

% Select the hex file 
Initials = HexName(1:end-4);
defaultName = [ExeDir, FindLatestFile(ExeDir, Initials)];
[filename, pathname] = uigetfile({[Initials,'*.hex']},'Select FW file',convertCharsToStrings(defaultName));
if isempty(filename ) || isequal(filename,0) 
    UpdateTxtBox('Canceled per user request') ; 
    return 
end
 
fname = [pathname,filename] ; % [ProjectRoot,'Debug\',HexName] ; 

ButtonName = questdlg({"\fontsize{12}Is this FW file correct: "+string(str2tex(fname))}, ...
                         'Please approve', ...
                         'Approve', 'Reject', struct('Interpreter','tex','Default','Reject')  );
if ~isequal(ButtonName,'Approve')
    UpdateTxtBox( ['Downloading FW from file [',fname,'] has been rejected'] ) ;
    return ; 
end 



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
    
    if  IsDirectCommunication && (cnt == cnttest) 
        zvulun = 1; 
    end 
        
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

% buffer of longs 
spacel = ( s1 * 256 + s2 )  +  (s3 * 256 + s4)* 65536 ;

% Get CS start, CS end, and CS 
CsStart = minadd ; 
CsEnd   = minadd + length(spacel) * 2 - 1 ; 
CSum    = 2^32 - mod ( sum(spacel) , 2^32 ) ; 
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
UpdateTxtBox( 'Reading project identity ...' ) ; 


% Read the length of programming buffer
ProgBufLen = KvaserCom( 8 , [SdoGetId ,SdoSetId ,hex2dec('2301') ,3,DataType.long,0,100] );

if isempty(ProgBufLen) 
    errorClose ( 'Cannot establish CAN communication with target', messageFig) ; 
end

if  (ProgBufLen < ProgBufLenLimits(1)) || ( ProgBufLen > ProgBufLenLimits(2)) 
    errorClose ( 'Bad length for programming buffer', messageFig) ; 
end

FwVer       = GetFwString(FetchObj( [hex2dec('2301') ,7],DataType.long,'Get Version'));

UpdateTxtBox( ['FW version: ',FwVer] ) ; 

% Set the password for flash operations and initialize flash 
SendObj([hex2dec('2301'),1], hex2dec('12345678'),DataType.long,'initialize flash memory') ;

if IsOperational 


    % Clear sector N 
    SendObj([hex2dec('2301'),130], 31 ,DataType.long,'Clear management sector',[],100) ;
 
    % Go to boot 
    % CAN transaction may fail because FW perishes before answering
    try
        KvaserCom( 7 , [SdoGetId ,SdoSetId ,hex2dec('2301'),245,DataType.long,0,100], 1234 ); 
    catch 
    end 
    
    UpdateTxtBox( 'Waiting 1 sec for reboot') ; 
    pause(1) ; 
    
    DetectedSlaves = KvaserCom(32);
    DetectedSlaves = DetectedSlaves(1,:) ; 

%     if  ~(length(DetectedSlaves)==length(InitialDetectedSlaves)) 
%         error('Number of network residents changed') ;
%     end
    NewPeople = setdiff(DetectedSlaves,InitialDetectedSlaves) ; 
    if ~(length(NewPeople)<=1)
        errorClose('Unexpected, more than 1 residents changed', messageFig) ;
    end
    if isscalar(NewPeople) 
        DetectedSlaves = NewPeople ;
    end

    mm = length(DetectedSlaves);
    switch mm 
        case 0
            errorClose('Couldn''t detect wakeup to boot', messageFig) ; 
        otherwise
            % Verify a boot waking and take it 
            TakeMe = zeros(1, mm); 
            for cnt = 1:mm
                nextSlave = DetectedSlaves(cnt) ; 
                nextSlave= [ bitand(nextSlave,2^24 * (2^8-1))/2^24  , bitand(nextSlave,2^8 * (2^16-1))/2^8  ,  bitand(nextSlave,255)] ;
                if ( nextSlave(3) == TargetCanId ) && (nextSlave(2) == RecStruct.ProjId-16)
                    TakeMe(cnt) = 1 ;  
                end
            end
            TakeMeF = find(TakeMe) ; 
            if length(TakeMeF) ~= 1 
                if mm == 1
                    % If there is a single unit on the line, no ambiguity
                    % even if retreated to boot ID, so go on
                    TargetCanId = nextSlave(3) ; 
                else
                    errorClose('Couldn''t detect the boot version of the original project', messageFig) ; 
                end
            end
            nextSlave = DetectedSlaves(TakeMeF) ; 
%             RecStruct.TargetCanId = nextSlave(3) ; 
%             TargetCanId = RecStruct.TargetCanId ; 
            BootSdoGetId = SdoGetId ; 
            BootSdoSetId = SdoSetId ; 
    end 

    % Refresh flash initialization after reboot 
    SendObj([hex2dec('2301'),1], hex2dec('12345678'),DataType.long,'initialize flash memory') ;
    
    % Verify we work against the boot 
    [~,IsOperational]    = GetProjTypeString( FetchObj( [hex2dec('2301') ,5],DataType.long,'Get Project type' )) ;
    if  IsOperational 
        errorClose ( 'Did not switch correctly to boot', messageFig) ; 
    end 
	% Refresh the programming buffer length
    ProgBufLen = FetchObj([hex2dec('2301') ,3],DataType.long,'Refresh programming buffer length') ; 
    
end 


% First to clear is the password segment Flash  
SendObj([hex2dec('2301'),130],31,DataType.long,'Clear the program flash',[],1500)  ;
% stat = KvaserCom( 7 , [BootSdoGetId ,BootSdoSetId ,hex2dec('2301'),130,DataType.long,0,1500], 1234 ); 
% if stat
%     errorClose ('Could not clear program sectors ' ) ; 
% end     

%disp( 'Cleared all the relevant sectors...') ; 
UpdateTxtBox( 'Cleared all the relevant sectors...') ;

BlockSize = nbytesmod / 4 ; 
BaseAddress = minadd ;

tburnall = clock () ;   

UpdateTxtBox( ['programming ',num2str(nblocks),'  Blocks']) ; 

progressBar = InitProgress();

% Program in the reverse order so that last to program is the code start 
for blcnt = nblocks:-1:1  
    myprogress(progressBar, 1-(blcnt-1)/nblocks);

    StartAdd = (blcnt-1)*BlockSize*2 + minadd; 
    NextBlock = spacel(1+(blcnt-1)*BlockSize:blcnt*BlockSize) ; 
    if all( NextBlock == 4294967295 ) 
        % page does not contain any info 
        UpdateTxtBox( ['Skipping empty block at 0x',dec2hex(StartAdd)]) ; 
        continue ;
    end 
    
    % Set the flash address 
    SendObj([hex2dec('2301'),100],StartAdd,DataType.long,'Set flash page address')  ;
%     stat = KvaserCom( 7 , [SdoGetId ,SdoSetId ,hex2dec('2301'),100,DataType.long,0,100], StartAdd  );
%     if stat , error ('Couldnt set flash page address ') ; end 

    % Set the data in the flash buffer 
    tt = clock () ;  
    temp = {['Programming internal block, start at 0x',dec2hex(StartAdd)] ; ['Wait: Block takes about 0.3 sec' , ''] };
    UpdateTxtBox( temp,0) ; 
    %SendObj( [hex2dec('2302'),1] , NextBlock , DataType.ulvec , 'Downloading block of code' ) ;  
    KvaserCom( 20 , [TargetCanId+1536 ,TargetCanId+1408,hex2dec('2302'),1,DataType.long,0,100], NextBlock   );
%         stat = KvaserCom( 7 , [SdoGetId ,SdoSetId ,hex2dec('2302'),1,DataType.ulvec,0,100],NextBlock);
%         if stat
%             RetStr = ['Set Sdo failure code=[',Errtext(Retcode),'] ID=[',num2str(NodeId),']	Index = [0x2302] SubIndex = 1 : Downloading block code'];
%             errorClose (RetStr) ; 
%         end 
    etimeText = num2str(etime(clock(),tt));
    StartAddText = num2str ( dec2hex(StartAdd));

    temp(end+1,:) = {['Page programming time: ' , etimeText]}; %#ok<SAGROW> 
    temp(end+1,:) = {['Burn to flash, start at 0x', StartAddText]}; %#ok<SAGROW> 

    UpdateTxtBox( temp ,0 ) ; %#ok<*CLOCK,*DETIM> 

    SendObj([hex2dec('2301'),131],length(NextBlock),DataType.long,'Burn code to flash ')  ;
    
%     stat = KvaserCom( 7 , [SdoGetId ,SdoSetId ,hex2dec('2301'),131,DataType.long,0,100], length(NextBlock) ); 
%             if stat , errorClose ('Could not burn to flash') ; end 
end 

% .. Statistics to sector N 
UpdateTxtBox( 'Download flash statistics' ) ; 

% if stat , errorClose ('Could not program internal buffer offset') ; end 
NextChunk = ones( 1, ProgChunkSize ) * (2^32-1) ; 
NextChunk(1) = ShuffleLong( hex2dec('12345678') ) ; 
NextChunk(2) = ShuffleLong( CsStart )  ;
NextChunk(3) = ShuffleLong(CsEnd) ;
NextChunk(4) = ShuffleLong(CSum)  ; 
SendObj( [hex2dec('2302'),1] , NextChunk(1:16) , DataType.ulvec , 'Downloading statistics block' ) ;  

UpdateTxtBox( ['Burn statistics to flash, start at 0x', dec2hex(GamiliAddress) ]) ; 

SendObj([hex2dec('2301'),132],16,DataType.long,'Burn statistics to flash ')  ;
% stat = KvaserCom( 7 , [SdoGetId ,SdoSetId ,hex2dec('2301'),132,DataType.long,0,100], 16 ); 
%             if stat , errorClose ('Could not burn to flash') ; end 

UpdateTxtBox( ['Entire programming time: ' , num2str(etime( clock() , tburnall ) ) ] ) ; 

UpdateTxtBox('Reboot... Wait 1 sec ' ) ;
try 
    % Ask reboot, no answer is expected, so response shall be a "Failure",
    % thus the try...catch 
    SendObj([hex2dec('2301'),245],0,DataType.long,'Reset FW ')  ;
%    KvaserCom( 7 , [SdoGetId ,SdoSetId ,hex2dec('2301'),245,DataType.long,0,100], 0  );
catch 
end 

pause (1); 

DetectedSlaves = KvaserCom(32);

if isempty(DetectedSlaves) 
    errorClose('Couldn''t detect wakeup after boot', messageFig) ; 
end    

DetectedSlaves = GetDetectedSlavePars(DetectedSlaves) ; 

[m,~] = size(DetectedSlaves) ; 
n = find (DetectedSlaves(:,2) == ProjIdAfter)  ; 

if ~isempty(n) &&  (m>=nDetectedSlaves)
    if length(n) > 1
        n = find ((DetectedSlaves(:,2) == ProjIdAfter) & (DetectedSlaves(:,3)==TargetCanId ) )  ; 
        if isempty(n) 
            errorClose ('Failed to locate awakened target', messageFig) ; 
        end
    end
    RecStruct.ProjId = DetectedSlaves(n,1) ; 
    RecStruct.Proj  = DetectedSlaves(n,2) ; 
    RecStruct.TargetCanId = DetectedSlaves(n,3) ; 
    TargetCanId = RecStruct.TargetCanId ; 
    %disp('Successful wakeup following FW download') ; 
    %UpdateTxtBox ('Successful wakeup following FW download');
    questdlg('Successful wakeup following FW download.', 'Notificatoin','Close', struct ('Default','Close','Interpreter','tex') ); 
else
    errorClose('Couldn''t detect wakeup after boot, or your Identity is not burned', messageFig) ; 
end 

try 
    FwVer       = GetFwString(FetchObj( [hex2dec('2301') ,7],DataType.long,'Get Version'));
    ProjType    = GetProjTypeString( FetchObj( [hex2dec('2301') ,5],DataType.long,'Get Project type' )) ;

    %disp( ['FW version: ',FwVer] ) ; 
    %disp(['Found Project type: ',ProjType] ) ; 

    %disp( ['Project Id is: ', num2str(AtpCfg.ProjListWithBoot(DetectedSlaves(n))) ])

    str = {['FW version: ',FwVer] , ...
        ['Found Project type:',ProjType] , ...
        ['Project Id is: ', num2str(AtpCfg.ProjListWithBoot(DetectedSlaves(n)))] };

    UpdateTxtBox(str);

catch 
    errorClose ('After boot, software does not respond or is unidentified' , messageFig) ; 
end

% if ~exist('cfg','var') || isempty(cfg) || isfield ( cfg,'NoDoneMsg')
%     close all force;
% end
close(progressBar);
close(messageFig);

function progressBar = InitProgress ()
    %fig = uifigure;
    %d = uiprogressdlg(fig,'Downloading...');
    %progressBar  = uiprogressdlg(fig);
    progressBar = waitbar(0,'Downloading...');
end

function myprogress (progressBar, progress)
    %progressBar.Value = progress; 
    %delete(progressBar);
    %progressBar.Position = progress;
    waitbar(progress,progressBar);

    % if progress == 1
    %     close(progressBar);
    % end

    % if progress == 1
    % % Close dialog box
    %     close all;
    % end
end





