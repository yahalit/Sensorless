function [rxout,tx] = GetOlivier( fname) 
    rx = [] ; tx = [] ; 
    fid = fopen( fname, 'r+') ; 
    if fid < 0 
        error(['Could not open text file for read: ',fname]) ;
    end 

    linecnt = 0 ; 
    while(1) 
        str = fgets(fid); 
        if str < 0 
            break  ; 
        end 
        linecnt = linecnt + 1 ; 
        if contains ( str,'Wrong checksum') 
            disp(['Wrong checksum at line: ' , num2str(linecnt) ] ) ; 
            continue ; 
        end
        if contains ( str,'Wrong preamble') 
            disp(['Wrong preamble at line: ' , num2str(linecnt) ] ) ; 
            continue ; 
        end
        
        if contains( str , 'received message') 
            
            if contains ( str, 'InvalidEnum') 
                disp(['Invalid enumerated value at line: ' , num2str(linecnt) ] ) ; 
                continue ; 
            end
            place = strfind(str,'ac13') ; 
            if isempty(place)
                disp(['RX preamble not found, line=', num2str(linecnt)]  ) ;  %#ok<*ST2NM>
                continue ; 
            end
            place = place(1) ; 
            str = strsplit( str(place+5:end),',') ; 
            
            
            if length(str) < 20 
                disp(['RX message string too short, line=', num2str(linecnt)]  ) ; 
                continue
            end

            if contains( str{3},'MC_RPT_STATUS') 
                rxn = struct('cntrx',str2num(str{1}),'cnttx',str2num(str{2})) ;
                rxn = DecodeRptStatus(rxn,str(4:end)) ; 
            elseif contains( str{3},'MC_RPT_BIT') 
                if isempty( rxn) 
                    continue ; 
                end 
                rxn = DecodeRptBit(rxn,str(4:end)) ; 
                rx = [rx,rxn];  %#ok<*AGROW>
                rxn = [] ; 
            else
                error(['RX Cant identify message type, line=', str2num(linecnt)]) 
            end 

        end 
    end 
    p = [rx.pos] ; 
    p1 = p(1:3:end);
    p2 = p(2:3:end);
    p3 = p(3:3:end);
    
%     T
%     OK
%     WorkMode
%     GeneralReason
%     pos
%     Head
%     body
%     spd
%     pitch
%     roll
%     Reason
%     MotionEx
%     CBit
%     Mode
%     dev54v
%     dev36v
%     lim
%     Act
%     PD
%     Fail

    b36 = [rx.dev36v] / 10 + 36 ; 
    b54 = [rx.dev54v] / 10 + 54 ;

    miss = [rx.GeneralReason] ;
    MissionStat1 = bitand( miss(1:2:end) , 255) ;
    MissionStat2 = bitand( miss(2:2:end) , 255) ;
    MissionAbortedStat1 =  bitand( miss(1:2:end) , 255 * 256 ) / 256 ;
    MissionAbortedStat2 =  bitand( miss(2:2:end) , 255 * 256 ) / 256 ;
    cbit3 = GetCbit3([rx.lim]);
    PdBitGen = GetCPdBitGen([rx.Act]);
    ManBit1 = GetManBit1([rx.PD]); 
    
    rxout = struct ( 'T' , unwrap([rx.T]*2*pi/2^32) * 2^32 / (2e-6 * pi) / 2^32  , 'pos' ,[p1 ; p2 ; p3] ,'MissionStat',[MissionStat1;MissionStat2],...
        'MissionAbortedStat',[MissionAbortedStat1;MissionAbortedStat2],'V36',b36,'V54',b54,'PdCbit3',cbit3,'PdBitGen',PdBitGen,'ManBit',ManBit1 ...
        ) ; 
end


function rx = DecodeRptStatus(rx,str)
%    'Req:CMD_POLL=0'    'T:2266492552'    'chk:0xd0dc'    'OK=0'    'Asleep=5'    'GeneralReason=1'
%  Columns 7 through 14
%    'pos[38408'    '11919'    '0]'    'Head[-571'    '-32763'    '0]'    'body:0 deg(0)'    'spd:0'
%  Columns 15 through 20
%    'pitch:0 deg(0)'    'roll:0 deg(0)'    'Q(-1'    '0)'    'Laser:65493'    '0?'
rx.T = ReadDelim(str{2},'T',':','N') ;  
rx.OK = ReadDelim(str{4},[],'=','N') ;  
rx.WorkMode = ReadDelim(str{5},[],'=','N') ;  
rx.GeneralReason = ReadDelim(str{6},'','=','N') ;  
rx.pos = [ReadDelim(str{7},'pos','[','N') , str2num(str{8}) , str2num(str{9}(1:end-1))]  ;  
rx.Head = [ReadDelim(str{10},'Head','[','N') , str2num(str{11}) , str2num(str{12}(1:end-1))]  ;  
rx.body = ReadDelim(str{13},'body',':','N') ;
rx.spd = ReadDelim(str{14},'spd',':','N') ;
rx.pitch = ReadDelim(str{15},'pitch',':','N') ;
rx.roll = ReadDelim(str{16},'roll',':','N') ;
rx.roll = ReadDelim(str{19},'Laser',':','N') ;

end 


function rx = DecodeRptBit(rx,str)
%  Columns 1 through 6
%    'Req:CMD_POLL=0'    'T:2266594984'    'chk:0xa3cf'    'OK=0'    'Asleep=5'    'GeneralReason=1'
%  Columns 7 through 14
%    '0'    'MotionEx:0'    'CBit:16416'    'Mode:(0'    '0'    '0'    '0)'    'dev(54v:88'
%  Columns 15 through 21
%    '36v:36)'    'lim:336'    'Act:14344'    'PD:8391683'    'Fail:0x0'    'Q(-1'    '0)'
rx.OK = [rx.OK,ReadDelim(str{4},[],'=','N')] ;  
rx.WorkMode = [rx.WorkMode,ReadDelim(str{5},[],'=','N')] ;  
rx.Reason = [rx.GeneralReason,ReadDelim(str{6},[],'=','N')] ;  
rx.MotionEx = ReadDelim(str{8},'MotionEx',':','N') ;  
rx.CBit = ReadDelim(str{9},'CBit',':','N') ;  
rx.Mode = [ReadDelim(str{10},'Mode:','(','N'),str2num(str{11}),str2num(str{12}), str2num(str{13}(1:end-1))] ;
rx.dev54v = ReadDelim(str{14},'dev(54v',':','N') ; 
rx.dev36v = ReadDelim(str{15}(1:end-1),'36v',':','N') ; 
if ( rx.dev36v < 0  ) 
    disp('foff'); 
end
rx.lim = ReadDelim(str{16},'lim',':','N') ; 
rx.Act = ReadDelim(str{17},'Act',':','N') ; 
rx.PD = ReadDelim(str{18},'PD',':','N') ; 
rx.Fail = ReadDelim(str{19},'Fail',':','X') ; 

end 


function v = ReadDelim( src , str ,delim,  type ) 

    junk = find(src==' ',1) ; 
    if ~isempty(junk) 
        src = src(1:junk-1) ; 
    end 
    
    if nargin < 4 
        delim  = 'S' ; 
    end 

    if ~isempty(str) && ~startsWith(src,[str,delim]) 
        error ([str, ': Not found in ', src]) ; 
    end 
    place = find( src == delim , 1) ; 
    v = src(place+1:end) ; 
    if type == 'N' 
        v = str2num(v) ; 
    elseif type == 'X' 
        if ~startsWith(v,'0x' ) 
            error (['0x Not found in ', src]) ; 
        end 
        v = hex2dec(v(3:end)) ; 
    end 

end

function y =getbymask( x , m ) 
y = bitand( x , m ) / ( 2^floor( log2(m) ) ) ; 
end

% struct CPdCBit3
% {
% 	int unsigned ManSw1 : 1 ;
% 	int unsigned ManSw2 : 1 ;
% 	int unsigned StopSw1 : 1 ;
% 	int unsigned StopSw2 : 1 ;
% 	int unsigned Dyn12NetOn : 1 ;
% 	int unsigned Dyn12InitDone : 1 ;
% 	int unsigned Dyn24NetOn : 1 ;
% 	int unsigned Dyn24InitDone : 1 ;
% 	int unsigned Disc2In : 1  ;
% 	int unsigned MotorOnMan : 3 ;
% 	int unsigned MotorOnStop : 2 ;
% 	int unsigned PbitDone : 1 ;
% 	int unsigned IndividualAxControl : 1 ; // !< Manipulator axes controlled manually and individually
% };
function str = GetCbit3( x) 
str = struct('ManSw1',getbymask(x,1),'ManSw2',getbymask(x,2),'StopSw1',getbymask(x,4),'StopSw2',getbymask(x,8),'Dyn12NetOn',getbymask(x,16),'Dyn12NetDone',getbymask(x,32),...
    'Dyn24NetOn',getbymask(x,64),'Dyn24NetDone',getbymask(x,2^7),'Disc2In',getbymask(x,2^8),'MotorOnMan',getbymask(x,2^9*7),'MotorOnStop',getbymask(x,2^12*3),'PbitDone',getbymask(x,2^14),...
    'IndividualAxControl', getbymask(x,2^15)) ; 
end



% 
% struct CPdBitGen
% {
% 	int unsigned SteerBrakeRelease : 1 ;
% 	int unsigned WheelBrakeRelease : 1 ;
% 	int unsigned NeckBrakeRelease : 1 ;
% 	int unsigned ShuntActive : 1 ;
% 	int unsigned ServoGateDriveOn : 1 ;
% 	int unsigned LaserPsSwOn : 1 ;
% 	int unsigned Pump1SwOn : 1 ;
% 	int unsigned Pump2SwOn : 1 ;
% 	int unsigned ChakalakaOn : 1 ;
% 	int unsigned StopBrakeReleased : 1 ;
% 	int unsigned StopRelaySwOn : 1 ;
% 	int unsigned FanSwOn : 1  ;
% 	int unsigned TailLampSwOn : 1 ;
% 	int unsigned Disc1On : 1 ;
% 	int unsigned ServoPowerOn : 1 ;
% 	int unsigned Reserved : 1 ;
% };
function str = GetCPdBitGen( x) 
str = struct('SteerBrakeRelease',getbymask(x,1),'WheelBrakeRelease',getbymask(x,2),'NeckBrakeRelease',getbymask(x,4),'ShuntActive',getbymask(x,8),'ServoGateDriveOn',getbymask(x,16),'LaserPsSwOn',getbymask(x,32),...
    'Pump1SwOn',getbymask(x,64),'Pump2SwOn',getbymask(x,2^7),'ChakalakaOn',getbymask(x,2^8),'StopBrakeReleased',getbymask(x,2^9),'StopRelaySwOn',getbymask(x,2^10),'FanSwOn',getbymask(x,2^11),...
    'TailLampSwOn', getbymask(x,2^12),'Disc1On',getbymask(x,2^13),'ServoPowerOn',getbymask(x,2^14),'Reserved',getbymask(x,2^15)) ; 
end

% // Descriptor for self test bits
% struct CPdCBit
% {
% 	int unsigned V24Fail : 1 ; //!< Failure of the 24V voltage
% 	int unsigned V12Fail : 1 ; //!< Failure of the 12V voltage
% 	int unsigned MushroomDepressed : 1 ; // !< Mushrum is depressed
% 	int unsigned ShuntFail : 1 ; // !< 1 if shunt fails to stabilize voltages (too hot) 0x8
% 	int unsigned GripFail : 1 ; // !< 1 if grip of package failed 0x10
% 	int unsigned ManFail: 3 ; // !< Dynamixel errors: Shoulder , elbow , wrist 0x20,0x40,0x80
%     int unsigned StopFail: 2 ; // !< Dynamixel errors:   left . right  0x100 0x200
% 	int unsigned V54Fail : 1 ; // !< 54V failure 0x400
% 	int unsigned NoSuck1 : 1 ; // !< No sucking in sucker pump 1 0x800
% 	int unsigned NoSuck2 : 1 ; // !< No sucking in sucker pump 2 0x1000
% 	int unsigned Reserved : 3 ; //!< Reserved

% struct CPdCBit2
% {
% 	int unsigned Active12V : 1 ;
% 	int unsigned FailCode12V : 3 ;
% 	int unsigned Active24V : 1 ;
% 	int unsigned FailCode24V : 3 ;
%     int unsigned Active54V : 1 ;
% 	int unsigned FailCode54V : 3 ;
% };

% };
function str = GetManBit1( x) 
str = struct('V24Fail',getbymask(x,1),'V12Fail',getbymask(x,2),'MushroomDepressed',getbymask(x,4),'ShuntFail',getbymask(x,8),'GripFail',getbymask(x,16),'ManFail',getbymask(x,32*7),...
    'StopFail',getbymask(x,2^8*3),'V54Fail',getbymask(x,2^10),'NoSuck1',getbymask(x,2^11),...
    'NoSuck2', getbymask(x,2^12),'Reserved',getbymask(x,2^13*7),...
    'Active12V',getbymask(x,2^16),'FailCode12V',getbymask(x,2^17*7),'Active24V',getbymask(x,2^20),...
    'FailCode24V',getbymask(x,2^21*7),'v',getbymask(x,2^24),'FailCode54V',getbymask(x,2^27)  ) ; 
end



% struct CManControlWord
% {
% 	int unsigned Automatic  : 1 ; // !< 1 for automatic action , 0 for manual
% 	int unsigned MotorsOn	: 1 ; // !< Active manipulator motors
% 	int unsigned Standby	: 1 ; // !< 1: Standby  position
% 	int unsigned Package	: 1 ; // !< 1: deal Package
% 	int unsigned PackageGet : 1 ; // !< 1 get package, 0: Put packge
% 	int unsigned Side		: 2 ; // !< Access side: 0: Straight back (undefined), 1: Left , 2: Right
% 	int unsigned LaserValid : 1 ; // !< Laser reading is valid
% 	int unsigned BrakeValid	: 1 ; // !< 1 if later brake control fields are valid
% 	int unsigned ReleaseWheels : 1 ; // !< 1 to release the wheels ( if BrakeValid )
% 	int unsigned ReleaseSteer : 1 ; // !< 1 to release the steering ( if BrakeValid )
% 	int unsigned ReleaseNeck : 1 ; // !< 1 to release the neck ( if BrakeValid )
% 	int unsigned LaserPsOn : 1 ; // !< Set on the laser PS (Switch 1)
% 	int unsigned RepeatAction: 1 ; // !< Set if repeated action (e.g. repush package)
% 	int unsigned Reserved	: 1 ; // !< Reserved
% 	int unsigned UnProcFromPdo : 1 ; // !< 1: Do not process from PDO
% };
% 
% // Command word #2
% struct CPdCmd2
% {
%     int unsigned ChakalakaOn : 1 ; // Chakalaka
%     int unsigned FanOn : 1 ;
%     int unsigned Power24V   : 1 ;
%     int unsigned Power12V   : 1 ;
%     int unsigned CommRestart : 1 ; // Restart manipulator communication
%     int unsigned PowerEnter : 1 ; // <Enter> for Power commands
%     int unsigned FrontCamLightOn : 1 ; // Front camera light
%     int unsigned RearCamLightOn : 1 ; // Front camera light
% };
% 
% 
% 
% 
% 
% struct CPdCBit2
% {
% 	int unsigned Active12V : 1 ;
% 	int unsigned FailCode12V : 3 ;
% 	int unsigned Active24V : 1 ;
% 	int unsigned FailCode24V : 3 ;
%     int unsigned Active54V : 1 ;
% 	int unsigned FailCode54V : 3 ;
% };
% 
% 
% 
% 
% struct CPdBitGen
% {
% 	int unsigned SteerBrakeRelease : 1 ;
% 	int unsigned WheelBrakeRelease : 1 ;
% 	int unsigned NeckBrakeRelease : 1 ;
% 	int unsigned ShuntActive : 1 ;
% 	int unsigned ServoGateDriveOn : 1 ;
% 	int unsigned LaserPsSwOn : 1 ;
% 	int unsigned Pump1SwOn : 1 ;
% 	int unsigned Pump2SwOn : 1 ;
% 	int unsigned ChakalakaOn : 1 ;
% 	int unsigned StopBrakeReleased : 1 ;
% 	int unsigned StopRelaySwOn : 1 ;
% 	int unsigned FanSwOn : 1  ;
% 	int unsigned TailLampSwOn : 1 ;
% 	int unsigned Disc1On : 1 ;
% 	int unsigned ServoPowerOn : 1 ;
% 	int unsigned Reserved : 1 ;
% };
% 
% #define MAN_HOLDS_ACTIVE_STICKY 1
% #define MAN_HOLDS_SUSPECT_CONTACT 2
% #define MAN_HOLDS_SUSPECT_CONTACT_W_PUMP 4
% #define MAN_HOLDS_SUSPECT_CONTACT_STICKY 8
% #define MAN_HOLDS_SUSPECT_CONTACT_W_PUMP_STICKY 16
% #define MAN_HOLDS_INACTIVE 32
% 
% 
% 
% struct CFloatParRecord
% {
%     float * ptr ;
%     short unsigned ind;
%     float lower ;
%     float upper ;
%     float dflt ;
% } ;







