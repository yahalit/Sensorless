% RecCurs Experiment to record current loop variables
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Setup the recorder 
RecTime = 3 ; 
MaxRecLen = 500 ; 


RecStruct.Sync2C = 1 ; 
RecTime = 0.5 ; 
RecStruct.TrigType = 1; 
RecStruct.TrigSigName = 'bAcceleratingAsV2FState' ;
RecStruct.TrigVal = 4 ; 
%       .:   0 = immediate 
%                       1 = Up trigger 
%                       2 = Dn trigger (by recstruct.TrigVal)  

RecInitAction = struct( 'InitRec' , 1 , 'BringRec' , 0 ,'ProgRec' , 1 ,'Struct' , 1 ,'BlockUpLoad', 0,...
        'T',RecTime,'MaxLen',2000,'PreTrigPercent',50) ; 
RecBringAction = struct( 'InitRec' , 0 , 'BringRec' , 1 ,'ProgRec' , 0 ,'Struct' , 1 ,'BlockUpLoad', 1  ) ; 

RecNames = {'VarMirrorVa','VarMirrorVb','VarMirrorVc','VarMirrorIa','VarMirrorIb','VarMirrorIc','ThetaElect',...
    'StepSpeed','StepTime','SixThetaRawPU','StepSpeed','SpeedKi','SpeedKp','bAcceleratingAsV2FState'}  ; 
RecDisplay = {{'VarMirrorVa','VarMirrorVb','VarMirrorVc'},...
    {'VarMirrorIa','VarMirrorIb','VarMirrorIc'},{'SixThetaRawPU'},...
    {'StepSpeed'},{'SpeedKi','SpeedKp'},{'bAcceleratingAsV2FState'}};
%RecNames = {'PhaseCurAdc0','PhaseCurAdc1','PhaseCurAdc2','PwmA','PwmB','PwmC','vqd','ThetaElect','va','vb','vc','Iq','Id'}  ; 
%RecNames = {'Int_q','Int_d','vqd','Id','vdd','va','vb','vc','ThetaElect','PwmFac','SaturationFac4AWU','Iq', ...
%   'PwmA','PwmB','PwmC'}  ; 


L_RecStruct = RecStruct ;
L_RecStruct.BlockUpLoad = 0 ; 
[~,~,~] = Recorder(RecNames , L_RecStruct , RecInitAction   );

return 
pause( RecTime) ;
[~,~,r] = Recorder(RecNames , L_RecStruct , RecBringAction  ); 

 DrawRecs(r,10,RecDisplay,[0.24,0.27]) ;
save RecSixStep_20OpenLoop2KpKi.mat r 




