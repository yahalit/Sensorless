function r = AnaSwitchRecord( action , reclen , fastupload ) 
% AnaSwitchRecord( action , reclen , fastupload ) 
% Analize the recording of the limit switches 
% action: A bit field 1: Program recorder (reclen: Time in seconds, or defaults to 20 seconds) 
%                     2: Pause for the recording time 
%                     4: Upload & analyze  
% fastupload: 1 if to use fast upload ( will not work with proemion)  
% Returns 
% r: Recorded varables structure
global DataType
global RecStruct 

% error('AnaSwitchRecord  is an obsolete file')  ; 
CalcGeomData;

if nargin < 2 || isempty( reclen) 
    RecTime = 20; 
else
    RecTime = reclen; 
end

if nargin < 3 
    fastupload = 0 ; 
end 

RecNames = {'lDebug0','lDebug1','lDebug2','lDebug3','lDebug4','lDebug5','fDebug0','fDebug1','fDebug2','fDebug3',...
        'RightWheelEncoder','LeftWheelEncoder','ArcDistance0'} ;

if bitand(action,1 )
    SendObj( [hex2dec('2222'),2] , 1 , DataType.long , 'Debug mode = lsw' ) ;


    RecStruct.Sync2C = 1 ; 
    RecInitAction = struct( 'InitRec' , 1 , 'BringRec' , 0 ,'ProgRec' , 1 ,'Struct' , 1 ,'T' , RecTime ) ; 



    RecStruct.BlockUpLoad = 0 ; 
    [~,RecStruct] = Recorder(RecNames , RecStruct , RecInitAction   );
    %return
end
if bitand(action,2 )
    pause(RecTime) ;
end
if bitand(action,4 )
    RecBringAction = struct( 'InitRec' , 0 , 'BringRec' , 1 ,'ProgRec' , 0 ,'Struct' , 1  ) ; 
    recstruct = RecStruct ; 
    recstruct.BlockUpLoad = fastupload ; 
    [~,~,r] = Recorder(RecNames , recstruct , RecBringAction   );
    t = r.t ; 
    Ts = r.Ts ;
	r.Meter2WheelEncoder = FetchObj( [hex2dec('2226'),12] , DataType.float , 'Get Meter2WheelEncoder') ;

%    r.Meter2WheelEncoder  = ( GetFloatPar('Geom.WheelCntRad') * GetFloatPar('Geom.WheelMotCntRadRail') ) / ...
%        (GetFloatPar('Geom.rrailnom') * GetFloatPar('Geom.WheelMotCntRadGnd')) ; 
    r.Wheel2EncoderMeter = 1 / r.Meter2WheelEncoder ; 

    r.RCaptEncoderH = r.lDebug0 ;
    r.RCaptEncoderL = r.lDebug1 ;
    r.LCaptEncoderH = r.lDebug2 ;
    r.LCaptEncoderL = r.lDebug3 ;
    r.RSwAnalog = r.fDebug0 ; 
    r.LSwAnalog = r.fDebug1 ;
    r.RSWidthRaw = r.fDebug2 ; 
    r.LSWidthRaw = r.fDebug3 ;
    statf = fix( r.lDebug4 + 2^32 ) ;
    %         usl.us[0] =  RLimitSwRegs.PresentValue +  ( RLimitSwRegs.RiseMarker << 1 ) + ( RLimitSwRegs.FallMarker << 2 ) +
    %             (( RLimitSwRegs.ExpectedDir & 3) <<3 )  + ( (ClaState.RLimit.SwitchRequest ? 1 :0 ) << 5 )  + ( (ClaState.RLimit.SwitchDetectValid ? 1 :0 ) << 6 ) +
    %             ( (SysState.CBit.bit.QueueAborted ? 1 :0 ) << 7 ) + ( ManRouteCmd.ShelfSubMode  << 8 ) ;
    %         usl.us[1] =  LLimitSwRegs.PresentValue +  ( LLimitSwRegs.RiseMarker << 1 ) + ( LLimitSwRegs.FallMarker << 2 ) +
    %             (( LLimitSwRegs.ExpectedDir & 3) <<3 )  + ( (ClaState.LLimit.SwitchRequest ? 1 :0 ) << 5 )  + ( (ClaState.LLimit.SwitchDetectValid ? 1 :0 ) << 6 ) ;

%     st = bitand ( statf ,65535 ) ;  
%     d = bitget( st , 4) + bitget( st , 5) * 2  ; 
%     d( d== 3) = -1 ; 
%     r.rstat = struct('Value',bitget(st,1),'Rise', bitget(st,2),'Fall', bitget(st,3),'Dir',d,'Rqst',bitget(st,6)) ; 
%     r.rstat.Valid = bitget(st,13)+2*bitget(st,14)+4*bitget(st,15)+8*bitget(st,16); 
%     r.mstat = struct('Abort',bitget(st,8),'ShelfSubMode',bitget(st,9)+2*bitget(st,10)+4*bitget(st,11)+8*bitget(st,12)) ; 
% 
%     r.Aborted = bitget(st,8);
%     % r.ShelfSubMode = bitand(st,2^8*31) /2^8  ;   
%     st = bitand ( (statf - st)/2^16,65535 ) ;  
%     r.lstat = struct('Value',bitget(st,1),'Rise', bitget(st,2),'Fall', bitget(st,3),'Dir',d,'Rqst',bitget(st,6),'Valid',bitget(st,7)) ; 
%     r.lstat.Valid = bitget(st,13)+2*bitget(st,14)+4*bitget(st,15)+8*bitget(st,16); 
%     r.mstat.TargetArmDone = bitget(st,8)+2*bitget(st,9)+4*bitget(st,10);
%     r.mstat.GoDirection  = bitget(st,11)+2*bitget(st,12);
% 
%     >>>>>>>>>>>
%     
    statf = fix( r.lDebug4 + 2^32 ) ;
%         usl.us[0] =  (RLimitSwRegs.PresentValue > 0 ? 1 :0 ) +  ( RLimitSwRegs.RiseMarker > 0 ? 2 :0  ) + ( RLimitSwRegs.FallMarker > 0 ? 4 : 0 ) +
%             (( (short)ClaState.RLimit.SwitchRequestDir & 3) <<3 )  + ( (ClaState.LLimit.SwitchDetectMarker ? 1 :0 ) << 5 )  +
%             ( (SysState.CBit.bit.QueueAborted ? 1 :0 ) << 7 ) + ( (ManRouteCmd.ShelfSubMode & 0xf ) << 8 ) +  (( ClaState.RLimit.SwitchDetectValid & 0xf ) << 12 );
%         usl.us[1] =  (LLimitSwRegs.PresentValue > 0 ? 1 :0 ) +  ( LLimitSwRegs.RiseMarker > 0 ? 2 :0 ) + ( LLimitSwRegs.FallMarker > 0 ? 4 : 0 ) +
%             (( (short)ClaState.LLimit.SwitchRequestDir & 3) <<3 )  + ( (ClaState.LLimit.SwitchDetectMarker ? 1 :0 ) << 5 )  +
%             (( SysState.PoleRun.TargetArmDone & 0x7 ) << 7 ) + ((SysState.ManRouteState.GoDirection & 3 ) << 10) + (( ClaState.LLimit.SwitchDetectValid & 0xf ) << 12 );

st = bitand ( statf ,65535 ) ;  
d = bitget( st , 4) + bitget( st , 5) * 2  ; 
v = bitextract(st , 15, 12 );
d( d== 3) = -1 ; 
r.rstat = struct('Value',bitget(st,1),'Rise', bitget(st,2),'Fall', bitget(st,3),'Dir',d,'Rqst',bitget(st,6),'Valid',v) ; 
r.mstat = struct('Abort',bitget(st,8),'ShelfSubMode',bitget(st,9)+2*bitget(st,10)+4*bitget(st,11)+8*bitget(st,12)) ; 

r.Aborted = bitget(st,8);
% r.ShelfSubMode = bitand(st,2^8*31) /2^8  ;   
st = bitand ( (statf - st)/2^16,65535 ) ;  
v = bitextract(st , 15, 12 );
r.lstat = struct('Value',bitget(st,1),'Rise', bitget(st,2),'Fall', bitget(st,3),'Dir',d,'Rqst',bitget(st,6),'Valid',v) ; 
r.mstat.TargetArmDone = bitget(st,8)+2*bitget(st,9)+4*bitget(st,10);
r.mstat.GoDirection  = bitget(st,11)+2*bitget(st,12);

%     >>>>>>>>>>>
    
    
    save('AnaSwitchRecord.mat','r','Ts','t' ) ; 

    figure(100) ; clf 
    subplot( 2,1,1) ; 
    plot( (r.RightWheelEncoder - r.RightWheelEncoder(1) ) * r.Wheel2EncoderMeter , r.rstat.Value ) ; legend('Right LS') ; 
    xlabel('Encoder, meters') ; 
    subplot( 2,1,2) ; 
    plot( (r.LeftWheelEncoder - r.LeftWheelEncoder(1) ) * r.Wheel2EncoderMeter , r.lstat.Value ) ; legend('Left LS') ; 
    xlabel('Encoder, meters') ; 
    
end

end






