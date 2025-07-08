function s = SGetState(CanId) 
    global GetStateList    %#ok<*GVMIS> 
    global TargetCanId ; 

    DataType = GetDataType() ; 
    if nargin < 1 || isempty(CanId) 
        CanId = TargetCanId ;
        LocalGetStateList = GetStateList ;
    else
        [~,~,LocalGetStateList,~] = SetCanComTargetByCanId(CanId);
    end

    BitW  = ulong( FetchObj( [hex2dec('2220'),99,CanId] , DataType.long , 'CBIT 99' ) ) ; 
    StatW = ulong( FetchObj( [hex2dec('2220'),98,CanId] , DataType.long , 'CBIT 98' ) ) ; 
    StatSys = ulong( FetchObj( [hex2dec('2220'),100,CanId] , DataType.long , 'CBIT 100' ) ) ; 
    
    base = GetSignalsByList(LocalGetStateList) ; 
%     base = GetStateList.out ; 
%     nbase = length(GetStateList.str) ; 
%     for cnt = 1:nbase
%         next = GetStateList.str(cnt) ; 
%         base.(next.Signal) = FetchObj( [hex2dec('2002'),next.Ind] , next.datatype ,'Get Signal') ;
%     end 
    exp = ulong(base.LongException) ; 

    HallValue = bitgetvalue(StatW,(1:3)+3); 
    if ( HallValue  > 5  ) 
        HallValue = -1 ; 
    end
        
    Bit = struct ('MotorOn',bitget(BitW,1),'MotorReady',bitget(BitW,2),'ProfileConverged',bitget(BitW,4),'MotionConverged',bitget(BitW,5),...
        'Fault',bitget(BitW,6),'QuickStop',bitget(BitW,7),'BrakeRelease',bitget(BitW,8),'PotRefFail',bitget(BitW,9),'LoopClosure',bitgetvalue(BitW,(1:3)+9),'SystemMode',...
        bitgetvalue(BitW,(1:3)+12),'CurrentLimit',bitget(BitW,16),'NoCalib',bitget(BitW,17), ... 
        'GyroNotReady',bitget(BitW,18),'RecorderWaitTrigger',bitget(BitW,19), ... 
        'RecorderActive',bitget(BitW,20),'RecorderReady',bitget(BitW,21), ... 
        'RefGenOn',bitget(BitW,22),'TRefGenOn',bitget(BitW,23), ... % 'ProjType',bitgetvalue(BitW,(1:4)+24),...
        'Configured',bitget(BitW,29),'Homed',bitget(BitW,30),'Din',bitgetvalue(BitW,(1:2)+30),... 
        'HallKey',bitgetvalue(StatW,(1:3)),'HallValue',HallValue,'CommInit',bitget(StatW,29), ... 
        'CommException',bitget(StatW,30),'HallException',bitget(StatW,31), ... 
        'CommutationMode', bitgetvalue(StatSys,(1:3)),'CorrState',bitgetvalue(StatSys,((1:3)+3)),...
        'CurrentPrefOff',bitget(StatSys,7),'MaxLoopClosureMode',bitgetvalue(StatSys,(1:3)+7),'bBypassPosFilter',bitget(StatSys,11),...
        'bPeriodicProf',bitget(StatSys,12),'ReferenceMode',bitgetvalue(StatSys,(1:3)+12),'IsValidIdentity',bitget(StatSys,16),'IsRev2',bitget(StatSys,17),... 
        'LastException' , bitand(exp,65535),'AbortException' , fix(exp/65535),'RailSwitchState',bitgetvalue(StatSys,(1:3)+17),...
         'DisableAutoBrake',bitget(StatSys,22),'InAutoBrakeEngage' ,bitget(StatSys,23))  ;
 
    if Bit.SystemMode >= 6 
        Bit.SystemMode = Bit.SystemMode - 8 ; 
    end
    base.HallAngle = bitgetvalue(StatW,(1:10)+6) / 1024 ; 
    base.CommAngle = bitgetvalue(StatW,(1:10)+16) / 1024 ; 
    base.BridgeTemperature =  FetchObj( [hex2dec('2222'),3,CanId] , DataType.float , 'Temperature' ) ;

    [~,IntfcId] = GetTargetCanId(CanId);    
    base.BrakeVolts =  FetchObj( [hex2dec('2222'),4,IntfcId] , DataType.float , 'BrakeVolt' ) ;
    
    s = struct('Bit',Bit,'base',base) ;

end

function x = ulong(x) 
    x = bitand( x + 2^32 , 2^32 -1 ); 
end

function z = bitgetvalue(x,y) 
    z = bitget(x,y) ; 
    junk = 2.^(0:(length(z)-1));
    z = sum( z.* junk) ; 
end

