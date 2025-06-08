% User setup 
MaxSpeed = 0.4; 
StartPos = [3,2.6] ; 
EndPos   = [5.5,2.6] ; 
RecNames = {'UsecTimer','RawPosTStamp','RawSEst','HackedPosAzimuth','RawPosReport_0','RawPosReport_1',...
    'RWheelEncPos','RWheelEncSpeed'} ;

experimentNum =12 ; 
switch experimentNum 
    case 1
        MaxSpeed = 0.4; 
        RecSaveName = 'TestQrAcqOnMotion1.mat' ; 
    case 2
        MaxSpeed = 0.4; 
        RecSaveName = 'TestQrAcqOnMotion0p4_Try2.mat' ; 
    case 3
        MaxSpeed = 0.25; 
        RecSaveName = 'TestQrAcqOnMotion0p25_Try1.mat' ; 
    case 4
        MaxSpeed = 0.5; 
        RecSaveName = 'TestQrAcqOnMotion0p5_Try1.mat' ; 
    case 5
        MaxSpeed = 0.5; 
        RecSaveName = 'TestQrAcqOnMotion0p5_Try2.mat' ; 
    case 6
        MaxSpeed = 0.6; 
        RecSaveName = 'TestQrAcqOnMotion0p6_Try1.mat' ; 
    case 7
%         error('Tambal this record is bad')  ; 
        MaxSpeed = 0.3; 
        RecSaveName = 'TestQrAcqOnMotion0p3_Try1.mat' ; 
    case 8
        MaxSpeed = 0.3; 
        RecSaveName = 'TestQrAcqOnMotion0p3_Try2.mat' ; 
    case 9
        MaxSpeed = 0.35; 
        RecSaveName = 'TestQrAcqOnMotion0p35_Try1.mat' ; 
    case 10
        MaxSpeed = 0.35; 
        RecSaveName = 'TestQrAcqOnMotion0p35_Try2.mat' ; 
    case 11
        %MaxSpeed = 0.35; 
        error('Tambal you destroyed this record by mistake')  ; 
    case 12
        MaxSpeed = 0.4; 
        RecSaveName = 'TestQrAcqOnMotion0p4_Try3.mat' ; 
    otherwise
        error('Bad experiment number') ; 
end
% End user setup 


x = load(RecSaveName) ; 
Recs = x.Recs ; 
EncFac  = 1.329221607826457e-04 * 1.02 ; 
t = Recs.t  ;
% Show results 
figure(1) ; clf
plot( t , (Recs.UsecTimer-Recs.UsecTimer(1)) * 1e-6, t , (Recs.RawPosTStamp-Recs.UsecTimer(1))*1e-6); legend('Global time','QR relevance time'); 
figure(2) ; clf
subplot( 3,1,1) ; 
plot( Recs.t , Recs.RawSEst); legend('Length in segment');
subplot( 3,1,2) ; 
plot( Recs.t , Recs.RWheelEncPos); legend('Position (Encoder) '); 
subplot( 3,1,3) ; 
plot( Recs.t , Recs.RWheelEncSpeed); legend('Speed (Encoder) '); 
figure(3) ; clf
subplot( 2,1,1) ; 
plot( Recs.t , Recs.RawPosReport_0); legend('x reading of qr'); 
subplot( 2,1,2) ; 
plot( Recs.t , Recs.RawPosReport_1); legend('y reading of qr'); 


% Correct some junk 
Epos = EncFac* Recs.RWheelEncPos; Epos = Epos-Epos(1) + 3; 
Espeed = EncFac* Recs.RWheelEncSpeed ; 
d = find( diff(Recs.RawPosTStamp) ) + 1 ; d = d(2:end) ; 
tRawPos = Recs.RawPosTStamp(d) ;
pRawPos = -Recs.RawPosReport_0(d) /1e4;

tr1 = tRawPos( find( tRawPos < Recs.UsecTimer(1))) ; 
tr2 = tRawPos( find( tRawPos >= Recs.UsecTimer(1))) ; 

IntEncoder = [tr1*0+Epos(1) , interp1( Recs.UsecTimer ,Epos , tr2 )] ; 
IntSpeed   = [ tr1 * 0 , interp1( Recs.UsecTimer ,Espeed , tr2 )] ; 
figure(5) ; 
subplot( 4,1,1)  ;
plot(Recs.UsecTimer ,Epos , tRawPos , IntEncoder , 'x', tRawPos ,pRawPos - pRawPos(1) + IntEncoder(1) ,'o-'); 
subplot( 4,1,2)  ;
plot(Recs.UsecTimer ,Espeed , tRawPos , IntSpeed ,'x'); 
xlim = get(gca,'xlim') ; 
subplot( 4,1,3)  ;
plot( tRawPos , IntEncoder - ( pRawPos - pRawPos(1) + IntEncoder(1)) ,'o-'); 
set(gca,'xlim',xlim) ; 
subplot( 4,1,4)  ;
plot( tRawPos , (IntEncoder - ( pRawPos - pRawPos(1) + IntEncoder(1)))./ IntSpeed ,'o-'); 
set(gca,'xlim',xlim) ; 





