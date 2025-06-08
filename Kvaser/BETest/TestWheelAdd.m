WheelCanId = 12 ; 
SteerCanId = 14 ;
DataType = GetDataType();
E_SysMotionModeManual = 2 ; 
E_RefModeSpeed = 5 ; 


% Set wheel to manual 
SendObj([hex2dec('2223'),3,WheelCanId],1,DataType.long,'Ignore host CW') ;
SendObj([hex2dec('2220'),12,WheelCanId],E_SysMotionModeManual,DataType.long,'Set to manual mode') ;
motor(0,WheelCanId);


s = SGetState() ;
if ( ~s.Bit.Configured )
    SaveCfg([],'StamCfg.jsn','wheel_l',WheelCanId) ; 
    ProgCfg('StamCfg.jsn','wheel_l',WheelCanId) ; 
end


motor(1,WheelCanId); % Set the motor back to ON 
SendObj([hex2dec('2220'),14,WheelCanId],E_RefModeSpeed,DataType.long,'Ref Gen to speed') ; 

% Set steering comp
SendObj([hex2dec('2223'),9,WheelCanId],1,DataType.long) ; % Set steering compensation 

