classdef TrayBIT_exported < matlab.apps.AppBase

    % Properties that correspond to app components
    properties (Access = public)
        UIFigure                       matlab.ui.Figure
        ModeFault                      matlab.ui.control.Lamp
        EefSyncEnButton_2              matlab.ui.control.Button
        WakeupStateEditField           matlab.ui.control.EditField
        RefmodeLabel_5                 matlab.ui.control.Label
        EefSyncEnLamp                  matlab.ui.control.Lamp
        EefSyncEnButton                matlab.ui.control.Button
        LogTextArea                    matlab.ui.control.TextArea
        LogTextAreaLabel               matlab.ui.control.Label
        ClearDetailButton              matlab.ui.control.Button
        AutoManipControlLamp           matlab.ui.control.Lamp
        AutoManipControlButton         matlab.ui.control.Button
        IndividualAxisControlLamp      matlab.ui.control.Lamp
        IndividualAxisControlBotton    matlab.ui.control.Button
        EEFAutoGripEnableLamp          matlab.ui.control.Lamp
        EEFAutoGripEnableButton        matlab.ui.control.Button
        OverRideSwitchesLamp           matlab.ui.control.Lamp
        ManualActivationButton         matlab.ui.control.Button
        EEFElementsStatePanel          matlab.ui.container.Panel
        PackageDistTextArea            matlab.ui.control.TextArea
        LaserMedianmTextAreaLabel_2    matlab.ui.control.Label
        LaserCalibBotton_2             matlab.ui.control.Button
        LaserCalibrationMode           matlab.ui.control.Lamp
        LaserCalibBotton               matlab.ui.control.Button
        LaserMedianmTextArea           matlab.ui.control.TextArea
        LaserMedianmTextAreaLabel      matlab.ui.control.Label
        LedOnButton                    matlab.ui.control.Button
        LedOnLamp                      matlab.ui.control.Lamp
        LaserOnBotton                  matlab.ui.control.Button
        LaserOnLamp                    matlab.ui.control.Lamp
        LaserMedianFailedLamp          matlab.ui.control.Lamp
        LasermedianfailedLampLabel     matlab.ui.control.Label
        LaserMedianValidLamp           matlab.ui.control.Lamp
        LaserMedianValidLabel          matlab.ui.control.Label
        EefTabGroup                    matlab.ui.container.TabGroup
        EEFAutoTab_2                   matlab.ui.container.Tab
        PumpGripLamp                   matlab.ui.control.Lamp
        PumpsGripActivationButton      matlab.ui.control.Button
        DoNotLookForPackageCheckBox    matlab.ui.control.CheckBox
        DoNotTestSuctionCheckBox       matlab.ui.control.CheckBox
        PumpsOnLamp                    matlab.ui.control.Lamp
        PumpsonLampLabel               matlab.ui.control.Label
        ReleaseErrorLamp               matlab.ui.control.Lamp
        ReleaseErrorLampLabel          matlab.ui.control.Label
        GripErrorLamp                  matlab.ui.control.Lamp
        WaitingForReleaseLabel_2       matlab.ui.control.Label
        FullyreleasedLamp              matlab.ui.control.Lamp
        FullyreleasedLabel             matlab.ui.control.Label
        WaitingForReleaseLamp          matlab.ui.control.Lamp
        WaitingForReleaseLabel         matlab.ui.control.Label
        FullyGrippedLamp               matlab.ui.control.Lamp
        FullyGrippedLabel              matlab.ui.control.Label
        WaitingForFullGripLamp         matlab.ui.control.Lamp
        WaitingForFullGripLabel        matlab.ui.control.Label
        WaitingForInitialGripLamp      matlab.ui.control.Lamp
        WaitingForInitialGripLabel     matlab.ui.control.Label
        EEFManualTab                   matlab.ui.container.Tab
        PumpsOnLamp2                   matlab.ui.control.Lamp
        PumpsOnButton                  matlab.ui.control.Button
        ErrordetailButton              matlab.ui.control.Button
        CancelButton                   matlab.ui.control.Button
        NextstepButton                 matlab.ui.control.Button
        ProblemsTextArea               matlab.ui.control.TextArea
        ProblemsTextAreaLabel          matlab.ui.control.Label
        InstructionsTextArea           matlab.ui.control.TextArea
        InstructionsTextAreaLabel      matlab.ui.control.Label
        TabGroup                       matlab.ui.container.TabGroup
        AutoManipulatorControlTab      matlab.ui.container.Tab
        Panel                          matlab.ui.container.Panel
        PosturefixtolegalButton        matlab.ui.control.Button
        KillHomingButton               matlab.ui.control.Button
        OnRailsCheckBox_2              matlab.ui.control.CheckBox
        DoHomingButton                 matlab.ui.control.Button
        HomedLamp                      matlab.ui.control.Lamp
        GotoStandByButton              matlab.ui.control.Button
        GoToPosturePanel               matlab.ui.container.Panel
        XPosition                      matlab.ui.control.Label
        XpositionLabel                 matlab.ui.control.Label
        AngledegLabel                  matlab.ui.control.Label
        AnglePosition                  matlab.ui.control.Label
        YPosition                      matlab.ui.control.Label
        YpositionLabel                 matlab.ui.control.Label
        CurrentPosButton_3             matlab.ui.control.Button
        CurrentPosButton_2             matlab.ui.control.Button
        CurrentPosButton               matlab.ui.control.Button
        TapeposmLabel                  matlab.ui.control.Label
        ShifterPositiontargetLabel_3   matlab.ui.control.Label
        PlatePosTarger_3               matlab.ui.control.Label
        ShifterCurrentPos_2            matlab.ui.control.Label
        PlateCurrentPosDeg_2           matlab.ui.control.Label
        TapeCurrentPos_2               matlab.ui.control.Label
        OnRailsCheckBox                matlab.ui.control.CheckBox
        ShelfPosButton_2               matlab.ui.control.Button
        StByPosButton_3                matlab.ui.control.Button
        RotatePosButton_2              matlab.ui.control.Button
        SettapeStByPosButton           matlab.ui.control.Button
        ShifterTarget_2                matlab.ui.control.NumericEditField
        ShifterPositiontargetLabel_2   matlab.ui.control.Label
        PlaceTargetDeg_2               matlab.ui.control.NumericEditField
        PlatePosTarger_2               matlab.ui.control.Label
        TapeTarget_2                   matlab.ui.control.NumericEditField
        TapetargetmLabel               matlab.ui.control.Label
        GotopostureButton              matlab.ui.control.Button
        SystemmodeAutomaticLabel       matlab.ui.control.Label
        SySModeStayLamp                matlab.ui.control.Lamp
        SySModeStayBotton              matlab.ui.control.Button
        SySModeAutoLamp                matlab.ui.control.Lamp
        systemModeTextArea             matlab.ui.control.EditField
        RefmodeLabel_4                 matlab.ui.control.Label
        SySModeAutoIdleLamp            matlab.ui.control.Lamp
        SySModeAutoIdleButton          matlab.ui.control.Button
        DealPackagePanel               matlab.ui.container.Panel
        NeckPutTargetDeg               matlab.ui.control.NumericEditField
        NeckPutPosTarger               matlab.ui.control.Label
        NeckGetTargetDeg               matlab.ui.control.NumericEditField
        NeckGetPosTarger               matlab.ui.control.Label
        DoNotLookForPackageCheckBox_2  matlab.ui.control.CheckBox
        DoNotTestSuctionCheckBox_2     matlab.ui.control.CheckBox
        GetPackageSwitch               matlab.ui.control.Switch
        DistancefromRobotValueEditField  matlab.ui.control.NumericEditField
        DistancefromRobotCentermabsvalueLabel  matlab.ui.control.Label
        SideSwitch                     matlab.ui.control.Switch
        DealPackageButton              matlab.ui.control.Button
        AxesIndividualControlTab       matlab.ui.container.Tab
        NeckControlPanel               matlab.ui.container.Panel
        HomedLabel_4                   matlab.ui.control.Label
        NeckGrantControlLamp           matlab.ui.control.Lamp
        SetCurrentPosButton            matlab.ui.control.Button
        GoNeck                         matlab.ui.control.Button
        NeckControlLamp                matlab.ui.control.Lamp
        RemoteControlButton            matlab.ui.control.Button
        PlatePosTarger_4               matlab.ui.control.Label
        NeckAngleText                  matlab.ui.control.Label
        NeckSetTargetDeg               matlab.ui.control.NumericEditField
        NeckGetPosTarger_2             matlab.ui.control.Label
        ShifterPanel                   matlab.ui.container.Panel
        SpacerHomeEditField            matlab.ui.control.NumericEditField
        SpacerHomeDirButton            matlab.ui.control.Button
        SpacerRefModeEditField         matlab.ui.control.EditField
        RefmodeLabel                   matlab.ui.control.Label
        SpacerLCmodeEditField          matlab.ui.control.EditField
        LCmodeEditFieldLabel           matlab.ui.control.Label
        LampShifterSpeedRefMode        matlab.ui.control.Lamp
        ShifterSpeedRefModeButton      matlab.ui.control.Button
        LampShifterPTPRefMode          matlab.ui.control.Lamp
        ShifterPTPRefModeButton        matlab.ui.control.Button
        TextErrorShifter               matlab.ui.control.Label
        ErrorcodeLabel_3               matlab.ui.control.Label
        ShifterCurrentPos              matlab.ui.control.Label
        PositionmLabel_2               matlab.ui.control.Label
        HomedLabel                     matlab.ui.control.Label
        ShifterhomedLamp               matlab.ui.control.Lamp
        LampShifterOn                  matlab.ui.control.Lamp
        ShifterMotorOnButton           matlab.ui.control.Button
        ShelfPosButton                 matlab.ui.control.Button
        StByPosButton                  matlab.ui.control.Button
        RotatePosButton                matlab.ui.control.Button
        ShifterTarget                  matlab.ui.control.NumericEditField
        SpacerKillHomingButton         matlab.ui.control.Button
        EditFieldSpacerHome            matlab.ui.control.NumericEditField
        ShifterAutomaticHomeButton     matlab.ui.control.Button
        ShifterSethomeButton           matlab.ui.control.Button
        ImmediateHomevaluemLabel_2     matlab.ui.control.Label
        ShifterGoButton                matlab.ui.control.Button
        ShifterPositiontargetLabel     matlab.ui.control.Label
        PlatePanel                     matlab.ui.container.Panel
        LampPlateMotorBrakeReleasedOn  matlab.ui.control.Lamp
        PlateMotorBrakeReleaseButton   matlab.ui.control.Button
        PlateRefModeEditField          matlab.ui.control.EditField
        RefmodeLabel_3                 matlab.ui.control.Label
        PlateLCmodeEditField           matlab.ui.control.EditField
        LCmodeEditField_2Label         matlab.ui.control.Label
        LampPlateSpeedRefMode          matlab.ui.control.Lamp
        PlateSpeedRefModeButton        matlab.ui.control.Button
        LampPlatePTPRefMode            matlab.ui.control.Lamp
        PlatePTPRefModeButton          matlab.ui.control.Button
        HomedLabel_2                   matlab.ui.control.Label
        PlateHomedLamp                 matlab.ui.control.Lamp
        PlaceTargetDeg                 matlab.ui.control.NumericEditField
        TextErrorPlate                 matlab.ui.control.Label
        ErrorcodeLabel_2               matlab.ui.control.Label
        LampPlateOn                    matlab.ui.control.Lamp
        PlateCalibrateButton           matlab.ui.control.Button
        PlateMotorOnButton             matlab.ui.control.Button
        PlateGoButton                  matlab.ui.control.Button
        PlatePosTarger                 matlab.ui.control.Label
        PlateCurrentPosDeg             matlab.ui.control.Label
        PositionDegLabel               matlab.ui.control.Label
        TapePanel_2                    matlab.ui.container.Panel
        LampTapeMotorBrakeReleasedOn   matlab.ui.control.Lamp
        TapeMotorBrakeReleasedBotton   matlab.ui.control.Button
        StByPosButton_2                matlab.ui.control.Button
        TapeRefModeEditField           matlab.ui.control.EditField
        RefmodeLabel_2                 matlab.ui.control.Label
        TapeLCmodeEditField            matlab.ui.control.EditField
        LCmodeEditField_3Label         matlab.ui.control.Label
        LampTapeSpeedRefMode           matlab.ui.control.Lamp
        TapeSpeedRefModeButton         matlab.ui.control.Button
        LampTapePTPRefMode             matlab.ui.control.Lamp
        TapePTPRefModeButton           matlab.ui.control.Button
        ErrorcodeLabel                 matlab.ui.control.Label
        TextErrorTape                  matlab.ui.control.Label
        HomedLabel_3                   matlab.ui.control.Label
        TapehomedLamp                  matlab.ui.control.Lamp
        TapeTarget                     matlab.ui.control.NumericEditField
        TapeKillHomeButton             matlab.ui.control.Button
        LampTapeOn                     matlab.ui.control.Lamp
        EditFieldTapeHome              matlab.ui.control.NumericEditField
        TapeAutomaticHomeButton        matlab.ui.control.Button
        TapeSethomeButton              matlab.ui.control.Button
        ImmediateHomevaluemLabel       matlab.ui.control.Label
        TapeMotorOnButton              matlab.ui.control.Button
        TapeGo                         matlab.ui.control.Button
        TapeRobotCsCheckBox            matlab.ui.control.CheckBox
        PositiontargetmLabel           matlab.ui.control.Label
        TapeCurrentPos                 matlab.ui.control.Label
        PositionmLabel                 matlab.ui.control.Label
        ParametersTab                  matlab.ui.container.Tab
        IndividualAxisControlBotton_2  matlab.ui.control.Button
        UITable                        matlab.ui.control.Table
        FlexManipulatordashboardLabel  matlab.ui.control.Label
    end

    
    properties (Access = private)
        EvtObj % Description
        DataType % Description
        ManStat  % Description
        s % Description
        IndividualSet % Description
        CanId % Description
        Edata % Description  
        DrvErrors % Description
        %Target % Description
        LogicId  % Description
        InPlateCalib % Description
        PushActionDone % Description
        PushForComplete % Description
        EdataOnStart % Description
        Handles % Description
        ControlWordCopy % Description
        Package % Description
        AutomaticMode % Description
        DoNotTestSuction % Description
        DoNotLookForPackage % Description
        LedOnState % Description
        LaserOnState % Description
        OverRideSwitchesSet % Description
        PackageGripByODModeSet % Description
        CwOwnerSet % Description
        Block % Description
        ManGeo % Description
        Core2ExceptionList % Description
        constants % Description
        SpacerHomingDirection % Description
        version % Description
    end
    
    properties (Access = public)
    end
    
    methods (Access = private)
        
        function SetText(~, ctrl , str , bgColor, fgColor , enable )
            if nargin < 6 
                enable = 1 ; 
            end 
            if isa(str,'double')
                set( ctrl , 'Text' , num2str(str) ) ; %sprintf('%.3f',str)
            else
                set( ctrl , 'Text' , str ) ; 
            end
            if nargin > 3 
                set( ctrl , 'Backgroundcolor' , bgColor ) ; 
                set( ctrl , 'Fontcolor' , fgColor ) ; 
                set( ctrl , 'Enable' , enable ) ; 
            end
        end


        
        % function SetIndividual(app, IndividualFlag) % IndividualFlag is after the change!
        % 
        %     if ( IndividualFlag )  % currently not individaul, turn on individual, Set the motors off
        %         SendObj( [hex2dec('0x2508'),7,app.CanId(2)] , 1023 , GetDataType('long') , 'Set manipulator to individual motor mode: motor off ' ) ;
        %         %SetText (app , app.TapeMotorOnButton ,'Motor Off', [0.96 0.96 0.96], [0,0,0]) ; 
        %         %SetText (app , app.PlateMotorOnButton ,'Motor Off', [0.96 0.96 0.96], [0,0,0]) ; 
        %         %SetText (app , app.ShifterMotorOnButton ,'Motor Off', [0.96 0.96 0.96], [0,0,0]) ; 
        %     else   % currently individaul, Exit individual mode, Set the motors off
        %         SendObj( [hex2dec('0x2508'),8,app.CanId(2)] , 1023 , GetDataType('long') , 'Set manipulator to individual motor mode: motor off ' ) ;
        %         %SetText (app , app.TapeMotorOnButton ,'Motor Off', [0.96 0.96 0.96], [0,0,0],0) ; 
        %         %SetText (app , app.PlateMotorOnButton ,'Motor Off', [0.96 0.96 0.96], [0,0,0],0) ; 
        %         %SetText (app , app.ShifterMotorOnButton ,'Motor Off', [0.96 0.96 0.96], [0,0,0],0) ; 
        %     end
        % 
        % end
        
        function update_display(app,~,~)
            % This function does not communicate status by itself, it depends in BIT reading the status continually 

            if app.Block 
                return 
            end 
            try 
                update_displayBody(app); 
            catch 
            end
        end


        function update_displayBody(app)
            
            app.s = LocalGetState(app) ; 
            app.Edata = GetExtData(app); 

            EnableControl(app,app.TapeGo,app.Edata.Individual)  ; 
            EnableControl(app,app.TapeMotorOnButton,app.Edata.Individual)  ; 
            EnableControl(app,app.RemoteControlButton,app.Edata.Individual)  ; 
            EnableControl(app,app.NeckSetTargetDeg,app.Edata.Individual)  ; 
            %EnableControl(app,app.TapeSethomeButton,app.Edata.Individual)  ; 
            EnableControl(app,app.TapeAutomaticHomeButton,app.Edata.Individual)  ; 
            EnableControl(app,app.TapeGo,app.Edata.Individual && (app.Edata.TapeArmOn || app.Edata.TapeArmReady))  ; 
            EnableControl(app,app.GoNeck,app.Edata.Individual && app.Edata.NeckWheelsControlBit)  ; 

            EnableControl(app,app.PlateGoButton ,app.Edata.Individual && (app.Edata.PlateOn && app.Edata.PlateReady) )  ; 
            EnableControl(app,app.PlateMotorOnButton ,app.Edata.Individual)  ; 
            EnableControl(app,app.PlateCalibrateButton ,app.Edata.Individual)  ; 
            EnableControl(app,app.ShifterGoButton ,app.Edata.Individual && (app.Edata.SpacerOn || app.Edata.SpacerReady) )  ; 
            EnableControl(app,app.ShifterMotorOnButton ,app.Edata.Individual )  ; 
            %EnableControl(app,app.ShifterSethomeButton ,app.Edata.Individual)  ; 
            EnableControl(app,app.TapeKillHomeButton ,app.Edata.Individual )  ; 
            EnableControl(app,app.SpacerKillHomingButton ,app.Edata.Individual)  ; 
            EnableControl(app,app.TapeRobotCsCheckBox ,app.Edata.Individual)  ; 

            EnableControl(app,app.TapePTPRefModeButton ,app.Edata.Individual)  ; 
            EnableControl(app,app.TapeSpeedRefModeButton ,app.Edata.Individual)  ; 
            EnableControl(app,app.PlatePTPRefModeButton ,app.Edata.Individual)  ; 
            EnableControl(app,app.PlateSpeedRefModeButton ,app.Edata.Individual)  ; 
            EnableControl(app,app.ShifterPTPRefModeButton ,app.Edata.Individual)  ; 
            EnableControl(app,app.ShifterSpeedRefModeButton ,app.Edata.Individual)  ; 
            EnableControl(app,app.SpacerHomeDirButton ,app.Edata.Individual)  ; 


            EnableControl(app,app.TapeAutomaticHomeButton ,app.Edata.Individual && (app.Edata.TapeArmOn || app.Edata.TapeArmReady) )  ; 
            EnableControl(app,app.ShifterAutomaticHomeButton ,app.Edata.Individual && (app.Edata.SpacerOn || app.Edata.SpacerReady) )  ; 
            EnableControl(app,app.PlateCalibrateButton ,app.Edata.Individual && (app.Edata.PlateOn && app.Edata.PlateReady))  ; 

            EnableControl(app,app.TapeMotorBrakeReleasedBotton ,app.Edata.Individual && (~app.Edata.TapeArmOn && ~app.Edata.TapeArmReady) )  ; 
            EnableControl(app,app.PlateMotorBrakeReleaseButton ,app.Edata.Individual && (~app.Edata.PlateOn && ~app.Edata.PlateReady) )  ; 

            EnableControl(app, app.DistancefromRobotValueEditField ,~app.Edata.CwOwner)  ; 
            EnableControl(app, app.NeckGetTargetDeg ,~app.Edata.CwOwner)  ; 
            EnableControl(app, app.NeckPutTargetDeg ,~app.Edata.CwOwner)  ; 
            EnableControl(app, app.DealPackageButton ,~app.Edata.CwOwner)  ; 
            EnableControl(app, app.GetPackageSwitch ,~app.Edata.CwOwner)  ;  
            EnableControl(app, app.SideSwitch ,~app.Edata.CwOwner)  ;  
            EnableControl(app, app.DoHomingButton ,~app.Edata.CwOwner && ((app.Edata.SystemMode == 9)||(app.Edata.SystemMode == 2)))  ;  
            EnableControl(app, app.SySModeAutoIdleButton ,~app.Edata.CwOwner)  ;  
            EnableControl(app, app.GotoStandByButton ,~app.Edata.CwOwner && (app.Edata.SystemMode == 9))  ;
            EnableControl(app, app.PosturefixtolegalButton ,~app.Edata.CwOwner && (app.Edata.SystemMode == 9))  ;
            EnableControl(app, app.SySModeStayBotton ,~app.Edata.CwOwner)  ;

            EnableControl(app,app.PumpsGripActivationButton ,app.Edata.PackageGripByODMode) ; 
            EnableControl(app,app.DoNotTestSuctionCheckBox ,app.Edata.PackageGripByODMode) ; 
            EnableControl(app,app.DoNotLookForPackageCheckBox ,app.Edata.PackageGripByODMode) ; 

            EnableControl(app,app.LaserOnBotton, app.Edata.PackageGripByODMode || app.Edata.OverRideSwitches);
            EnableControl(app,app.LedOnButton, app.Edata.PackageGripByODMode || app.Edata.OverRideSwitches);
            EnableControl(app,app.LaserCalibBotton, app.Edata.PackageGripByODMode || app.Edata.OverRideSwitches);
            EnableControl(app,app.LaserCalibBotton_2, app.Edata.PackageGripByODMode || app.Edata.OverRideSwitches);

            EnableControl(app,app.PumpsOnButton ,app.Edata.OverRideSwitches) ; 

            EnableControl(app, app.EefSyncEnButton ,~app.Edata.EefSyncEnBit) ; %if EEF enabled then the button is disabled to avoid misuse.

            EnableControl(app,app.ShifterTarget_2 ,~app.OnRailsCheckBox.Value) ;
            %EnableControl(app, app.GoToPosturePanel , app.Edata.SystemMode == 9);
            EnableControl(app, app.GotopostureButton , app.Edata.SystemMode == 9);
            %EnableControl(app, app.DealPackagePanel , app.Edata.SystemMode == 9);
            %EnableControl(app, app.DealPackageButton , app.Edata.SystemMode == 9 && ~app.Edata.CwOwner && ~app.Edata.PackageGripByODMode && ~app.Edata.OverRideSwitches);

            ButtonAndLampLogical(app,app.TapeMotorOnButton, app.LampTapeOn, app.Edata.TapeArmOn || app.Edata.TapeArmReady );
            ButtonAndLampLogical(app,app.PlateMotorOnButton, app.LampPlateOn, app.Edata.PlateOn || app.Edata.PlateReady);
            ButtonAndLampLogical(app,app.ShifterMotorOnButton, app.LampShifterOn, app.Edata.SpacerOn || app.Edata.SpacerReady);

            ButtonAndLampLogical(app,app.TapeMotorBrakeReleasedBotton, app.LampTapeMotorBrakeReleasedOn, app.Edata.TapeArmBrakeReleased );
            ButtonAndLampLogical(app,app.PlateMotorBrakeReleaseButton, app.LampPlateMotorBrakeReleasedOn, app.Edata.PlateBrakeReleased );

            ButtonAndLampLogical(app, app.LedOnButton , app.LedOnLamp , app.Edata.LedOn);
            ButtonAndLampLogical(app, app.LaserOnBotton , app.LaserOnLamp , app.Edata.LaserOn);
            ButtonAndLampLogical(app, app.LaserCalibBotton , app.LaserCalibrationMode , app.Edata.LaserCalibOn);

            ButtonAndLampLogical(app, app.PumpsGripActivationButton , app.PumpGripLamp , app.Edata.EEFPackageGripActivated);

            %Activation statuses
            ButtonAndLampLogical(app, app.IndividualAxisControlBotton , app.IndividualAxisControlLamp , app.Edata.Individual);
            ButtonAndLampLogical(app, app.AutoManipControlButton , app.AutoManipControlLamp , ~app.Edata.CwOwner);
            ButtonAndLampLogical(app, app.ManualActivationButton , app.OverRideSwitchesLamp , app.Edata.OverRideSwitches);            
            ButtonAndLampLogical(app, app.EEFAutoGripEnableButton , app.EEFAutoGripEnableLamp , app.Edata.PackageGripByODMode );

            ButtonAndLampLogical(app, app.EefSyncEnButton , app.EefSyncEnLamp , app.Edata.EefSyncEnBit );

            ButtonAndLampLogical(app,app.SySModeAutoIdleButton , app.SySModeAutoIdleLamp , app.Edata.SystemMode == 9); %E_SysMotionModeAutomaticIdle = 9 

            if (app.Edata.SystemMode == 10) 
                app.SySModeAutoIdleButton.BackgroundColor = [1.0, 0.1, 0.1]; %red
            else
                app.SySModeAutoIdleButton.BackgroundColor = [0.9608 0.9608 0.9608]; %gray
            end
            ButtonAndLampLogical(app,app.SySModeStayBotton , app.SySModeStayLamp , app.Edata.SystemMode == 2); %E_SysMotionModeStay = 2
            UpdateLamp(app, app.SySModeAutoLamp , app.Edata.SystemMode == 10); %E_SysMotionModeAutomatic = 10

            SetAxisErrorCode( app , app.TextErrorTape, app.Edata.TapeArmFault) ; 
            SetAxisErrorCode( app , app.TextErrorPlate, app.Edata.PlateFault) ; 
            SetAxisErrorCode( app , app.TextErrorShifter, app.Edata.SpacerFault) ; 

            UpdateLamp(app, app.TapehomedLamp , app.Edata.TapeArmHomed);
            UpdateLamp(app, app.PlateHomedLamp , app.Edata.PlateHomed);
            UpdateLamp(app, app.ShifterhomedLamp , app.Edata.SpacerHomed);
            UpdateLamp(app, app.HomedLamp , logical(app.Edata.AxesHomed)); 

            UpdateLamp(app, app.LampTapePTPRefMode , app.Edata.TapeReferenceMode==3); %E_PosModePTP = 3
            UpdateLamp(app, app.LampPlatePTPRefMode , app.Edata.PlateReferenceMode==3); %E_PosModePTP = 3
            UpdateLamp(app, app.LampShifterPTPRefMode , app.Edata.ShifterReferenceMode==3); %E_PosModePTP = 3

            UpdateLamp(app, app.LampTapeSpeedRefMode , app.Edata.TapeReferenceMode==5); %E_RefModeSpeed = 5
            UpdateLamp(app, app.LampPlateSpeedRefMode , app.Edata.PlateReferenceMode==5); %E_RefModeSpeed = 5
            UpdateLamp(app, app.LampShifterSpeedRefMode , app.Edata.ShifterReferenceMode==5); %E_RefModeSpeed = 5

%TapeLCMode, TapeReferenceMode, PlateLCMode, PlateReferenceMode, ShifterLCMode, ShifterReferenceMode 

            UpdateLamp(app, app.LaserMedianValidLamp , logical(app.Edata.LaserMedianValid));     
            UpdateLamp(app, app.LaserMedianFailedLamp , logical(app.Edata.LaserMedianFailed));     
            UpdateLamp(app, app.LedOnLamp , app.Edata.LedOn); 
            UpdateLamp(app, app.LaserOnLamp , app.Edata.LaserOn); 
            UpdateLamp(app, app.PumpsOnLamp , app.Edata.PumpsOn); 

            UpdateLamp(app, app.PumpsOnLamp2 , app.Edata.PumpsOn); 

            UpdateLamp(app, app.WaitingForInitialGripLamp , app.Edata.WaitingForInitialGrip);
            UpdateLamp(app, app.WaitingForFullGripLamp , app.Edata.WaitingForFullGrip);
            UpdateLamp(app, app.FullyGrippedLamp , app.Edata.FullyGripped);
            UpdateLamp(app, app.WaitingForReleaseLamp , app.Edata.WaitingForRelease);
            UpdateLamp(app, app.FullyreleasedLamp , app.Edata.Fullyreleased);
            UpdateLamp(app, app.GripErrorLamp , app.Edata.GripError);
            UpdateLamp(app, app.ReleaseErrorLamp , app.Edata.ReleaseError);

            UpdateLamp(app,app.ModeFault , app.Edata.SystemMode >= -1); %E_SysMotionModeAutomaticIdle = 9 
            
            UpdateLamp(app, app.NeckControlLamp , app.Edata.NeckWheelsControlBit);

            UpdateLamp(app, app.NeckGrantControlLamp , app.Edata.NeckGrantControl); 
            
            app.TapeLCmodeEditField.Value = num2str(app.Edata.TapeLCMode);
            app.PlateLCmodeEditField.Value = num2str(app.Edata.PlateLCMode);
            app.SpacerLCmodeEditField.Value = num2str(app.Edata.ShifterLCMode);
            app.TapeRefModeEditField.Value = num2str(app.Edata.TapeReferenceMode);
            app.PlateRefModeEditField.Value = num2str(app.Edata.PlateReferenceMode);
            app.SpacerRefModeEditField.Value = num2str(app.Edata.ShifterReferenceMode);

            app.XPosition.Text = sprintf('%.3f',app.Edata.ManipXPos );
            app.YPosition.Text = sprintf('%.3f', app.Edata.ManipYPos );
            app.AnglePosition.Text = sprintf('%.3f', app.Edata.ManipThetaAngle );

            if logical(app.Edata.TapeArmFault) ||  logical(app.Edata.PlateFault) || logical(app.Edata.SpacerFault) 
                app.ErrordetailButton.BackgroundColor = [249, 168, 37] / 256 ; 
            else
                app.ErrordetailButton.BackgroundColor = [238, 238, 238] / 256 ; 
            end 

            % SetText(app, app.TapeCurrentPos , app.Edata.FlexPos ); 
            % SetText(app, app.PlateCurrentPosDeg , app.Edata.RotaryDeg ); 
            % SetText(app, app.ShifterCurrentPos , app.Edata.SpacerPos ); 
            % 
            % SetText(app, app.TapeCurrentPos_2 , app.Edata.FlexPos ); 
            % SetText(app, app.PlateCurrentPosDeg_2 , app.Edata.RotaryDeg ); 
            % SetText(app, app.ShifterCurrentPos_2 , app.Edata.SpacerPos ); 


            app.TapeCurrentPos.Text = sprintf('%.3f',app.Edata.FlexPos);
            app.PlateCurrentPosDeg.Text = sprintf('%.1f',app.Edata.RotaryDeg);
            app.ShifterCurrentPos.Text = sprintf('%.3f',app.Edata.SpacerPos);

            app.TapeCurrentPos_2.Text = sprintf('%.3f',app.Edata.FlexPos);
            app.PlateCurrentPosDeg_2.Text = sprintf('%.1f',app.Edata.RotaryDeg);
            app.ShifterCurrentPos_2.Text = sprintf('%.3f',app.Edata.SpacerPos);

            app.NeckAngleText.Text = sprintf('%.3f',app.Edata.NeckAngle);

            app.LaserMedianmTextArea.Value = num2str(app.Edata.LaserMedian) ;
            if app.Edata.PackageDist>=0
                app.PackageDistTextArea.Value = num2str(app.Edata.PackageDist) ; 
            else
                app.PackageDistTextArea.Value = num2str(0) ; 
            end

            app.SpacerHomeEditField.Value = app.Edata.ShifterHomeDiretion;   
            app.EditFieldSpacerHome.Value =  app.Edata.ShifterHomeValue;
            app.EditFieldTapeHome.Value = app.Edata.TapeHomeValue;

            %str = sprintf('%s\n%s\n%s\n%s\n' , num2str(app.Core2ExceptionList{1}), num2str(app.Core2ExceptionList{2}), num2str(app.Core2ExceptionList{3}), num2str(app.Core2ExceptionList{4}) );
            str = sprintf('%s\n%s\n%s\n%s\n%s\n%s\n%s\n' , app.Core2ExceptionList{1}, app.Core2ExceptionList{2},...
                                                           app.Core2ExceptionList{3}, app.Core2ExceptionList{4},...
                                                           app.Core2ExceptionList{5}, app.Core2ExceptionList{6}, app.Core2ExceptionList{7} );

            FoundDriveRrrors = 0;
            for i=1:7
                if contains(app.Core2ExceptionList{i}, 'axis_registered_a_fault') 
                    FoundDriveRrrors = 1;
                end
            end

            if FoundDriveRrrors==1
                ErrordetailButtonPushedBody(app);
                app.ProblemsTextArea.FontColor = 'red';
            else
                app.ProblemsTextArea.FontColor = 'black';
            end

            app.LogTextArea.Value = str;
            app.WakeupStateEditField.Value = num2str(app.Edata.WakeupState);
            if str2num(app.WakeupStateEditField.Value)==15;
                app.WakeupStateEditField.BackgroundColor = 'red';
            else
                app.WakeupStateEditField.BackgroundColor = 'cyan';
            end
            app.systemModeTextArea.Value = num2str(app.Edata.SystemMode);
            
            %TODO:
            %SetText(app, app.XPosition , app.s.Manip.ManX); 
            %SetText(app, app.YPosition , app.s.Manip.ManY); 
            %SetText(app, app.AnglePosition * 180 / pi , app.s.Manip.ManTht); 

            if app.InPlateCalib 
                app.PlateCalibrateButton.Enable = 'off' ; 
                app.CalibStateMachine() ; 
            else
                app.PlateCalibrateButton.Enable = 'on' ; 
            end
            
            %SendObj( [hex2dec('2508'),13,app.CanId(2)] , app.Edata.ShifterHomeDiretion , GetDataType('long') , 'set Homing direction' ) ;%set Homing direction
           
            %TODO:FUTURE update to LP values
	        %if ( app.UseCase.HomeDirection < 0 )
		    %    app.HomepositionEditField.Value = FetchObj([hex2dec('2225'),13],app.DataType.float,'User home position FW') ;
	        %else
		    %    app.HomepositionEditField.Value = FetchObj([hex2dec('2225'),14],app.DataType.float,'User home position Reverse') ;
            %end
        end



        
        
        function s = LocalGetState(~)
            s = GetState('Map') ; 
        end
        
        function EnableControl(~,control,value)
            if logical(value) 
                set(control,'Enable','on') ; 
            else
                set(control,'Enable','off') ; 
            end
        end

        function ButtonAndLamp(~,button,lamp,state)
            switch state 
                case -1
                    %set(button,'Text','Reset Error','Backgroundcolor',[1,0,0],'Fontcolor',[1,1,1] ); 
                    set(lamp,'Color','yellow'); 
                case 0
                    %set(button,'Text','Set Motor On','Backgroundcolor',[0,1,1],'Fontcolor',[0,0,1] ); 
                    %set(lamp,'Color',[0,0,1]); 
                    set(lamp,'Color','red');
                case 1
                    %set(button,'Text','Set Motor Off','Backgroundcolor',[0,1,0],'Fontcolor',[0,0,1] ); 
                    set(lamp,'Color',[0,1,0]); 
                    set(lamp,'Color','green'); 
            end
        end

        function ButtonAndLampLogical(~,button,lamp,state)
            switch logical(state)
                case 0
                    %set(button,'Text','Set Motor On','Backgroundcolor',[0,1,1],'Fontcolor',[0,0,1] ); 
                    %set(lamp,'Color',[0,0,1]); 
                    set(lamp,'Color','red');
                case 1
                    %set(button,'Text','Set Motor Off','Backgroundcolor',[0,1,0],'Fontcolor',[0,0,1] ); 
                    set(lamp,'Color',[0,1,0]); 
                    set(lamp,'Color','green'); 
            end
        end


        function UpdateLamp(~,lamp,state)
            switch state 
                case -1
                    set(lamp,'Color','yellow');% ,[1,0,0]); 
                case 0
                    set(lamp,'Color','red');% ,[0,0,1]); 
                case 1
                    set(lamp,'Color','green');% ,[0,1,0]); 
            end
        end

        
        function Edata = GetExtData(app)

            FlexPos   =  FetchObj( [hex2dec('2104'),1,app.CanId(2)] , app.DataType.float , 'Tape position' );
            RotaryDeg =  FetchObj( [hex2dec('2104'),2,app.CanId(2)] , app.DataType.float , 'Rotary rad' ) / pi() * 180 ;
            SpacerPos =  FetchObj( [hex2dec('2104'),3,app.CanId(2)] , app.DataType.float , 'Spacer pos' );
            
            LDoorRad =  FetchObj( [hex2dec('2103'),43,app.CanId(2)] , app.DataType.long , 'Door 1 rad' );
            RDoorRad =  FetchObj( [hex2dec('2103'),53,app.CanId(2)] , app.DataType.long , 'Door 2 rad' );
                            
            MotorsOnInfo =  ulong(FetchObj([hex2dec('250a'),1,app.CanId(2)] , app.DataType.long , 'Motors on Info' ))  ;
            NeckInfo =  ulong(FetchObj([hex2dec('250a'),5,app.CanId(2)] , app.DataType.long , 'Neck Info' ))  ;

            NeckMotorOn = bitgetvalue(NeckInfo,1) ; 
            NeckFault = bitgetvalue(NeckInfo,2) ; 
            NeckProfileConverged = bitgetvalue(NeckInfo,3) ; 
            NeckMotionConverged = bitgetvalue(NeckInfo,4) ;
            InPackage = bitgetvalue(NeckInfo, 5); 

            NeckAngle =  FetchObj([hex2dec('2514'),5,app.CanId(2)] , app.DataType.float , 'Neck Aangle' )  / pi() * 180  ;

            SystemMode = FetchObj([hex2dec('250a'),2,app.CanId(2)] , app.DataType.long , 'System mode Info' )  ;

            %get SysState.WakeupState
            WakeupState = FetchObj([hex2dec('250a'),3,app.CanId(2)] , app.DataType.long , 'SysState.WakeupState mode' )  ;

            %Mode = bitand(MotorsOnInfo , double(0x0f00)) / double(0x0100);

            TapeArmOn = bitgetvalue(MotorsOnInfo,1) ; 
            TapeArmReady = bitgetvalue(MotorsOnInfo,9) ; 
            TapeArmFault = bitgetvalue(MotorsOnInfo,2) ; 
            TapeArmBrakeReleased = bitgetvalue(MotorsOnInfo,12) ; 
            if ( logical(TapeArmFault) )
                TapeArmFault = FetchObj( [hex2dec('2104'),4,app.CanId(2)] , app.DataType.long , 'Tape fault' ) ;
            else
                TapeArmFault = 0 ; 
            end 

            PlateOn  = bitgetvalue(MotorsOnInfo,3) ; %4
            PlateReady = bitgetvalue(MotorsOnInfo,10) ; 
            PlateFault  = bitgetvalue(MotorsOnInfo,4) ;  %8
            PlateBrakeReleased = bitgetvalue(MotorsOnInfo,13) ; 
            if ( logical(PlateFault) )
                PlateFault = FetchObj( [hex2dec('2104'),5,app.CanId(2)] , app.DataType.long , 'Plate fault' ) ;
            else
                PlateFault = 0 ; 
            end 

            SpacerOn = bitgetvalue(MotorsOnInfo,5) ; %16
            SpacerReady = bitgetvalue(MotorsOnInfo,11) ; 
            SpacerFault = bitgetvalue(MotorsOnInfo,6) ; %32     
            if ( logical(SpacerFault) )
                SpacerFault = FetchObj( [hex2dec('2104'),6,app.CanId(2)] , app.DataType.long , 'Spacer fault' ) ;
            else
                SpacerFault = 0 ; 
            end 

            ServoMotorOn = bitgetvalue(MotorsOnInfo,7) ; %64   - if all servo motors are on


            MotorHomedInfo =  FetchObj( [hex2dec('2509'),1,app.CanId(2)] , app.DataType.long , 'Motor Homed Info' )  ;
            TapeArmHomed = bitgetvalue(MotorHomedInfo,1) ; 
            PlateHomed = bitgetvalue(MotorHomedInfo,2) ; 
            SpacerHomed = bitgetvalue(MotorHomedInfo,3) ; %4
            AxesHomed = bitgetvalue(MotorHomedInfo,4) ; %8

            %TODO: update lamps, set callbacks for buttons
            TapeLCMode = FetchObj( [hex2dec('2511'),1,app.CanId(2)] , app.DataType.long , 'Tape LC mode' ) ;
            TapeReferenceMode = FetchObj( [hex2dec('2511'),2,app.CanId(2)] , app.DataType.long , 'Tape ref mode' ) ;
            PlateLCMode = FetchObj( [hex2dec('2511'),3,app.CanId(2)] , app.DataType.long , 'Plate LC mode' ) ;
            PlateReferenceMode = FetchObj( [hex2dec('2511'),4,app.CanId(2)] , app.DataType.long , 'Plate ref mode' ) ;
            ShifterLCMode = FetchObj( [hex2dec('2511'),5,app.CanId(2)] , app.DataType.long , 'Shifter LC mode' ) ;
            ShifterReferenceMode = FetchObj( [hex2dec('2511'),6,app.CanId(2)] , app.DataType.long , 'Shifter ref mode' ) ;
            
            ManipXPos =  FetchObj( [hex2dec('2514'),1,app.CanId(2)] , app.DataType.float , 'Manip X Position' );
            ManipYPos =  FetchObj( [hex2dec('2514'),2,app.CanId(2)] , app.DataType.float , 'Manip Y Positio' );
            ManipThetaAngle =  FetchObj( [hex2dec('2514'),3,app.CanId(2)] , app.DataType.float , 'Manip Theta Angle' );

             %*  bit 0 - individual mode
             %*  bit 1 - owner of control word (1- Core1, 0- OD)
             %*  bit 2 - OverrideSwitches (EEF manual operation by OD)
             %*  bit 4 - PackageGripByODMode (EEF automated activation of EEF by OD)
            ManipActivationStatus = ulong(FetchObj( [hex2dec('250f'),0,app.CanId(2)] , app.DataType.long , 'Get auto activation status' ))  ; %TODO: verify that all bitfield are sent as ulong
            Individual = bitgetvalue(ManipActivationStatus, 1);
            CwOwner = bitgetvalue(ManipActivationStatus, 2);
            OverRideSwitches = bitgetvalue(ManipActivationStatus, 3); %4
            PackageGripByODMode = bitgetvalue(ManipActivationStatus, 4); %8
            EefSyncEnBit = bitgetvalue(ManipActivationStatus, 5); %16
            NeckWheelsControlBit = bitgetvalue(ManipActivationStatus, 6); %32
            NeckGrantControl = bitgetvalue(ManipActivationStatus, 7); %64

            %OverRideSwitches = FetchObj( [hex2dec('250e'),1,app.CanId(2)] , app.DataType.long , 'Get Over Ride Switches' )  ;
            
            EEFElementsState =  FetchObj( [hex2dec('250b'),1,app.CanId(2)] , app.DataType.long , 'EEF elements state' )  ;
            LaserMedianValid = bitgetvalue(EEFElementsState, 1);
            PumpsOn = bitgetvalue(EEFElementsState, 4); %8
            LaserOn = bitgetvalue(EEFElementsState, 3); %4
            LedOn = bitgetvalue(EEFElementsState, 2); %2
            EEFPackageGripActivated = bitgetvalue(EEFElementsState,14) ;
            LaserMedianFailed = bitgetvalue(EEFElementsState, 16);
            LaserCalibOn = bitgetvalue(EEFElementsState, 12); %2


            LaserMedian =  FetchObj( [hex2dec('2510'),1,app.CanId(2)] , app.DataType.float , 'Laser Median' ) ;
            PackageDist =  FetchObj( [hex2dec('2510'),2,app.CanId(2)] , app.DataType.float , 'package distance' ) ;

            GripState =  FetchObj( [hex2dec('250c'),1,app.CanId(2)] , app.DataType.long , 'Get EEF grip state' )  ;

            WaitingForInitialGrip = bitgetvalue(GripState, 1);
            WaitingForFullGrip = bitgetvalue(GripState, 2);
            FullyGripped = bitgetvalue(GripState, 3); %4
            WaitingForRelease= bitgetvalue(GripState, 4); %8
            Fullyreleased = bitgetvalue(GripState, 5) ; %16
            GripError = bitgetvalue(GripState, 6); %32
            ReleaseError = bitgetvalue(GripState, 7); %64

            
            InstalledInfo =  ulong(FetchObj([hex2dec('250a'),4,app.CanId(2)] , app.DataType.long , 'Motors on Info' ))  ;
            PlateInstalled = bitgetvalue(InstalledInfo,1) ; 
            TapeArmInstalled = bitgetvalue(InstalledInfo,2) ; 
            SpacerInstalled = bitgetvalue(InstalledInfo,3) ; 

            if (PlateInstalled == 0) || (TapeArmInstalled == 0) || (SpacerInstalled == 0)
                uiwait(errordlg({'One of the tray Axes is not installed (check if set as installed in StructDef.h).'},'Error') ); 
            end

            try
                ShifterHomeDiretionTemp =  FetchObj( [hex2dec('2512'),3,app.CanId(2)] , app.DataType.long , 'spacer Homing direction' );         
            catch
                uiwait(errordlg({'The LP Cant communicate with the spacer axis. please use WhoIsThere on CAN2 to investigate.'},'Error') ); 
            end
            
            TapeHomeValueTemp =  FetchObj( [hex2dec('2512'),4,app.CanId(2)] , app.DataType.float , 'Tape Homing forward value' );          
            if (ShifterHomeDiretionTemp == 1)
                ShifterHomeValueTemp = FetchObj( [hex2dec('2512'),1,app.CanId(2)] , app.DataType.float , 'spacer Homing forward value' ); 
            else
                ShifterHomeValueTemp = FetchObj( [hex2dec('2512'),2,app.CanId(2)] , app.DataType.float , 'spacer Homing reverse value' ); 
            end

            %Get16bitField %TODO: useGet16bitField
            
            %temp = ulong(FetchObj( [hex2dec('220b'),2,app.CanId(2)] , app.DataType.long , 'Get last exception' ))  ;
            temp = FetchObj( [hex2dec('220b'),2,app.CanId(2)] , app.DataType.long , 'Get last exception' )  ;
            [field1, field2] = Get16bitFields(temp);
            [etext,elabtext] = Errtext(field1);
            %[app.Core2ExceptionList{1}, junk] = Errtext(Get16bitField(temp , 1)); %TODO: %OBB why doesnt work
            app.Core2ExceptionList{1} = etext;
            [etext,elabtext] = Errtext(field2);
            app.Core2ExceptionList{2} = etext;

            temp = FetchObj( [hex2dec('220b'),3,app.CanId(2)] , app.DataType.long , 'Get last-1 exception' )  ;
            [field1, field2] = Get16bitFields(temp);
            [etext,elabtext] = Errtext(field1);
            app.Core2ExceptionList{3} = etext;
            [etext,elabtext] = Errtext(field2);
            app.Core2ExceptionList{4} = etext;

            %temp = ulong(FetchObj( [hex2dec('220b'),3,app.CanId(2)] , app.DataType.long , 'Get last-1 exception' ))  ;
            temp = FetchObj( [hex2dec('220b'),4,app.CanId(2)] , app.DataType.long , 'Get last-2 exception' )  ;
            [field1, field2] = Get16bitFields(temp);
            [etext,elabtext] = Errtext(field1);
            app.Core2ExceptionList{5} = etext;
            [etext,elabtext] = Errtext(field2);
            app.Core2ExceptionList{6} = etext;

            %temp = ulong(FetchObj( [hex2dec('220b'),4,app.CanId(2)] , app.DataType.long , 'Get last-2 exception' ))  ;
            temp = FetchObj( [hex2dec('220b'),5,app.CanId(2)] , app.DataType.long , 'Get last-3 exception' )  ;
            [field1, field2] = Get16bitFields(temp);
            [etext,elabtext] = Errtext(field1);
            app.Core2ExceptionList{7} = etext;

            Edata = struct ( 'FlexPos' , FlexPos ,'RotaryDeg',RotaryDeg, 'SpacerPos' , SpacerPos ,...
                'LDoorRad' , LDoorRad ,'RDoorRad',RDoorRad ,...
                'ManipXPos', ManipXPos, 'ManipYPos', ManipYPos, 'ManipThetaAngle', ManipThetaAngle, ...
                'TapeArmOn',TapeArmOn,'TapeArmFault',TapeArmFault,'PlateOn',PlateOn,'PlateFault',PlateFault,'SpacerOn', SpacerOn,'SpacerFault',SpacerFault,...
                'TapeArmReady', TapeArmReady , 'PlateReady', PlateReady , 'SpacerReady', SpacerReady , ...
                'TapeArmBrakeReleased', TapeArmBrakeReleased, 'PlateBrakeReleased', PlateBrakeReleased, ...
                'MotorOnInfo' , MotorsOnInfo , 'ServoMotorOn', ServoMotorOn,...
                'NeckMotorOn', NeckMotorOn, 'NeckFault', NeckFault, 'NeckProfileConverged', NeckProfileConverged,'NeckMotionConverged', NeckMotionConverged,'InPackage', InPackage, 'NeckAngle', NeckAngle,...
                'TapeArmHomed', TapeArmHomed, 'PlateHomed', PlateHomed, 'SpacerHomed', SpacerHomed, 'AxesHomed', AxesHomed , ...
                'Individual', Individual, 'PackageGripByODMode', PackageGripByODMode, 'NeckWheelsControlBit', NeckWheelsControlBit, 'NeckGrantControl', NeckGrantControl,...
                'OverRideSwitches', OverRideSwitches', 'CwOwner', CwOwner, ...
                'WakeupState', WakeupState, 'SystemMode', SystemMode,...
                'TapeLCMode', TapeLCMode, 'TapeReferenceMode', TapeReferenceMode,...
                'PlateLCMode', PlateLCMode, 'PlateReferenceMode', PlateReferenceMode,...
                'ShifterLCMode', ShifterLCMode ,'ShifterReferenceMode', ShifterReferenceMode,...
                'EEFPackageGripActivated', EEFPackageGripActivated, 'EEFElementsState', EEFElementsState, 'EefSyncEnBit', EefSyncEnBit, ...
                'LaserMedianValid', LaserMedianValid, 'LaserMedian', LaserMedian', 'PackageDist', PackageDist, ...
                'ShifterHomeDiretion', ShifterHomeDiretionTemp, 'TapeHomeValue', TapeHomeValueTemp,'ShifterHomeValue', ShifterHomeValueTemp,...
                'PumpsOn', PumpsOn, 'LaserOn' , LaserOn, 'LedOn', LedOn, 'LaserMedianFailed', LaserMedianFailed, 'LaserCalibOn', LaserCalibOn,...
                'WaitingForInitialGrip', WaitingForInitialGrip, 'WaitingForFullGrip', WaitingForFullGrip, 'FullyGripped', FullyGripped,...
                'WaitingForRelease', WaitingForRelease, 'Fullyreleased', Fullyreleased, 'GripError', GripError, 'ReleaseError', ReleaseError) ; 
        end
        
        
        function str = InterpretDrvError(app, code , axname)

            global RecStruct
            if nargin < 3 
                axname = 'Unspecified axis' ; 
            end
            %ind = FindInSorted( RecStruct.ErrCodes.Code , code) ;
            ind = FindInSorted( RecStruct.BHErrCodes.Code , code) ;
            if isempty(ind)
                str = ['Unidentified error code: 0x',dec2hex(code)] ; 
                return ; 
            end            
            str = string([axname,': Code : 0x',dec2hex(code),' Formal: ',RecStruct.BHErrCodes.Formal{ind},'[' ,RecStruct.BHErrCodes.Fatality{ind},'] ',RecStruct.BHErrCodes.Description{ind}]) ; 
        end
        
        function SetAxisErrorCode(~,control,code)
            if ( code == 0 )
                set( control,'Text','Ok','BackgroundColor',[0 1 0],'FontColor',[0,0,0]) ; 
            else
                set( control,'Text',num2str(code),'BackgroundColor',[1 0 0],'FontColor',[1,1,1]) ; 
            end
        end
        
        function CalibStateMachine(app)
            global RecStruct %#ok<GVMIS> 
            switch ( app.InPlateCalib  )
                case 1
                    
                
                    if app.PushActionDone
                        app.InPlateCalib = 11 ; 
                        set(app.PushForComplete,'String','Start'); 
                        app.Handles.RecTime = 12; 
                        RecInitAction = struct( 'InitRec' , 0 , 'BringRec' , 0 ,'ProgRec' , 1 ,'Struct' , 1 ,'T' , app.Handles.RecTime ,'MaxLen', 1000 ) ; 
                        app.Handles.RecBringAction = struct( 'InitRec' , 0 , 'BringRec' , 1 ,'ProgRec' , 0 ,'Struct' , 1 ,'BlockUpLoad', 1  ) ; 
                        app.Handles.RecNames = {'AxisReadout_6','FlexPlateRatio'} ; 
                        L_RecStruct = RecStruct ;
                        L_RecStruct.Sync2C = 1 ; 
        
                        L_RecStruct.BlockUpLoad = 0 ; 
                        [~,L_RecStruct] = Recorder(app.Handles.RecNames , L_RecStruct , RecInitAction   );
                        app.Handles.L_RecStruct = L_RecStruct ;
                        app.EdataOnStart = app.Edata ; 
                        sum = 0 ; 
                        for cnt = 1:5
                            sum = sum + GetSignal('FlexPlateRatio'); 
                        end 
                        app.Handles.FlexRotaryCenter = sum / 5 ; 
                        app.InstructionsTextArea.Value = {'Set the tapearm to -90g (90 deg CCW)';' and press Ready'}; 
                        set(app.PushForComplete,'String','Ready'); 
                        app.PushActionDone = 0 ; 
                    end
                case 11
                    if app.PushActionDone
                        app.InPlateCalib = 2 ; 
                        set(app.PushForComplete,'String','Start'); 
                        app.InstructionsTextArea.Value = {'After you push Start';['You have ',num2str(app.Handles.RecTime) ,' seconds'];...
                            'to pause 1 second';'then SLOWLY rotate tapearm 90 degrees clockwise'} ; 
                        app.PushActionDone = 0 ; 
                    end
        
                case 2
                    if app.PushActionDone
                        app.PushActionDone = 0 ; 
                        SendObj( [hex2dec('2000'),100] , 1 , app.DataType.short  , 'Set the recorder on' ) ;
                        
                        % InitRec set zero , recorder shall start automatically
                        app.InPlateCalib = 3 ; 
                        app.Handles.tic = tic ; 
                        set(app.PushForComplete,'String',num2str(app.Handles.RecTime)); 
                    end
        
                case 3
                    tremain = app.Handles.RecTime - toc(app.Handles.tic) ; 
                    if tremain > 0 
                        set(app.PushForComplete,'String',num2str(tremain) ); 
                    else
                        set(app.PushForComplete,'String','Uploading' ); 
                        drawnow ; 
                        [~,~,r] = Recorder(app.Handles.RecNames , app.Handles.L_RecStruct , app.Handles.RecBringAction   );
                        nomgain = GetFloatPar('ManGeo.FlexPlatePot2Rad','2') ; 
                        EdataOnStart = app.EdataOnStart ; %#ok<ADPROP,ADPROP> 
                        PotCenter    = app.Handles.FlexRotaryCenter ;
                        save CalibFlexPlatePot.mat r nomgain EdataOnStart PotCenter 
                        [corr, estr] = AnaCalibFlexPlate() ; 
                        if isempty(estr) 

                            app.InstructionsTextArea.Value = {'Your results are ready'}; 
                            ButtonName = questdlg('Do you want to update/flash the result:?','Question','Yes', 'No', 'No');
                            if isequal(ButtonName,'Yes') 
                                SendObj( [hex2dec('2303'),1,app.CanId(2)] ,GetSFPass() , app.DataType.long  , 'Set parameters password' ) ;
                                SendObj( [hex2dec('2303'),251,app.CanId(2)] ,0 , app.DataType.long  , 'Update calibration parameters from flash' ) ;
                                SendObj( [hex2dec('2303'),GetCalibIndex('FlexRotaryCenter',handles.CalibNames),app.CanId(2)] , handles.FlexRotaryCenter , app.DataType.float  , 'Set FlexRotaryCenter' ) ;
                                SendObj( [hex2dec('2303'),GetCalibIndex('FlexRotaryPotGain',handles.CalibNames),app.CanId(2)] , corr , app.DataType.float  , 'Set FlexRotaryPotGain' ) ;
                                CalibData = FetchObj( [hex2dec('2303'),GetCalibIndex('CalibData',handles.CalibNames),app.CanId(2)] , app.DataType.long  , 'Fetch CalibData' ) ;
                                SendObj( [hex2dec('2303'),253,app.CanId(2)] , CalibData , app.DataType.long  , 'Save in flash' ) ;
                            end
        
                        else
                            set( handles.TextPleaseDo,'String',{'Your results are rejected';estr}) ;
                        end
                        app.InPlateCalib = 0 ;
                        set( app.PushForComplete,'Visible','Off','String','Done') ; 
                    end 
                otherwise
                    app.InPlateCalib = 0 ; 
                    set( app.PushForComplete,'Visible','Off','String','Done') ; 
        %             set( handles.TextPleaseDo,'String',{'Have a good day'}) ; 
               %set( handles.TextPleaseDo,'Visible','Off') ; 
            end 
            
        end
      
        
        function msboxAndCloseApp(app, str)
            fig_id = msgbox(str); 
            while isvalid( fig_id) 
                set(fig_id,'WindowStyle','modal');
                pause(0.2);
            end
            UIFigureCloseRequest(app) ; 
        end

        function msbox(~, str)
            fig_id = msgbox(str); 
            while isvalid( fig_id) 
                set(fig_id,'WindowStyle','modal');
                pause(0.2);
            end
        end
        
        function LogException(app, exception)
            str = exception;
            app.ProblemsTextArea.Value = str ; 
        end
        
        function UpdateManGeoParameters(app)
            app.ManGeo.ShelfTrackPoint1Pos = GetFloatPar('ManGeo.ShelfTrackPoint1Pos','2') ;  % Description
            app.UITable.Data = ["ManGeo.ShelfTrackPoint1Pos", app.ManGeo.ShelfTrackPoint1Pos];

            app.ManGeo.ShelfTrackPoint2Pos = GetFloatPar('ManGeo.ShelfTrackPoint2Pos','2') ;  % Description
            app.UITable.Data = [app.UITable.Data ; "ManGeo.ShelfTrackPoint2Pos", app.ManGeo.ShelfTrackPoint2Pos];

            app.ManGeo.ShelfTrackPoint3Pos = GetFloatPar('ManGeo.ShelfTrackPoint3Pos','2') ;  % Description
            app.UITable.Data = [app.UITable.Data ; "ManGeo.ShelfTrackPoint3Pos", app.ManGeo.ShelfTrackPoint3Pos];

            app.ManGeo.ShelfTrackPoint4Pos = GetFloatPar('ManGeo.ShelfTrackPoint4Pos','2') ;  % Description
            app.UITable.Data = [app.UITable.Data ; "ManGeo.ShelfTrackPoint4Pos", app.ManGeo.ShelfTrackPoint4Pos];

            app.ManGeo.ShelfTrackPoint5Pos = GetFloatPar('ManGeo.ShelfTrackPoint5Pos','2') ;  % Description
            app.UITable.Data = [app.UITable.Data ; "ManGeo.ShelfTrackPoint5Pos", app.ManGeo.ShelfTrackPoint5Pos];

            app.ManGeo.ShelfTrackPoint3Angle = GetFloatPar('ManGeo.ShelfTrackPoint3Angle','2') ;  % Description
            app.UITable.Data = [app.UITable.Data ; "ManGeo.ShelfTrackPoint3Angle", app.ManGeo.ShelfTrackPoint3Angle];

            app.ManGeo.ShelfTrackPoint4Angle = GetFloatPar('ManGeo.ShelfTrackPoint4Angle','2') ;  % Description
            app.UITable.Data = [app.UITable.Data ; "ManGeo.ShelfTrackPoint4Angle", app.ManGeo.ShelfTrackPoint4Angle];
            
            app.ManGeo.ShelfTrackPoint5Angle = GetFloatPar('ManGeo.ShelfTrackPoint5Angle','2') ;  % Description
            app.UITable.Data = [app.UITable.Data ; "ManGeo.ShelfTrackPoint5Angle", app.ManGeo.ShelfTrackPoint5Angle];


            app.ManGeo.FlexMaxLinearTravel = GetFloatPar('ManGeo.FlexMaxLinearTravel','2') ;  % Description 
            app.UITable.Data = [app.UITable.Data ; "ManGeo.FlexMaxLinearTravel", app.ManGeo.FlexMaxLinearTravel];

            app.ManGeo.FlexMaxExtensionTravel = GetFloatPar('ManGeo.FlexMaxExtensionTravel','2') ;  % Description 
            app.UITable.Data = [app.UITable.Data ; "ManGeo.FlexMaxExtensionTravel", app.ManGeo.FlexMaxExtensionTravel];

            app.ManGeo.FlexMaxAngle = GetFloatPar('ManGeo.FlexMaxAngle','2') ;  % Description 
            app.UITable.Data = [app.UITable.Data ; "ManGeo.FlexMaxAngle", app.ManGeo.FlexMaxAngle];

            app.ManGeo.FlexSpacerPosSetPackageShelf = GetFloatPar('ManGeo.FlexSpacerPosSetPackageShelf','2') ;  % Description
            app.UITable.Data = [app.UITable.Data ; "ManGeo.FlexSpacerPosSetPackageShelf", app.ManGeo.FlexSpacerPosSetPackageShelf];

            app.ManGeo.FlexYDistWheel2PackageAtSpacer0Ext0 = GetFloatPar('ManGeo.FlexYDistWheel2PackageAtSpacer0Ext0','2') ;  % Description
            app.UITable.Data = [app.UITable.Data ; "ManGeo.FlexYDistWheel2PackageAtSpacer0Ext0", app.ManGeo.FlexYDistWheel2PackageAtSpacer0Ext0];

            app.ManGeo.FlexPlateSpeed = GetFloatPar('ManGeo.FlexPlateSpeed','2') ;  % Description
            app.UITable.Data = [app.UITable.Data ; "ManGeo.FlexPlateSpeed", app.ManGeo.FlexPlateSpeed];

            app.ManGeo.FlexTapeSpeed = GetFloatPar('ManGeo.FlexTapeSpeed','2') ;  % Description
            app.UITable.Data = [app.UITable.Data ; "ManGeo.FlexTapeSpeed", app.ManGeo.FlexTapeSpeed];

            app.ManGeo.FlexSpacerSpeed = GetFloatPar('ManGeo.FlexSpacerSpeed','2') ;  % Description
            app.UITable.Data = [app.UITable.Data ; "ManGeo.FlexSpacerSpeed", app.ManGeo.FlexSpacerSpeed];




            %can be removed after integration:
            app.ManGeo.FlexArmRetreatDist4SuctRelease = GetFloatPar('ManGeo.FlexArmRetreatDist4SuctRelease','2') ;  % Description 
            app.UITable.Data = [app.UITable.Data ; "ManGeo.FlexArmRetreatDist4SuctRelease", app.ManGeo.FlexArmRetreatDist4SuctRelease];

            app.ManGeo.FlexArmDistLaser2CupsPressed = GetFloatPar('ManGeo.FlexArmDistLaser2CupsPressed','2') ;  % Description 
            app.UITable.Data = [app.UITable.Data ; "ManGeo.FlexArmDistLaser2CupsPressed", app.ManGeo.FlexArmDistLaser2CupsPressed];

            app.ManGeo.FlexArmETolForPackageY = GetFloatPar('ManGeo.FlexArmETolForPackageY','2') ;  % Description 
            app.UITable.Data = [app.UITable.Data ; "ManGeo.FlexArmETolForPackageY", app.ManGeo.FlexArmETolForPackageY];

            app.ManGeo.FlexArmMaxExtWithinTray = GetFloatPar('ManGeo.FlexArmMaxExtWithinTray','2') ;  % Description 
            app.UITable.Data = [app.UITable.Data ; "ManGeo.FlexArmMaxExtWithinTray", app.ManGeo.FlexArmMaxExtWithinTray];

            app.ManGeo.FlexArmActivateSlowApproach = GetFloatPar('ManGeo.FlexArmActivateSlowApproach','2') ;  % Description 
            app.UITable.Data = [app.UITable.Data ; "ManGeo.FlexArmActivateSlowApproach", app.ManGeo.FlexArmActivateSlowApproach];

            app.ManGeo.FlexArmPackageGrippedLaserTol = GetFloatPar('ManGeo.FlexArmPackageGrippedLaserTol','2') ;  % Description 
            app.UITable.Data = [app.UITable.Data ; "ManGeo.FlexArmPackageGrippedLaserTol", app.ManGeo.FlexArmPackageGrippedLaserTol];

            app.ManGeo.FlexArmPackageOnTrayLaserTol = GetFloatPar('ManGeo.FlexArmPackageOnTrayLaserTol','2') ;  % Description 
            app.UITable.Data = [app.UITable.Data ; "ManGeo.FlexArmPackageOnTrayLaserTol", app.ManGeo.FlexArmPackageOnTrayLaserTol];

            app.ManGeo.FlexArmExtUpdateTol = GetFloatPar('ManGeo.FlexArmExtUpdateTol','2') ;  % Description 
            app.UITable.Data = [app.UITable.Data ; "ManGeo.FlexArmExtUpdateTol", app.ManGeo.FlexArmExtUpdateTol];

            app.ManGeo.FlexArmETolForPackageY = GetFloatPar('ManGeo.FlexArmETolForPackageY','2') ;  % Description 
            app.UITable.Data = [app.UITable.Data ; "ManGeo.FlexArmETolForPackageY", app.ManGeo.FlexArmETolForPackageY];

            app.ManGeo.FlexArmPackagePreloadExt = GetFloatPar('ManGeo.FlexArmPackagePreloadExt','2') ;  % Description global
            app.UITable.Data = [app.UITable.Data ; "ManGeo.FlexArmPackagePreloadExt", app.ManGeo.FlexArmPackagePreloadExt];

            app.ManGeo.FlexStandbyExtPos = GetFloatPar('ManGeo.FlexStandbyExtPos','2') ;  % Description 
            app.UITable.Data = [app.UITable.Data ; "ManGeo.FlexStandbyExtPos", app.ManGeo.FlexStandbyExtPos];

            app.ManGeo.FlexSpacerPosSetPackageShelf = GetFloatPar('ManGeo.FlexSpacerPosSetPackageShelf','2') ;  % Description 
            app.UITable.Data = [app.UITable.Data ; "ManGeo.FlexSpacerPosSetPackageShelf", app.ManGeo.FlexSpacerPosSetPackageShelf];

            app.Package.maxDPacakge = -app.ManGeo.FlexYDistWheel2PackageAtSpacer0Ext0 + app.ManGeo.FlexMaxExtensionTravel; % [m] 
            app.Package.minDPacakge = -app.ManGeo.FlexYDistWheel2PackageAtSpacer0Ext0; % [m] 
            app.Package.maxYPacakge = app.ManGeo.FlexMaxExtensionTravel;
            app.Package.minYPacakge = 0;
                    
        end
        
        % function results = bitandLogical(~, a , b)
        %     results = logical(bitand(a, b));
        % end

        function ErrordetailButtonPushedBody(app)
            str = sprintf('Tape: %s\nPlate: %s\nShifter: %s\n' , InterpretDrvError(app,app.Edata.TapeArmFault,'Tape'),InterpretDrvError(app,app.Edata.PlateFault,'Plate'),InterpretDrvError(app,app.Edata.SpacerFault,'Spacer') );
            app.ProblemsTextArea.Value = cellstr(str) ; 
            %app.AxisErrorsTextArea.Value = cellstr(str) ; 
        end
    end
    

    % Callbacks that handle component events
    methods (Access = private)

        % Code that executes after component creation
        function startupFcn(app)
            global DispT ; %#ok<GVMIS> 
            global TargetCanId2 %#ok<GVMIS> 
            global TargetCanId %#ok<GVMIS> 

            app.version = '1.4';
            app.FlexManipulatordashboardLabel.Text = ['Tray BIT, Version ', app.version]; 

            try %OBB section added to start AtpStart if deployed
                if isdeployed && ~exist('AtpCfg','var')
                    AtpStart();
                end
            catch
                uiwait(errordlg({'Cant run AtpStart'},'Error') ); 
            end

            app.Handles = struct() ; 
            app.InPlateCalib = 0  ; 
            app.DataType = GetDataType() ; 
            app.CanId = [TargetCanId,TargetCanId2] ; 
            app.Block = 1 ; 

            app.LogicId = struct('PLATE',0,'TAPEARM',1,'SPACER',2) ; 

            app.ControlWordCopy = 0;

            app.Package = struct();
            app.ManGeo = struct ();
            
            try
                UpdateManGeoParameters(app);
            catch me
                %disp(me.message) ; 
                msboxAndCloseApp(app, {'Com is down, check connection to CAN1/ restart MATLAB/ reset LP.',me.message});
            end
            
            app.Package.DPackage = 0; %package distance from the robot center %[m]
            app.Package.Side = 0; % 1 - right, -1 - left
            app.Package.Right = 0;
            app.Package.Left = 0;
            app.Package.Get = 1; % 1 - get ; 0 - set
            app.GetPackageSwitch.Value = 'Get Package';
            app.Package.RepeatAction = 0;
            app.PackageGripByODModeSet = 0;
            app.CwOwnerSet = 1; % 1 - set by core1, 0 - set by OD
            app.LedOnState = 0;
            app.LaserOnState = 0;

            app.SideSwitch.Value = "Right";
            app.Package.Right = 1;
            app.Package.Left = 0;

            app.Core2ExceptionList = {'', '', '', '', '', '', ''};

            % try 
            %     MatDir   = '.\Mat\'; 
            %     x = load([MatDir, 'Entities.mat'],'EntityTableNeck'); 
            %     RecStruct.ErrCodes = x.EntityTableNeck.ErrCodes ; 
            % catch
            %     uiwait(msgbox('Cant find error messages for drives') ) ;
            %     UIFigureCloseRequest(app) ;                 
            % end

            try
                ManType = FetchObj( [hex2dec('2220'),53,app.CanId(1)],app.DataType.long ,'Manipulator type') ;
                if ~(ManType == 2 )
                    msboxAndCloseApp(app,'This dialog is only for Tape Arm Manipulator'); 
                end
    
                app.s = LocalGetState(app) ; 
                app.Edata = GetExtData(app);
    
                app.IndividualSet = logical(app.s.Manip.bIndividual) ; 

                app.OverRideSwitchesSet = 0;
                app.PackageGripByODModeSet = 0;
                app.Edata.PackageGripByODMode = 0;
                
                app.EvtObj = DlgUserObj(@app.update_display,findobj(app) );
                app.EvtObj.MylistenToTimer(DispT) ;  
            catch me
                %disp(me.message) ; 
                msboxAndCloseApp(app, me.message);
            end
            app.Block = 0  ;

            app.GotopostureButton.BackgroundColor = [0.30,0.75,0.93];

        end

        % Close request function: UIFigure
        function UIFigureCloseRequest(app, event)
            delete(app)
            
        end

        % Button pushed function: ErrordetailButton
        function ErrordetailButtonPushed(app, event)
            %str = sprintf('Tape: %s\nPlate: %s\nShifter: %s\n' , InterpretDrvError(app,app.Edata.TapeArmFault,'Tape'),InterpretDrvError(app,app.Edata.PlateFault,'Plate'),InterpretDrvError(app,app.Edata.SpacerFault,'Spacer') );
            %app.ProblemsTextArea.Value = cellstr(str) ; 
            ErrordetailButtonPushedBody(app);
        end

        % Button pushed function: TapeMotorOnButton
        function TapeMotorOnButtonPushed(app, event)
            if ( app.Edata.TapeArmOn || app.Edata.TapeArmReady ) 
                SendObj( [hex2dec('2508'),131,app.CanId(2)] , app.LogicId.TAPEARM , GetDataType('long') , 'Set motor off ' ) ;
            else
                SendObj( [hex2dec('2508'),130,app.CanId(2)] , app.LogicId.TAPEARM , GetDataType('long') , 'Set motor on ' ) ;
            end

        end

        % Button pushed function: PlateMotorOnButton
        function PlateMotorOnButtonPushed(app, event)
            
            if ( app.Edata.PlateOn || app.Edata.PlateReady ) 
                SendObj( [hex2dec('2508'),131,app.CanId(2)] , app.LogicId.PLATE , GetDataType('long') , 'Set motor off ' ) ;
            else
                SendObj( [hex2dec('2508'),130,app.CanId(2)] , app.LogicId.PLATE , GetDataType('long') , 'Set motor on ' ) ;
            end
            
        end

        % Button pushed function: ShifterMotorOnButton
        function ShifterMotorOnButtonPushed(app, event)
            
            if ( app.Edata.SpacerOn || app.Edata.SpacerReady ) 
                SendObj( [hex2dec('2508'),131,app.CanId(2)] , app.LogicId.SPACER , GetDataType('long') , 'Set motor off ' ) ;
            else
                SendObj( [hex2dec('2508'),130,app.CanId(2)] , app.LogicId.SPACER , GetDataType('long') , 'Set motor on ' ) ;
            end
            
        end

        % Button pushed function: TapeGo
        function TapeGoButtonPushed(app, event)
            % Set to E_PosModePTP reference mode & E_LoopClosureMode to E_LC_Pos_Mode/ E_LC_Dual_Pos_Mode
            SendObj( [hex2dec('2508'),139,app.CanId(2)] , app.LogicId.TAPEARM , GetDataType('long') , 'set tapearm PTP ref mode' ) ;%set Homing direction

            if app.TapeRobotCsCheckBox.Value
                % in robot CS entered DTarget. From DTarget 2 YTarget 
                addval = (app.ManGeo.FlexYDistWheel2PackageAtSpacer0Ext0 - app.ManGeo.FlexSpacerPosSetPackageShelf);
            else
                addval = 0 ; 
            end 

            % Take the reference and issue it 
            SendObj( [hex2dec('2508'),133,app.CanId(2)] ,app.TapeTarget.Value + addval, GetDataType('float') , 'Issue the reference itself' ) ;
        end

        % Button pushed function: PlateGoButton
        function PlateGoButtonPushed(app, event)
            % Set to E_PosModePTP reference mode & E_LoopClosureMode to E_LC_Pos_Mode/ E_LC_Dual_Pos_Mode
            SendObj( [hex2dec('2508'),139,app.CanId(2)] , app.LogicId.PLATE , GetDataType('long') , 'set plate PTP ref mode' ) ;%set Homing direction

            %addval = 0 ; 
            % Take the reference and issue it 
            SendObj( [hex2dec('2508'),134,app.CanId(2)] , app.PlaceTargetDeg.Value/180*pi() , GetDataType('float') , 'Issue the reference itself' ) ;
        end

        % Button pushed function: ShifterGoButton
        function ShifterGoButtonPushed(app, event)
            % Set to E_PosModePTP reference mode & E_LoopClosureMode to E_LC_Pos_Mode/ E_LC_Dual_Pos_Mode
            SendObj( [hex2dec('2508'),139,app.CanId(2)] , app.LogicId.SPACER , GetDataType('long') , 'set spacer PTP ref mode' ) ;%set Homing direction

            %addval = 0 ; 
            % Take the reference and issue it 
            SendObj( [hex2dec('2508'),135,app.CanId(2)] , app.ShifterTarget.Value , GetDataType('float') , 'Issue the reference itself' ) ;            
        end

        % Button pushed function: TapeSethomeButton
        function TapeSethomeButtonPushed(app, event)
            
            SendObj( [hex2dec('2508'),141,app.CanId(2)] , app.EditFieldTapeHome.Value , GetDataType('float') , 'Set tape homing value' ) ;
            
        end

        % Button pushed function: ShifterSethomeButton
        function ShifterSethomeButtonPushed(app, event)

            SendObj( [hex2dec('2508'),142,app.CanId(2)] , app.EditFieldSpacerHome.Value , GetDataType('float') , 'Set spacer homing value' ) ;
            
        end

        % Button pushed function: TapeAutomaticHomeButton
        function TapeAutomaticHomeButtonPushed(app, event)
            
            SendObj( [hex2dec('2508'),150,app.CanId(2)] , app.LogicId.TAPEARM , GetDataType('long') , 'Set to Homing' ) ;

            %TODO: after the homing is fully done, the user need to return it to
            %its correct E_ReferenceModes (E_PosModePTP) & E_LoopClosureMode (E_LC_Pos_Mode/ E_LC_Dual_Pos_Mode)
            %SendObj( [hex2dec('2508'),139,app.CanId(2)] , app.LogicId.TAPEARM , GetDataType('long') , 'Set to Homing' ) ;
            
        end

        % Button pushed function: ShifterAutomaticHomeButton
        function ShifterAutomaticHomeButtonPushed(app, event)
            
            % change mode to speed mode. 
            SendObj( [hex2dec('2508'),150,app.CanId(2)] , app.LogicId.SPACER , GetDataType('long') , 'Set to Homing' ) ;
            
        end

        % Button pushed function: PlateCalibrateButton
        function PlateCalibrateButtonPushed(app, event)
            SendObj( [hex2dec('2508'),152,app.CanId(2)] , 1234 , GetDataType('long') , 'immidiate Homing' ) ;
            %app.InPlateCalib = 1 ;

        end

        % Button pushed function: TapeKillHomeButton
        function TapeKillHomeButtonPushed(app, event)
            
            SendObj( [hex2dec('2508'),151,app.CanId(2)] , app.LogicId.TAPEARM  , GetDataType('long') , 'Set to Homing' ) ;

        end

        % Button pushed function: SpacerKillHomingButton
        function SpacerKillHomingButtonPushed(app, event)

            SendObj( [hex2dec('2508'),151,app.CanId(2)] , app.LogicId.SPACER  , GetDataType('long') , 'Set to Homing' ) ;
            
        end

        % Button pushed function: RotatePosButton
        function RotatePosButtonPushed(app, event)
            app.ShifterTarget.Value = app.ManGeo.ShelfTrackPoint2Pos;  
        end

        % Button pushed function: StByPosButton
        function StByPosButtonPushed(app, event)
            app.ShifterTarget.Value = app.ManGeo.ShelfTrackPoint1Pos; 
        end

        % Button pushed function: ShelfPosButton
        function ShelfPosButtonPushed(app, event)
            app.ShifterTarget.Value = app.ManGeo.ShelfTrackPoint4Pos; 
        end

        % Button pushed function: GotoStandByButton
        function GotoStandByButtonPushed(app, event)

            if app.Edata.CwOwner == 0 %which means that we the LP is not the owner!!!
                app.ControlWordCopy = 1 + 2 + 4 + app.OnRailsCheckBox_2.Value * 32768 ; % automatic = 1, MotorsOn = 2, standBy = 4, on_rail 32768
                SendObj( [hex2dec('2506'),10,app.CanId(2)] , 0 , GetDataType('short') , 'Send get ready for stand by' ) ; 
                SendObj( [hex2dec('2506'),1,app.CanId(2)] , app.ControlWordCopy , GetDataType('short') , 'Send get ready for stand by' ) ;
            end
        end

        % Value changed function: DistancefromRobotValueEditField
        function DistancefromRobotValueEditFieldValueChanged(app, event)
            value = app.DistancefromRobotValueEditField.Value;
            %valueM = value;
            if ((value <= app.Package.maxDPacakge) && (value >= app.Package.minDPacakge))
                app.Package.DPackage = value;
            else
                app.DistancefromRobotValueEditField.Value = 0;
                LogException(app,'Pacakge distance out of range.');
            end
        end

        % Value changed function: SideSwitch
        function SideSwitchValueChanged(app, event)
            value = app.SideSwitch.Value;
            if value == "Right"
                app.Package.Left = 0;
                app.Package.Right = 1;
            else  
                app.Package.Right = 0;
                app.Package.Left = 1;
            end
        end

        % Value changed function: GetPackageSwitch
        function GetPackageSwitchValueChanged(app, event)
            value = app.GetPackageSwitch.Value;
            if value == "Get Package" % 1 - get ; 0 - set
                app.Package.Get = 1;
            else  
                app.Package.Get = 0;
            end
        end

        % Button pushed function: DealPackageButton
        function DealPackageButtonPushed(app, event)
            if app.Edata.CwOwner
                uiwait(msgbox('Turn on Auto manipulator control.') ) ;
                return;
            else 
                if app.Edata.PackageGripByODMode || app.Edata.OverRideSwitches
                    uiwait(msgbox('Turn off EEF Auto Grip control/ EEF manual activation.') ) ;
                    return;
                end
            end
            
            % app.Package.Side = 0; % 1 - right, -1 - left
            if app.Package.Right 
                app.Package.Side = 1;
            else
                app.Package.Side = -1;
            end
            
            if app.Package.Get
                SendObj( [hex2dec('2506'),3,app.CanId(2)] , app.NeckPutTargetDeg.Value * app.Package.Side, GetDataType('float') , 'Send incidence angle' ) ;
            else
                SendObj( [hex2dec('2506'),3,app.CanId(2)] , app.NeckPutTargetDeg.Value * app.Package.Side, GetDataType('float') , 'Send incidence angle' ) ;
            end
            app.ControlWordCopy = 1 + 2 + 8 + app.Package.Get*16 + app.Package.Left*32 + app.Package.Right*64 + app.Package.RepeatAction*2^13; % automatic = 1, MotorsOn = 2, standBy = 4, deal Package = 8 , get = 16,  side = 32
            SendObj( [hex2dec('2506'),4,app.CanId(2)] , app.Package.DPackage * app.Package.Side, GetDataType('float') , 'Send Package distance from center' ) ;

            SendObj( [hex2dec('2506'),1,app.CanId(2)] , app.ControlWordCopy , GetDataType('short') , 'deal package' ) ;
        end

        % Button pushed function: SySModeAutoIdleButton
        function SySModeAutoIdleButtonPushed(app, event)
            if app.Edata.CwOwner == 0 %which means that we the LP is not the owner!!!
                SendObj( [hex2dec('2506'),12,app.CanId(2)] , 1, GetDataType('long') , 'Reday for motors on/off' ) ;
                %SendObj( [hex2dec('2506'),1,app.CanId(2)] , 3 , GetDataType('short') , 'Flex manip motors on - go to AutomaticIdleState' ) ;
            end
        end

        % Button pushed function: DoHomingButton
        function DoHomingButtonPushed(app, event)
            %if ( app.Edata.AxesHomed == 0 ) 
            if (app.Edata.CwOwner == 0 ) && (app.Edata.ServoMotorOn)
                cw = 1 + 2 + 4096 ; % automatic = 1, MotorsOn = 2, homing = 12 (4096)
                SendObj( [hex2dec('2506'),11,app.CanId(2)] , 1 , GetDataType('short') , 'prepare for Flex manip motors homing' ) ; %only Automatic & motors on & DoHoming bits are 1
                SendObj( [hex2dec('2506'),1,app.CanId(2)] , cw , GetDataType('short') , 'Flex manip motors homing' ) ; %only Automatic & motors on & DoHoming bits are 1
            end

        end

        % Button pushed function: PumpsOnButton
        function PumpsOnButtonButtonPushed(app, event)
            if app.Edata.PumpsOn  % Direct pump activation    was app.Edata.EEFPackageGripActivated
                SendObj( [hex2dec('2505'),12,app.CanId(2)] , 0 , GetDataType('long') , 'Set pump off ' ) ;%turn pump activation off
            else
                SendObj( [hex2dec('2505'),12,app.CanId(2)] , 1 , GetDataType('long') , 'Set pump on ' ) ; %turn pump activation on
            end
        end

        % Button pushed function: PumpsGripActivationButton
        function PumpsGripActivationButtonPushed(app, event)
            app.LedOnState = app.Edata.LedOn; %keep current LED state
            app.LaserOnState = app.Edata.LaserOn; %keep current Laser state
            cw = ~app.Edata.EEFPackageGripActivated + 2 * app.LedOnState + 4 * app.LaserOnState + 2048*app.DoNotLookForPackageCheckBox.Value + 4096*app.DoNotTestSuctionCheckBox.Value ;%1 - pacakge grip, 2 - ledOnCmd, 4 - laserOnCmd
            SendObj( [hex2dec('2505'),3,app.CanId(2)] , cw , GetDataType('long') , 'Set grip on off ' ) ;%turn automatic pump grip on/off 

            % if ( app.Edata.EEFPackageGripActivated )  % Direct pump activation    was app.Edata.EEFPackageGripActivated 
            %     SendObj( [hex2dec('2505'),3,app.CanId(2)] , cw , GetDataType('long') , 'Set grip on off ' ) ;%turn automatic pump grip off 
            % else
            %     SendObj( [hex2dec('2505'),3,app.CanId(2)] , cw , GetDataType('long') , 'Set grip on ' ) ; %turn automatic pump grip on 
            % end
        end

        % Button pushed function: LaserOnBotton
        function LaserOnBottonButtonPushed(app, event)
            % does not depend on individual mode. test
            if ( app.Edata.LaserOn )  % Direct laser activation    
                SendObj( [hex2dec('2505'),11,app.CanId(2)] , 0 , GetDataType('long') , 'Set laser off ' ) ;%turn laser off 
                app.LaserOnState = 0;
            else
                SendObj( [hex2dec('2505'),11,app.CanId(2)] , 1 , GetDataType('long') , 'Set laser on ' ) ; %turn laser on 
                app.LaserOnState = 1;
            end
        end

        % Button pushed function: LedOnButton
        function LedOnButtonPushed(app, event)
            % does not depend on individual mode.
            if ( app.Edata.LedOn )  % Direct led activation    
                SendObj( [hex2dec('2505'),10,app.CanId(2)] , 0 , GetDataType('long') , 'Set led off ' ) ;%turn laser off
                app.LedOnState = 0;
            else
                SendObj( [hex2dec('2505'),10,app.CanId(2)] , 1 , GetDataType('long') , 'Set led on ' ) ; %turn laser on 
                app.LedOnState = 1;
            end
        end

        % Button pushed function: ManualActivationButton
        function ManualActivationButtonPushed(app, event)
            if ( app.Edata.OverRideSwitches )  % OverRide Switches on/off
                SendObj( [hex2dec('2505'),1,app.CanId(2)] , 0 , GetDataType('long') , 'reset OverRideSwitches ' ) ;%set OverRideSwitchesSet
                app.OverRideSwitchesSet = 0;
            else
                % reseting PackageGripByODMode
                SendObj( [hex2dec('2505'),2,app.CanId(2)] , 0 , GetDataType('long') , 'Set PackageGripByODMode off ' ) ;%reset PackageGripByODMode

                SendObj( [hex2dec('2505'),1,app.CanId(2)] , 1 , GetDataType('long') , 'set OverRideSwitches ' ) ; %set OverRideSwitchesSet
                app.OverRideSwitchesSet = 1;
            end
        end

        % Value changed function: DoNotTestSuctionCheckBox
        function DoNotTestSuctionCheckBoxValueChanged(app, event)
            value = app.DoNotTestSuctionCheckBox.Value;
            app.DoNotTestSuctionCheckBox_2.Value = value;
            app.DoNotTestSuction = value;
        end

        % Value changed function: DoNotLookForPackageCheckBox
        function DoNotLookForPackageCheckBoxValueChanged(app, event)
            value = app.DoNotLookForPackageCheckBox.Value;
            app.DoNotLookForPackageCheckBox_2.Value = value;
            app.DoNotLookForPackage = value;
        end

        % Button pushed function: EEFAutoGripEnableButton
        function EEFAutoGripEnableButtonPushed(app, event)
            % This button allows only EEFcw automatic activation setting directly (not through deal pacakge).
            if ( app.Edata.PackageGripByODMode )  % OverRide Switches on/off  
                SendObj( [hex2dec('2505'),2,app.CanId(2)] , 0 , GetDataType('long') , 'Set led off ' ) ;%reset PackageGripByODMode
            else
                %reseting override switches
                app.OverRideSwitchesSet = 0;
                SendObj( [hex2dec('2505'),1,app.CanId(2)] , 0 , GetDataType('long') , 'reset OverRideSwitches ' ) ;%turn laser off

                SendObj( [hex2dec('2505'),2,app.CanId(2)] , 1 , GetDataType('long') , 'Set led on ' ) ; %set PackageGripByODMode
            end
        end

        % Button pushed function: IndividualAxisControlBotton
        function IndividualAxisControlBottonPushed(app, event)
            if ( app.Edata.Individual )  % OverRide Switches on/off
                app.IndividualSet = 0;
                SendObj( [hex2dec('2508'),8,app.CanId(2)] , 1 , GetDataType('long') , 'Reset individual control ' ) ;
                %SetIndividual(app, app.IndividualSet) ; 
            else
                    SendObj( [hex2dec('2506'),0,app.CanId(2)] , 1 , GetDataType('long') , 'reset CwOwner ' ) ; % reset PackageGripByODMode
                app.CwOwnerSet = 1;
                app.IndividualSet = 1;
                SendObj( [hex2dec('2508'),7,app.CanId(2)] , 1 , GetDataType('long') , 'Set manipulator to individual control' ) ;

                %verify moving to individual
                ManipActivationStatus = FetchObj( [hex2dec('250f'),0,app.CanId(2)] , app.DataType.long , 'Get auto activation status' )  ;
                Individual = bitgetvalue(ManipActivationStatus, 1);
                
                if Individual
                    SendObj( [hex2dec('2508'),139,app.CanId(2)] , app.LogicId.TAPEARM , GetDataType('long') , 'set tapearm PTP ref mode' ) ;%set PTP 
                    SendObj( [hex2dec('2508'),139,app.CanId(2)] , app.LogicId.PLATE , GetDataType('long') , 'set plate PTP ref mode' ) ;%set PTP       
                    SendObj( [hex2dec('2508'),139,app.CanId(2)] , app.LogicId.SPACER , GetDataType('long') , 'set spacer PTP ref mode' ) ;%set PTP 
                else
                    msbox(app, 'Changing mode to individual did not succeed.');
                end
                %seting PackageGripByODModeSet (hence giving control of the CW to core1)
                %SetIndividual(app, app.IndividualSet) ; 
            end
        end

        % Button pushed function: AutoManipControlButton
        function PackageGripByODModeButtonPushed(app, event)
            if ( app.Edata.CwOwner )  % app.Edata.CwOwner = 0 means object dictionary can set the manipulator control word
                %reseting Individual
                app.IndividualSet = 0;
                SendObj( [hex2dec('2508'),8,app.CanId(2)] , 1023 , GetDataType('long') , 'Reset individual control ' ) ;
                
                SendObj( [hex2dec('2506'),0,app.CanId(2)] , 0 , GetDataType('long') , 'reset CwOwner ' ) ; % reset CwOwner, set PackageGripByODMode, take ownership on Cw
                app.CwOwnerSet = 0;
            else
                SendObj( [hex2dec('2506'),0,app.CanId(2)] , 1 , GetDataType('long') , 'set CwOwner ' ) ; %set PackageGripByODMode
                app.CwOwnerSet = 1;
            end
        end

        % Button pushed function: ClearDetailButton
        function ClearDetailButtonPushed(app, event)
            app.ProblemsTextArea.Value = '' ; 
        end

        % Cell edit callback: UITable
        function UITableCellEdit(app, event)
            indices = event.Indices;
            newData = event.NewData;
            SetFloatPar(convertStringsToChars(app.UITable.Data(indices(1),1)),str2double(newData),'2') ;  % Description
            UpdateManGeoParameters(app);
        end

        % Value changed function: TapeTarget
        function TapeTargetValueChanged(app, event)
            value = app.TapeTarget.Value;
            if ((value > app.Package.maxYPacakge) || (value < app.Package.minYPacakge))
                app.TapeTarget.Value = 0;
                LogException(app,'Tape arm target out of range.');
            end
        end

        % Value changed function: PlaceTargetDeg
        function PlaceTargetDegValueChanged(app, event)
            value = app.PlaceTargetDeg.Value;
            if (( deg2rad(value) > app.ManGeo.FlexMaxAngle) || (deg2rad(value) < -app.ManGeo.FlexMaxAngle))
                app.PlaceTargetDeg.Value = 0;
                LogException(app,'Plate target out of range.');
            end
        end

        % Value changed function: ShifterTarget
        function ShifterTargetValueChanged(app, event)
            value = app.ShifterTarget.Value;
            if ((value > app.ManGeo.FlexMaxLinearTravel) || (value < 0))
                app.ShifterTarget.Value = 0;
                LogException(app,'Plate target out of range.');
            end
        end

        % Button pushed function: EefSyncEnButton
        function EefSyncEnButtonButtonPushed(app, event)
            if ( app.Edata.EefSyncEnBit )  % EefSyncEn on/off
                SendObj( [hex2dec('2505'),4,app.CanId(2)] , 0 , GetDataType('long') , 'reset EefSyncEn ' ) ;%set EefSyncEn
            else
                % reseting PackageGripByODMode
                SendObj( [hex2dec('2505'),4,app.CanId(2)] , 1 , GetDataType('long') , 'reset EefSyncEn ' ) ;%set EefSyncEn
            end
        end

        % Button pushed function: TapePTPRefModeButton
        function TapePTPRefModeButtonPushed(app, event)
            % Set to E_PosModePTP reference mode & E_LoopClosureMode to E_LC_Pos_Mode/ E_LC_Dual_Pos_Mode
            SendObj( [hex2dec('2508'),139,app.CanId(2)] , app.LogicId.TAPEARM , GetDataType('long') , 'set tapearm PTP ref mode' ) ;%set Homing direction
        end

        % Button pushed function: PlatePTPRefModeButton
        function PlatePTPRefModeButtonPushed(app, event)
            % Set to E_PosModePTP reference mode & E_LoopClosureMode to E_LC_Pos_Mode/ E_LC_Dual_Pos_Mode
            SendObj( [hex2dec('2508'),139,app.CanId(2)] , app.LogicId.PLATE , GetDataType('long') , 'set plate PTP ref mode' ) ;%set Homing direction
        end

        % Button pushed function: ShifterPTPRefModeButton
        function ShifterPTPRefModeButtonPushed(app, event)
            % Set to E_PosModePTP reference mode & E_LoopClosureMode to E_LC_Pos_Mode/ E_LC_Dual_Pos_Mode
            SendObj( [hex2dec('2508'),139,app.CanId(2)] , app.LogicId.SPACER , GetDataType('long') , 'set spacer PTP ref mode' ) ;%set Homing direction
        end

        % Button pushed function: TapeSpeedRefModeButton
        function TapeSpeedRefModeButtonPushed(app, event)
            % Set to E_RefModeSpeed reference mode & E_LoopClosureMode to E_LC_Pos_Mode/ E_LC_Dual_Pos_Mode
            SendObj( [hex2dec('2508'),138,app.CanId(2)] , app.LogicId.TAPEARM , GetDataType('long') , 'set tapearm speed ref mode' ) ;%set Homing direction
        end

        % Button pushed function: PlateSpeedRefModeButton
        function PlateSpeedRefModeButtonPushed(app, event)
            % Set to E_RefModeSpeed reference mode & E_LoopClosureMode to E_LC_Pos_Mode/ E_LC_Dual_Pos_Mode
            SendObj( [hex2dec('2508'),138,app.CanId(2)] , app.LogicId.PLATE , GetDataType('long') , 'set plate speed ref mode' ) ;%set Homing direction
        end

        % Button pushed function: ShifterSpeedRefModeButton
        function ShifterSpeedRefModeButtonPushed(app, event)
            % Set to E_RefModeSpeed reference mode & E_LoopClosureMode to E_LC_Pos_Mode/ E_LC_Dual_Pos_Mode
            SendObj( [hex2dec('2508'),138,app.CanId(2)] , app.LogicId.SPACER , GetDataType('long') , 'set tapearm speed ref mode' ) ;%set Homing direction
            
        end

        % Button pushed function: SpacerHomeDirButton
        function SpacerHomeDirButtonPushed(app, event)
            %value = app.HomePositiveDirectionCheckBox.Value;
            
            SendObj( [hex2dec('2508'),13,app.CanId(2)] , -app.Edata.ShifterHomeDiretion , GetDataType('long') , 'set Homing direction' ) ;%set Homing direction

        end

        % Button pushed function: StByPosButton_2
        function StByPosButton_2Pushed(app, event)
            app.TapeTarget.Value = app.ManGeo.FlexStandbyExtPos; 
        end

        % Button pushed function: SySModeStayBotton
        function SySModeStayBottonButtonPushed(app, event)
            if app.Edata.CwOwner == 0 %which means that we the LP is not the owner!!!
                SendObj( [hex2dec('2506'),13,app.CanId(2)] , 2 , GetDataType('short') , 'Reday for Flex manip change mode - go to stayInPlace' ) ; %E_SysMotionModeStay = 2
                %SendObj( [hex2dec('2506'),1,app.CanId(2)] , 0 , GetDataType('short') , 'Flex manip motors on - go to AutomaticIdleState' ) ;
            end
        end

        % Button pushed function: KillHomingButton
        function KillHomingButtonPushed(app, event)
            if (app.Edata.CwOwner == 0 )  %which means that we the LP is not the owner!!!
                cw = 1 + 2 * app.Edata.ServoMotorOn + 128 ; % automatic = 1, MotorsOn - keep as is, kill homing = 64
                SendObj( [hex2dec('2506'),14,app.CanId(2)] , 1 , GetDataType('short') , 'prepare for Flex manip motors kill homing' ) ; %prepare for kill homing
                SendObj( [hex2dec('2506'),1,app.CanId(2)] , cw , GetDataType('short') , 'Flex manip motors homing' ) ; %only Automatic & motors on & kill homing bits are 1
            end
        end

        % Value changed function: DoNotLookForPackageCheckBox_2
        function DoNotLookForPackageCheckBox_2ValueChanged(app, event)
            value = app.DoNotLookForPackageCheckBox_2.Value;
            app.DoNotLookForPackageCheckBox.Value = value;
            app.DoNotLookForPackage = value;
        end

        % Value changed function: DoNotTestSuctionCheckBox_2
        function DoNotTestSuctionCheckBox_2ValueChanged(app, event)
            value = app.DoNotTestSuctionCheckBox_2.Value;
            app.DoNotTestSuctionCheckBox.Value = value;
            app.DoNotTestSuction = value;
        end

        % Button pushed function: IndividualAxisControlBotton_2
        function IndividualAxisControlBotton_2ButtonPushed(app, event)
            SendObj( [hex2dec('2508'),136,app.CanId(2)] , 1 , GetDataType('long') , 'update to new speeds' ) ; %prepare for kill homing
        end

        % Button pushed function: GotopostureButton
        function GotopostureButtonPushed(app, event)
            if app.Edata.CwOwner == 0 %which means that we the LP is not the owner!!!
                app.ControlWordCopy = 1 + 2 ; % automatic = 1, MotorsOn = 2, standBy = 4
                SendObj( [hex2dec('2506'),20,app.CanId(2)] , app.PlaceTargetDeg_2.Value/180*pi() , GetDataType('float') , 'set PlateOdCmd' ) ;
                SendObj( [hex2dec('2506'),21,app.CanId(2)] , app.ShifterTarget_2.Value , GetDataType('float') , 'set SpacerOdCmd' ) ;
                SendObj( [hex2dec('2506'),22,app.CanId(2)] , app.TapeTarget_2.Value , GetDataType('float') , 'set TapearmOdCmd' ) ;
                SendObj( [hex2dec('2506'),23,app.CanId(2)] , double(app.OnRailsCheckBox.Value) , GetDataType('long') , 'set on rails flag' ) ;
                SendObj( [hex2dec('2506'),29,app.CanId(2)] , 0 , GetDataType('short') , 'Send get ready for posture command' ) ; 
                SendObj( [hex2dec('2506'),1,app.CanId(2)] , app.ControlWordCopy , GetDataType('short') , 'perform command' ) ;
            end
        end

        % Button pushed function: StByPosButton_3
        function StByPosButton_3Pushed(app, event)
            app.ShifterTarget_2.Value = app.ManGeo.ShelfTrackPoint1Pos; 
        end

        % Button pushed function: ShelfPosButton_2
        function ShelfPosButton_2Pushed(app, event)
            app.ShifterTarget_2.Value = app.ManGeo.ShelfTrackPoint4Pos; 
        end

        % Button pushed function: RotatePosButton_2
        function RotatePosButton_2Pushed(app, event)
            app.ShifterTarget_2.Value = app.ManGeo.ShelfTrackPoint2Pos;  
        end

        % Button pushed function: SettapeStByPosButton
        function SettapeStByPosButtonPushed(app, event)
            app.TapeTarget_2.Value = app.ManGeo.FlexStandbyExtPos; 
        end

        % Button pushed function: PosturefixtolegalButton
        function PosturefixtolegalButtonPushed(app, event)
            if app.Edata.CwOwner == 0 %which means that we the LP is not the owner!!!
                app.ControlWordCopy = 1 + 2 + app.OnRailsCheckBox_2.Value * 32768 ; % automatic = 1, MotorsOn = 2, 32768 - on rail
                SendObj( [hex2dec('2506'),15,app.CanId(2)] , 0 , GetDataType('short') , 'Send get ready for posture fix' ) ; 
                SendObj( [hex2dec('2506'),1,app.CanId(2)] , app.ControlWordCopy , GetDataType('short') , 'Send get ready for stand by' ) ;
            end
        end

        % Button pushed function: CurrentPosButton_2
        function CurrentPosButton_2Pushed(app, event)
            app.PlaceTargetDeg_2.Value = round( app.Edata.RotaryDeg, 1);
        end

        % Button pushed function: CurrentPosButton
        function CurrentPosButtonPushed(app, event)
            app.ShifterTarget_2.Value = round( app.Edata.SpacerPos, 3);
        end

        % Button pushed function: CurrentPosButton_3
        function CurrentPosButton_3Pushed(app, event)
             app.TapeTarget_2.Value = round( app.Edata.FlexPos, 3 );
        end

        % Button pushed function: LaserCalibBotton
        function LaserCalibButtonPushed(app, event)

                if (app.Edata.LaserCalibOn)
                    %notify the EEF on calibration start - will transmit raw measurement
                    SendObj( [hex2dec('2505'),20,app.CanId(2)] ,0 , GetDataType('long') , 'Start calibration ' ) ;%tcalibration
                    return ;
                end 

                laserOnState = app.Edata.LaserOn;
                
                SendObj( [hex2dec('2505'),20,app.CanId(2)] ,hex2dec('ABCDEFAB')  , GetDataType('long') , 'Start calibration ' ) ;%tcalibration

                answer = questdlg({'\fontsize{12}Are you sure you want to calibrate the laser?', 'The laser will be turned on!'}, 'Calibration verification', ...
                                         'Yes', 'Abort', struct ('Default','Abort','Interpreter','tex') );     %the default button is Abort, the interpreter is tex
                if ~isequal(answer,'Yes')
                    return ; 
                end  

                SendObj( [hex2dec('2505'),11,app.CanId(2)] , 1 , GetDataType('long') , 'Set laser on ' ) ; %turn laser on 
                app.LaserOnState = 1;
                %notify the EEF on calibration start - will transmit raw measurement
                SendObj( [hex2dec('2505'),20,app.CanId(2)] ,1 , GetDataType('long') , 'Start calibration ' ) ;%tcalibration

                questdlg({'\fontsize{12}Locate the calibration jig at position 1 (12cm) (suction cups) and press Continue:'}, 'Laser calibration', ...
                                         'Continue', struct ('Default','Continue','Interpreter','tex') );     %the default button is Continue, the interpreter is tex
                
                %calibP1RawVoltage =  FetchObj( [hex2dec('2510'),1,app.CanId(2)] , app.DataType.long , 'Laser Median' ) ;
                calibP1RawVoltage = app.Edata.LaserMedian;
                calibP1Distance = 0.12; %m

                questdlg({'\fontsize{12}Locate the calibration jig at position 2 (25cm) (suction cups) and press Continue:'}, 'Laser calibration', ...
                                         'Continue', struct ('Default','Continue','Interpreter','tex') );     %the default button is Continue, the interpreter is tex
                
                calibP2RawVoltage =  app.Edata.LaserMedian ;
                calibP2Distance = 0.25; %m

                questdlg({'\fontsize{12}Locate the calibration jig at position 3 (50cm) (suction cups) and press Continue:'}, 'Laser calibration', ...
                                         'Continue', struct ('Default','Continue','Interpreter','tex') );     %the default button is Continue, the interpreter is tex
                
                calibP3RawVoltage =  app.Edata.LaserMedian ;
                calibP3Distance = 0.5; %m

                x = [calibP1Distance, calibP2Distance, calibP3Distance];
                y = [calibP1RawVoltage, calibP2RawVoltage, calibP3RawVoltage];
                poly = polyfit(x, y, 1);

                errorPercentage = round( max( abs(polyval(poly, x) - y) ./y ) * 100 , 0 );

                figure(120);
                x1 = [0:0.005:2];
                plot(x,y,'rx',x,polyval(poly, x),'bo', x1, polyval(poly, x1), 'g-');

                %notify the EEF on calibration start - will transmit raw measurement
                SendObj( [hex2dec('2505'),20,app.CanId(2)] ,0 , GetDataType('long') , 'Start calibration ' ) ;%tcalibration

                if (~laserOnState)
                    SendObj( [hex2dec('2505'),11,app.CanId(2)] , 0 , GetDataType('long') , 'Set laser off ' ) ;%turn laser off 
                    app.LaserOnState = 0;
                end

                if ( errorPercentage>2 || abs(poly(1)-1)>0.2 || poly(2)>0.02 ) 
                    str = sprintf('The polynomial constants are: m=%.3f, %.3f.',poly(1), poly(2));

                    questdlg({strcat('\fontsize{12}The linearity error for the measured distances is:  ', num2str(errorPercentage), '%.'),...
                          str, 'The calibration error is too high. Calibration aborted.'}, 'Laser calibration abort', ...
                                         'Abort',  struct ('Default','Abort','Interpreter','tex') );     %the default button is Continue, the interpreter is tex
                    close(120);
                    return ; 
                end

                str = sprintf('The polynomial constants are: m=%.3f, %.3f.',poly(1), poly(2));

                answer = questdlg({strcat('\fontsize{12}The linearity error for the measured distances is:  ', num2str(errorPercentage), '%.'),...
                          str,'Would you like to upload new calibration?'}, 'Laser calibration', ...
                                         'Continue', 'Abort',  struct ('Default','Abort','Interpreter','tex') );     %the default button is Continue, the interpreter is tex

                close(120);

                if ~isequal(answer,'Continue')
                    return ; 
                end  

                %upload the calibration values to the EEF:
                SendObj( [hex2dec('2505'),21,app.CanId(2)] ,poly(1)  , GetDataType('float') , 'laser calibration - slop' ) ;%tcalibration
                SendObj( [hex2dec('2505'),22,app.CanId(2)] ,poly(2)  , GetDataType('float') , 'laser calibration - slop' ) ;%tcalibration

        end

        % Button pushed function: LaserCalibBotton_2
        function LaserCalibBotton_2ButtonPushed(app, event)
            answer = questdlg({'\fontsize{12}Are you sure you want to delete the calibration of the laser?'}, 'Calibration reset', ...
                                         'Yes', 'Abort', struct ('Default','Abort','Interpreter','tex') );     %the default button is Abort, the interpreter is tex
            if ~isequal(answer,'Yes')
                return ; 
            end  

            SendObj( [hex2dec('2505'),23,app.CanId(2)] ,1  , GetDataType('long') , 'reset calibration ' ) ;%tcalibration
        end

        % Button pushed function: EefSyncEnButton_2
        function EefSyncEnButton_2Pushed(app, event)
            SendObj( [hex2dec('2506'),99,app.CanId(2)] ,1  , GetDataType('long') , 'fatal error recovery ' ) ;%fatal error recovery
        end

        % Button pushed function: TapeMotorBrakeReleasedBotton
        function TapeMotorBrakeReleasedBottonButtonPushed(app, event)
            if ( app.Edata.TapeArmBrakeReleased ) 
                SendObj( [hex2dec('2508'),161,app.CanId(2)] , app.LogicId.TAPEARM , GetDataType('long') , 'engage brake ' ) ;
            else
                SendObj( [hex2dec('2508'),160,app.CanId(2)] , app.LogicId.TAPEARM , GetDataType('long') , 'Release brake ' ) ;
            end
        end

        % Button pushed function: PlateMotorBrakeReleaseButton
        function PlateMotorBrakeReleaseButtonButtonPushed(app, event)
            if ( app.Edata.PlateBrakeReleased ) 
                SendObj( [hex2dec('2508'),161,app.CanId(2)] , app.LogicId.PLATE , GetDataType('long') , 'engage brake ' ) ;
            else
                SendObj( [hex2dec('2508'),160,app.CanId(2)] , app.LogicId.PLATE , GetDataType('long') , 'release brake ' ) ;
            end
        end

        % Button pushed function: RemoteControlButton
        function RemoteControlButtonPushed(app, event)
            if ( app.Edata.NeckWheelsControlBit ) 
                SendObj( [hex2dec('2508'),170,app.CanId(2)] , 0 , GetDataType('long') , 'Set remote control off ' ) ;
                SendObj( [hex2dec('2220'),46,app.CanId(1)] , 0 , GetDataType('long') , 'Force control by core2 for debug ' ) ;
            else
                SendObj( [hex2dec('2508'),170,app.CanId(2)] , 1 , GetDataType('long') , 'Set remote control on ' ) ;
                SendObj( [hex2dec('2220'),46,app.CanId(1)] , 4321 , GetDataType('long') , 'Force control by core2 for debug ' ) ;
            end
        end

        % Button pushed function: GoNeck
        function GoNeckButtonPushed(app, event)
            SendObj( [hex2dec('2508'),175,app.CanId(2)] , app.NeckSetTargetDeg.Value/180*pi() , GetDataType('float') , 'Set Neck Angle' ) ;
            SendObj( [hex2dec('2508'),171,app.CanId(2)] , 1 , GetDataType('long') , 'Set Neck command valid ' ) ;
        end

        % Button pushed function: SetCurrentPosButton
        function SetCurrentPosButtonPushed(app, event)
             app.NeckSetTargetDeg.Value = app.Edata.NeckAngle;
        end
    end

    % Component initialization
    methods (Access = private)

        % Create UIFigure and components
        function createComponents(app)

            % Create UIFigure and hide until all components are created
            app.UIFigure = uifigure('Visible', 'off');
            app.UIFigure.Position = [100 100 1038 917];
            app.UIFigure.Name = 'MATLAB App';
            app.UIFigure.CloseRequestFcn = createCallbackFcn(app, @UIFigureCloseRequest, true);
            app.UIFigure.Scrollable = 'on';

            % Create FlexManipulatordashboardLabel
            app.FlexManipulatordashboardLabel = uilabel(app.UIFigure);
            app.FlexManipulatordashboardLabel.FontSize = 24;
            app.FlexManipulatordashboardLabel.FontWeight = 'bold';
            app.FlexManipulatordashboardLabel.FontAngle = 'italic';
            app.FlexManipulatordashboardLabel.FontColor = [1 0 0];
            app.FlexManipulatordashboardLabel.Position = [23 870 457 31];
            app.FlexManipulatordashboardLabel.Text = 'Flex Manipulator dashboard';

            % Create TabGroup
            app.TabGroup = uitabgroup(app.UIFigure);
            app.TabGroup.Position = [24 245 658 574];

            % Create AutoManipulatorControlTab
            app.AutoManipulatorControlTab = uitab(app.TabGroup);
            app.AutoManipulatorControlTab.Title = 'Auto Manipulator Control';

            % Create DealPackagePanel
            app.DealPackagePanel = uipanel(app.AutoManipulatorControlTab);
            app.DealPackagePanel.Title = 'Deal Package (required to disable EEF Auto grip control/ EEF manual activation)';
            app.DealPackagePanel.Position = [16 32 627 146];

            % Create DealPackageButton
            app.DealPackageButton = uibutton(app.DealPackagePanel, 'push');
            app.DealPackageButton.ButtonPushedFcn = createCallbackFcn(app, @DealPackageButtonPushed, true);
            app.DealPackageButton.Position = [129 51 109 29];
            app.DealPackageButton.Text = 'Deal Package';

            % Create SideSwitch
            app.SideSwitch = uiswitch(app.DealPackagePanel, 'slider');
            app.SideSwitch.Items = {'Left', 'Right'};
            app.SideSwitch.ValueChangedFcn = createCallbackFcn(app, @SideSwitchValueChanged, true);
            app.SideSwitch.Position = [327 90 45 20];
            app.SideSwitch.Value = 'Left';

            % Create DistancefromRobotCentermabsvalueLabel
            app.DistancefromRobotCentermabsvalueLabel = uilabel(app.DealPackagePanel);
            app.DistancefromRobotCentermabsvalueLabel.Position = [19 82 134 35];
            app.DistancefromRobotCentermabsvalueLabel.Text = {'Distance from Robot'; 'Center [m] (abs value)'};

            % Create DistancefromRobotValueEditField
            app.DistancefromRobotValueEditField = uieditfield(app.DealPackagePanel, 'numeric');
            app.DistancefromRobotValueEditField.ValueChangedFcn = createCallbackFcn(app, @DistancefromRobotValueEditFieldValueChanged, true);
            app.DistancefromRobotValueEditField.Position = [19 53 100 22];

            % Create GetPackageSwitch
            app.GetPackageSwitch = uiswitch(app.DealPackagePanel, 'slider');
            app.GetPackageSwitch.Items = {'Get Package', 'Set Package'};
            app.GetPackageSwitch.ValueChangedFcn = createCallbackFcn(app, @GetPackageSwitchValueChanged, true);
            app.GetPackageSwitch.Position = [327 54 45 20];
            app.GetPackageSwitch.Value = 'Get Package';

            % Create DoNotTestSuctionCheckBox_2
            app.DoNotTestSuctionCheckBox_2 = uicheckbox(app.DealPackagePanel);
            app.DoNotTestSuctionCheckBox_2.ValueChangedFcn = createCallbackFcn(app, @DoNotTestSuctionCheckBox_2ValueChanged, true);
            app.DoNotTestSuctionCheckBox_2.Visible = 'off';
            app.DoNotTestSuctionCheckBox_2.Text = 'Do not test suction';
            app.DoNotTestSuctionCheckBox_2.Position = [90 17 121 22];

            % Create DoNotLookForPackageCheckBox_2
            app.DoNotLookForPackageCheckBox_2 = uicheckbox(app.DealPackagePanel);
            app.DoNotLookForPackageCheckBox_2.ValueChangedFcn = createCallbackFcn(app, @DoNotLookForPackageCheckBox_2ValueChanged, true);
            app.DoNotLookForPackageCheckBox_2.Visible = 'off';
            app.DoNotLookForPackageCheckBox_2.Text = 'Do not look for package';
            app.DoNotLookForPackageCheckBox_2.Position = [267 17 149 22];

            % Create NeckGetPosTarger
            app.NeckGetPosTarger = uilabel(app.DealPackagePanel);
            app.NeckGetPosTarger.Position = [486 95 118 22];
            app.NeckGetPosTarger.Text = 'Neck get angle (Deg)';

            % Create NeckGetTargetDeg
            app.NeckGetTargetDeg = uieditfield(app.DealPackagePanel, 'numeric');
            app.NeckGetTargetDeg.ValueDisplayFormat = '%.3f';
            app.NeckGetTargetDeg.Position = [500 74 89 22];

            % Create NeckPutPosTarger
            app.NeckPutPosTarger = uilabel(app.DealPackagePanel);
            app.NeckPutPosTarger.Position = [486 45 118 22];
            app.NeckPutPosTarger.Text = 'Neck put angle (Deg)';

            % Create NeckPutTargetDeg
            app.NeckPutTargetDeg = uieditfield(app.DealPackagePanel, 'numeric');
            app.NeckPutTargetDeg.ValueDisplayFormat = '%.3f';
            app.NeckPutTargetDeg.Position = [500 24 89 22];

            % Create SySModeAutoIdleButton
            app.SySModeAutoIdleButton = uibutton(app.AutoManipulatorControlTab, 'push');
            app.SySModeAutoIdleButton.ButtonPushedFcn = createCallbackFcn(app, @SySModeAutoIdleButtonPushed, true);
            app.SySModeAutoIdleButton.Position = [11 445 214 23];
            app.SySModeAutoIdleButton.Text = 'System mode Automatic Idle /  STOP';

            % Create SySModeAutoIdleLamp
            app.SySModeAutoIdleLamp = uilamp(app.AutoManipulatorControlTab);
            app.SySModeAutoIdleLamp.Position = [232 446 20 20];
            app.SySModeAutoIdleLamp.Color = [1 0 0];

            % Create RefmodeLabel_4
            app.RefmodeLabel_4 = uilabel(app.AutoManipulatorControlTab);
            app.RefmodeLabel_4.HorizontalAlignment = 'right';
            app.RefmodeLabel_4.Position = [30 505 78 22];
            app.RefmodeLabel_4.Text = 'System Mode';

            % Create systemModeTextArea
            app.systemModeTextArea = uieditfield(app.AutoManipulatorControlTab, 'text');
            app.systemModeTextArea.Editable = 'off';
            app.systemModeTextArea.BackgroundColor = [0 1 1];
            app.systemModeTextArea.Position = [123 504 64 22];

            % Create SySModeAutoLamp
            app.SySModeAutoLamp = uilamp(app.AutoManipulatorControlTab);
            app.SySModeAutoLamp.Position = [232 416 20 20];
            app.SySModeAutoLamp.Color = [1 0 0];

            % Create SySModeStayBotton
            app.SySModeStayBotton = uibutton(app.AutoManipulatorControlTab, 'push');
            app.SySModeStayBotton.ButtonPushedFcn = createCallbackFcn(app, @SySModeStayBottonButtonPushed, true);
            app.SySModeStayBotton.Position = [12 475 211 23];
            app.SySModeStayBotton.Text = 'System mode Stay In Place';

            % Create SySModeStayLamp
            app.SySModeStayLamp = uilamp(app.AutoManipulatorControlTab);
            app.SySModeStayLamp.Position = [232 476 20 20];
            app.SySModeStayLamp.Color = [1 0 0];

            % Create SystemmodeAutomaticLabel
            app.SystemmodeAutomaticLabel = uilabel(app.AutoManipulatorControlTab);
            app.SystemmodeAutomaticLabel.HorizontalAlignment = 'right';
            app.SystemmodeAutomaticLabel.Position = [48 416 134 22];
            app.SystemmodeAutomaticLabel.Text = 'System mode Automatic';

            % Create GoToPosturePanel
            app.GoToPosturePanel = uipanel(app.AutoManipulatorControlTab);
            app.GoToPosturePanel.Title = 'Go To Posture';
            app.GoToPosturePanel.Position = [17 210 512 176];

            % Create GotopostureButton
            app.GotopostureButton = uibutton(app.GoToPosturePanel, 'push');
            app.GotopostureButton.ButtonPushedFcn = createCallbackFcn(app, @GotopostureButtonPushed, true);
            app.GotopostureButton.BackgroundColor = [0.302 0.7451 0.9333];
            app.GotopostureButton.Position = [288 96 117 36];
            app.GotopostureButton.Text = 'Go to posture';

            % Create TapetargetmLabel
            app.TapetargetmLabel = uilabel(app.GoToPosturePanel);
            app.TapetargetmLabel.Position = [111 34 86 22];
            app.TapetargetmLabel.Text = 'Tape target (m)';

            % Create TapeTarget_2
            app.TapeTarget_2 = uieditfield(app.GoToPosturePanel, 'numeric');
            app.TapeTarget_2.ValueDisplayFormat = '%.3f';
            app.TapeTarget_2.Position = [108 12 87 22];

            % Create PlatePosTarger_2
            app.PlatePosTarger_2 = uilabel(app.GoToPosturePanel);
            app.PlatePosTarger_2.Position = [106 125 100 22];
            app.PlatePosTarger_2.Text = 'Plate target (Deg)';

            % Create PlaceTargetDeg_2
            app.PlaceTargetDeg_2 = uieditfield(app.GoToPosturePanel, 'numeric');
            app.PlaceTargetDeg_2.ValueDisplayFormat = '%.3f';
            app.PlaceTargetDeg_2.Position = [106 104 89 22];

            % Create ShifterPositiontargetLabel_2
            app.ShifterPositiontargetLabel_2 = uilabel(app.GoToPosturePanel);
            app.ShifterPositiontargetLabel_2.Position = [110 80 95 22];
            app.ShifterPositiontargetLabel_2.Text = 'Shifter target (m)';

            % Create ShifterTarget_2
            app.ShifterTarget_2 = uieditfield(app.GoToPosturePanel, 'numeric');
            app.ShifterTarget_2.ValueDisplayFormat = '%.3f';
            app.ShifterTarget_2.Position = [106 59 87 22];

            % Create SettapeStByPosButton
            app.SettapeStByPosButton = uibutton(app.GoToPosturePanel, 'push');
            app.SettapeStByPosButton.ButtonPushedFcn = createCallbackFcn(app, @SettapeStByPosButtonPushed, true);
            app.SettapeStByPosButton.Position = [272 11 128 25];
            app.SettapeStByPosButton.Text = 'Set tape St.By. Pos';

            % Create RotatePosButton_2
            app.RotatePosButton_2 = uibutton(app.GoToPosturePanel, 'push');
            app.RotatePosButton_2.ButtonPushedFcn = createCallbackFcn(app, @RotatePosButton_2Pushed, true);
            app.RotatePosButton_2.Position = [368 51 50 37];
            app.RotatePosButton_2.Text = {'Rotate'; 'Pos'};

            % Create StByPosButton_3
            app.StByPosButton_3 = uibutton(app.GoToPosturePanel, 'push');
            app.StByPosButton_3.ButtonPushedFcn = createCallbackFcn(app, @StByPosButton_3Pushed, true);
            app.StByPosButton_3.Position = [268 50 46 37];
            app.StByPosButton_3.Text = {'St.By.'; 'Pos'};

            % Create ShelfPosButton_2
            app.ShelfPosButton_2 = uibutton(app.GoToPosturePanel, 'push');
            app.ShelfPosButton_2.ButtonPushedFcn = createCallbackFcn(app, @ShelfPosButton_2Pushed, true);
            app.ShelfPosButton_2.Position = [320 51 42 37];
            app.ShelfPosButton_2.Text = {'Shelf'; 'Pos'};

            % Create OnRailsCheckBox
            app.OnRailsCheckBox = uicheckbox(app.GoToPosturePanel);
            app.OnRailsCheckBox.Text = 'On rails';
            app.OnRailsCheckBox.Position = [312 130 63 22];

            % Create TapeCurrentPos_2
            app.TapeCurrentPos_2 = uilabel(app.GoToPosturePanel);
            app.TapeCurrentPos_2.BackgroundColor = [0 1 1];
            app.TapeCurrentPos_2.FontSize = 18;
            app.TapeCurrentPos_2.FontWeight = 'bold';
            app.TapeCurrentPos_2.FontColor = [0.7176 0.2745 1];
            app.TapeCurrentPos_2.Position = [10 12 87 23];

            % Create PlateCurrentPosDeg_2
            app.PlateCurrentPosDeg_2 = uilabel(app.GoToPosturePanel);
            app.PlateCurrentPosDeg_2.BackgroundColor = [0 1 1];
            app.PlateCurrentPosDeg_2.FontSize = 18;
            app.PlateCurrentPosDeg_2.FontWeight = 'bold';
            app.PlateCurrentPosDeg_2.FontColor = [0.7176 0.2745 1];
            app.PlateCurrentPosDeg_2.Position = [10 104 87 23];

            % Create ShifterCurrentPos_2
            app.ShifterCurrentPos_2 = uilabel(app.GoToPosturePanel);
            app.ShifterCurrentPos_2.BackgroundColor = [0 1 1];
            app.ShifterCurrentPos_2.FontSize = 18;
            app.ShifterCurrentPos_2.FontWeight = 'bold';
            app.ShifterCurrentPos_2.FontColor = [0.7176 0.2745 1];
            app.ShifterCurrentPos_2.Position = [11 59 86 23];

            % Create PlatePosTarger_3
            app.PlatePosTarger_3 = uilabel(app.GoToPosturePanel);
            app.PlatePosTarger_3.Position = [8 126 88 22];
            app.PlatePosTarger_3.Text = 'Plate pos (Deg)';

            % Create ShifterPositiontargetLabel_3
            app.ShifterPositiontargetLabel_3 = uilabel(app.GoToPosturePanel);
            app.ShifterPositiontargetLabel_3.Position = [8 78 84 22];
            app.ShifterPositiontargetLabel_3.Text = 'Shifter pos (m)';

            % Create TapeposmLabel
            app.TapeposmLabel = uilabel(app.GoToPosturePanel);
            app.TapeposmLabel.Position = [9 32 75 22];
            app.TapeposmLabel.Text = 'Tape pos (m)';

            % Create CurrentPosButton
            app.CurrentPosButton = uibutton(app.GoToPosturePanel, 'push');
            app.CurrentPosButton.ButtonPushedFcn = createCallbackFcn(app, @CurrentPosButtonPushed, true);
            app.CurrentPosButton.Position = [204 51 58 38];
            app.CurrentPosButton.Text = {'Current '; 'Pos'};

            % Create CurrentPosButton_2
            app.CurrentPosButton_2 = uibutton(app.GoToPosturePanel, 'push');
            app.CurrentPosButton_2.ButtonPushedFcn = createCallbackFcn(app, @CurrentPosButton_2Pushed, true);
            app.CurrentPosButton_2.Position = [204 98 58 38];
            app.CurrentPosButton_2.Text = {'Current '; 'Pos'};

            % Create CurrentPosButton_3
            app.CurrentPosButton_3 = uibutton(app.GoToPosturePanel, 'push');
            app.CurrentPosButton_3.ButtonPushedFcn = createCallbackFcn(app, @CurrentPosButton_3Pushed, true);
            app.CurrentPosButton_3.Position = [204 5 58 38];
            app.CurrentPosButton_3.Text = {'Current '; 'Pos'};

            % Create YpositionLabel
            app.YpositionLabel = uilabel(app.GoToPosturePanel);
            app.YpositionLabel.Position = [440 73 58 22];
            app.YpositionLabel.Text = 'Y position';

            % Create YPosition
            app.YPosition = uilabel(app.GoToPosturePanel);
            app.YPosition.BackgroundColor = [0 1 1];
            app.YPosition.FontSize = 18;
            app.YPosition.FontWeight = 'bold';
            app.YPosition.FontColor = [1 0 0];
            app.YPosition.Position = [427 55 77 23];

            % Create AnglePosition
            app.AnglePosition = uilabel(app.GoToPosturePanel);
            app.AnglePosition.BackgroundColor = [0 1 1];
            app.AnglePosition.FontSize = 18;
            app.AnglePosition.FontWeight = 'bold';
            app.AnglePosition.FontColor = [1 0 0];
            app.AnglePosition.Position = [427 5 75 23];

            % Create AngledegLabel
            app.AngledegLabel = uilabel(app.GoToPosturePanel);
            app.AngledegLabel.Position = [441 27 59 22];
            app.AngledegLabel.Text = 'Angle deg';

            % Create XpositionLabel
            app.XpositionLabel = uilabel(app.GoToPosturePanel);
            app.XpositionLabel.Position = [443 126 58 22];
            app.XpositionLabel.Text = 'X position';

            % Create XPosition
            app.XPosition = uilabel(app.GoToPosturePanel);
            app.XPosition.BackgroundColor = [0 1 1];
            app.XPosition.FontSize = 18;
            app.XPosition.FontWeight = 'bold';
            app.XPosition.FontColor = [1 0 0];
            app.XPosition.Position = [429 103 77 23];

            % Create Panel
            app.Panel = uipanel(app.AutoManipulatorControlTab);
            app.Panel.Position = [267 413 262 119];

            % Create GotoStandByButton
            app.GotoStandByButton = uibutton(app.Panel, 'push');
            app.GotoStandByButton.ButtonPushedFcn = createCallbackFcn(app, @GotoStandByButtonPushed, true);
            app.GotoStandByButton.Position = [120 48 126 23];
            app.GotoStandByButton.Text = 'Go to Stand By';

            % Create HomedLamp
            app.HomedLamp = uilamp(app.Panel);
            app.HomedLamp.Position = [227 80 20 20];
            app.HomedLamp.Color = [1 0 0];

            % Create DoHomingButton
            app.DoHomingButton = uibutton(app.Panel, 'push');
            app.DoHomingButton.ButtonPushedFcn = createCallbackFcn(app, @DoHomingButtonPushed, true);
            app.DoHomingButton.Position = [120 79 100 23];
            app.DoHomingButton.Text = 'Do Homing';

            % Create OnRailsCheckBox_2
            app.OnRailsCheckBox_2 = uicheckbox(app.Panel);
            app.OnRailsCheckBox_2.Text = 'On rails';
            app.OnRailsCheckBox_2.Position = [26 66 63 22];

            % Create KillHomingButton
            app.KillHomingButton = uibutton(app.Panel, 'push');
            app.KillHomingButton.ButtonPushedFcn = createCallbackFcn(app, @KillHomingButtonPushed, true);
            app.KillHomingButton.Position = [13 17 91 23];
            app.KillHomingButton.Text = 'Kill Homing';

            % Create PosturefixtolegalButton
            app.PosturefixtolegalButton = uibutton(app.Panel, 'push');
            app.PosturefixtolegalButton.ButtonPushedFcn = createCallbackFcn(app, @PosturefixtolegalButtonPushed, true);
            app.PosturefixtolegalButton.Position = [120 17 126 23];
            app.PosturefixtolegalButton.Text = 'Posture fix to legal';

            % Create AxesIndividualControlTab
            app.AxesIndividualControlTab = uitab(app.TabGroup);
            app.AxesIndividualControlTab.Title = 'Axes Individual Control';

            % Create TapePanel_2
            app.TapePanel_2 = uipanel(app.AxesIndividualControlTab);
            app.TapePanel_2.Title = 'Tape';
            app.TapePanel_2.Position = [15 11 199 527];

            % Create PositionmLabel
            app.PositionmLabel = uilabel(app.TapePanel_2);
            app.PositionmLabel.Position = [62 421 69 22];
            app.PositionmLabel.Text = 'Position (m)';

            % Create TapeCurrentPos
            app.TapeCurrentPos = uilabel(app.TapePanel_2);
            app.TapeCurrentPos.BackgroundColor = [0 1 1];
            app.TapeCurrentPos.FontSize = 18;
            app.TapeCurrentPos.FontWeight = 'bold';
            app.TapeCurrentPos.FontColor = [0.7176 0.2745 1];
            app.TapeCurrentPos.Position = [34 401 119 23];

            % Create PositiontargetmLabel
            app.PositiontargetmLabel = uilabel(app.TapePanel_2);
            app.PositiontargetmLabel.Position = [42 378 106 22];
            app.PositiontargetmLabel.Text = 'Position  target (m)';

            % Create TapeRobotCsCheckBox
            app.TapeRobotCsCheckBox = uicheckbox(app.TapePanel_2);
            app.TapeRobotCsCheckBox.Text = 'Robot C.S.';
            app.TapeRobotCsCheckBox.Position = [30 321 81 22];

            % Create TapeGo
            app.TapeGo = uibutton(app.TapePanel_2, 'push');
            app.TapeGo.ButtonPushedFcn = createCallbackFcn(app, @TapeGoButtonPushed, true);
            app.TapeGo.Position = [122 355 46 23];
            app.TapeGo.Text = 'Go';

            % Create TapeMotorOnButton
            app.TapeMotorOnButton = uibutton(app.TapePanel_2, 'push');
            app.TapeMotorOnButton.ButtonPushedFcn = createCallbackFcn(app, @TapeMotorOnButtonPushed, true);
            app.TapeMotorOnButton.BackgroundColor = [0.9608 0.9608 0.9608];
            app.TapeMotorOnButton.Position = [12 477 60 23];
            app.TapeMotorOnButton.Text = 'Motor On';

            % Create ImmediateHomevaluemLabel
            app.ImmediateHomevaluemLabel = uilabel(app.TapePanel_2);
            app.ImmediateHomevaluemLabel.Position = [25 153 148 22];
            app.ImmediateHomevaluemLabel.Text = 'Immediate Home value [m]';

            % Create TapeSethomeButton
            app.TapeSethomeButton = uibutton(app.TapePanel_2, 'push');
            app.TapeSethomeButton.ButtonPushedFcn = createCallbackFcn(app, @TapeSethomeButtonPushed, true);
            app.TapeSethomeButton.Enable = 'off';
            app.TapeSethomeButton.Position = [25 99 144 23];
            app.TapeSethomeButton.Text = 'Set home value';

            % Create TapeAutomaticHomeButton
            app.TapeAutomaticHomeButton = uibutton(app.TapePanel_2, 'push');
            app.TapeAutomaticHomeButton.ButtonPushedFcn = createCallbackFcn(app, @TapeAutomaticHomeButtonPushed, true);
            app.TapeAutomaticHomeButton.Position = [25 72 144 23];
            app.TapeAutomaticHomeButton.Text = 'Automatic homing';

            % Create EditFieldTapeHome
            app.EditFieldTapeHome = uieditfield(app.TapePanel_2, 'numeric');
            app.EditFieldTapeHome.Editable = 'off';
            app.EditFieldTapeHome.BackgroundColor = [0 1 1];
            app.EditFieldTapeHome.Position = [51 130 87 22];

            % Create LampTapeOn
            app.LampTapeOn = uilamp(app.TapePanel_2);
            app.LampTapeOn.Position = [75 478 20 20];
            app.LampTapeOn.Color = [1 0 0];

            % Create TapeKillHomeButton
            app.TapeKillHomeButton = uibutton(app.TapePanel_2, 'push');
            app.TapeKillHomeButton.ButtonPushedFcn = createCallbackFcn(app, @TapeKillHomeButtonPushed, true);
            app.TapeKillHomeButton.Position = [25 46 144 23];
            app.TapeKillHomeButton.Text = 'Kill homing';

            % Create TapeTarget
            app.TapeTarget = uieditfield(app.TapePanel_2, 'numeric');
            app.TapeTarget.ValueDisplayFormat = '%.3f';
            app.TapeTarget.ValueChangedFcn = createCallbackFcn(app, @TapeTargetValueChanged, true);
            app.TapeTarget.Position = [29 357 87 22];

            % Create TapehomedLamp
            app.TapehomedLamp = uilamp(app.TapePanel_2);
            app.TapehomedLamp.Position = [167 477 20 20];
            app.TapehomedLamp.Color = [1 0 0];

            % Create HomedLabel_3
            app.HomedLabel_3 = uilabel(app.TapePanel_2);
            app.HomedLabel_3.HorizontalAlignment = 'right';
            app.HomedLabel_3.Position = [114 477 44 22];
            app.HomedLabel_3.Text = 'Homed';

            % Create TextErrorTape
            app.TextErrorTape = uilabel(app.TapePanel_2);
            app.TextErrorTape.BackgroundColor = [0 1 1];
            app.TextErrorTape.FontSize = 18;
            app.TextErrorTape.FontWeight = 'bold';
            app.TextErrorTape.FontColor = [1 0 0];
            app.TextErrorTape.Position = [99 8 72 23];

            % Create ErrorcodeLabel
            app.ErrorcodeLabel = uilabel(app.TapePanel_2);
            app.ErrorcodeLabel.Position = [32 8 64 22];
            app.ErrorcodeLabel.Text = 'Error code:';

            % Create TapePTPRefModeButton
            app.TapePTPRefModeButton = uibutton(app.TapePanel_2, 'push');
            app.TapePTPRefModeButton.ButtonPushedFcn = createCallbackFcn(app, @TapePTPRefModeButtonPushed, true);
            app.TapePTPRefModeButton.BackgroundColor = [0.9608 0.9608 0.9608];
            app.TapePTPRefModeButton.Position = [29 229 110 23];
            app.TapePTPRefModeButton.Text = 'PTP Ref mode';

            % Create LampTapePTPRefMode
            app.LampTapePTPRefMode = uilamp(app.TapePanel_2);
            app.LampTapePTPRefMode.Position = [146 230 20 20];
            app.LampTapePTPRefMode.Color = [1 0 0];

            % Create TapeSpeedRefModeButton
            app.TapeSpeedRefModeButton = uibutton(app.TapePanel_2, 'push');
            app.TapeSpeedRefModeButton.ButtonPushedFcn = createCallbackFcn(app, @TapeSpeedRefModeButtonPushed, true);
            app.TapeSpeedRefModeButton.BackgroundColor = [0.9608 0.9608 0.9608];
            app.TapeSpeedRefModeButton.Enable = 'off';
            app.TapeSpeedRefModeButton.Visible = 'off';
            app.TapeSpeedRefModeButton.Position = [29 203 110 23];
            app.TapeSpeedRefModeButton.Text = 'Speed Ref mode';

            % Create LampTapeSpeedRefMode
            app.LampTapeSpeedRefMode = uilamp(app.TapePanel_2);
            app.LampTapeSpeedRefMode.Enable = 'off';
            app.LampTapeSpeedRefMode.Visible = 'off';
            app.LampTapeSpeedRefMode.Position = [146 204 20 20];
            app.LampTapeSpeedRefMode.Color = [1 0 0];

            % Create LCmodeEditField_3Label
            app.LCmodeEditField_3Label = uilabel(app.TapePanel_2);
            app.LCmodeEditField_3Label.HorizontalAlignment = 'right';
            app.LCmodeEditField_3Label.Position = [28 259 54 22];
            app.LCmodeEditField_3Label.Text = 'LC mode';

            % Create TapeLCmodeEditField
            app.TapeLCmodeEditField = uieditfield(app.TapePanel_2, 'text');
            app.TapeLCmodeEditField.Editable = 'off';
            app.TapeLCmodeEditField.BackgroundColor = [0 1 1];
            app.TapeLCmodeEditField.Position = [94 259 69 22];

            % Create RefmodeLabel_2
            app.RefmodeLabel_2 = uilabel(app.TapePanel_2);
            app.RefmodeLabel_2.HorizontalAlignment = 'right';
            app.RefmodeLabel_2.Position = [25 287 57 22];
            app.RefmodeLabel_2.Text = 'Ref mode';

            % Create TapeRefModeEditField
            app.TapeRefModeEditField = uieditfield(app.TapePanel_2, 'text');
            app.TapeRefModeEditField.Editable = 'off';
            app.TapeRefModeEditField.BackgroundColor = [0 1 1];
            app.TapeRefModeEditField.Position = [94 287 69 22];

            % Create StByPosButton_2
            app.StByPosButton_2 = uibutton(app.TapePanel_2, 'push');
            app.StByPosButton_2.ButtonPushedFcn = createCallbackFcn(app, @StByPosButton_2Pushed, true);
            app.StByPosButton_2.Position = [115 314 46 37];
            app.StByPosButton_2.Text = {'St.By.'; 'Pos'};

            % Create TapeMotorBrakeReleasedBotton
            app.TapeMotorBrakeReleasedBotton = uibutton(app.TapePanel_2, 'push');
            app.TapeMotorBrakeReleasedBotton.ButtonPushedFcn = createCallbackFcn(app, @TapeMotorBrakeReleasedBottonButtonPushed, true);
            app.TapeMotorBrakeReleasedBotton.Position = [42 447 94 23];
            app.TapeMotorBrakeReleasedBotton.Text = 'Brake Release';

            % Create LampTapeMotorBrakeReleasedOn
            app.LampTapeMotorBrakeReleasedOn = uilamp(app.TapePanel_2);
            app.LampTapeMotorBrakeReleasedOn.Position = [142 448 20 20];
            app.LampTapeMotorBrakeReleasedOn.Color = [1 0 0];

            % Create PlatePanel
            app.PlatePanel = uipanel(app.AxesIndividualControlTab);
            app.PlatePanel.Title = 'Plate';
            app.PlatePanel.Position = [230 173 200 365];

            % Create PositionDegLabel
            app.PositionDegLabel = uilabel(app.PlatePanel);
            app.PositionDegLabel.Position = [63 260 81 22];
            app.PositionDegLabel.Text = 'Position (Deg)';

            % Create PlateCurrentPosDeg
            app.PlateCurrentPosDeg = uilabel(app.PlatePanel);
            app.PlateCurrentPosDeg.BackgroundColor = [0 1 1];
            app.PlateCurrentPosDeg.FontSize = 18;
            app.PlateCurrentPosDeg.FontWeight = 'bold';
            app.PlateCurrentPosDeg.FontColor = [0.7176 0.2745 1];
            app.PlateCurrentPosDeg.Position = [42 240 119 23];

            % Create PlatePosTarger
            app.PlatePosTarger = uilabel(app.PlatePanel);
            app.PlatePosTarger.Position = [42 215 115 22];
            app.PlatePosTarger.Text = 'Position target (Deg)';

            % Create PlateGoButton
            app.PlateGoButton = uibutton(app.PlatePanel, 'push');
            app.PlateGoButton.ButtonPushedFcn = createCallbackFcn(app, @PlateGoButtonPushed, true);
            app.PlateGoButton.Position = [129 194 46 23];
            app.PlateGoButton.Text = 'Go';

            % Create PlateMotorOnButton
            app.PlateMotorOnButton = uibutton(app.PlatePanel, 'push');
            app.PlateMotorOnButton.ButtonPushedFcn = createCallbackFcn(app, @PlateMotorOnButtonPushed, true);
            app.PlateMotorOnButton.Position = [14 316 61 23];
            app.PlateMotorOnButton.Text = 'Motor On';

            % Create PlateCalibrateButton
            app.PlateCalibrateButton = uibutton(app.PlatePanel, 'push');
            app.PlateCalibrateButton.ButtonPushedFcn = createCallbackFcn(app, @PlateCalibrateButtonPushed, true);
            app.PlateCalibrateButton.BackgroundColor = [0.9294 0.6941 0.1255];
            app.PlateCalibrateButton.Position = [27 156 141 23];
            app.PlateCalibrateButton.Text = 'Calibrate';

            % Create LampPlateOn
            app.LampPlateOn = uilamp(app.PlatePanel);
            app.LampPlateOn.Position = [78 317 20 20];
            app.LampPlateOn.Color = [1 0 0];

            % Create ErrorcodeLabel_2
            app.ErrorcodeLabel_2 = uilabel(app.PlatePanel);
            app.ErrorcodeLabel_2.Position = [36 10 64 22];
            app.ErrorcodeLabel_2.Text = 'Error code:';

            % Create TextErrorPlate
            app.TextErrorPlate = uilabel(app.PlatePanel);
            app.TextErrorPlate.BackgroundColor = [0 1 1];
            app.TextErrorPlate.FontSize = 18;
            app.TextErrorPlate.FontWeight = 'bold';
            app.TextErrorPlate.FontColor = [1 0 0];
            app.TextErrorPlate.Position = [100 9 71 23];

            % Create PlaceTargetDeg
            app.PlaceTargetDeg = uieditfield(app.PlatePanel, 'numeric');
            app.PlaceTargetDeg.ValueDisplayFormat = '%.3f';
            app.PlaceTargetDeg.ValueChangedFcn = createCallbackFcn(app, @PlaceTargetDegValueChanged, true);
            app.PlaceTargetDeg.Position = [37 194 86 22];

            % Create PlateHomedLamp
            app.PlateHomedLamp = uilamp(app.PlatePanel);
            app.PlateHomedLamp.Position = [166 315 20 20];
            app.PlateHomedLamp.Color = [1 0 0];

            % Create HomedLabel_2
            app.HomedLabel_2 = uilabel(app.PlatePanel);
            app.HomedLabel_2.HorizontalAlignment = 'right';
            app.HomedLabel_2.Position = [114 315 44 22];
            app.HomedLabel_2.Text = 'Homed';

            % Create PlatePTPRefModeButton
            app.PlatePTPRefModeButton = uibutton(app.PlatePanel, 'push');
            app.PlatePTPRefModeButton.ButtonPushedFcn = createCallbackFcn(app, @PlatePTPRefModeButtonPushed, true);
            app.PlatePTPRefModeButton.BackgroundColor = [0.9608 0.9608 0.9608];
            app.PlatePTPRefModeButton.Position = [36 68 110 23];
            app.PlatePTPRefModeButton.Text = 'PTP Ref mode';

            % Create LampPlatePTPRefMode
            app.LampPlatePTPRefMode = uilamp(app.PlatePanel);
            app.LampPlatePTPRefMode.Position = [153 69 20 20];
            app.LampPlatePTPRefMode.Color = [1 0 0];

            % Create PlateSpeedRefModeButton
            app.PlateSpeedRefModeButton = uibutton(app.PlatePanel, 'push');
            app.PlateSpeedRefModeButton.ButtonPushedFcn = createCallbackFcn(app, @PlateSpeedRefModeButtonPushed, true);
            app.PlateSpeedRefModeButton.BackgroundColor = [0.9608 0.9608 0.9608];
            app.PlateSpeedRefModeButton.Enable = 'off';
            app.PlateSpeedRefModeButton.Visible = 'off';
            app.PlateSpeedRefModeButton.Position = [36 42 110 23];
            app.PlateSpeedRefModeButton.Text = 'Speed Ref mode';

            % Create LampPlateSpeedRefMode
            app.LampPlateSpeedRefMode = uilamp(app.PlatePanel);
            app.LampPlateSpeedRefMode.Enable = 'off';
            app.LampPlateSpeedRefMode.Visible = 'off';
            app.LampPlateSpeedRefMode.Position = [153 43 20 20];
            app.LampPlateSpeedRefMode.Color = [1 0 0];

            % Create LCmodeEditField_2Label
            app.LCmodeEditField_2Label = uilabel(app.PlatePanel);
            app.LCmodeEditField_2Label.HorizontalAlignment = 'right';
            app.LCmodeEditField_2Label.Position = [35 98 54 22];
            app.LCmodeEditField_2Label.Text = 'LC mode';

            % Create PlateLCmodeEditField
            app.PlateLCmodeEditField = uieditfield(app.PlatePanel, 'text');
            app.PlateLCmodeEditField.Editable = 'off';
            app.PlateLCmodeEditField.BackgroundColor = [0 1 1];
            app.PlateLCmodeEditField.Position = [101 98 69 22];

            % Create RefmodeLabel_3
            app.RefmodeLabel_3 = uilabel(app.PlatePanel);
            app.RefmodeLabel_3.HorizontalAlignment = 'right';
            app.RefmodeLabel_3.Position = [32 124 57 22];
            app.RefmodeLabel_3.Text = 'Ref mode';

            % Create PlateRefModeEditField
            app.PlateRefModeEditField = uieditfield(app.PlatePanel, 'text');
            app.PlateRefModeEditField.Editable = 'off';
            app.PlateRefModeEditField.BackgroundColor = [0 1 1];
            app.PlateRefModeEditField.Position = [101 124 69 22];

            % Create PlateMotorBrakeReleaseButton
            app.PlateMotorBrakeReleaseButton = uibutton(app.PlatePanel, 'push');
            app.PlateMotorBrakeReleaseButton.ButtonPushedFcn = createCallbackFcn(app, @PlateMotorBrakeReleaseButtonButtonPushed, true);
            app.PlateMotorBrakeReleaseButton.Position = [42 285 94 23];
            app.PlateMotorBrakeReleaseButton.Text = 'Brake Release';

            % Create LampPlateMotorBrakeReleasedOn
            app.LampPlateMotorBrakeReleasedOn = uilamp(app.PlatePanel);
            app.LampPlateMotorBrakeReleasedOn.Position = [142 286 20 20];
            app.LampPlateMotorBrakeReleasedOn.Color = [1 0 0];

            % Create ShifterPanel
            app.ShifterPanel = uipanel(app.AxesIndividualControlTab);
            app.ShifterPanel.Title = 'Shifter';
            app.ShifterPanel.Position = [445 11 198 527];

            % Create ShifterPositiontargetLabel
            app.ShifterPositiontargetLabel = uilabel(app.ShifterPanel);
            app.ShifterPositiontargetLabel.Position = [44 379 106 22];
            app.ShifterPositiontargetLabel.Text = 'Position  target (m)';

            % Create ShifterGoButton
            app.ShifterGoButton = uibutton(app.ShifterPanel, 'push');
            app.ShifterGoButton.ButtonPushedFcn = createCallbackFcn(app, @ShifterGoButtonPushed, true);
            app.ShifterGoButton.Position = [122 358 46 23];
            app.ShifterGoButton.Text = 'Go';

            % Create ImmediateHomevaluemLabel_2
            app.ImmediateHomevaluemLabel_2 = uilabel(app.ShifterPanel);
            app.ImmediateHomevaluemLabel_2.Position = [22 155 148 22];
            app.ImmediateHomevaluemLabel_2.Text = 'Immediate Home value [m]';

            % Create ShifterSethomeButton
            app.ShifterSethomeButton = uibutton(app.ShifterPanel, 'push');
            app.ShifterSethomeButton.ButtonPushedFcn = createCallbackFcn(app, @ShifterSethomeButtonPushed, true);
            app.ShifterSethomeButton.Enable = 'off';
            app.ShifterSethomeButton.Position = [22 101 149 23];
            app.ShifterSethomeButton.Text = 'Set home value';

            % Create ShifterAutomaticHomeButton
            app.ShifterAutomaticHomeButton = uibutton(app.ShifterPanel, 'push');
            app.ShifterAutomaticHomeButton.ButtonPushedFcn = createCallbackFcn(app, @ShifterAutomaticHomeButtonPushed, true);
            app.ShifterAutomaticHomeButton.Position = [22 72 149 23];
            app.ShifterAutomaticHomeButton.Text = 'Automatic homing';

            % Create EditFieldSpacerHome
            app.EditFieldSpacerHome = uieditfield(app.ShifterPanel, 'numeric');
            app.EditFieldSpacerHome.Editable = 'off';
            app.EditFieldSpacerHome.BackgroundColor = [0 1 1];
            app.EditFieldSpacerHome.Position = [53 131 87 22];

            % Create SpacerKillHomingButton
            app.SpacerKillHomingButton = uibutton(app.ShifterPanel, 'push');
            app.SpacerKillHomingButton.ButtonPushedFcn = createCallbackFcn(app, @SpacerKillHomingButtonPushed, true);
            app.SpacerKillHomingButton.Position = [22 45 148 23];
            app.SpacerKillHomingButton.Text = 'Kill homing';

            % Create ShifterTarget
            app.ShifterTarget = uieditfield(app.ShifterPanel, 'numeric');
            app.ShifterTarget.ValueDisplayFormat = '%.3f';
            app.ShifterTarget.ValueChangedFcn = createCallbackFcn(app, @ShifterTargetValueChanged, true);
            app.ShifterTarget.Position = [25 358 91 22];

            % Create RotatePosButton
            app.RotatePosButton = uibutton(app.ShifterPanel, 'push');
            app.RotatePosButton.ButtonPushedFcn = createCallbackFcn(app, @RotatePosButtonPushed, true);
            app.RotatePosButton.Position = [121 316 50 37];
            app.RotatePosButton.Text = {'Rotate'; 'Pos'};

            % Create StByPosButton
            app.StByPosButton = uibutton(app.ShifterPanel, 'push');
            app.StByPosButton.ButtonPushedFcn = createCallbackFcn(app, @StByPosButtonPushed, true);
            app.StByPosButton.Position = [21 315 46 37];
            app.StByPosButton.Text = {'St.By.'; 'Pos'};

            % Create ShelfPosButton
            app.ShelfPosButton = uibutton(app.ShifterPanel, 'push');
            app.ShelfPosButton.ButtonPushedFcn = createCallbackFcn(app, @ShelfPosButtonPushed, true);
            app.ShelfPosButton.Position = [73 316 42 37];
            app.ShelfPosButton.Text = {'Shelf'; 'Pos'};

            % Create ShifterMotorOnButton
            app.ShifterMotorOnButton = uibutton(app.ShifterPanel, 'push');
            app.ShifterMotorOnButton.ButtonPushedFcn = createCallbackFcn(app, @ShifterMotorOnButtonPushed, true);
            app.ShifterMotorOnButton.Position = [14 477 58 23];
            app.ShifterMotorOnButton.Text = 'Motor On';

            % Create LampShifterOn
            app.LampShifterOn = uilamp(app.ShifterPanel);
            app.LampShifterOn.Position = [75 478 20 20];
            app.LampShifterOn.Color = [1 0 0];

            % Create ShifterhomedLamp
            app.ShifterhomedLamp = uilamp(app.ShifterPanel);
            app.ShifterhomedLamp.Position = [164 478 20 20];
            app.ShifterhomedLamp.Color = [1 0 0];

            % Create HomedLabel
            app.HomedLabel = uilabel(app.ShifterPanel);
            app.HomedLabel.HorizontalAlignment = 'right';
            app.HomedLabel.Position = [113 478 44 22];
            app.HomedLabel.Text = 'Homed';

            % Create PositionmLabel_2
            app.PositionmLabel_2 = uilabel(app.ShifterPanel);
            app.PositionmLabel_2.Position = [65 422 69 22];
            app.PositionmLabel_2.Text = 'Position (m)';

            % Create ShifterCurrentPos
            app.ShifterCurrentPos = uilabel(app.ShifterPanel);
            app.ShifterCurrentPos.BackgroundColor = [0 1 1];
            app.ShifterCurrentPos.FontSize = 18;
            app.ShifterCurrentPos.FontWeight = 'bold';
            app.ShifterCurrentPos.FontColor = [0.7176 0.2745 1];
            app.ShifterCurrentPos.Position = [39 402 119 23];

            % Create ErrorcodeLabel_3
            app.ErrorcodeLabel_3 = uilabel(app.ShifterPanel);
            app.ErrorcodeLabel_3.Position = [28 9 64 22];
            app.ErrorcodeLabel_3.Text = 'Error code:';

            % Create TextErrorShifter
            app.TextErrorShifter = uilabel(app.ShifterPanel);
            app.TextErrorShifter.BackgroundColor = [0 1 1];
            app.TextErrorShifter.FontSize = 18;
            app.TextErrorShifter.FontWeight = 'bold';
            app.TextErrorShifter.FontColor = [1 0 0];
            app.TextErrorShifter.Position = [97 9 72 23];

            % Create ShifterPTPRefModeButton
            app.ShifterPTPRefModeButton = uibutton(app.ShifterPanel, 'push');
            app.ShifterPTPRefModeButton.ButtonPushedFcn = createCallbackFcn(app, @ShifterPTPRefModeButtonPushed, true);
            app.ShifterPTPRefModeButton.BackgroundColor = [0.9608 0.9608 0.9608];
            app.ShifterPTPRefModeButton.Position = [28 230 110 23];
            app.ShifterPTPRefModeButton.Text = 'PTP Ref mode';

            % Create LampShifterPTPRefMode
            app.LampShifterPTPRefMode = uilamp(app.ShifterPanel);
            app.LampShifterPTPRefMode.Position = [145 231 20 20];
            app.LampShifterPTPRefMode.Color = [1 0 0];

            % Create ShifterSpeedRefModeButton
            app.ShifterSpeedRefModeButton = uibutton(app.ShifterPanel, 'push');
            app.ShifterSpeedRefModeButton.ButtonPushedFcn = createCallbackFcn(app, @ShifterSpeedRefModeButtonPushed, true);
            app.ShifterSpeedRefModeButton.BackgroundColor = [0.9608 0.9608 0.9608];
            app.ShifterSpeedRefModeButton.Enable = 'off';
            app.ShifterSpeedRefModeButton.Visible = 'off';
            app.ShifterSpeedRefModeButton.Position = [28 204 110 23];
            app.ShifterSpeedRefModeButton.Text = 'Speed Ref mode';

            % Create LampShifterSpeedRefMode
            app.LampShifterSpeedRefMode = uilamp(app.ShifterPanel);
            app.LampShifterSpeedRefMode.Enable = 'off';
            app.LampShifterSpeedRefMode.Visible = 'off';
            app.LampShifterSpeedRefMode.Position = [145 205 20 20];
            app.LampShifterSpeedRefMode.Color = [1 0 0];

            % Create LCmodeEditFieldLabel
            app.LCmodeEditFieldLabel = uilabel(app.ShifterPanel);
            app.LCmodeEditFieldLabel.HorizontalAlignment = 'right';
            app.LCmodeEditFieldLabel.Position = [30 260 54 22];
            app.LCmodeEditFieldLabel.Text = 'LC mode';

            % Create SpacerLCmodeEditField
            app.SpacerLCmodeEditField = uieditfield(app.ShifterPanel, 'text');
            app.SpacerLCmodeEditField.Editable = 'off';
            app.SpacerLCmodeEditField.BackgroundColor = [0 1 1];
            app.SpacerLCmodeEditField.Position = [96 260 69 22];

            % Create RefmodeLabel
            app.RefmodeLabel = uilabel(app.ShifterPanel);
            app.RefmodeLabel.HorizontalAlignment = 'right';
            app.RefmodeLabel.Position = [27 286 57 22];
            app.RefmodeLabel.Text = 'Ref mode';

            % Create SpacerRefModeEditField
            app.SpacerRefModeEditField = uieditfield(app.ShifterPanel, 'text');
            app.SpacerRefModeEditField.Editable = 'off';
            app.SpacerRefModeEditField.BackgroundColor = [0 1 1];
            app.SpacerRefModeEditField.Position = [96 286 69 22];

            % Create SpacerHomeDirButton
            app.SpacerHomeDirButton = uibutton(app.ShifterPanel, 'push');
            app.SpacerHomeDirButton.ButtonPushedFcn = createCallbackFcn(app, @SpacerHomeDirButtonPushed, true);
            app.SpacerHomeDirButton.BackgroundColor = [0.9608 0.9608 0.9608];
            app.SpacerHomeDirButton.Position = [28 176 95 23];
            app.SpacerHomeDirButton.Text = 'Home direction';

            % Create SpacerHomeEditField
            app.SpacerHomeEditField = uieditfield(app.ShifterPanel, 'numeric');
            app.SpacerHomeEditField.Editable = 'off';
            app.SpacerHomeEditField.BackgroundColor = [0 1 1];
            app.SpacerHomeEditField.Position = [133 176 37 22];

            % Create NeckControlPanel
            app.NeckControlPanel = uipanel(app.AxesIndividualControlTab);
            app.NeckControlPanel.Title = 'Neck Control';
            app.NeckControlPanel.Position = [230 11 200 152];

            % Create NeckGetPosTarger_2
            app.NeckGetPosTarger_2 = uilabel(app.NeckControlPanel);
            app.NeckGetPosTarger_2.Position = [105 60 94 22];
            app.NeckGetPosTarger_2.Text = 'Neck Cmd (Deg)';

            % Create NeckSetTargetDeg
            app.NeckSetTargetDeg = uieditfield(app.NeckControlPanel, 'numeric');
            app.NeckSetTargetDeg.ValueDisplayFormat = '%.3f';
            app.NeckSetTargetDeg.Position = [105 37 89 22];

            % Create NeckAngleText
            app.NeckAngleText = uilabel(app.NeckControlPanel);
            app.NeckAngleText.BackgroundColor = [0 1 1];
            app.NeckAngleText.FontSize = 18;
            app.NeckAngleText.FontWeight = 'bold';
            app.NeckAngleText.FontColor = [0.7176 0.2745 1];
            app.NeckAngleText.Position = [11 37 81 23];

            % Create PlatePosTarger_4
            app.PlatePosTarger_4 = uilabel(app.NeckControlPanel);
            app.PlatePosTarger_4.Position = [10 60 88 22];
            app.PlatePosTarger_4.Text = 'Neck pos (Deg)';

            % Create RemoteControlButton
            app.RemoteControlButton = uibutton(app.NeckControlPanel, 'push');
            app.RemoteControlButton.ButtonPushedFcn = createCallbackFcn(app, @RemoteControlButtonPushed, true);
            app.RemoteControlButton.Position = [13 84 62 38];
            app.RemoteControlButton.Text = {'Remote'; 'Control'};

            % Create NeckControlLamp
            app.NeckControlLamp = uilamp(app.NeckControlPanel);
            app.NeckControlLamp.Position = [79 94 20 20];
            app.NeckControlLamp.Color = [1 0 0];

            % Create GoNeck
            app.GoNeck = uibutton(app.NeckControlPanel, 'push');
            app.GoNeck.ButtonPushedFcn = createCallbackFcn(app, @GoNeckButtonPushed, true);
            app.GoNeck.Position = [129 9 46 23];
            app.GoNeck.Text = 'Go';

            % Create SetCurrentPosButton
            app.SetCurrentPosButton = uibutton(app.NeckControlPanel, 'push');
            app.SetCurrentPosButton.ButtonPushedFcn = createCallbackFcn(app, @SetCurrentPosButtonPushed, true);
            app.SetCurrentPosButton.Position = [21 8 100 23];
            app.SetCurrentPosButton.Text = 'Set Current Pos';

            % Create NeckGrantControlLamp
            app.NeckGrantControlLamp = uilamp(app.NeckControlPanel);
            app.NeckGrantControlLamp.Position = [169 95 20 20];
            app.NeckGrantControlLamp.Color = [1 0 0];

            % Create HomedLabel_4
            app.HomedLabel_4 = uilabel(app.NeckControlPanel);
            app.HomedLabel_4.HorizontalAlignment = 'center';
            app.HomedLabel_4.Position = [114 83 52 44];
            app.HomedLabel_4.Text = {'Neck'; 'Grant'; ' Control'};

            % Create ParametersTab
            app.ParametersTab = uitab(app.TabGroup);
            app.ParametersTab.Title = 'Parameters';

            % Create UITable
            app.UITable = uitable(app.ParametersTab);
            app.UITable.ColumnName = {'Parameter'; 'Value'};
            app.UITable.ColumnWidth = {350, 'auto'};
            app.UITable.RowName = {};
            app.UITable.ColumnEditable = [false true];
            app.UITable.CellEditCallback = createCallbackFcn(app, @UITableCellEdit, true);
            app.UITable.Position = [28 59 508 473];

            % Create IndividualAxisControlBotton_2
            app.IndividualAxisControlBotton_2 = uibutton(app.ParametersTab, 'push');
            app.IndividualAxisControlBotton_2.ButtonPushedFcn = createCallbackFcn(app, @IndividualAxisControlBotton_2ButtonPushed, true);
            app.IndividualAxisControlBotton_2.Position = [30 15 163 23];
            app.IndividualAxisControlBotton_2.Text = 'Update to new axes speeds';

            % Create InstructionsTextAreaLabel
            app.InstructionsTextAreaLabel = uilabel(app.UIFigure);
            app.InstructionsTextAreaLabel.HorizontalAlignment = 'right';
            app.InstructionsTextAreaLabel.Position = [42 74 67 22];
            app.InstructionsTextAreaLabel.Text = 'Instructions';

            % Create InstructionsTextArea
            app.InstructionsTextArea = uitextarea(app.UIFigure);
            app.InstructionsTextArea.Editable = 'off';
            app.InstructionsTextArea.Position = [43 27 847 48];

            % Create ProblemsTextAreaLabel
            app.ProblemsTextAreaLabel = uilabel(app.UIFigure);
            app.ProblemsTextAreaLabel.HorizontalAlignment = 'right';
            app.ProblemsTextAreaLabel.Position = [40 216 55 22];
            app.ProblemsTextAreaLabel.Text = 'Problems';

            % Create ProblemsTextArea
            app.ProblemsTextArea = uitextarea(app.UIFigure);
            app.ProblemsTextArea.Editable = 'off';
            app.ProblemsTextArea.Position = [42 168 848 49];

            % Create NextstepButton
            app.NextstepButton = uibutton(app.UIFigure, 'push');
            app.NextstepButton.Position = [901 52 100 23];
            app.NextstepButton.Text = 'Next step';

            % Create CancelButton
            app.CancelButton = uibutton(app.UIFigure, 'push');
            app.CancelButton.Position = [901 27 100 23];
            app.CancelButton.Text = 'Cancel';

            % Create ErrordetailButton
            app.ErrordetailButton = uibutton(app.UIFigure, 'push');
            app.ErrordetailButton.ButtonPushedFcn = createCallbackFcn(app, @ErrordetailButtonPushed, true);
            app.ErrordetailButton.Position = [901 194 100 23];
            app.ErrordetailButton.Text = 'Error detail';

            % Create EefTabGroup
            app.EefTabGroup = uitabgroup(app.UIFigure);
            app.EefTabGroup.Position = [699 570 311 249];

            % Create EEFAutoTab_2
            app.EEFAutoTab_2 = uitab(app.EefTabGroup);
            app.EEFAutoTab_2.Title = 'EEF Auto';

            % Create WaitingForInitialGripLabel
            app.WaitingForInitialGripLabel = uilabel(app.EEFAutoTab_2);
            app.WaitingForInitialGripLabel.HorizontalAlignment = 'right';
            app.WaitingForInitialGripLabel.Position = [139 117 123 22];
            app.WaitingForInitialGripLabel.Text = 'Waiting For Initial Grip';

            % Create WaitingForInitialGripLamp
            app.WaitingForInitialGripLamp = uilamp(app.EEFAutoTab_2);
            app.WaitingForInitialGripLamp.Position = [277 117 20 20];
            app.WaitingForInitialGripLamp.Color = [1 1 1];

            % Create WaitingForFullGripLabel
            app.WaitingForFullGripLabel = uilabel(app.EEFAutoTab_2);
            app.WaitingForFullGripLabel.HorizontalAlignment = 'right';
            app.WaitingForFullGripLabel.Position = [147 92 115 22];
            app.WaitingForFullGripLabel.Text = 'Waiting For Full Grip';

            % Create WaitingForFullGripLamp
            app.WaitingForFullGripLamp = uilamp(app.EEFAutoTab_2);
            app.WaitingForFullGripLamp.Position = [277 92 20 20];
            app.WaitingForFullGripLamp.Color = [1 1 1];

            % Create FullyGrippedLabel
            app.FullyGrippedLabel = uilabel(app.EEFAutoTab_2);
            app.FullyGrippedLabel.HorizontalAlignment = 'right';
            app.FullyGrippedLabel.Position = [186 68 76 22];
            app.FullyGrippedLabel.Text = 'Fully Gripped';

            % Create FullyGrippedLamp
            app.FullyGrippedLamp = uilamp(app.EEFAutoTab_2);
            app.FullyGrippedLamp.Position = [277 68 20 20];
            app.FullyGrippedLamp.Color = [1 1 1];

            % Create WaitingForReleaseLabel
            app.WaitingForReleaseLabel = uilabel(app.EEFAutoTab_2);
            app.WaitingForReleaseLabel.HorizontalAlignment = 'right';
            app.WaitingForReleaseLabel.Position = [149 43 113 22];
            app.WaitingForReleaseLabel.Text = 'Waiting For Release';

            % Create WaitingForReleaseLamp
            app.WaitingForReleaseLamp = uilamp(app.EEFAutoTab_2);
            app.WaitingForReleaseLamp.Position = [277 43 20 20];
            app.WaitingForReleaseLamp.Color = [1 1 1];

            % Create FullyreleasedLabel
            app.FullyreleasedLabel = uilabel(app.EEFAutoTab_2);
            app.FullyreleasedLabel.HorizontalAlignment = 'right';
            app.FullyreleasedLabel.Position = [182 18 80 22];
            app.FullyreleasedLabel.Text = 'Fully released';

            % Create FullyreleasedLamp
            app.FullyreleasedLamp = uilamp(app.EEFAutoTab_2);
            app.FullyreleasedLamp.Position = [277 18 20 20];
            app.FullyreleasedLamp.Color = [1 1 1];

            % Create WaitingForReleaseLabel_2
            app.WaitingForReleaseLabel_2 = uilabel(app.EEFAutoTab_2);
            app.WaitingForReleaseLabel_2.HorizontalAlignment = 'right';
            app.WaitingForReleaseLabel_2.Position = [30 47 58 22];
            app.WaitingForReleaseLabel_2.Text = 'Grip Error';

            % Create GripErrorLamp
            app.GripErrorLamp = uilamp(app.EEFAutoTab_2);
            app.GripErrorLamp.Position = [103 47 20 20];
            app.GripErrorLamp.Color = [1 1 1];

            % Create ReleaseErrorLampLabel
            app.ReleaseErrorLampLabel = uilabel(app.EEFAutoTab_2);
            app.ReleaseErrorLampLabel.HorizontalAlignment = 'right';
            app.ReleaseErrorLampLabel.Position = [9 21 79 22];
            app.ReleaseErrorLampLabel.Text = 'Release Error';

            % Create ReleaseErrorLamp
            app.ReleaseErrorLamp = uilamp(app.EEFAutoTab_2);
            app.ReleaseErrorLamp.Position = [103 21 20 20];
            app.ReleaseErrorLamp.Color = [1 1 1];

            % Create PumpsonLampLabel
            app.PumpsonLampLabel = uilabel(app.EEFAutoTab_2);
            app.PumpsonLampLabel.HorizontalAlignment = 'right';
            app.PumpsonLampLabel.Position = [205 193 59 22];
            app.PumpsonLampLabel.Text = 'Pumps on';

            % Create PumpsOnLamp
            app.PumpsOnLamp = uilamp(app.EEFAutoTab_2);
            app.PumpsOnLamp.Position = [272 193 20 20];
            app.PumpsOnLamp.Color = [1 0 0];

            % Create DoNotTestSuctionCheckBox
            app.DoNotTestSuctionCheckBox = uicheckbox(app.EEFAutoTab_2);
            app.DoNotTestSuctionCheckBox.ValueChangedFcn = createCallbackFcn(app, @DoNotTestSuctionCheckBoxValueChanged, true);
            app.DoNotTestSuctionCheckBox.Text = 'Do not test suction';
            app.DoNotTestSuctionCheckBox.Position = [18 153 121 22];

            % Create DoNotLookForPackageCheckBox
            app.DoNotLookForPackageCheckBox = uicheckbox(app.EEFAutoTab_2);
            app.DoNotLookForPackageCheckBox.ValueChangedFcn = createCallbackFcn(app, @DoNotLookForPackageCheckBoxValueChanged, true);
            app.DoNotLookForPackageCheckBox.Text = 'Do not look for package';
            app.DoNotLookForPackageCheckBox.Position = [150 153 149 22];

            % Create PumpsGripActivationButton
            app.PumpsGripActivationButton = uibutton(app.EEFAutoTab_2, 'push');
            app.PumpsGripActivationButton.ButtonPushedFcn = createCallbackFcn(app, @PumpsGripActivationButtonPushed, true);
            app.PumpsGripActivationButton.Position = [17 193 116 23];
            app.PumpsGripActivationButton.Text = 'Pumps Grip';

            % Create PumpGripLamp
            app.PumpGripLamp = uilamp(app.EEFAutoTab_2);
            app.PumpGripLamp.Position = [137 194 20 20];
            app.PumpGripLamp.Color = [1 0 0];

            % Create EEFManualTab
            app.EEFManualTab = uitab(app.EefTabGroup);
            app.EEFManualTab.Title = 'EEF Manual';

            % Create PumpsOnButton
            app.PumpsOnButton = uibutton(app.EEFManualTab, 'push');
            app.PumpsOnButton.ButtonPushedFcn = createCallbackFcn(app, @PumpsOnButtonButtonPushed, true);
            app.PumpsOnButton.Position = [17 181 116 23];
            app.PumpsOnButton.Text = 'Pumps on';

            % Create PumpsOnLamp2
            app.PumpsOnLamp2 = uilamp(app.EEFManualTab);
            app.PumpsOnLamp2.Position = [137 182 20 20];
            app.PumpsOnLamp2.Color = [1 0 0];

            % Create EEFElementsStatePanel
            app.EEFElementsStatePanel = uipanel(app.UIFigure);
            app.EEFElementsStatePanel.Title = 'Laser/ LED State';
            app.EEFElementsStatePanel.Position = [700 246 311 307];

            % Create LaserMedianValidLabel
            app.LaserMedianValidLabel = uilabel(app.EEFElementsStatePanel);
            app.LaserMedianValidLabel.HorizontalAlignment = 'right';
            app.LaserMedianValidLabel.Position = [84 221 106 22];
            app.LaserMedianValidLabel.Text = 'Laser median valid';

            % Create LaserMedianValidLamp
            app.LaserMedianValidLamp = uilamp(app.EEFElementsStatePanel);
            app.LaserMedianValidLamp.Position = [205 221 20 20];
            app.LaserMedianValidLamp.Color = [1 1 1];

            % Create LasermedianfailedLampLabel
            app.LasermedianfailedLampLabel = uilabel(app.EEFElementsStatePanel);
            app.LasermedianfailedLampLabel.HorizontalAlignment = 'right';
            app.LasermedianfailedLampLabel.Position = [80 194 110 22];
            app.LasermedianfailedLampLabel.Text = 'Laser median failed';

            % Create LaserMedianFailedLamp
            app.LaserMedianFailedLamp = uilamp(app.EEFElementsStatePanel);
            app.LaserMedianFailedLamp.Position = [205 194 20 20];
            app.LaserMedianFailedLamp.Color = [1 1 1];

            % Create LaserOnLamp
            app.LaserOnLamp = uilamp(app.EEFElementsStatePanel);
            app.LaserOnLamp.Position = [129 253 20 20];
            app.LaserOnLamp.Color = [1 1 1];

            % Create LaserOnBotton
            app.LaserOnBotton = uibutton(app.EEFElementsStatePanel, 'push');
            app.LaserOnBotton.ButtonPushedFcn = createCallbackFcn(app, @LaserOnBottonButtonPushed, true);
            app.LaserOnBotton.Position = [29 252 91 23];
            app.LaserOnBotton.Text = 'Laser on';

            % Create LedOnLamp
            app.LedOnLamp = uilamp(app.EEFElementsStatePanel);
            app.LedOnLamp.Position = [263 253 20 20];
            app.LedOnLamp.Color = [1 1 1];

            % Create LedOnButton
            app.LedOnButton = uibutton(app.EEFElementsStatePanel, 'push');
            app.LedOnButton.ButtonPushedFcn = createCallbackFcn(app, @LedOnButtonPushed, true);
            app.LedOnButton.Position = [175 252 82 23];
            app.LedOnButton.Text = 'LED on';

            % Create LaserMedianmTextAreaLabel
            app.LaserMedianmTextAreaLabel = uilabel(app.EEFElementsStatePanel);
            app.LaserMedianmTextAreaLabel.HorizontalAlignment = 'right';
            app.LaserMedianmTextAreaLabel.Position = [23 151 99 22];
            app.LaserMedianmTextAreaLabel.Text = 'Laser Median (m)';

            % Create LaserMedianmTextArea
            app.LaserMedianmTextArea = uitextarea(app.EEFElementsStatePanel);
            app.LaserMedianmTextArea.Editable = 'off';
            app.LaserMedianmTextArea.Position = [42 121 61 26];

            % Create LaserCalibBotton
            app.LaserCalibBotton = uibutton(app.EEFElementsStatePanel, 'push');
            app.LaserCalibBotton.ButtonPushedFcn = createCallbackFcn(app, @LaserCalibButtonPushed, true);
            app.LaserCalibBotton.Position = [19 90 108 23];
            app.LaserCalibBotton.Text = 'Laser Calibration';

            % Create LaserCalibrationMode
            app.LaserCalibrationMode = uilamp(app.EEFElementsStatePanel);
            app.LaserCalibrationMode.Position = [131 91 20 20];
            app.LaserCalibrationMode.Color = [1 0 0];

            % Create LaserCalibBotton_2
            app.LaserCalibBotton_2 = uibutton(app.EEFElementsStatePanel, 'push');
            app.LaserCalibBotton_2.ButtonPushedFcn = createCallbackFcn(app, @LaserCalibBotton_2ButtonPushed, true);
            app.LaserCalibBotton_2.Position = [180 90 108 23];
            app.LaserCalibBotton_2.Text = 'Reset Calibration';

            % Create LaserMedianmTextAreaLabel_2
            app.LaserMedianmTextAreaLabel_2 = uilabel(app.EEFElementsStatePanel);
            app.LaserMedianmTextAreaLabel_2.HorizontalAlignment = 'center';
            app.LaserMedianmTextAreaLabel_2.Position = [176 150 113 30];
            app.LaserMedianmTextAreaLabel_2.Text = {'Package distance'; 'from cups (m)'};

            % Create PackageDistTextArea
            app.PackageDistTextArea = uitextarea(app.EEFElementsStatePanel);
            app.PackageDistTextArea.Editable = 'off';
            app.PackageDistTextArea.Position = [204 121 61 26];

            % Create ManualActivationButton
            app.ManualActivationButton = uibutton(app.UIFigure, 'push');
            app.ManualActivationButton.ButtonPushedFcn = createCallbackFcn(app, @ManualActivationButtonPushed, true);
            app.ManualActivationButton.Position = [860 833 135 23];
            app.ManualActivationButton.Text = 'EEF Manual activation';

            % Create OverRideSwitchesLamp
            app.OverRideSwitchesLamp = uilamp(app.UIFigure);
            app.OverRideSwitchesLamp.Position = [998 834 20 20];
            app.OverRideSwitchesLamp.Color = [1 0 0];

            % Create EEFAutoGripEnableButton
            app.EEFAutoGripEnableButton = uibutton(app.UIFigure, 'push');
            app.EEFAutoGripEnableButton.ButtonPushedFcn = createCallbackFcn(app, @EEFAutoGripEnableButtonPushed, true);
            app.EEFAutoGripEnableButton.Position = [695 834 131 23];
            app.EEFAutoGripEnableButton.Text = 'EEF Auto Grip enable';

            % Create EEFAutoGripEnableLamp
            app.EEFAutoGripEnableLamp = uilamp(app.UIFigure);
            app.EEFAutoGripEnableLamp.Position = [828 835 20 20];
            app.EEFAutoGripEnableLamp.Color = [1 0 0];

            % Create IndividualAxisControlBotton
            app.IndividualAxisControlBotton = uibutton(app.UIFigure, 'push');
            app.IndividualAxisControlBotton.ButtonPushedFcn = createCallbackFcn(app, @IndividualAxisControlBottonPushed, true);
            app.IndividualAxisControlBotton.Position = [203 834 135 23];
            app.IndividualAxisControlBotton.Text = 'Individual axis control';

            % Create IndividualAxisControlLamp
            app.IndividualAxisControlLamp = uilamp(app.UIFigure);
            app.IndividualAxisControlLamp.Position = [342 835 20 20];
            app.IndividualAxisControlLamp.Color = [1 0 0];

            % Create AutoManipControlButton
            app.AutoManipControlButton = uibutton(app.UIFigure, 'push');
            app.AutoManipControlButton.ButtonPushedFcn = createCallbackFcn(app, @PackageGripByODModeButtonPushed, true);
            app.AutoManipControlButton.Position = [21 833 147 23];
            app.AutoManipControlButton.Text = 'Auto Manipulator Control';

            % Create AutoManipControlLamp
            app.AutoManipControlLamp = uilamp(app.UIFigure);
            app.AutoManipControlLamp.Position = [171 834 20 20];
            app.AutoManipControlLamp.Color = [1 0 0];

            % Create ClearDetailButton
            app.ClearDetailButton = uibutton(app.UIFigure, 'push');
            app.ClearDetailButton.ButtonPushedFcn = createCallbackFcn(app, @ClearDetailButtonPushed, true);
            app.ClearDetailButton.Position = [901 168 100 23];
            app.ClearDetailButton.Text = 'Clear Detail';

            % Create LogTextAreaLabel
            app.LogTextAreaLabel = uilabel(app.UIFigure);
            app.LogTextAreaLabel.Position = [48 147 55 22];
            app.LogTextAreaLabel.Text = 'Log';

            % Create LogTextArea
            app.LogTextArea = uitextarea(app.UIFigure);
            app.LogTextArea.Editable = 'off';
            app.LogTextArea.Position = [43 95 956 53];

            % Create EefSyncEnButton
            app.EefSyncEnButton = uibutton(app.UIFigure, 'push');
            app.EefSyncEnButton.ButtonPushedFcn = createCallbackFcn(app, @EefSyncEnButtonButtonPushed, true);
            app.EefSyncEnButton.Position = [704 878 114 23];
            app.EefSyncEnButton.Text = 'EEF Sync bypass';

            % Create EefSyncEnLamp
            app.EefSyncEnLamp = uilamp(app.UIFigure);
            app.EefSyncEnLamp.Position = [821 879 20 20];
            app.EefSyncEnLamp.Color = [1 0 0];

            % Create RefmodeLabel_5
            app.RefmodeLabel_5 = uilabel(app.UIFigure);
            app.RefmodeLabel_5.HorizontalAlignment = 'right';
            app.RefmodeLabel_5.Position = [407 834 84 22];
            app.RefmodeLabel_5.Text = 'Wake-up State';

            % Create WakeupStateEditField
            app.WakeupStateEditField = uieditfield(app.UIFigure, 'text');
            app.WakeupStateEditField.Editable = 'off';
            app.WakeupStateEditField.BackgroundColor = [0 1 1];
            app.WakeupStateEditField.Position = [506 833 64 22];

            % Create EefSyncEnButton_2
            app.EefSyncEnButton_2 = uibutton(app.UIFigure, 'push');
            app.EefSyncEnButton_2.ButtonPushedFcn = createCallbackFcn(app, @EefSyncEnButton_2Pushed, true);
            app.EefSyncEnButton_2.Position = [501 878 120 23];
            app.EefSyncEnButton_2.Text = 'Fatal error recovery';

            % Create ModeFault
            app.ModeFault = uilamp(app.UIFigure);
            app.ModeFault.Position = [624 879 20 20];
            app.ModeFault.Color = [1 0 0];

            % Show the figure after all components are created
            app.UIFigure.Visible = 'on';
        end
    end

    % App creation and deletion
    methods (Access = public)

        % Construct app
        function app = TrayBIT_exported

            % Create UIFigure and components
            createComponents(app)

            % Register the app with App Designer
            registerApp(app, app.UIFigure)

            % Execute the startup function
            runStartupFcn(app, @startupFcn)

            if nargout == 0
                clear app
            end
        end

        % Code that executes before app deletion
        function delete(app)

            % Delete UIFigure when app is deleted
            delete(app.UIFigure)
        end
    end
end