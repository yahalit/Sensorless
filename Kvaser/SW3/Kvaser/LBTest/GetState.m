function s = GetState( extra , forceCan )
% function s = GetState(  )
% Get a struct with a lot of info on the robot's state
% s = GetState('Map') tries to take by file mapping a previous reading if it is less 1.5sec of age. 
%           If mapped data is bad or age too big, do standard reading from robot.
global DataType 
global AtpCfg %#ok<*GVMIS> 
global TargetCanId
TemperatureRW = [] ;
TemperatureLW = [] ;
if nargin < 1
    extra = 0 ; 
else
    if ( extra == 0) 
        extra = 1 ; 
    end 
end 

posixnow = convertTo(datetime('now'),'posixtime') ;
GetFromMap = 0 ; 
if isequal(extra,'Map')
    try 
        MapData = AtpCfg.GetStateMapFile.Data ; 
        dTime = posixnow - MapData(4) ;
        if ( dTime > 1.5)
            GetFromMap = 0 ; 
        else
            if isequal( MapData(1:3) ,double('can') )
                BulkData = MapData(4:end) ; 
                GetFromMap = 1 ; 
                forceCan   = 1 ; 
            elseif isequal( MapData(1:3) ,double('udp') )
                BulkData = MapData(4:end) ; 
                GetFromMap = 2 ; 
                forceCan   = 0 ; 
            else
                GetFromMap = 0 ; 
            end
        end
    catch 
        GetFromMap = 0 ; 
    end 
    extra = 0 ; 
end

if nargin < 2
    forceCan = 0 ; 
end 

if AtpCfg.Udp.On && (forceCan == 0)
    if ( GetFromMap == 2 )
        try 
            s = TunnelFields( BulkData ) ; 
        catch
            GetFromMap = 0 ;
        end
    end
    if (GetFromMap==0) 
        [s,err] = UdpComJava( 200 , [1536+TargetCanId ,1408+TargetCanId ,16384,0,0,0,200] ); % Get records  
        try
            AtpCfg.GetStateMapFile.Data =  [double('udp'), posixnow , s.RawData]  ; 
            s.RawData = []; 
        catch 
        end
    end
    
    if ~isempty(err) 
        error('Could not read the state via UDP') ; 
    end 
    b = s.Bit ; 
    ms = s.Manip ; 

    s.NavDesc.PosX = s.NavDesc.PosX * 1e-4 ; 
    s.NavDesc.PosY = s.NavDesc.PosY * 1e-4 ; 
    s.NavDesc.PosZ = s.NavDesc.PosZ * 1e-4 ; 
    s.NavDesc.QrX = s.NavDesc.QrX * 1e-4 ; 
    s.NavDesc.QrY = s.NavDesc.QrY * 1e-4 ; 
    s.NavDesc.QrAz = s.NavDesc.QrAz * 180 / 32768  ;
    if ( s.NavDesc.QrAz > 180) 
        s.NavDesc.QrAz = s.NavDesc.QrAz - 360 ; 
    end

    CamCntObj = s.NavDesc.TotalMsgCounter ;
    s.NavDesc.QrCnt = bitand( CamCntObj ,1023 ) ; 
    CamCntObj  = (CamCntObj - s.NavDesc.QrCnt ) / 1024 ; 
    s.NavDesc.DevCnt = bitand( CamCntObj ,1023 ) ; 
    CamCntObj  = (CamCntObj - s.NavDesc.DevCnt ) / 1024 ; 
    s.NavDesc.RelPosCnt = bitand( CamCntObj ,1023 ) ; 


    
    BitW = ulong(b.BitW) ; 
    BitPand3 = ulong(b.BitPand3) ; 
    Bit1and2 = ulong(b.Bit1and2) ; 
    
    BitFault = ulong(b.BitFault);
    eBit     = ulong(b.eBit);
    fBit     = ulong(b.fBit);
    Mbit     = ulong(ms.Mbit) ;
    ManStat  = ulong(ms.ManStat) ;
    WarmSummary = ulong(b.WarmSummary);
    ManipMotStat1 = ulong(b.ManipMotStat1);
    ManipMotStat2 = ulong(b.ManipMotStat2);
    ManX = ms.X ;
    ManY = ms.Y ;
    ManTht = ms.Tht ;
    ManLD = ms.LD ;
    ManRD = ms.RD ;
    
else

    if ( GetFromMap == 1 )
        try 
            BitW = BulkData(1);
            BitPand3 = BulkData(2);
            Bit1and2 = BulkData(3);
            
            BitFault = BulkData(4); 
            eBit     = BulkData(5);
            fBit     = BulkData(6);
            WarmSummary = BulkData(7);
            ManipMotStat1 = BulkData(8);
            ManipMotStat2 = BulkData(9);
            
            Mbit     = BulkData(10); 
        
            ManStat = BulkData(11); 
            ManX = BulkData(12); 
            ManY = BulkData(13);
            ManTht = BulkData(14);
            ManLD = BulkData(15);
            ManRD = BulkData(16);
        catch
            GetFromMap = 0 ;
        end
    end

    if ( GetFromMap == 0 )
        BitW = ulong( FetchObj( [hex2dec('2220'),99] , DataType.long , 'CBIT 99' ) ) ; 
        BitPand3 = ulong( FetchObj( [hex2dec('2220'),97] , DataType.long , 'CBIT 97' ))  ; 
        Bit1and2 = ulong( FetchObj( [hex2dec('2220'),98] , DataType.long , 'CBIT 98' ))  ; 
        
        BitFault = ulong( FetchObj( [hex2dec('2220'),100] , DataType.long , 'CBIT 100' )) ; 
        eBit     = FetchObj( [hex2dec('220b'),1] , DataType.long , 'Ebit' ) ;
        fBit     = FetchObj( [hex2dec('220b'),15] , DataType.long , 'Fbit' ) ;
        WarmSummary = FetchObj( [hex2dec('220b'),23] , DataType.long ,'Wheel arm state') ;
        ManipMotStat1 = ulong( FetchObj( [hex2dec('2223'),47] , DataType.long , 'ManipStat 47' ))  ; 
        ManipMotStat2 = ulong( FetchObj( [hex2dec('2223'),48] , DataType.long , 'ManipStat 49' ))  ; 
        
        Mbit     = FetchObj( [hex2dec('220b'),11] , DataType.long ,'Manipulator package status') ; % Low byte is manipulator state, high byte is error 
    
        ManStat = FetchObj( [hex2dec('220b'),14] , DataType.long , 'MAN Stat' ) ;
        ManX = FetchObj( [hex2dec('2204'),80] , DataType.float , 'MAN X' ) ;
        ManY = FetchObj( [hex2dec('2204'),81] , DataType.float , 'MAN Y' ) ;
        ManTht = FetchObj( [hex2dec('2204'),82] , DataType.float , 'MAN T' ) ;
        ManLD = FetchObj( [hex2dec('2204'),83] , DataType.float , 'MAN RD' ) ;
        ManRD = FetchObj( [hex2dec('2204'),84] , DataType.float , 'MAN LD' ) ;
    
        GetStateArr = [ BitW ,BitPand3,Bit1and2,BitFault,eBit,...
            fBit,WarmSummary,ManipMotStat1,ManipMotStat2,Mbit,...
            ManStat,ManX,ManY,ManTht,ManLD,...
            ManRD]   ;
        try
            AtpCfg.GetStateMapFile.Data =  [double('can'), posixnow , GetStateArr]  ; 
        catch 
        end
    end

end 
Bit = struct( 'MotorOnRw', bitget(BitW,1), 'MotorOnLw', bitget(BitW,2) , 'MotorOnRSteer', bitget(BitW,3) , ...
      'MotorOnLSteer', bitget(BitW,4) , 'MotorOnNeck', bitget(BitW,5),'NavInitialized', bitget(BitW,6),...
      'FaultRw', bitget(BitW,7), 'FaultLw', bitget(BitW,8) , 'FaultRSteer', bitget(BitW,9) , ...
      'FaultLSteer', bitget(BitW,10) , 'FaultNeck', bitget(BitW,11), 'InPause', bitget(BitW,14),'QuickStop',bitget(BitW,15),...
      'BrakeReleaseCmd', bitget(BitW,16),'PotRefFail', bitget(BitW,17),'IMUFail', bitget(BitW,18),'CalibReadFail', bitget(BitW,19),...
      'PdDataMissFail', bitget(BitW,20),'GyroOffsetCalibrating', bitget(BitW,21), ...
      'QueueAborted', bitget(BitW,22),'CompromiseNavInit', bitget(BitW,23),...
      'OnRescueMission', bitget(BitW,24),'GyroQuatListReady', bitget(BitW,25),...
      'QueueIsSane', bitget(BitW,26),'SleepRequest', bitget(BitW,27:29),...  % 'PumpRequest', bitget(BitW,30),..
'RBrakeForce', bitget(BitW,31),'LBrakeForce', bitget(BitW,32),...      
'V24Fail',bitget(Bit1and2,1),'V12Fail',bitget(Bit1and2,2),'MushroomDepressed',bitget(Bit1and2,3),...
'ShuntFail',bitget(Bit1and2,4),'GripFail',bitget(Bit1and2,5),'ManFail',bitget(Bit1and2,6:8),'StopFail',bitget(Bit1and2,9:10),'V54Fail',bitget(Bit1and2,11),...
'Active12V',bitget(Bit1and2,17),'FailCode12V',bitgetvalue(Bit1and2,18:20),...
'Active24V',bitget(Bit1and2,21),'FailCode24V',bitgetvalue(Bit1and2,22:24),...
'Active54V',bitget(Bit1and2,25),'FailCode54V',bitgetvalue(Bit1and2,26:28),... 
'Active18V',bitget(Bit1and2,29),'FailCode18V',bitgetvalue(Bit1and2,30:32),...
'SteerBrakeRelease',bitget(BitPand3,2),'WheelBrakeRelease',bitget(BitPand3,1),'NeckBrakeRelease',bitget(BitPand3,3),...
'ShuntActive',bitget(BitPand3,4),'ServoGateDriveOn',bitget(BitPand3,5),'LaserPsSwOn',bitget(BitPand3,6),...
'Pump1SwOn',bitget(BitPand3,7),'Pump2SwOn',bitget(BitPand3,8),'ChakalakaOn',bitget(BitPand3,9),...
'StopBrakeReleased',bitget(BitPand3,10),'StopRelaySwOn',bitget(BitPand3,11),'FanSwOn',bitget(BitPand3,12),...
'TailLampSwOn',bitget(BitPand3,13),'Disc1On',bitget(BitPand3,14),'ServoPowerOn',bitget(BitPand3,15),...
'ManSw1',bitget(BitPand3,17),'ManSw2',bitget(BitPand3,18),'StopSw1',bitget(BitPand3,19),...
'StopSw2',bitget(BitPand3,20),'Dyn12NetOn',bitget(BitPand3,21),'Dyn12InitDone',bitget(BitPand3,22),...
'Dyn24NetOn',bitget(BitPand3,23),'Dyn24InitDone',bitget(BitPand3,24),'Disc2In',bitget(BitPand3,25),...
'MotorOnMan',bitget(BitPand3,(26:28)),'MotorOnStop',bitget(BitPand3,(29:30)),'PbitDone',bitget(BitPand3,31),...
'OverNeckStretch',bitget(BitFault,4),'OnDebugWait',bitgetvalue(BitFault,(5:12)),'DebugHoldEnabled',bitget(BitFault,13),'SerialFlashFault',bitget(BitFault,15),...
'Net24BootState',bitgetvalue(ManipMotStat1,1:4), 'Net12BootState',bitgetvalue(ManipMotStat1,(1:4)+4),...
'Net12MovState',[bitgetvalue(ManipMotStat1,(1:8)+16),bitgetvalue(ManipMotStat1,(1:8)+24)],...
'Net24MovState',[bitgetvalue(ManipMotStat2,(1:8)+0),bitgetvalue(ManipMotStat2,(1:8)+8),bitgetvalue(ManipMotStat2,(1:8)+16)],...
'Mode',bitgetvalue(eBit,(1:4)),'ExecutingQueue',bitgetvalue(eBit,(1:3)+4),'nGet',bitgetvalue(eBit,(1:5)+7),'OpCode',bitgetvalue(eBit,(1:5)+14),'InGroundNav',bitget(BitFault,17),'InPack',bitget(BitFault,18),...
'RSwValue',bitget(BitFault,19),'LSwValue',bitget(BitFault,20),'RSwDetectCnt',bitgetvalue(BitFault,20+(1:3)),'LSwDetectCnt',bitgetvalue(BitFault,23+(1:3)),...
'bBalanceWheelLoadsOnManual',bitget(BitFault,27), ... 
        'ShelfMode',bitgetvalue(eBit,(1:4)+21),'PackState',bitgetvalue(eBit,(1:4)+25),'WakeupState',bitgetvalue(eBit,(1:3)+29) + 8 * bitget(BitFault,14) ,...
        'NeckMode',bitgetvalue(fBit,(1:3)+2),'Status_WakeUp',bitgetvalue(fBit,(1:4)+5),'PackageMode',bitgetvalue(fBit,(1:4)+9),...
        'WarmSummary',WarmSummary,'CrabCrawl',bitgetvalue(WarmSummary,(1:2)),'IsInMission',bitgetvalue(WarmSummary,(1:3)+2),'WarmState',bitgetvalue(WarmSummary,(1:4)+6),...
        'ShelfEndGame',bitget(WarmSummary,17),'TargetArmDone',bitgetvalue(WarmSummary,(1:3)+17),'NextStationIsPole',bitget(WarmSummary,21),'ShelfSubMode',bitgetvalue(WarmSummary,(1:5)+21),...
        'RobotType',bitgetvalue(fBit,(1:4)+28)) ;

Bit.V18Fail = double(logical(Bit.FailCode18V)) ; 

if Bit.CrabCrawl == 3
    Bit.CrabCrawl = -1 ; 
end

ManErr  = bitand( ManStat,65535)   ; 
ManRecover = bitand( ManStat,65536) / 65536  ;
ManOk = 1 - bitand( ManStat,2^17) / 2^17  ;
ManOn = bitand( ManStat,2^18) / 2^18  ;
ManErrFlag = ~(ManErr==0); 
ManStdBy = ManOk ; 
if  ~(ManOn==0)
    ManStdBy = 0 ; 
end 

Manip = struct('ManState',bitgetvalue(Mbit,(1:8)),'ManStopErr',bitgetvalue(Mbit,(1:8)+8),'Permission',bitgetvalue(Mbit,(1:8)+17),...
    'bIndividual',bitget(Mbit,26),'FlexArmHomed',bitget(Mbit,27),'SpacerHomed',bitget(Mbit,28),...
    'X',ManX,'Y',ManY,'Tht',ManTht,'RD',ManRD,'LD', ManLD, 'Stat',...
                ManStat,'stdby',ManStdBy,'MotorOn',ManOn,...
                'Error',ManErrFlag,'ErrorRecoverable',ManRecover) ;

if AtpCfg.Udp.On && (forceCan == 0)
    s.Bit = Bit ; 
    s.Manip = Manip ; 
    vrpt = s.base.V36 ; 
    if ( Bit.RobotType >= 3 )
        s.base.V36 = 0 ; 
        s.base.V18 = vrpt ;
    else
        s.base.V36 = vrpt ; 
        s.base.V18 = 0 ;
    end

    return ; 
end 

if ( Bit.RobotType >= 3 )
    Volts18  = FetchObj( [hex2dec('2204'),69] , DataType.float , 'V36' ) ; 
    V36 = 0 ;
else
    V36  = FetchObj( [hex2dec('2204'),72] , DataType.float , 'V36' ) ; 
    Volts18 = 0 ;
end

VBat54 = FetchObj( [hex2dec('2204'),73] , DataType.float , 'VBat54' ) ; 
Volts24 = FetchObj( [hex2dec('2204'),71] , DataType.float , 'V24' ) ; 
Volts12 = FetchObj( [hex2dec('2204'),70] , DataType.float , 'V12' ) ; 

TemperatureRW = FetchObj( [hex2dec('2226'),37] , DataType.float , 'Right temperature' ) ; 
TemperatureLW = FetchObj( [hex2dec('2226'),38] , DataType.float , 'Left temperature' ) ; 

TimeElapseMsec = FetchObj( [hex2dec('2220'),79] , DataType.long , 'T Elapse msec' ) ; 



CurObj = FetchObj( [hex2dec('220b'),10] , DataType.long , 'Trqs' ) ; 
Curs = [  motorcur(CurObj,1), motorcur(CurObj,7) , motorcur(CurObj,13) , motorcur(CurObj,19) , motorcur(CurObj,25)  ] ; 




    

ROuterPos = FetchObj( [hex2dec('2204'),30] , DataType.float , 'ROuterPos' ) ;
LOuterPos = FetchObj( [hex2dec('2204'),31] , DataType.float , 'LOuterPos' ) ;
NOuterPos = FetchObj( [hex2dec('2204'),32] , DataType.float , 'NOuterPos' ) ;
REnc = FetchObj( [hex2dec('2204'),40] , DataType.float , 'REnc' ) ;
LEnc = FetchObj( [hex2dec('2204'),41] , DataType.float , 'LEnc' ) ;
NEnc = FetchObj( [hex2dec('2204'),42] , DataType.float , 'NEnc' ) ;    
TorqueDiff = FetchObj( [hex2dec('2204'),33] , DataType.float , 'TorqueDiff' ) ;   

cmdrsteerRadSec = FetchObj( [hex2dec('2206'),13] , DataType.float ,'Right steer cmd') ; 
cmdlsteerRadSec = FetchObj( [hex2dec('2206'),14] , DataType.float ,'Left steer cmd') ; 
cmdneckRadSec =  FetchObj( [hex2dec('2206'),15] , DataType.float ,'Left steer cmd') ; 

NavDesc = GetNavDesc( );

LedsOn = FetchObj( [hex2dec('2203'),100] , DataType.long ,'Cam light on');
Tilt = FetchObj( [hex2dec('2204'),53] , DataType.float ,'Tilt') ;
expnum_2 = FetchObj( [hex2dec('220b'),2] , DataType.long ,'Captured exceptions') ;
expnum_3 = FetchObj( [hex2dec('220b'),3] , DataType.long ,'Mode status') ;
LaserDist = FetchObj( [hex2dec('2204'),10] , DataType.float ,'Laser distance') ;

BitDialog = struct('LaserDist',LaserDist,'LedsOn',LedsOn,'Tilt',Tilt,'expnum_2',expnum_2,'expnum_3',expnum_3) ; 

base = struct( 'V36',V36,'VBat54',VBat54,'Volts24',Volts24,'Volts18',Volts18,'Volts12',Volts12,'Current1',Curs(1),'Current2',Curs(2),'Current3',Curs(3),'Current4',Curs(4),'Current5',Curs(5),'TimeElapseMsec',TimeElapseMsec,...
'ROuterPos',ROuterPos,'LOuterPos',LOuterPos,'NOuterPos',NOuterPos,'REnc',REnc,'LEnc',LEnc,'NEnc',NEnc,'TorqueDiff',TorqueDiff,...
'cmdrsteerRadSec',cmdrsteerRadSec,'cmdlsteerRadSec',cmdlsteerRadSec,'cmdneckRadSec',cmdneckRadSec) ;

if ~isempty(TemperatureRW) 
    base.TemperatureRW = TemperatureRW ; 
    base.TemperatureLW = TemperatureLW ; 
end

% s = struct( 'V36',V36,'VBat54',VBat54,'Volts24',Volts24,'Volts12',Volts12,'Bit',Bit,'Manip',Manip,'base',base,'Current',Curs,'TimeElapseMsec',TimeElapseMsec,...
% 'ROuterPos',ROuterPos,'LOuterPos',LOuterPos,'NOuterPos',NOuterPos,'REnc',REnc,'LEnc',LEnc,'NEnc',NEnc,'TorqueDiff',TorqueDiff,...
% 'cmdrsteerRadSec',cmdrsteerRadSec,'cmdlsteerRadSec',cmdlsteerRadSec,'cmdneckRadSec',cmdneckRadSec) ;
s = struct('Bit',Bit,'Manip',Manip,'NavDesc',NavDesc,'BitDialog',BitDialog,'base',base) ;

if extra 
    WarmBitW = FetchObj( [hex2dec('2222'),24] , DataType.long ,'Wheel arm BIT') ;
    
    WarmBit = struct('IBitState',bitgetvalue(WarmBitW,(1:3)+8)) ; 


    HVer = FetchObj( [hex2dec('2204'),122] , DataType.long , 'HomeVerify' ) ;
    RPotZero = FetchObj( [hex2dec('2204'),123] , DataType.float , 'RPotZero' ) ;
    LPotZero = FetchObj( [hex2dec('2204'),124] , DataType.float , 'LPotZero' ) ;
    NPotZero = FetchObj( [hex2dec('2204'),125] , DataType.float , 'NPotZero' ) ;
    
    Hm = struct(...
        'R',struct('Verified',bitget(HVer,1),'ZeroPos',RPotZero,'NowPot',ROuterPos,'Encoder',REnc ) ,... 
        'L',struct('Verified',bitget(HVer,2),'ZeroPos',LPotZero,'NowPot',LOuterPos,'Encoder',LEnc ) ,... 
        'N',struct('Verified',bitget(HVer,3),'ZeroPos',NPotZero,'NowPot',NOuterPos,'Encoder',NEnc ) ... 
        ) ; 
    
    Vpot = FetchObj( [hex2dec('2204'),120] , DataType.float , 'Vpot' );
    MoreInfo = FetchObj( [hex2dec('2204'),121] , DataType.long , 'MoreInfo' );
    Diagnostic = struct('Vpot',Vpot,'MoreInfo',MoreInfo,'Hm',Hm,'WarmBit',WarmBit) ; 
    s.('Diagnostic') = Diagnostic ; 
    
    WhatsMyProblem(s,extra) ; 
end 


end

function x = ulong(x) 
    x = bitand( x + 2^32 , 2^32 -1 ); 
end

function z = bitgetvalue(x,y) 
    z = bitget(x+2^32,y) ; 
    junk = 2.^(0:(length(z)-1));
    z = sum( z.* junk) ; 
end

function c = motorcur(x,y)
c = bitgetvalue(x,y:y+5) ; 
if ( c > 31 ) 
    c = c - 64 ; 
end
end

