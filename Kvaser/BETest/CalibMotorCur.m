% CalibMotorCur: Calibrate motor parameters = obsolete


TGenStr = struct('Gen','T','Type',RecStruct.Enums.SigRefTypes.E_S_Sine,'On',1,...
        'Dc',0,'Amp',vvec(cnt) * cos(UseAngle) ,'F',nextF,'Duty',0.5,'bAngleSpeed',0)  ;
GGenStr = struct('Gen','G','Type',RecStruct.Enums.SigRefTypes.E_S_Sine,'On',1,...
        'Dc',0,'Amp',vvec(cnt) * sin(UseAngle),'F',nextF,'Duty',0.5,'bAngleSpeed',0,'AnglePeriod',1)  ;
