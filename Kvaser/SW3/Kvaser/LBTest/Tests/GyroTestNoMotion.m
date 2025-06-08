%Test the gyro readouts with no motion 
global DataType

ProjectDir = 'C:\Nimrod\BHT\kvaser\LPTest\CCS';
success = KvaserCom(1) ; 
DataType=struct( 'long' , 0 , 'float', 1 , 'short' , 2 , 'char' , 3 ,'string', 9 ,'lvec' , 10 ,'fvec' , 11 , 'ulvec' , 20 ) ; 
RecStruct = struct('Gap',1,'Len',300,'TrigSig',26,'TrigVal',2,'TrigType',0,'Signals',[16,19,25,26,28],...
    'Sync2C', 0 ,'PreTrigCnt', 150 , 'SigList' , {ReadSigList( [ProjectDir,'\ProjRecorderSignals.h'])} ) ; 

RecNames = {'ImuAcc0','ImuAcc1','ImuAcc2','ImuOmega0','ImuOmega1','ImuOmega2'} ; 
RecStruct.TrigType = 0 ; % Immediate record 
RecStruct.Gap = 16 ; 
RecStruct.Sync2C = 0 ; 

uiwait(msgbox('Mount gyro horizontally','Attention','modal'));

disp( 'Wait up to 30 seconds...') 
RecVec = Recorder(RecNames , RecStruct  ) ;

figure(1) ; clf ; 
[m,n] = size( RecVec)  ; 
t = (0:n-1) * 25e-6 * RecStruct.Gap ;
subplot( 2,1,1) ; 

NormAcc = sqrt( RecVec(1,:).^2 + RecVec(2,:).^2 + RecVec(3,:).^2 ) ; 
junk = find( NormAcc < 8 | NormAcc > 12 ) ; 
if length( junk ) * 5 > n 
    error ( 'Too many outliers in acceleration measurement') ; 
end 
RecVec( 1:3,junk) = NaN + RecVec( 1:3,junk); 

plot ( t , RecVec(1,:) , t , RecVec(2,:)  , t , RecVec(3,:)  ) ; 
xlabel( 'Time' ) ; 
ylabel('Acceleration m/sec^2') ; 
grid on ; 
legend( 'Acc X','Acc Y', 'Acc Z') 

subplot( 2,1,2) ; 
plot ( t , RecVec(4,:) , t , RecVec(5,:)  , t , RecVec(6,:)  ) ; 
xlabel( 'Time' ) ; 
ylabel('Gyro rad/sec') ; 
grid on ; 

legend('W X','W Y', 'W Z') ; 





