% RecStruct = struct('Gap',1,'Len',300,'TrigSig',26,'TrigVal',2,'TrigType',0,'Signals',[16,19,25,26,28],...
%     'Sync2C', 0 ,'PreTrigCnt', 150 , 'SigList' ,{SigTable}, 'SigNames' , {SigNames} , ...
% 	'ParList', {ParTable} ,'ErrCodes', {ErrCodes} ,...
%     'BHErrCodes', {BHErrCodes} ) ;% ,...
	%,'ParList', {ReadParTable('.\Application\ParRecords.h')} 	) ; 

TrigSig   = find( strcmpi( SigNames ,'fDebug3')) ;  
TrigTypes = struct('Immediate', 0 , 'Rising' , 1 , 'Falling' , 2 ,'Equal' , 3) ; 
RecNames = {'RawImuAcc0','RawImuAcc1','RawImuAcc2','ImuAcc0','ImuAcc1','ImuAcc2'} ; 

RecStructUser = struct('TrigSig',TrigSig,'TrigType',TrigTypes.Immediate ,'TrigVal',20000,...
    'Sync2C', 1 , 'Gap' , 2 , 'Len' , 300 ) ; 
RecStructUser.PreTrigCnt = RecStructUser.Len / 4;

RecStructUser = MergeStruct ( RecStruct, RecStructUser)  ; 

%Flags (set only one of them to 1) : 
% ProgRec = 1 just programs the signals, recorder remains inactive waiting an activating event 
% InitRec = 1 initates the recorder and makes it work 
% BringRec = 1 Programs the recorder, waits completion, and brings the
% results immediately
options = struct( 'InitRec' , 1 , 'BringRec' , 1 ,'ProgRec' , 1 ); 

RecVec = Recorder(RecNames , RecStructUser , options ) ; 
str = struct() ; 
for cnt  = 1: size(RecVec,1)
    str.(RecNames{cnt}) =  RecVec( cnt,:) ; 
end 
str.gMod = sqrt( str.RawImuAcc0.^2 + str.RawImuAcc1.^2 + str.RawImuAcc2.^2) ; 
disp('raw , full g') ; 
mRaw = [mean(str.RawImuAcc0); mean(str.RawImuAcc1) ; mean(str.RawImuAcc2)] ;
disp( [mRaw' , mean(str.gMod) ])
disp('corrected') ; 
mAcc = [mean(str.ImuAcc0); mean(str.ImuAcc1) ; mean(str.ImuAcc2) ];
disp( mAcc' )

