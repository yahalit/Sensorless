function DownFWFunc( fname , CommFunc , ExpectSectProgTime )
% global TargetCanId
global DataType
global ObjectJokerMap

ObjectJokerMap = zeros(1,5) ; % Reset the object map anyway 

% SdoGetId = 1536 + TargetCanId ; 
% SdoSetId = 1408 + TargetCanId ; 
% LpSdoGetId = 1536 + 124 ; 
% LpSdoSetId = 1408 + 124 ; 
if nargin < 3 
    ExpectSectProgTime = 12 ; 
end 

FlashSecStarts = [ hex2dec('82000'),hex2dec('84000'),hex2dec('86000'),hex2dec('88000'),hex2dec('90000'),hex2dec('98000'),...
    hex2dec('A0000'),hex2dec('A8000'),hex2dec('B0000'),hex2dec('B8000') ,hex2dec('Ba000'),hex2dec('Bc000'),hex2dec('Be000')];

disp( ['Reading the project HEX file ', fname] ) ; 


AddressFinal = FlashSecStarts(end) ; 
EndIsNext = 0 ; 
fid = fopen( fname ) ; 

if isequal(fid,-1) 
    error (['Cant find .hex file [',fname,']'] ) ; 
end

minadd = 2^32 ; 
maxadd = -minadd ; 

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
    ind = 16 ;  %#ok<NASGU>
    
    for c1 = 7:length(tline) 
        cs  = cs + hex2dec( tline(c1) )  ; 
    end 
    if ~( mod(cs,256) == csum ) 
        error ( 'Checksum error') ; 
    end  
end

fclose(fid ) ; 

% The (max address + 1 )  must divide neatly in 2048 
nbytesmod = 8192 ; % 2048 longs per buffer  = 8192 bytes 
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
MinAddress = hex2dec('84000') ; 
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
FlashSegMin = max( find ( minadd  >= FlashSecStarts ) ) ; 

if ( FlashSegMax >= length(FlashSecStarts) ) 
    error ( 'Program is too big') ; 
end 

%%%%%%%% PROGRAMMING %%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
disp( 'Reading project identity ...' ) ; 

% Just clear the state of the SDO machine by dummy read
FetchObj( [hex2dec('2300'),0] , DataType.long , 'Dummy read for start' , CommFunc) ;
% KvaserCom( 8 , [SdoGetId ,SdoSetId ,hex2dec('2300') ,0,DataType.long,0,100] ); 

% Read the length of programming buffer
ProgBufLen = FetchObj( [hex2dec('2301'),3] , DataType.long , 'ProgBufLen' , CommFunc) ;
% ProgBufLen = KvaserCom( 8 , [SdoGetId ,SdoSetId ,hex2dec('2301') ,3,DataType.long,0,100] );

if isempty(ProgBufLen) 
    error ( 'Cannot establish CAN communication with target') ; 
end

if  (ProgBufLen < 2048) || ( ProgBufLen > 8192) 
    error ( 'Bad length for programming buffer') ; 
end

FwVer = FetchObj( [hex2dec('2301'),4] , DataType.long , 'FwVer' , CommFunc) ;
ProjType = FetchObj( [hex2dec('2301'),5] , DataType.long , 'ProjType' , CommFunc) ;

% FwVer       = KvaserCom( 8 , [SdoGetId ,SdoSetId ,hex2dec('2301') ,4,DataType.long,0,100] );
% ProjType    = KvaserCom( 8 , [SdoGetId ,SdoSetId ,hex2dec('2301') ,5,DataType.long,0,100] );

Operational = 1; 

switch ProjType 
    case hex2dec('8000') 
        Operational = 0 ; 
        disp('Found boot software' ) ; 
        disp(['Boot FW ver: ',ShowVersionString(FwVer) ]  ) ; 

    case hex2dec('8100') 
        disp('Found LP operational software' ) ; 
        % Verify PD is absent or mushroom depressed 
        val = FetchObj( [hex2dec('2220'),100] , DataType.long , 'Mushroom status' , CommFunc) ;
    %     val = KvaserCom( 8 , [SdoGetId ,SdoSetId ,hex2dec('2220') ,100,DataType.long,0,100] ); % Get status 
        PdAbsent = bitget( val , 3) ; 
        MushroomDepressed = bitget( val , 19) ; 

        if ( PdAbsent == 0 ) 
            if ( MushroomDepressed == 0 ) 
                error ( 'The Mushroom emergency switch must be depressed on SW download') ; 
            end 
            % Kill PD-LP communication. It wont harm anyway 
            SendObj( [hex2dec('2220'),1] , 1 , DataType.short , 'kill PD commmunication' ,CommFunc) ;
    %         stat = KvaserCom( 7 , [LpSdoGetId ,LpSdoSetId ,hex2dec('2220'),1,DataType.short,0,100], 1) ; 
    %         if stat , error ('Could not kill PD commmunication') ; end
        end        

    
    case hex2dec('8200') 
        disp('Found PD operational software' ) ; 
        
        % If this is PD, verify that the mushroom is depressed 
        % val = FetchObj( [hex2dec('2104'),1] , DataType.long , 'Mushroom status' , CommFunc) ;
%         val = KvaserCom( 8 , [SdoGetId ,SdoSetId ,hex2dec('2104') ,1,DataType.long,0,100] ); % Get status 
        %if bitget( val ,3  ) == 0 
        %    error ( 'Mushroom is released. Please depress it before attempting FW changes') ; 
        %end
        
    otherwise
        error ('Working agains un-identified software' ) ; 
end

% Set the password for flash operations and initialize flash 
SendObj( [hex2dec('2301'),1] , hex2dec('12345678') , DataType.long , 'Could not initialize flash memory' ,CommFunc,250) ;
% stat = KvaserCom( 7 , [SdoGetId ,SdoSetId ,hex2dec('2301'),1,DataType.long,0,100], hex2dec('12345678') ); 
% if stat , error ('Could not initialize flash memory') ; end     

if Operational 
    % Clear sector N 
    SendObj( [hex2dec('2301'),130] , 13 , DataType.long , 'Clear management sector' ,CommFunc, 250) ;
%     stat = KvaserCom( 7 , [SdoGetId ,SdoSetId ,hex2dec('2301'),130,DataType.long,0,100], 13 ); 
%     if stat , error ('Could not clear management sector ') ; end     
 
    % Go to boot 
    % CAN transaction may fail because FW perishes before answering
    try
        SendObj( [hex2dec('2301'),244] , 1234 , DataType.long , 'Reboot' ,CommFunc) ;
%         KvaserCom( 7 , [SdoGetId ,SdoSetId ,hex2dec('2301'),244,DataType.long,0,100], 1234 ); 
    catch 
    end 
    
    disp( 'Waiting 1 sec for reboot') ; 
    pause(1) ; 
    
    % Refresh flash initialization after reboot 
    SendObj( [hex2dec('2301'),1] , hex2dec('12345678') , DataType.long , 'Initialize flash memory' ,CommFunc, 250 ) ;
%     stat = KvaserCom( 7 , [SdoGetId ,SdoSetId ,hex2dec('2301'),1,DataType.long,0,100], hex2dec('12345678') ); 
%     if stat , error ('Could not initialize flash memory') ; end     
    
    % Verify we work against the boot 
    ProjType = FetchObj( [hex2dec('2301'),5] , DataType.long , 'ProjType' , CommFunc) ;
%     ProjType    = KvaserCom( 8 , [SdoGetId ,SdoSetId ,hex2dec('2301') ,5,DataType.long,0,100] );
    if ~ ProjType == hex2dec('8000') 
        error ( 'Did not switch correctly to boot') ; 
    end 
    
    
end 


% First to clear is the password segment Flash N 
FlashSects2Clear = [ length(FlashSecStarts), (FlashSegMin : FlashSegMax)] ; 
for cnt = 1:length(FlashSects2Clear) 
    NextSec =FlashSects2Clear(cnt) ; 
    SendObj( [hex2dec('2301'),130] , NextSec , DataType.long , 'Clear FW sector' ,CommFunc) ;
%     stat = KvaserCom( 7 , [SdoGetId ,SdoSetId ,hex2dec('2301'),130,DataType.long,0,100], NextSec ); 
%     if stat , error (['Could not clear sector ', num2str(NextSec) ]) ; end     
end 

disp( 'Cleared all the relevant sectors...') ; 

BlockSize = nbytesmod / 4 ; 
BaseAddress = minadd ; %#ok<NASGU>

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
    disp( ['Programming internal block, start at 0x',dec2hex(StartAdd), '  Wait: Block takes about ',num2str(ExpectSectProgTime),' sec' ]) ; 
    SendObj( [hex2dec('2301'),100] , StartAdd , DataType.long , 'Program flash page address' ,CommFunc) ;

%     stat = KvaserCom( 7 , [SdoGetId ,SdoSetId ,hex2dec('2301'),100,DataType.long,0,100], StartAdd  );
%     if stat , error ('Couldnt program flash page address ') ; end 

    % Set the data in the flash buffer 
    tt = clock () ;
    InternalBufOffset = 0; 
    while ( InternalBufOffset < ProgBufLen ) 
        % disp ( 'Downloading 256...') ; 
        SendObj( [hex2dec('2301'),2] , InternalBufOffset , DataType.long , 'Program internal buffer offset' ,CommFunc) ;
%         stat = KvaserCom( 7 , [SdoGetId ,SdoSetId ,hex2dec('2301'),2,DataType.long,0,100], InternalBufOffset ); 
%         if stat , error ('Could not program internal buffer offset') ; end 

        NextChunk = NextBlock( 1 + InternalBufOffset : 256 + InternalBufOffset ) ;
        for cnt = 1:256   
            SendObj( [hex2dec('2300'),cnt-1] , NextChunk(cnt) , DataType.long , 'Program internal buffer data' ,CommFunc) ;
%             stat = KvaserCom( 7 , [SdoGetId ,SdoSetId ,hex2dec('2300'),cnt-1,DataType.long,0,100], NextChunk(cnt) ); 
%             if stat , error ('Could not program internal buffer data') ; end 
        end 

        InternalBufOffset = InternalBufOffset + 256 ;
    end
    disp( ['Page programming time: ' , num2str(etime( clock() , tt ) ) ] ) ; 
    disp( ['Burn to flash, start at 0x',dec2hex(StartAdd) ]) ; 
    SendObj( [hex2dec('2301'),131] , 1234 , DataType.long , 'Burn to flash' ,CommFunc, 400 ) ;
%     stat = KvaserCom( 7 , [SdoGetId ,SdoSetId ,hex2dec('2301'),131,DataType.long,0,100], 1234 ); 
%             if stat , error ('Could not burn to flash') ; end 
end 

% .. Statistics to sector N 
disp( 'Upload flash statistics' ) ; 
SendObj( [hex2dec('2301'),100] , FlashSecStarts(end) , DataType.long , 'program section N start' ,CommFunc) ;
% stat = KvaserCom( 7 , [SdoGetId ,SdoSetId ,hex2dec('2301'),100,DataType.long,0,100], FlashSecStarts(end)  ); % Flash address 
%             if stat , error ('Could not program section N start') ; end 
SendObj( [hex2dec('2301'),2] , 0 , DataType.long , 'program section N offset' ,CommFunc) ;
% stat = KvaserCom( 7 , [SdoGetId ,SdoSetId ,hex2dec('2301'),2,DataType.long,0,100], 0 ); % Internal offset 
%             if stat , error ('Could not program section N offset') ; end 

% if stat , error ('Could not program internal buffer offset') ; end 
NextChunk = ones( 1, 2048 ) * (2^32-1) ; 
NextChunk(1) = ShuffleLong( hex2dec('12345678') ) ; 
NextChunk(2) = ShuffleLong( CsStart )  ;
NextChunk(3) = ShuffleLong(CsEnd) ;
NextChunk(4) = ShuffleLong(CSum)  ; 

for cnt = 1:256  
    SendObj( [hex2dec('2300'),cnt-1] , NextChunk(cnt) , DataType.long , 'program internal buffer data' ,CommFunc) ;
%     stat = KvaserCom( 7 , [SdoGetId ,SdoSetId ,hex2dec('2300'),cnt-1,DataType.long,0,100], NextChunk(cnt) ); 
%     if stat , error ('Could not program internal buffer data') ; end 
end 
disp( ['Burn statistics to flash, start at 0x', dec2hex(FlashSecStarts(end)) ]) ; 

SendObj( [hex2dec('2301'),131] , 1234 , DataType.long , 'burn to flash' ,CommFunc, 500) ;
% stat = KvaserCom( 7 , [SdoGetId ,SdoSetId ,hex2dec('2301'),131,DataType.long,0,100], 1234 ); 
%             if stat , error ('Could not burn to flash') ; end 

disp( ['Entire programming time: ' , num2str(etime( clock() , tburnall ) ) ] ) ; 

disp('Reboot... Wait 1 sec ' ) ;
try 
    SendObj( [hex2dec('2301'),150] , 0 , DataType.long , 'Reboot' ,CommFunc) ;
%     KvaserCom( 7 , [SdoGetId ,SdoSetId ,hex2dec('2301'),150,DataType.long,0,100], 0  );
catch 
end 
pause (1); 

[FwVer,~,errdesc] = FetchObj( [hex2dec('2301'),4] , DataType.long , 'FwVer' , CommFunc) ;

% FwVer       = KvaserCom( 8 , [SdoGetId ,SdoSetId ,hex2dec('2301') ,4,DataType.long,0,100] );
if isempty(FwVer) 
    disp(errdesc) ;
    error ('Reboot failed after downloading firmware' ) ; 
end

ProjType = FetchObj( [hex2dec('2301'),5] , DataType.long , 'ProjType' , CommFunc) ;
% ProjType    = KvaserCom( 8 , [SdoGetId ,SdoSetId ,hex2dec('2301') ,5,DataType.long,0,100] );

try 
    switch ProjType  
        case hex2dec('8000')  
            error ('Programmin gfailed, remained in boot ' ) ; 
        case hex2dec('8100')  
            disp(['Success:  LP operational software ver ',ShowVersionString(FwVer) ]  ) ; 
        case hex2dec('8200')  
            disp(['Success:  PD operational software ver ',ShowVersionString(FwVer) ]  ) ; 
        otherwise
            error ('Working agains un-identified software' ) ; 
    end
catch 
    error ('After boot, software does not respond or is unidentified' ) ; 
end

disp('PLEASE POWER CYCLE THE ENTIRE ROBOT' ) ; 
disp('FOR RE_ESTABLISHING SYNCHRONISATION BETWEEN THE CARDS' ) ; 






