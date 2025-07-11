uiwait(msgbox('Move connection to CAN #2')) ; 
tic
cd ..\PDTest
AtpStart

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
LpSdoGetId = 1536 + 124 ; 
LpSdoSetId = 1408 + 124 ; 
MalinkiBootProjId   = hex2dec('9000') ;
MalinkiOpProjId   = hex2dec('9100') ;

% fname = [ProjectRoot,'Debug\',HexName] ; 
fname = [ProjectHexLoc,'\',HexName] ;   

[filename, pathname] = ...
     uigetfile({'*.hex'},'Select FW file',fname);
 
fname = [pathname,filename] ; % [ProjectRoot,'Debug\',HexName] ; 

ButtonName = questdlg({'Is this FW file correct?';fname}, ...
                         'Please approve', ...
                         'Approve', 'Reject', 'Reject');
if ~isequal(ButtonName,'Approve')
    disp( ['Downloading FW from file [',fname,'] has been rejected'] ) ; 
    return ; 
end 



disp( ['Reading the project HEX file ', fname] ) ; 


EndIsNext = 0 ; 
fid = fopen( fname ) ; 

if isequal(fid,-1) 
    error (['Cant find .hex file [',fname,']'] ) ; 
end

minadd = 2^32 ; 
maxadd = -minadd ; 
cnttest = 840 ; 

for cnt = 1:1000000 
            
    tline = fgets( fid) ; 
    if isequal( tline , -1)
        if ( ~EndIsNext ) 
            error ('Premature end of file' ) ; 
        end 
        break;
    else
        if EndIsNext 
            if tline(1) == '%'
                error ('Expected end of file' ) ; 
            end 
        else
            if ~( tline(1) == '%')
                error ('First character must be a percent sign' ) ; 
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
            error ( 'Expected a data line ') ; 
        end
    end
    csum  = hex2dec( tline(5:6) ); 
    if ~( tline(7) == '8')
        error ( 'Address number of digits should be 8') ; 
    end
    if  ~( reclen == length( tline)-1 ) 
        error ( 'Unexpected line length') ; 
    end 
    
    address = hex2dec( tline(8:15) ); 
    nbytes  = (reclen - 14)/2 ; 
    
    minadd = min( minadd , address ) ;
    if ( address < AddressFinal ) 
        % Last sector is only for password, checksums, etc. , avoid it 
        maxadd = max( maxadd , address + nbytes - 1) ; 
    end 
    
    if ~(nbytes == fix(nbytes)) 
          error ('Record should contain only full bytes') ;
    end 
    
    cs = hex2dec(tline(2))+hex2dec(tline(3))+hex2dec(tline(4))  ; 
    ind = 16 ; 
    
    for c1 = 7:length(tline) 
        cs  = cs + hex2dec( tline(c1) )  ; 
    end 
    if ~( mod(cs,256) == csum ) 
        error ( 'Checksum error') ; 
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
    error ( 'Code must start at the beginning of sector C') ; 
end 
if ( minadd < MinAddress ) 
    space (1:((MinAddress-minadd)*2)) = [] ;  
    minadd = MinAddress ; 
end

% Verify again that length of space divides neatly in 4
nspace = length( space) ; 
nblocks = fix( nspace/nbytesmod);
if  nblocks * nbytesmod ~= nspace  
    error ( ['Space length must divide neatly in ',num2str(nbytesmod)] ) ; 
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
disp ( ['Code start = 0x', dec2hex(CsStart) , '  Code last=0x' , dec2hex(CsEnd) , '  Checksum=0x', dec2hex(CSum) ]) ; 

% Find sectors for erasure 
FlashSegMax = max( find ( maxadd  >= FlashSecStarts ) ) ;  %#ok<*MXFND>

FlashSegMin = ( minadd  >= FlashSecStarts ); 
if ~any( FlashSegMin ) 
    error ( 'Program starts too early') ; 
end 
FlashSegMin = max( find ( minadd  >= FlashSecStarts ) ) ; 

if ( FlashSegMax >= length(FlashSecStarts) ) 
    error ( 'Program is too big') ; 
end 

%%%%%%%% PROGRAMMING %%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
disp( 'Reading project identity ...' ) ; 

% Just clear the state of the SDO machine by dummy read
KvaserCom( 8 , [SdoGetId ,SdoSetId ,hex2dec('2300') ,0,DataType.long,0,100] ); 

% Read the length of programming buffer
ProgBufLen = KvaserCom( 8 , [SdoGetId ,SdoSetId ,hex2dec('2301') ,3,DataType.long,0,100] );

if isempty(ProgBufLen) 
    error ( 'Cannot establish CAN communication with target') ; 
end

if  (ProgBufLen < ProgBufLenLimits(1)) || ( ProgBufLen > ProgBufLenLimits(2)) 
    error ( 'Bad length for programming buffer') ; 
end

FwVer       = KvaserCom( 8 , [SdoGetId ,SdoSetId ,hex2dec('2301') ,4,DataType.long,0,100] );
ProjType    = KvaserCom( 8 , [SdoGetId ,SdoSetId ,hex2dec('2301') ,5,DataType.long,0,100] );

Operational = 1; 
NewBoot     = 0 ; 
switch ProjType 
    case hex2dec('8000') 
        Operational = 0 ; 
        disp('Found boot software' ) ; 
        disp(['Boot FW ver: ',ShowVersionString(FwVer) ]  ) ; 
    case hex2dec('8001') 
        Operational = 0 ; 
        NewBoot = 1 ; 
        disp('Found fast - download boot software' ) ; 
        disp(['Boot FW ver: ',ShowVersionString(FwVer) ]  ) ; 
    case hex2dec('8200') 
        disp('Found PD operational software' ) ; 

        % If this is PD, verify that the mushroom is depressed 
        val = KvaserCom( 8 , [SdoGetId ,SdoSetId ,hex2dec('2104') ,1,DataType.long,0,100] ); % Get status 
        if bitget( val ,3  ) == 0 
            error ( 'Mushroom is released. Please depress it before attempting FW changes') ; 
        end
    otherwise
        error (['Working agains un-identified software, project type = 0x', dec2hex(ProjType)]) ; 
end

if ( (LpSdoGetId == SdoGetId) && Operational ) 
    % Verify PD is absent or mushroom depressed 
    val = KvaserCom( 8 , [SdoGetId ,SdoSetId ,hex2dec('2220') ,100,DataType.long,0,100] ); % Get status 
    PdAbsent = bitget( val , 3) ; 
    MushroomDepressed = bitget( val , 19) ; 
    
    if ( PdAbsent == 0 ) 
        if ( MushroomDepressed == 0 ) 
            mushAns = questdlg({'The Mushroom emergency switch must be depressed on SW download','Proceed?'}, 'Decision', 'Yes', 'No', 'No');
            if ~isequal(mushAns,'Yes')
                error ( 'The Mushroom emergency switch must be depressed on SW download') ; 
            end
        end 
        % Kill PD-LP communication. It wont harm anyway 
        stat = KvaserCom( 7 , [LpSdoGetId ,LpSdoSetId ,hex2dec('2220'),1,DataType.short,0,100], 1) ; 
        if stat 
            disp('Maybe you are connected to CAN2? ') ; 
            error ('Could not kill PD commmunication') ; 
        end
    end        
end 

% Set the password for flash operations and initialize flash 
stat = KvaserCom( 7 , [SdoGetId ,SdoSetId ,hex2dec('2301'),1,DataType.long,0,100], hex2dec('12345678') ); 
if stat , error ('Could not initialize flash memory') ; end     

if Operational 
    % Clear sector N 
    stat = KvaserCom( 7 , [SdoGetId ,SdoSetId ,hex2dec('2301'),130,DataType.long,0,100], GamiliSector ); 
    if stat , error ('Could not clear management sector ') ; end     
 
    % Go to boot 
    % CAN transaction may fail because FW perishes before answering
    try
        KvaserCom( 7 , [SdoGetId ,SdoSetId ,hex2dec('2301'),244,DataType.long,0,100], 1234 ); 
    catch 
    end 
    
    disp( 'Waiting 1 sec for reboot') ; 
    pause(1) ; 
    
    % Refresh flash initialization after reboot 
    stat = KvaserCom( 7 , [SdoGetId ,SdoSetId ,hex2dec('2301'),1,DataType.long,0,100], hex2dec('12345678') ); 
    if stat , error ('Could not initialize flash memory') ; end     
    
    % Verify we work against the boot 
    ProjType    = KvaserCom( 8 , [SdoGetId ,SdoSetId ,hex2dec('2301') ,5,DataType.long,0,100] );
    if  ~any( ProjType == [hex2dec('8000'),hex2dec('8081'),hex2dec('8001'),MalinkiBootProjId] ) 
        error ( 'Did not switch correctly to boot') ; 
    end 
    if mod (ProjType,2) == 1 % == hex2dec('8001')
        NewBoot = 1 ; 
        disp('Found fast boot - download' ) ; 
    end
    
end 


% First to clear is the password segment Flash  
FlashSects2Clear = [ GamiliSector , (FlashSegMin : FlashSegMax)] ; 
for cnt = 1:length(FlashSects2Clear) 
    NextSec =FlashSects2Clear(cnt) ; 
    stat = KvaserCom( 7 , [SdoGetId ,SdoSetId ,hex2dec('2301'),130,DataType.long,0,100], NextSec ); 
    if stat
        error (['Could not clear sector ', num2str(NextSec) ]) ; 
    end     
end 

disp( 'Cleared all the relevant sectors...') ; 

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
        disp( ['Skipping empty block at 0x',dec2hex(StartAdd)]) ; 
        continue ;
    end 
    
    % Set the flash address 
    stat = KvaserCom( 7 , [SdoGetId ,SdoSetId ,hex2dec('2301'),100,DataType.long,0,100], StartAdd  );
    if stat , error ('Couldnt program flash page address ') ; end 

    % Set the data in the flash buffer 
    tt = clock () ;
    InternalBufOffset = 0; 
    if NewBoot
        disp( ['Programming internal block, start at 0x',dec2hex(StartAdd), '  Wait: Block takes about 1.3 sec' ]) ; 
        stat = KvaserCom( 20 , [SdoGetId ,SdoSetId ,hex2dec('2303'),0,DataType.long,0,100], NextBlock(1:ProgBufLen)  ); 
        if stat , error ('Could not program internal buffer in block mode') ; end 
	
	else
        disp( ['Programming internal block, start at 0x',dec2hex(StartAdd), '  Wait: Block takes about 30 sec' ]) ; 
        while ( InternalBufOffset < ProgBufLen ) 
            % disp ( 'Downloading 256...') ; 
            stat = KvaserCom( 7 , [SdoGetId ,SdoSetId ,hex2dec('2301'),2,DataType.long,0,100], InternalBufOffset ); 
            if stat , error ('Could not program internal buffer offset') ; end 

            NextChunk = NextBlock( 1 + InternalBufOffset : 256 + InternalBufOffset ) ;
            %tic
            for cnt = 1:256   
                stat = KvaserCom( 7 , [SdoGetId ,SdoSetId ,hex2dec('2300'),cnt-1,DataType.long,0,100], NextChunk(cnt) ); 
                if stat , error ('Could not program internal buffer data') ; end 
            end
            %toc

            InternalBufOffset = InternalBufOffset + 256 ;
        end
    end
    disp( ['Page programming time: ' , num2str(etime( clock() , tt ) ) ] ) ; 
    disp( ['Burn to flash, start at 0x',dec2hex(StartAdd) ]) ; 
    stat = KvaserCom( 7 , [SdoGetId ,SdoSetId ,hex2dec('2301'),131,DataType.long,0,100], 1234 ); 
            if stat , error ('Could not burn to flash') ; end 
end 

% .. Statistics to sector N 
disp( 'Download flash statistics' ) ; 
stat = KvaserCom( 7 , [SdoGetId ,SdoSetId ,hex2dec('2301'),100,DataType.long,0,100], GamiliAddress  ); % Flash address 
            if stat , error ('Could not program statistics section start') ; end 
stat = KvaserCom( 7 , [SdoGetId ,SdoSetId ,hex2dec('2301'),2,DataType.long,0,100], 0 ); % Internal offset 
            if stat , error ('Could not program statistics section offset') ; end 



% if stat , error ('Could not program internal buffer offset') ; end 
NextChunk = ones( 1, ProgChunkSize ) * (2^32-1) ; 
NextChunk(1) = ShuffleLong( hex2dec('12345678') ) ; 
NextChunk(2) = ShuffleLong( CsStart )  ;
NextChunk(3) = ShuffleLong(CsEnd) ;
NextChunk(4) = ShuffleLong(CSum)  ; 

for cnt = 1:256  
    stat = KvaserCom( 7 , [SdoGetId ,SdoSetId ,hex2dec('2300'),cnt-1,DataType.long,0,100], NextChunk(cnt) ); 
    if stat , error ('Could not program internal buffer data') ; end 
end 
disp( ['Burn statistics to flash, start at 0x', dec2hex(GamiliAddress) ]) ; 

stat = KvaserCom( 7 , [SdoGetId ,SdoSetId ,hex2dec('2301'),131,DataType.long,0,100], 1234 ); 
            if stat , error ('Could not burn to flash') ; end 

disp( ['Entire programming time: ' , num2str(etime( clock() , tburnall ) ) ] ) ; 

disp('Reboot... Wait 1 sec ' ) ;
try 
    % Ask reboot, no answer is expected, so response shall be a "Failure",
    % thus the try...catch 
    KvaserCom( 7 , [SdoGetId ,SdoSetId ,hex2dec('2301'),244,DataType.long,0,100], 0  );
catch 
end 
pause (1); 

FwVer       = KvaserCom( 8 , [SdoGetId ,SdoSetId ,hex2dec('2301') ,4,DataType.long,0,100] );
if isempty(FwVer) 
    error ('Reboot failed after downloading firmware' ) ; 
end

% CreateStruct.Interpreter = 'tex';
% CreateStruct.WindowStyle = 'modal';
uiwait( msgbox({'PLEASE POWER CYCLE THE ENTIRE ROBOT','Release the mushroom','Press enter when brake realease is heard'}) )  ;

disp('Waiting:') ; 
pause (2); 


ProjType    = KvaserCom( 8 , [SdoGetId ,SdoSetId ,hex2dec('2301') ,5,DataType.long,0,100] );

try 
    switch ProjType  
        case hex2dec('8000')  
            error ('Programminfailed, remained in boot ' ) ; 
        case hex2dec('8001')  
            error ('Programming failed, remained in high speed boot ' ) ; 
        case hex2dec('8100')  
            disp(['Success:  LP operational software ver ',ShowVersionString(FwVer) ]  ) ; 
        case hex2dec('8180')  
            disp(['Success:  LB operational software ver ',ShowVersionString(FwVer) ]  ) ; 
        case hex2dec('8100')  
            disp(['Success:  LP operational software ver ',ShowVersionString(FwVer) ]  ) ; 
        case hex2dec('8200')  
            disp(['Success:  PD operational software ver ',ShowVersionString(FwVer) ]  ) ; 
        case MalinkiBootProjId  
            error ('Programming failed, remained in boot ' ) ; 
        case MalinkiOpProjId  
            disp(['Success:  Malinki operational software ver ',ShowVersionString(FwVer) ]  ) ; 			
        otherwise
            error ('Working agains un-identified software' ) ; 
    end
catch 
    error ('After boot, software does not respond or is unidentified' ) ; 
end



toc



