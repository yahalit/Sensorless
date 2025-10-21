% Make a pulsing voltage at the A/B coordinates

%                              & ClaControlPars.VoltageAddAmp, //58
%                              & ClaControlPars.VoltageAddStartA, //59
%                              & ClaControlPars.VoltageAddEndA, //60
%                              & ClaControlPars.VoltageAddStartB, //61
%                              & ClaControlPars.VoltageAddEndB  //62
PulsePars = struct('VoltageAddAmpVoltPP',0,'Tperiod',0.05,'PulseTime',0.005,'PulseShift',0.005,'VoltageAddStartA',0,'VoltageAddEndA',0,'VoltageAddStartB',0,'VoltageAddEndB',0) ; 
Ts = FetchObj([hex2dec('2000'),64],DataType.float,'Ts') ; % Get sampling time

% Frame size
PwmFrame = FetchObj([hex2dec('2220'),50],DataType.short,'PwmFrame') ; % PwmFrame

Vdc = GetSignal('Vdc') ;
if ( Vdc < 10 ) 
    error('Vdc too small') ;
end

PulsePars.VoltageAddAmp = min(PulsePars.VoltageAddAmpVoltPP / 6 /  Vdc,0.25) * PwmFrame ;

PulsePars.VoltageAddStartA = 0 ; 
PulsePars.VoltageAddEndA   = fix( PulsePars.Tperiod / Ts)  ; 
PulsePars.VoltageAddStartB = PulsePars.VoltageAddStartA + fix( PulsePars.PulseShift / Ts) ; 
PulsePars.VoltageAddEndB   = PulsePars.VoltageAddStartB + fix( PulsePars.Tperiod / Ts)  ; 


SendObj([hex2dec('2225'),58],0,DataType.float,'VoltageAddAmp') ; % Kill before transition
SendObj([hex2dec('2225'),59],PulsePars.VoltageAddStartA,DataType.float,'VoltageAddStartA') ; 
SendObj([hex2dec('2225'),60],PulsePars.VoltageAddEndA,DataType.float,'VoltageAddEndA') ; 
SendObj([hex2dec('2225'),61],PulsePars.VoltageAddStartB,DataType.float,'VoltageAddStartB') ; 
SendObj([hex2dec('2225'),62],PulsePars.VoltageAddEndB,DataType.float,'VoltageAddEndB') ; 
SendObj([hex2dec('2225'),63],PulsePars.VoltageAddCountMax,DataType.float,'VoltageAddCountMax') ; 
SendObj([hex2dec('2225'),58],PulsePars.VoltageAddAmp,DataType.float,'VoltageAddAmp') ; 

disp( ['Done: amp = ',num2str(PulsePars.VoltageAddAmp) ]);