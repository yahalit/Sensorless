% RecCurs Experiment to record current loop variables
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Setup the recorder 
RecTime = 3 ; 
MaxRecLen = 500 ; 


RecStruct.Sync2C = 1 ; 
RecStruct.Gap = 1; 
RecStruct.Len = 300; 

% InitRec set zero , recorder shall start automatically
% RecInitAction = struct( 'InitRec' , 0 , 'BringRec' , 0 ,'ProgRec' , 1 ,'Struct' , 1 ,'T' , RecTime ) ; 

RecInitAction = struct( 'InitRec' , 1 , 'BringRec' , 0 ,'ProgRec' , 1 ,'Struct' , 1 ,'BlockUpLoad', 0 ) ; 
RecBringAction = struct( 'InitRec' , 0 , 'BringRec' , 1 ,'ProgRec' , 0 ,'Struct' , 1 ,'BlockUpLoad', 1  ) ; 

RecNames = {'PhaseCur0','PhaseCur1','PhaseCur2','PwmA','PwmB','PwmC','vqd','ThetaElect','va','vb','vc','Iq','Id'}  ; 
%RecNames = {'PhaseCurAdc0','PhaseCurAdc1','PhaseCurAdc2','PwmA','PwmB','PwmC','vqd','ThetaElect','va','vb','vc','Iq','Id'}  ; 
%RecNames = {'Int_q','Int_d','vqd','Id','vdd','va','vb','vc','ThetaElect','PwmFac','SaturationFac4AWU','Iq', ...
%   'PwmA','PwmB','PwmC'}  ; 


L_RecStruct = RecStruct ;
L_RecStruct.BlockUpLoad = 0 ; 
[~,~,r] = Recorder(RecNames , L_RecStruct , RecInitAction   );

return 
[~,~,r] = Recorder(RecNames , L_RecStruct , RecBringAction  );
t = r.t ; 


eq = 1 - r.Iq ; 
figure(50) ; clf
plot( t , eq , t , r.Int_q, t , r.Int_d,'r', t, r.vqd, t, r.vdd)






f1 = r.vqd .* r.vqd + r.vdd .* r.vdd;
plot( t , min(r.Vsat ./sqrt(f1),1)  , 'r' , t, r.SaturationFac4AWU , 'b.') ; 


figure(40) ; clf ;


c1 = r.PhaseCur0 ; c2 = r.PhaseCur1 ; c3 = r.PhaseCur2 ;
subplot( 3,1,1); 
plot( t , c1 ,'r', t, c2 ,'g', t , c3 ,'b') ; 

subplot( 3,1,2); 
plot( t , c1 , t, c2 , t , c3 ) ; 
plot( t , c1 + c2 + c3, 'r',t , r.Iq,'g') 

subplot( 3,1,3); 
plot( t , r.ThetaElect)

figure(41) ; 
subplot( 2,1,1); 
% plot( t , r.PwmA, t , r.PwmB , t , r.PwmC )
subplot( 2,1,2); 
plot( t , r.vqd )

tht = r.ThetaElect * 2 * pi ; 
ct1 = cos( tht); 
ct2 = cos( tht+2*pi/3); 
ct3 = cos( tht+4*pi/3); 
st1 = sin( tht); 
st2 = sin( tht+2*pi/3); 
st3 = sin( tht+4*pi/3); 

figure(42) ; clf ; plot(t , r.Iq , 'rd', t , 2/3*(ct1 .* c1 + ct2 .* c2 + ct3 .* c3),'b' ) ; 
figure(47) ; clf ; plot(t , r.Id , 'rd', t , 2/3*(st1 .* c1 + st2 .* c2 + st3 .* c3),'b' ) ; 

