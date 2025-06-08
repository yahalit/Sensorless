function WhatsMyProblem( s , code ) 
global RecStruct 
global DataType 
    b = s.Bit ; 
    Diagnostic = s.Diagnostic ; 
    Vpot   = Diagnostic.Vpot ; 
    MoreInfo = Diagnostic.MoreInfo; 
    WarmBit = Diagnostic.WarmBit; 
    
    WheelArmStates = MakeTableFromEnum(RecStruct.Enums.WheelArmStates) ; 
    [cfg,~,errstr] = GetRobotCfg(0); 
    if ~isempty(errstr) 
        uiwait(errordlg(["Robot is not configured correctly","User RobotCfg dialog to fix that"] ) ) ; 
        return ; 
    end
    RobotCfg = cfg ; 
    
    ManipStyleList = struct( 'None_Manipulator' , 0,'SCARA_Manipulator' , 1,'Flex_Manipulator' , 2 ) ; 
    ManipStyle     = FetchObj( [hex2dec('2220'),53] , DataType.long , 'ManipStyle' ) ; 

    
    
    Hm = Diagnostic.Hm ; 
 
    if isa(code,'string') 
        code = char(code) ; 
    end 
    if isa(code,'char') 
        code = hex2dec(code) ; 
    end
    
    CreateStruct.Interpreter = 'tex';
    CreateStruct.WindowStyle = 'modal';
    if ( code == hex2dec('713a') ) 
        % Left wheel pot misfit 
        msgbox({'\fontsize{12} After power up, the axis place is taken from the potentiometer',...
            'And is set as the encoder count',...
            'After some motion the movements in the encoder and potentiometer are compared',...
            'And if they match the axis is declared as "verified" ',...
            'Observe below that the starting potentiometr value makes sense with axis angle',...
            'And that potentiometer and encoder counts match',...
            'Bad potentiometer reading: probably bad potentiometer wiring',...
            'Deviation mismatch: If signs oppose, the potentiometer connections are reversed',...
            'If only one sensor moved the other or its wiring is probably defective'} , CreateStruct )  ;
        Hms = Hm.L; 
        disp('Left steering axis homing deviation problem:') ; 
        if ( Hms.Verified) 
            disp('Axis home verification: Done') ;
        else
            disp('Axis home verification: NOT Done') ;
        end
        disp([ 'Pot readout at zero (deg): ', num2str(Hms.ZeroPos * fac ) ]) ; 
        disp([ 'Pot readout now  (deg): ', num2str(Hms.NowPot * fac ) ]) ; 
        disp([ 'Pot movement  (deg): ', num2str( (Hms.NowPot-Hms.ZeroPos) * fac ) ]) ; 
        disp([ 'Encoder movement  (deg): ', num2str( (Hms.Encoder-Hms.ZeroPos) * fac ) ]) ; 
    end 
    
    
    if ( b.WakeupState == 2 ) 
        disp('Robot state : E_CAN_WAKEUP_SEND_CONFIG_SDO') ;
        for cnt = 1:5
            if bitget(MoreInfo,cnt) 
                disp( ['Axis ',num2str(cnt),': Programming complete']) ; 
            else
                disp( ['Axis ',num2str(cnt),': !!!!! Still Programming !!!! ']) ; 
            end
        end
        if bitget(MoreInfo,9) 
            disp(  'Robot Config succesfull read' ) ; 
        else
            disp(  '!!!  Did not read robot configuration !!!! ' ) ; 
        end 
        if bitget(MoreInfo,10) 
            disp(  'Homing done succesfully' ) ; 
        else
            disp(  '!!!  Homing not yet done , probably problem potentiometer reference voltage !!!! ' ) ; 
        end 
    end 
    if ( b.WakeupState == 5 ) 
         disp('Robot state : E_CAN_WAKEUP_PRE_OPERATIONAL') ;
         if b.MotorOnRw 
             disp('Right wheel motor: ON') ;
         else
             disp('!!!! Right wheel motor: OFF !!!!!') ;
         end
         if b.MotorOnLw 
             disp('Left wheel motor: ON') ;
         else
             disp('!!!! Left wheel motor: OFF !!!!!') ;
         end
         if b.MotorOnRSteer 
             disp('Right steer motor: ON') ;
         else
             disp('!!!! Right steer motor: OFF !!!!!') ;
         end
         if b.MotorOnLSteer 
             disp('Left steer motor: ON') ;
         else
             disp('!!!! Left steer motor: OFF !!!!!') ;
         end
         if b.MotorOnNeck 
             disp('Neck motor: ON') ;
         else
             disp('!!!! Neck motor: OFF !!!!!') ;
         end
        switch RobotCfg.WheelArmType 
            case RecStruct.Enums.WheelArmType.Rigid
                disp('Robot has No wheel arm') ; 
            otherwise % case RecStruct.Enums.WheelArmType.Wheel_Arm28
                 WaitDyn = 0; 
                 if ( ~b.Dyn12NetOn || ~b.Dyn12InitDone) 
                     WaitDyn = 1; 
                    disp(' !!!! Wheel arm RS485 network did not initialize !!!!!') ; 
                 end
                 if ( ~b.Dyn24NetOn || ~b.Dyn24InitDone) 
                     if ~(ManipStyleList.None_Manipulator == ManipStyle)
                         WaitDyn = 1; 
                        disp(' !!!! Manipulator is configured - but 24V RS485 network did not initialize !!!!!') ; 
                     end
                 end
                 WarmState = FetchObj( [hex2dec('220b'),23] , DataType.long ,'Wheel arm state') ;
                 WarmState = bitand(WarmState , 15*2^6)  / 2^6 ;
                 WarmLabelString = GetDictEntry( WheelArmStates , WarmState , 0 , 15 ) ; 
                 
                 if WaitDyn 
                     WarmLabelString = '!!!! Undetermined !!!!';
                 end 
                 
                 disp(['Wheel arm state: ',WarmLabelString] ) ; 
                 switch WarmLabelString
                     case 'E_GroundGood2Go'
                     case 'E_RExtendGood2Go'
                     case 'E_LExtendGood2Go'
                     otherwise
                         disp(['Wheel arm position incorrect'] ) ; 
                 end
            switch WarmBit.IBitState
                 
               case 0
                    disp('Wheel Arm test done') ; 
                case 1
                    disp(' !!!! Wheel Arm test stuck: Waiting Dynamixel wakeup !!!!!') ; 
                case 2 
                    disp(' !!!! (2) Wheel Arm test in wait: Waiting response from wheel arm motor !!!!!') ;   
                                        
                case 3
                    disp(' !!!! (3) Wheel Arm test in wait: Waiting response from wheel arm motor !!!!!') ; 
            end
        end
        
            
    end
    
    if ( Vpot < 2.0 || Vpot > 3.3 ) 
        disp(['Potentiometer voltage out of range: ', num2str(Vpot)]) ; 
    end
end

