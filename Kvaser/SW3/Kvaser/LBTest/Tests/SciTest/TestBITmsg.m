function BIT_err = TestBITmsg(msg)
%this functions checks if the BIT message received from the robot matches the ICD. 
    motion_exception_code =  msg(1:2);
    CBIT_words = msg(3:4);
    CBIT = msg(3) + msg(4)*(2^16);
    Bit = struct( 'MotorOnRw', bitget(CBIT,1), 'MotorOnLw', bitget(CBIT,2) , 'MotorOnRSteer', bitget(CBIT,3) , ...
      'MotorOnLSteer', bitget(CBIT,4) , 'MotorOnNeck', bitget(CBIT,5),'NavInitialized', bitget(CBIT,6),...
      'FaultRw', bitget(CBIT,7), 'FaultLw', bitget(CBIT,8) , 'FaultRSteer', bitget(CBIT,9) , ...
      'FaultLSteer', bitget(CBIT,10) , 'FaultNeck', bitget(CBIT,11),'QuickStop',bitget(CBIT,12),...
      'BrakeReleaseCmd', bitget(CBIT,13),'PotRefFail', bitget(CBIT,14),'IMUFail', bitget(CBIT,15),'CalibReadFail', bitget(CBIT,16),...
      'PdDataMissFail', bitget(CBIT,17),'GyroOffsetCalibrating', bitget(CBIT,18), ...
      'QueueAborted', bitget(CBIT,19),'CompromiseNavInit', bitget(CBIT,20),...
      'OnRescueMission', bitget(CBIT,21),'GyroQuatListReady', bitget(CBIT,22),...
      'QueueIsSane', bitget(CBIT,23),'SleepRequest', bitget(CBIT,24:26) );
    Mode_Info = msg(5);
    Battery_deviation_36 = bitand(msg(6),255);
    Battery_deviation_36 = typecast(uint8(Battery_deviation_36),'int8');
    Battery_deviation_54 = bitshift(msg(6),-8);
    Battery_deviation_54 = typecast(uint8(Battery_deviation_54),'int8');
    CBIT3 = msg(7);
    CBit3_bits = struct( 'ManSw1', bitget(CBIT3,1), 'ManSw2', bitget(CBIT3,2) , 'StopSw1', bitget(CBIT3,3) , ...
      'StopSw2', bitget(CBIT3,4) , 'Dyn12NetOn', bitget(CBIT3,5),'Dyn12InitDone', bitget(CBIT3,6),...
      'Dyn24NetOn', bitget(CBIT,7), 'Dyn24InitDone', bitget(CBIT,8) , 'Disc2In', bitget(CBIT,9) , ...
      'MotorOnMan', bitget(CBIT3,10:12) , 'MotorOnStop', bitget(CBIT3,13:14),'PbitDone',bitget(CBIT3,15),...
      'IndividualAxControl', bitget(CBIT3,16) );
    PdBitGen = msg(8);
    PdBitGen_bits = struct( 'SteerBrakeRelease', bitget(PdBitGen,1), 'WheelBrakeRelease', bitget(PdBitGen,2) , 'NeckBrakeRelease', bitget(PdBitGen,3) , ...
      'ShuntActive', bitget(PdBitGen,4) , 'ServoGateDriveOn', bitget(PdBitGen,5),'LaserPsSwOn', bitget(PdBitGen,6),...
      'Pump1SwOn', bitget(PdBitGen,7), 'Pump2SwOn', bitget(PdBitGen,8) , 'ChakalakaOn', bitget(PdBitGen,9) , ...
      'StopBrakeReleased', bitget(PdBitGen,10) , 'StopRelaySwOn', bitget(PdBitGen,11),'FanSwOn',bitget(PdBitGen,12),...
      'TailLampSwOn', bitget(PdBitGen,13) , 'Disc1On', bitget(PdBitGen,14), 'ServoPowerOn', bitget(PdBitGen,15), 'Reserved', bitget(PdBitGen,16) );
    
    CBIT_1_2 = msg(11) + msg(12)*(2^16);
    CBIT_1_2_Bits = struct( 'V24Fail', bitget(CBIT_1_2,1), 'V12Fail', bitget(CBIT_1_2,2) , 'MushroomDepressed', bitget(CBIT_1_2,3) , ...
      'ShuntFail', bitget(CBIT_1_2,4) , 'GripFail', bitget(CBIT_1_2,5),'ManFail', bitget(CBIT_1_2,6:8),...
      'StopFail', bitget(CBIT_1_2,9:10), 'V54Fail', bitget(CBIT_1_2,11) , 'NoSuck1', bitget(CBIT_1_2,12) , ...
      'NoSuck2Unused', bitget(CBIT_1_2,13) , 'Active12V', bitget(CBIT_1_2,14),'FailCode12V',bitget(CBIT_1_2,15:17),...
      'Active24V', bitget(CBIT_1_2,18),'FailCode24V', bitget(CBIT_1_2,19:21),'Active54V', bitget(CBIT_1_2,22),'FailCode54V', bitget(CBIT_1_2,23:25),...
      'reservred', bitget(CBIT_1_2,26:32) );

    fail_status = msg(13);
    wakeup_state = msg(14);
    system_motiom_mode = msg(15) ; 
    PS_36V = msg(16) + msg(17)*(2^16);
    PS_12V = msg(18) + msg(19)*(2^16);
    PS_24V = msg(20) + msg(21)*(2^16);
    PS_54V = msg(22) + msg(23)*(2^16);
    RW_mot_cur = msg(24);
    LW_mot_cur = msg(25);
    RS_mot_cur = msg(26);
    LS_mot_cur = msg(27);
    NeckMotorCurrent = msg(28);


    %not tested yet
    disp('blabla');
    Net24BootState = msg(9); %%not applied
    Net24BootState = msg(10); %%not applied
    %remove spares from BIT msg. later.
    

    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
end

