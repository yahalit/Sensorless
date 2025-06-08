global StopAfterRecProg 
global DataType 
StopAfterRecProg = 0 ; 

%         SendObj( [hex2dec('2207'),10] , ManDesc.CrabCrawl , DataType.float ,'CrabCrawl cmd') ;
%         SendObj( [hex2dec('2207'),100] , 1 , DataType.float , 'Start manual ground cmd' ) ;
Lpos = 2 ; 

if Lpos  == 2 
    Lpos = 1 ; 
    vec  = 2.^[0:15] ; 
    mon1 = 1 ; 
    mon2 = 1 ; 
    mon3 = 1 ; 
    mon4 = 1 ; 
    mon5 = 1 ; 
    mon = [mon1, mon2 ,mon3 ,mon4 ,mon5, 1] ; 
    qs = [0,1] ; % [get( handles.CheckQuickBox,'Value'), 1] ;
    rsfail = [1 , 1] ; 
    reserved = [0,0,0,0];
    brr = [1 1] ;  
    value = sum( [ mon , reserved , brr,  rsfail , qs] .* vec ) ;  
    SendObj( [hex2dec('2220'),5] , hex2dec('1234') , DataType.short , 'Set Master Blaster' ) ;
    SendObj( [hex2dec('2220'),6] , value , DataType.short ,'Reset motors cmd') ;

    pause(2) ; 
end

while(1) 
Lpos =-Lpos ;

Lpos = max( min( Lpos, 90 ) , -90) ; 

TrigSig   = find( strcmpi( SigNames ,'bPauseFlag')) ;  
TrigTypes = struct('Immediate', 0 , 'Rising' , 1 , 'Falling' , 2 ,'Equal' , 3) ; 
RecNames = {'LsteerOuterPos','LSteerPosEnc','LwSteerCmdSpeed','LsteerTorque','LwSteerCmdAxis',...
    'RsteerOuterPos','RSteerPosEnc','RwSteerCmdSpeed','RsteerTorque','RwSteerCmdAxis'} ; 
MyRecNames = RecNames ; 
RecTime = 7.5 ; 
TsRec   = 4.096e-3 ; 
RecGap  = 2 ; 
nRec    = fix( RecTime / ( RecGap* TsRec ) ) ; 
MaxRecLen = 10000 / length(RecNames) ; 
while nRec > MaxRecLen
	RecGap = RecGap + 1 ; 
	nRec    = fix( RecTime / ( RecGap* TsRec ) ) ; 
end 


RecStructUser = struct('TrigSig',TrigSig,'TrigType',TrigTypes.Immediate ,'TrigVal',0,...
    'Sync2C', 1 , 'Gap' , RecGap , 'Len' , nRec ) ; 
RecStructUser.PreTrigCnt = fix( nRec / 4) ;

RecStructUser = MergeStruct ( RecStruct, RecStructUser)  ; 

%Flags (set only one of them to 1) : 
% ProgRec = 1 just programs the signals, recorder remains inactive waiting an activating event 
% InitRec = 1 initates the recorder and makes it work 
% BringRec = 1 Programs the recorder, waits completion, and brings the
% results immediately
options = struct( 'InitRec' , 1 , 'BringRec' , 0 ,'ProgRec' , 1 , 'BlockUpLoad', 1  ); 
Recorder(RecNames , RecStructUser , options ) ; 

if StopAfterRecProg	
	return ;  %#ok<UNRCH>
end
% SendObj( [hex2dec('2206'),13] , Lpos * pi / 180  , DataType.float , 'Pos command LSteer' ) ;
% SendObj( [hex2dec('2206'),14] , Lpos * pi / 180  , DataType.float , 'Pos command LSteer' ) ;
        SendObj( [hex2dec('2207'),10] , Lpos , DataType.float ,'CrabCrawl cmd') ;
        SendObj( [hex2dec('2207'),100] , 1 , DataType.float , 'Start manual ground cmd' ) ;

pause(6) ; 
disp('Moving') ; 
s = GetState();
if ( s.Bit.FaultRSteer == 0 ) && (s.Bit.FaultLSteer == 0)
    disp('Was ok')  ; 
else
    break ;
end

end
disp('Bringing records') ; 
disp('>>>>>>>>>>>>>>>>>>>>>>>>>>>>') ; 
disp('>>>>>>>>>>>>>>>>>>>>>>>>>>>>') ; 
options = struct( 'InitRec' , 0 , 'BringRec' , 1 ,'ProgRec' , 0 , 'BlockUpLoad', 1 ,'Struct', 1 ); 
[~,~,r]= Recorder(RecNames , RecStructUser , options ) ; 


disp('Done') ; 
disp('>>>>>>>>>>>>>>>>>>>>>>>>>>>>') ; 
disp('>>>>>>>>>>>>>>>>>>>>>>>>>>>>') ; 

t = r.t ; 
figure(10) ; clf 
subplot( 4,1,1) ; 
plot( t , r.LsteerOuterPos); 
subplot( 4,1,2) ; 
plot( t , r.LSteerPosEnc,t,r.LwSteerCmdAxis) ; legend('pos','pos cmd') ; 
subplot( 4,1,3) ; 
encspeed = [0,( r.LSteerPosEnc(3:end) -  r.LSteerPosEnc(1:end-2)) / ( RecGap * TsRec * 2),0] ; 
plot( t , r.LwSteerCmdSpeed, t,encspeed) ; legend('Speed cmd','Enc speed') ; 
subplot( 4,1,4) ; 
plot( t , r.LsteerTorque); 

figure(20) ; clf 
subplot( 4,1,1) ; 
plot( t , r.RsteerOuterPos); 
subplot( 4,1,2) ; 
plot( t , r.RSteerPosEnc,t,r.RwSteerCmdAxis) ; legend('pos','pos cmd') ; 
subplot( 4,1,3) ;
encspeed = [0,( r.RSteerPosEnc(3:end) -  r.RSteerPosEnc(1:end-2)) / ( RecGap * TsRec * 2),0] ; 
plot( t , r.RwSteerCmdSpeed, t,encspeed) ; legend('Speed cmd','Enc speed') ; 
subplot( 4,1,4) ; 
plot( t , r.RsteerTorque); 


