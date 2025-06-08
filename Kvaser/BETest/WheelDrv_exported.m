classdef WheelDrv_exported < matlab.apps.AppBase

    % Properties that correspond to app components
    properties (Access = public)
        WheelDrvUIFigure               matlab.ui.Figure
        CBITPanel                      matlab.ui.container.Panel
        ConfigButton                   matlab.ui.control.Button
        AutoStopLamp                   matlab.ui.control.Lamp
        AutoStopLampLabel              matlab.ui.control.Label
        StartStopenaLamp               matlab.ui.control.Lamp
        StartStopenaLampLabel          matlab.ui.control.Label
        CalibratedLamp                 matlab.ui.control.Lamp
        CalibratedLampLabel            matlab.ui.control.Label
        MotionConvLamp                 matlab.ui.control.Lamp
        MotionConvLabel                matlab.ui.control.Label
        ProfileConvLamp                matlab.ui.control.Lamp
        ProfileConvLampLabel           matlab.ui.control.Label
        ReadyLamp                      matlab.ui.control.Lamp
        ReadyLampLabel                 matlab.ui.control.Label
        HomedLamp                      matlab.ui.control.Lamp
        HomedLampLabel                 matlab.ui.control.Label
        QuickStopLamp                  matlab.ui.control.Lamp
        QuickStopLampLabel             matlab.ui.control.Label
        FaultLamp                      matlab.ui.control.Lamp
        FaultLampLabel                 matlab.ui.control.Label
        ONLamp                         matlab.ui.control.Lamp
        ONLampLabel                    matlab.ui.control.Label
        IdentifyOkLamp                 matlab.ui.control.Lamp
        IdentifyOkLampLabel            matlab.ui.control.Label
        RefModeEditField               matlab.ui.control.EditField
        RefModeEditFieldLabel          matlab.ui.control.Label
        UnitsButtonGroup               matlab.ui.container.ButtonGroup
        EnccountsButton                matlab.ui.control.RadioButton
        MotorButton                    matlab.ui.control.RadioButton
        UserButton                     matlab.ui.control.RadioButton
        SignalsPanel                   matlab.ui.container.Panel
        TemperatureEditField           matlab.ui.control.NumericEditField
        TemperatureEditFieldLabel      matlab.ui.control.Label
        MotorPosEditField              matlab.ui.control.NumericEditField
        MotorPosEditFieldLabel         matlab.ui.control.Label
        OuterPosEditField              matlab.ui.control.NumericEditField
        OuterPosEditFieldLabel         matlab.ui.control.Label
        SpeedEditField                 matlab.ui.control.NumericEditField
        SpeedEditFieldLabel            matlab.ui.control.Label
        CurrentEditField               matlab.ui.control.NumericEditField
        CurrentEditFieldLabel          matlab.ui.control.Label
        ReferencegenPanel              matlab.ui.container.Panel
        GLabel                         matlab.ui.control.Label
        RefOn                          matlab.ui.control.Switch
        TLabel                         matlab.ui.control.Label
        TRefOn                         matlab.ui.control.Switch
        HelpButton                     matlab.ui.control.Button
        RecorderReadyLamp              matlab.ui.control.Lamp
        RecorderReadyLampLabel         matlab.ui.control.Label
        BrakePanel                     matlab.ui.container.Panel
        ToggleBrakeButton              matlab.ui.control.Button
        BrakeLabel                     matlab.ui.control.Label
        Lamp                           matlab.ui.control.Lamp
        SelectaxisButton               matlab.ui.control.Button
        STOEditField                   matlab.ui.control.NumericEditField
        STOEditFieldLabel              matlab.ui.control.Label
        MotorONButton                  matlab.ui.control.Button
        ConnectedLabel                 matlab.ui.control.Label
        TransientExceptionLabel        matlab.ui.control.Label
        TabGroup                       matlab.ui.container.TabGroup
        MotionTab                      matlab.ui.container.Tab
        HomeSWPanel                    matlab.ui.container.Panel
        HomepositionEditField          matlab.ui.control.NumericEditField
        HomepositionEditFieldLabel     matlab.ui.control.Label
        PositivedirectionCheckBox      matlab.ui.control.CheckBox
        Din2Lamp                       matlab.ui.control.Lamp
        DIN2Label                      matlab.ui.control.Label
        DIN1Label                      matlab.ui.control.Label
        Din1Lamp                       matlab.ui.control.Lamp
        HomeButton                     matlab.ui.control.Button
        SystemModeDropDown             matlab.ui.control.DropDown
        SystemModeDropDownLabel        matlab.ui.control.Label
        ATPPanel                       matlab.ui.container.Panel
        TestPositionButton             matlab.ui.control.Button
        ATPresultsLabel                matlab.ui.control.Label
        TextAreaAtpResult              matlab.ui.control.TextArea
        TestcurrentscalesButton        matlab.ui.control.Button
        TestcurrentloopButton          matlab.ui.control.Button
        AborttestButton                matlab.ui.control.Button
        GotonextstepButton             matlab.ui.control.Button
        TestencodersandHallsButton     matlab.ui.control.Button
        CommutationPanel               matlab.ui.container.Panel
        ElectangleEditField            matlab.ui.control.NumericEditField
        ElectangleEditFieldLabel       matlab.ui.control.Label
        CommangleEditField             matlab.ui.control.NumericEditField
        CommangleEditFieldLabel        matlab.ui.control.Label
        OkLamp                         matlab.ui.control.Lamp
        OkLampLabel                    matlab.ui.control.Label
        HallsLabel                     matlab.ui.control.Label
        CLamp                          matlab.ui.control.Lamp
        CLampLabel                     matlab.ui.control.Label
        BLamp                          matlab.ui.control.Lamp
        BLampLabel                     matlab.ui.control.Label
        ALamp                          matlab.ui.control.Lamp
        ALampLabel                     matlab.ui.control.Label
        CodeEditField                  matlab.ui.control.NumericEditField
        CodeEditFieldLabel             matlab.ui.control.Label
        SecEditField                   matlab.ui.control.NumericEditField
        SecEditFieldLabel              matlab.ui.control.Label
        AnalogsPanel                   matlab.ui.container.Panel
        RailsensorNPNCheckBox          matlab.ui.control.CheckBox
        RailsensorPNPCheckBox          matlab.ui.control.CheckBox
        BrakeVoltsEditField            matlab.ui.control.NumericEditField
        BrakeVoltsLabel                matlab.ui.control.Label
        VdcEditField                   matlab.ui.control.NumericEditField
        VdcEditFieldLabel              matlab.ui.control.Label
        POT2EditField                  matlab.ui.control.NumericEditField
        POT2EditFieldLabel             matlab.ui.control.Label
        POT1EditField                  matlab.ui.control.NumericEditField
        POT1EditFieldLabel             matlab.ui.control.Label
        MotorvariablesPanel            matlab.ui.container.Panel
        UserposEditField               matlab.ui.control.NumericEditField
        UserposEditFieldLabel          matlab.ui.control.Label
        Enc2PosEditField               matlab.ui.control.NumericEditField
        Enc2PosEditFieldLabel          matlab.ui.control.Label
        Enc1PosEditField               matlab.ui.control.NumericEditField
        Enc1PosEditFieldLabel          matlab.ui.control.Label
        LoopclosureButtonGroup         matlab.ui.container.ButtonGroup
        LC5Button                      matlab.ui.control.RadioButton
        LC4Button                      matlab.ui.control.RadioButton
        LC3Button                      matlab.ui.control.RadioButton
        LC2Button                      matlab.ui.control.RadioButton
        LC1Button                      matlab.ui.control.RadioButton
        LC0Button                      matlab.ui.control.RadioButton
        CalibrateTab                   matlab.ui.container.Tab
        PotentiometercalibrationPanel  matlab.ui.container.Panel
        AbortCalibButton               matlab.ui.control.Button
        SteerDnButton                  matlab.ui.control.Button
        SteerUpButton                  matlab.ui.control.Button
        NextButton                     matlab.ui.control.Button
        StepsizeDegEditField           matlab.ui.control.NumericEditField
        StepsizeDegEditFieldLabel      matlab.ui.control.Label
        CalibrateplaterotatorButton    matlab.ui.control.Button
        TextArea_2                     matlab.ui.control.TextArea
        TextArea                       matlab.ui.control.TextArea
        CommutationButton              matlab.ui.control.Button
        MotorcurrentsButton            matlab.ui.control.Button
        CalibphasecurrentsButton       matlab.ui.control.Button
        HallsExperimentButton          matlab.ui.control.Button
        AnalogsPanel_2                 matlab.ui.container.Panel
        CAdcRawEditField               matlab.ui.control.NumericEditField
        CAdcRawEditFieldLabel          matlab.ui.control.Label
        BAdcRawEditField               matlab.ui.control.NumericEditField
        BAdcRawEditFieldLabel          matlab.ui.control.Label
        AAdcRawEditField               matlab.ui.control.NumericEditField
        AAdcRawEditFieldLabel          matlab.ui.control.Label
        CcurrentEditField              matlab.ui.control.NumericEditField
        CcurrentEditFieldLabel         matlab.ui.control.Label
        BcurrentEditField              matlab.ui.control.NumericEditField
        BcurrentEditFieldLabel         matlab.ui.control.Label
        AcurrentEditField              matlab.ui.control.NumericEditField
        AcurrentEditFieldLabel         matlab.ui.control.Label
        ResetCalibButton               matlab.ui.control.Button
        CalibrationdataPanel           matlab.ui.container.Panel
        CalibdateEditField             matlab.ui.control.NumericEditField
        CalibdateEditFieldLabel        matlab.ui.control.Label
        CalibIDEditField               matlab.ui.control.NumericEditField
        CalibIDEditFieldLabel          matlab.ui.control.Label
        CalibexistsCheckBox            matlab.ui.control.CheckBox
        ParametersTab                  matlab.ui.container.Tab
        SheetsDropDown                 matlab.ui.control.DropDown
        SheetsDropDownLabel            matlab.ui.control.Label
        Download2driveButton           matlab.ui.control.Button
        SaveExcelButton                matlab.ui.control.Button
        LoadExcelButton                matlab.ui.control.Button
        ParTable                       matlab.ui.control.Table
        SigGenTab                      matlab.ui.container.Tab
        Label                          matlab.ui.control.Label
        TorquereferenceTPanel          matlab.ui.container.Panel
        TDutyEditField                 matlab.ui.control.NumericEditField
        DutyEditField_2Label           matlab.ui.control.Label
        TAmplitudeEditField            matlab.ui.control.NumericEditField
        AmplitudeEditField_2Label      matlab.ui.control.Label
        TFrequencyEditField            matlab.ui.control.NumericEditField
        FrequencyEditField_2Label      matlab.ui.control.Label
        TDCEditField                   matlab.ui.control.NumericEditField
        DCEditField_2Label             matlab.ui.control.Label
        TMethodButtonGroup             matlab.ui.container.ButtonGroup
        TriangleTorqueButton           matlab.ui.control.RadioButton
        SquareTorqueButton             matlab.ui.control.RadioButton
        SineTorqueButton               matlab.ui.control.RadioButton
        FixedTorqueButton              matlab.ui.control.RadioButton
        MainreferenceGPanel            matlab.ui.container.Panel
        SpeedCheckBox                  matlab.ui.control.CheckBox
        AnglePeriodEditField           matlab.ui.control.NumericEditField
        AnglePeriodEditFieldLabel      matlab.ui.control.Label
        DutyEditField                  matlab.ui.control.NumericEditField
        FrequencyEditField_2Label_2    matlab.ui.control.Label
        FrequencyEditField             matlab.ui.control.NumericEditField
        FrequencyEditFieldLabel        matlab.ui.control.Label
        AmplitudeEditField             matlab.ui.control.NumericEditField
        AmplitudeEditFieldLabel        matlab.ui.control.Label
        DCEditField                    matlab.ui.control.NumericEditField
        DCEditFieldLabel               matlab.ui.control.Label
        MethodButtonGroup              matlab.ui.container.ButtonGroup
        TriangleRefButton              matlab.ui.control.RadioButton
        SquareRefButton                matlab.ui.control.RadioButton
        SineRefButton                  matlab.ui.control.RadioButton
        FixedRefButton                 matlab.ui.control.RadioButton
        CurrentLoopTab                 matlab.ui.container.Tab
        BringrecorderButton            matlab.ui.control.Button
        KillprefilterCheckBox          matlab.ui.control.CheckBox
        KeVHzEditField                 matlab.ui.control.NumericEditField
        KeVHzEditFieldLabel            matlab.ui.control.Label
        InitRecorderButton             matlab.ui.control.Button
        CurControllerKiEditField       matlab.ui.control.NumericEditField
        CurControllerKiEditFieldLabel  matlab.ui.control.Label
        CurControllerKpEditField       matlab.ui.control.NumericEditField
        CurControllerKpEditFieldLabel  matlab.ui.control.Label
        SlopelimitAmsecEditField       matlab.ui.control.NumericEditField
        SlopelimitAmsecEditFieldLabel  matlab.ui.control.Label
        PrefilterBWHzEditField         matlab.ui.control.NumericEditField
        PrefilterBWHzEditFieldLabel    matlab.ui.control.Label
        UIAxesVoltage                  matlab.ui.control.UIAxes
        UIAxesCurrent                  matlab.ui.control.UIAxes
        ConfigTab                      matlab.ui.container.Tab
        SheetsDropDownCfg              matlab.ui.control.DropDown
        SheetsDropDown_2Label          matlab.ui.control.Label
        Download2driveButtonCfg        matlab.ui.control.Button
        SaveCfgExcelButton             matlab.ui.control.Button
        LoadCfgExcelButton             matlab.ui.control.Button
        CfgTabEdit                     matlab.ui.control.Table
        SpeedLoopTab                   matlab.ui.container.Tab
        TriggerPanel                   matlab.ui.container.Panel
        DropDownSpeedTrigType          matlab.ui.control.DropDown
        DropDownSpeedTrigSignal        matlab.ui.control.DropDown
        EditTriggerPercent             matlab.ui.control.NumericEditField
        Label_2                        matlab.ui.control.Label
        SpeedTriggerEditField          matlab.ui.control.NumericEditField
        ValueEditFieldLabel            matlab.ui.control.Label
        BringrecorderButton_2          matlab.ui.control.Button
        RecTimeEditField               matlab.ui.control.NumericEditField
        RecTimeEditFieldLabel          matlab.ui.control.Label
        AutotimeCheckBox               matlab.ui.control.CheckBox
        Includefilter2CheckBox         matlab.ui.control.CheckBox
        Includefilter1CheckBox         matlab.ui.control.CheckBox
        CurrentlimitEditField          matlab.ui.control.NumericEditField
        CurrentlimitEditFieldLabel     matlab.ui.control.Label
        InitRecordButton               matlab.ui.control.Button
        SpeedKiEditField               matlab.ui.control.NumericEditField
        SpeedKiEditFieldLabel          matlab.ui.control.Label
        SpeedKpEditField               matlab.ui.control.NumericEditField
        SpeedKpEditFieldLabel          matlab.ui.control.Label
        UIAxes2                        matlab.ui.control.UIAxes
        UIAxes                         matlab.ui.control.UIAxes
        PositionTab                    matlab.ui.container.Tab
        HereButton_2                   matlab.ui.control.Button
        HereButton                     matlab.ui.control.Button
        ControlPanel                   matlab.ui.container.Panel
        MaxAccEditField                matlab.ui.control.NumericEditField
        MaxAccEditFieldLabel           matlab.ui.control.Label
        KpEditField                    matlab.ui.control.NumericEditField
        KpEditFieldLabel               matlab.ui.control.Label
        StopButton                     matlab.ui.control.Button
        TargetHEditField               matlab.ui.control.NumericEditField
        TargetHEditFieldLabel          matlab.ui.control.Label
        PeriodicCheckBox               matlab.ui.control.CheckBox
        GoButton                       matlab.ui.control.Button
        TargetLEditField               matlab.ui.control.NumericEditField
        TargetLEditFieldLabel          matlab.ui.control.Label
        DecelerationEditField          matlab.ui.control.NumericEditField
        DecelerationEditFieldLabel     matlab.ui.control.Label
        AccelerationEditField          matlab.ui.control.NumericEditField
        AccelerationEditFieldLabel     matlab.ui.control.Label
        PosTrajSpeedEditField          matlab.ui.control.NumericEditField
        SpeedEditField_2Label          matlab.ui.control.Label
        PosRecTimeEditField            matlab.ui.control.NumericEditField
        SecEditField_2Label            matlab.ui.control.Label
        CurrentlimitEditFieldPos       matlab.ui.control.NumericEditField
        CurrentlimitEditField_2Label   matlab.ui.control.Label
        TriggerPanel_2                 matlab.ui.container.Panel
        DropDownPosTrigType            matlab.ui.control.DropDown
        DropDownPosTrigSignal          matlab.ui.control.DropDown
        EditPosTriggerPercent          matlab.ui.control.NumericEditField
        Label_3                        matlab.ui.control.Label
        PosTriggerEditField            matlab.ui.control.NumericEditField
        ValueEditFieldLabel_2          matlab.ui.control.Label
        BringrecorderButtonPos         matlab.ui.control.Button
        AutotimeCheckBoxPos            matlab.ui.control.CheckBox
        InitRecordButtonPos            matlab.ui.control.Button
        UIAxesPosH                     matlab.ui.control.UIAxes
        UIAxesPosL                     matlab.ui.control.UIAxes
        ExceptionLabel                 matlab.ui.control.Label
        InstructionsLabel              matlab.ui.control.Label
        WheeldrivedialogLabel          matlab.ui.control.Label
    end

    
    properties (Access = private)
        EvtObj % Description
        Timer  % Description
        Lock % Description
        CalibExist % Description
        Geom % Description
        ModeEntryCnt % Description
        TabDefaultPars % Description
        rawPars % Description
        ParSheets % Description
        XlsFileName % Description
        BupTable % Description
        IndArray % Description
        Property14 % Description
        s 
        ClosureModeStrings % Description
        CalibInit  % Description
        CalibRslt % Description
        SystemModesDict % Description
        DataType % Description
        Enums % Description
        DisConnectionCnt % Description
        CfgTable % Description
        GetAnalogsList % Description
        Card % The card, Servo or Intfc
        Axis % The axis, Wheel or Steer
        CreateStruct  % Description
        Project % Description
        Init % Description
        RecStruct % Description
        TabDefaultCfg% Description
        CgfRaw % Description
        CfgInd % Description
        CfgBupTable % Description
        CommModes % Description
        CfgSheets % Description
        CfgXlsFile % Description
        CurKp % Description
        CurKi % Description
        CurPrefBw 
        CurPrefSlope
        KeHz % Description
        SpeedCtlVars % Description
        RecMng % Description
        SysData  % Description
        SelectMot  % Description
        RegisteredTab % Description
        InAtpExperiment  % Description
        AtpState % Description
        AtpExpVarNames % Description
        SnapTypeFlags % Description
        ExpMng % Description
        UseBlockDownload % Description
        IsLocalBrake % Description
        IntfcCardCanId % Description
        IsWheel  % Description
        ProjId % Description
        UseCase % Description
        IsServoCard  % Description
        IntfcStr  % Description
        ProjName % Description
        InCalibExp % Description
    end
    
    methods (Access = private)
        
        function update_srv_display(app )
            % global DataType 
            global TmMgrTS %#ok<*GVMIS,*GVMIS> 

            global BitKillTime 

% %             global kuku ; 
% %             if kuku == 1  
% %                 app.EmergencyButton.Text = 'Release';
% %             else
% %                 app.EmergencyButton.Text = 'EMCY Kill' ; 
% %             end
%            disp(kuku) ; 
%             disp(app.EmergencyButton.Value) ; 

            tnow = clock ; %#ok<*CLOCK> 
            if etime ( tnow , BitKillTime  )  < 0 %#ok<*DETIM,*DETIM> 
                return ; 
            end

            try
            cnt = TmMgrTS.GetCounter('WHBIT') ; 
            
            if cnt < -0.5e-6 
                WheelDrvUIFigureCloseRequest(app, []); 
                %delete( hobj) ; 
            else
                TmMgrTS.IncrementCounter('WHBIT',2) ; 
            end     
                
            catch 
            end

            if app.Lock
                return ; 
            end

            if app.SelectMot
                app.TabGroup.SelectedTab = app.MotionTab;
                app.SelectMot = 0 ; 
            end

            % Check connection target
            % SetDialogTarget(app) ;
            
            % Check connection 
            try 
                app.s = SGetState(); 
                app.ConnectedLabel.BackgroundColor = [1,1,0] ; 
                app.ConnectedLabel.Text = 'Connected' ;
                app.DisConnectionCnt = 0 ; 
            catch
                if app.DisConnectionCnt > 3 
                    app.ConnectedLabel.BackgroundColor = [1,0,0] ; 
                    app.ConnectedLabel.Text = 'Not connected' ;
                else
                    app.DisConnectionCnt = app.DisConnectionCnt + 1 ; 
                end
                return 
            end 

            if app.s.Bit.MotorOn 
                app.ONLamp.Color = [0, 1, 0 ];
                app.ReadyLamp.Color = [0, 1, 0 ];
            else
                if app.s.Bit.MotorReady
                    app.ReadyLamp.Color = [0, 1, 0 ];
                    app.ONLamp.Color = [0, 0, 1 ];
                else
                    if ( app.s.Bit.Fault )
                        app.ReadyLamp.Color = [1, 0, 0 ];
                    else
                        app.ReadyLamp.Color = [0, 0, 1 ];
                    end
                    app.ONLamp.Color = [1, 0, 0 ];
                end
            end

            if app.s.Bit.Fault 
                app.FaultLamp.Color = [1, 0, 0 ];
            elseif ( app.s.Bit.SystemMode == app.RecStruct.Enums.SysModes.E_SysMotionModeSafeFault) 
                app.FaultLamp.Color = [1, 0.5 , 0.5 ];
            elseif ( app.s.Bit.SystemMode == app.RecStruct.Enums.SysModes.E_SysMotionModeFault) 
                app.FaultLamp.Color = [1, 0, 1 ];
            else
                app.FaultLamp.Color = [1, 1, 1] * 0.5;
            end

            if app.s.Bit.Configured 
                app.ConfigButton.BackgroundColor = [0, 1, 0 ];
                app.ConfigButton.Text = 'Configured';
            else
                app.ConfigButton.BackgroundColor = [1, 0, 0 ];
                app.ConfigButton.Text = 'Set Config';
            end


            if app.s.Bit.Homed 
                app.HomedLamp.Color = [0, 1, 0 ];
            else
                app.HomedLamp.Color = [0, 0, 1 ];
            end

            if app.s.Bit.ProfileConverged 
                app.ProfileConvLamp.Color = [0, 0, 1 ];
            else
                app.ProfileConvLamp.Color = [1, 1, 1 ] * 0.3;
            end
           

            if app.s.Bit.MotionConverged
                app.MotionConvLamp.Color = [0, 0 , 1];
            else
                app.MotionConvLamp.Color = [1, 1, 1 ] * 0.3;
            end
           
            if app.s.Bit.DisableAutoBrake
                app.StartStopenaLamp.Color = [0, 0,  1];
            else
                app.StartStopenaLamp.Color = [0, 1, 0];
            end
           
            if app.s.Bit.InAutoBrakeEngage
                app.AutoStopLamp.Color = [0, 0,  1];
            else
                app.AutoStopLamp.Color = [1 1, 1] * 0.3;
            end

            if app.s.Bit.NoCalib
                app.CalibratedLamp.Color = [1, 0,  0];
            else
                app.CalibratedLamp.Color = [0, 1, 0];
            end
           
           
            if app.s.Bit.QuickStop == 0  
                app.QuickStopLamp.Color = [0, 1, 0 ];
            else
                app.QuickStopLamp.Color = [1, 0, 0 ];
            end
            if app.s.Bit.IsValidIdentity 
                app.IdentifyOkLamp.Color = [0, 1, 0 ];
            else
                app.IdentifyOkLamp.Color = [1, 0, 0 ];
            end



            ManageMotorOn(app); 
            app.CurrentEditField.Value = app.s.base.Iq; 
            app.ExceptionLabel.Text = ...
                ['Last failure : (0x',dec2hex(app.s.Bit.LastException),')', Errtext( app.s.Bit.LastException )  ,... % Add neck 
                '  Killing failure : (0x',dec2hex(app.s.Bit.AbortException ),')', Errtext( app.s.Bit.AbortException )] ;  % Add neck 

            % Recorder indication 
            if app.s.Bit.RecorderReady
                app.RecorderReadyLamp.Color = [0 1 0] ;
                app.BringrecorderButton_2.Enable = 1 ; 
                app.BringrecorderButton.Enable = 1 ; 
            elseif app.s.Bit.RecorderActive
                app.RecorderReadyLamp.Color = [0 0 1 ]; 
                app.BringrecorderButton_2.Enable = 0 ; 
                app.BringrecorderButton.Enable = 0 ; 
            else
                app.RecorderReadyLamp.Color = [1 1 1 ] * 0.1; 
                app.BringrecorderButton_2.Enable = 0 ; 
                app.BringrecorderButton.Enable = 0 ; 
            end

            % General displays
            app.SpeedEditField.Value = app.s.base.UserSpeed  ; 

            if app.InAtpExperiment 
                app.TabGroup.SelectedTab = app.MotionTab ;  
                app.GotonextstepButton.Visible = 'on' ; 
                app.AborttestButton.Visible = 'on' ; 
            else
                app.GotonextstepButton.Visible = 'off' ; 
                app.AborttestButton.Visible = 'off' ; 
            end

            selectedButton = app.UnitsButtonGroup.SelectedObject;

            switch selectedButton.UserData 
                case 1
                    app.MotorPosEditField.Value = app.s.base.UserPos ; 
                case 2
                    app.MotorPosEditField.Value = app.s.base.MotorPos ; 
                case 3
                    app.MotorPosEditField.Value = app.s.base.EncCounts ; 
                otherwise
                    app.MotorPosEditField.Value = 0 ; 
            end
            app.OuterPosEditField.Value = app.s.base.OuterPos ;
            app.TemperatureEditField.Value = app.s.base.BridgeTemperature ;

            if app.s.Bit.BrakeRelease 
                app.Lamp.Color = [0,0,1] ; 
                app.BrakeLabel.Text = 'Released'; 
            else
                app.Lamp.Color = [1,1,1] * 0.3 ; 
                app.BrakeLabel.Text = 'Engaged'; 
            end
            % app.ReleaseCheckBox.Value = app.s.Bit.BrakeRelease ;


            % Reference generator indicators
            Items =  {'Off'  'On'}; 

            app.RefOn.Value = Items{app.s.Bit.RefGenOn+1} ; 
            app.TRefOn.Value = Items{app.s.Bit.TRefGenOn+1} ; 

            app.RefModeEditField.Value = GetEnumString( app.Enums.ReferenceModes, app.s.Bit.ReferenceMode) ;

            % Handle ATP 
            switch app.InAtpExperiment
                case 2
                    if app.ExpMng.NextCnt >= 1 
                        app.InAtpExperiment = 0 ; 
                        app.ExpMng.NextCnt = 0 ; 
                        app.GotonextstepButton.Visible = 'off' ; 
                        app.InstructionsLabel.Text = 'Done' ; 
                        motor(0) ;
                    end
                otherwise
                    app.InAtpExperiment = 0 ; 
            end

            if app.InCalibExp 
                switch app.ExpMng.NextAction 
                    case 'CalibRotatorCenter'
                        app.ExpMng = CalibRotatorMgr(app.ExpMng) ; 
                    case 'CalibNeckCenter'
                        app.ExpMng = CalibNeckMgr(app.ExpMng) ; 
                    case 'CalibSteerCenter'
                        app.ExpMng = CalibSteerMgr(app.ExpMng) ; 
                end
                if app.ExpMng.NextCnt == 0  
                    app.InCalibExp  = 0 ; 
                end
                app.InstructionsLabel.Text= app.ExpMng.MessageToHumanity ; 
            else
                app.ExpMng.ButtonVisibility = 'off' ; 
            end
            app.NextButton.Visible = app.ExpMng.ButtonVisibility ;  

            
            % Tab - specific function 
            if isequal ( app.TabGroup.SelectedTab.UserData , 1) 
                % Motion Tab 
                app.CommutationPanel.Title = ['Commutation , mode: ',app.CommModes{app.s.Bit.CommutationMode+1 }];
                try

                    app.VdcEditField.Value = app.s.base.Vdc ;
                    app.BrakeVoltsEditField.Value = app.s.base.BrakeVolts ;

                    app.RailsensorPNPCheckBox.Value = logical( bitand(app.s.Bit.RailSwitchState,1) ) ;
                    app.RailsensorNPNCheckBox.Value = logical( bitand(app.s.Bit.RailSwitchState,4) ) ;
                    

                    %app.OuterPosEditField.Value = app.s.base.OuterPos ;
                    app.UserposEditField.Value =  app.s.base.UserPos ;
                    
    
                    app.SystemModeDropDown.Value = GetDictEntry( app.SystemModesDict  , app.s.Bit.SystemMode  ) ; 
                    if ~( app.s.Bit.ReferenceMode == app.Enums.ReferenceModes.E_RefModeSpeed2Home )
                        SetClosureRadio(app,app.s.Bit.LoopClosure) ; 
                    end


%                     if app.s.Bit.RecorderActive 
%                         app.RecorderEditField.Value = 'Active' ; 
%                     elseif app.s.Bit.RecorderWaitTrigger 
%                         app.RecorderEditField.Value = 'Wait trigger' ; 
%                     elseif app.s.Bit.RecorderReady 
%                         app.RecorderEditField.Value = 'Data ready' ; 
%                     else
%                         app.RecorderEditField.Value = 'Idle' ; 
%                     end

                    if ( bitand(app.s.Bit.HallKey,1) )
                        app.ALamp.Color = [0,1,0]; 
                    else
                        app.ALamp.Color = [0,0,1]; 
                    end
                    if ( bitand(app.s.Bit.HallKey,2) )
                        app.BLamp.Color = [0,1,0]; 
                    else
                        app.BLamp.Color = [0,0,1]; 
                    end
                    if ( bitand(app.s.Bit.HallKey,4) )
                        app.CLamp.Color = [0,1,0]; 
                    else
                        app.CLamp.Color = [0,0,1]; 
                    end
                    if ( app.s.Bit.HallKey == 0 || app.s.Bit.HallKey == 7 ) 
                        app.CodeEditField.BackgroundColor = [1 , 0,0 ] * 0.75 ; 
                    else
                        app.CodeEditField.BackgroundColor = [0 , 1,1 ] * 0.75 ; 
                    end
                    app.CodeEditField.Value = app.s.Bit.HallKey ; 
                    app.SecEditField.Value = app.s.Bit.HallValue ;

                    if app.s.Bit.CommException || app.s.Bit.HallException 
                        app.OkLamp.Color = [1,0,0] ; 
                    else
                        app.OkLamp.Color = [0,1,0] ; 
                    end
                    app.CommangleEditField.Value  = app.s.base.CommAngle;
                    app.ElectangleEditField.Value = app.s.base.ThetaElect ;  


%                     app.Enc1PosEditField.Value = app.base.EncCounts; 
%                     app.UserposEditField.Value = app.base.UserPos ; 
% 

                   if app.IsServoCard 
                       pot1 = FetchObj( [hex2dec('2002'),app.IntfcStr.PotFiltSubIndex,app.IntfcStr.IntfcCanId ] , app.DataType.float ,'Pot1');
                       app.POT2EditField.Enable = "off" ; 
                       %outerpos = GetSignal('OuterPosInt') ; 
                       %app.Enc2PosEditField.Value = fix(outerpos) ; 
                       if app.IsWheel 
                           enc1 = FetchObj( [hex2dec('2002'),app.IntfcStr.Pos1,app.IntfcStr.IntfcCanId ] , app.DataType.long ,'Position 1');
                           encAux = FetchObj( [hex2dec('2002'),app.IntfcStr.Pos3,app.IntfcStr.IntfcCanId ] , app.DataType.long ,'Position Aux');
                           app.Enc2PosEditField.Value = encAux ; 
                       else
                           enc1 = FetchObj( [hex2dec('2002'),app.IntfcStr.Pos2,app.IntfcStr.IntfcCanId ] , app.DataType.long ,'Position 2');
                           app.Enc2PosEditField.Enable = 'off' ; 
                       end
                   else
                        pot1 = GetSignal('PotFilt0') ; 
                        pot2 = GetSignal('PotFilt1') ; 
                        app.POT2EditField.Value = pot2 ; 
                        enc1 = app.s.base.EncCounts ; 
                        app.Enc2PosEditField.Enable = 'off' ; 
                   end
                   app.POT1EditField.Value = pot1 ; 
                   app.Enc1PosEditField.Value = enc1 ;

                    if app.UseCase.Sw1 
                        if bitand(app.s.Bit.Din,1)
                            app.Din1Lamp.Color = [0,0,1] ;
                        else
                            app.Din1Lamp.Color = [1,1,1] * 0.5 ;
                        end
                    elseif app.IsWheel
                        if bitand(app.s.Bit.RailSwitchState,1)
                            app.Din1Lamp.Color = [0,0,1] ;
                        else
                            app.Din1Lamp.Color = [1,1,1] * 0.5 ;
                        end
                    end
                    if app.UseCase.Sw2 
                        if bitand(app.s.Bit.Din,2)
                            app.Din2Lamp.Color = [0,0,1] ;
                        else
                            app.Din2Lamp.Color = [1,1,1] * 0.5 ;
                        end
                    end


                catch 
                end 
            end

            if isequal ( app.TabGroup.SelectedTab.UserData , 2) 
                % Calibration tab 
                try 
                    slist = GetSignalsByList(app.GetAnalogsList) ; 
                    app.AcurrentEditField.Value = slist.PhaseCur0 ; 
                    app.BcurrentEditField.Value = slist.PhaseCur1 ; 
                    app.CcurrentEditField.Value = slist.PhaseCur2 ; 
    
                    app.AAdcRawEditField.Value = slist.PhaseCurAdc0 ; 
                    app.BAdcRawEditField.Value = slist.PhaseCurAdc1 ; 
                    app.CAdcRawEditField.Value = slist.PhaseCurAdc2 ; 
                catch
                    x = 1; %#ok<NASGU> 
                end 
            end

            if isequal ( app.TabGroup.SelectedTab.UserData , 4) 
                % Reference generator tab 
            end

%                 app.ExceptionLabel.Text = ...
%                     ['Last failure : ', Errtext( app.s.Bit.LastException )  ,...
%                     '  Fatal failure : ', Errtext( app.s.Bit.AbortException )] ; 
            if isequal ( app.TabGroup.SelectedTab.UserData , 5) 
                % Current control 
                app.KillprefilterCheckBox.Value = logical(app.s.Bit.CurrentPrefOff) ; 
            end 
            
            if isequal ( app.TabGroup.SelectedTab.UserData , 8) % Pos control
                if app.PeriodicCheckBox.Value
                    app.TargetHEditField.Enable = 'on' ; 
                else
                    app.TargetHEditField.Enable = 'off' ; 
                end
            end


        end
        
        
        
        
        function stat = SendObjDisp(app,mux,value,datatype,msg)
            try 
                [stat,errstr]  = SendObj( mux, double(value) , datatype , msg) ;  
            catch me
                errstr = ['Could not send SDO :',msg,' : ',me.message] ; 
                stat   = -1 ; 
            end           
            if ~isempty(errstr) 
                app.TransientExceptionLabel.Text = errstr ;
            end
        end
        
        function s = makeheader(~,enum,pre,post )
            f = fieldnames(enum) ; 
            n = length(f) ; 
            s = cell(1,n) ;
            npre = length(pre) ; 
            for cnt = 1:n 
                next = f{cnt} ; 
                nextt = next ; 
                place = strfind(next,pre) ; 
                if ~isempty(place) 
                    nextt = nextt( place+npre:end) ; 
                end
                place = strfind(nextt,post) ; 
                if ~isempty(place) 
                    nextt = nextt( 1:place-1) ; 
                end
                m = enum.(next)+1; 
                if ( m <= length(s) )
                    s{m} = nextt ;  
                end
            end
            while isempty( s{length(s)})
                s = s(1:length(s)-1) ; 
            end
        end
        
        function SetClosureRadio(app , mode )
            switch mode
                case 0
                    app.LoopclosureButtonGroup.SelectedObject = app.LC0Button; 
                case 1
                    app.LoopclosureButtonGroup.SelectedObject = app.LC1Button; 
                case 2
                    app.LoopclosureButtonGroup.SelectedObject = app.LC2Button; 
                case 3
                    app.LoopclosureButtonGroup.SelectedObject = app.LC3Button; 
                case 4
                    app.LoopclosureButtonGroup.SelectedObject = app.LC4Button; 
                case 5
                    app.LoopclosureButtonGroup.SelectedObject = app.LC5Button; 
                case 6
                    app.LoopclosureButtonGroup.SelectedObject = app.LC3Button; 
            end            
        end
        
        function RefreshCalibPanel(app)
            global DataType
            % Bring calibration from flash 
            stat = SendObj( [hex2dec('2302'),251] , 0 , DataType.long ,'Load the calibration from the flash to the programming struct') ;  
            if ( stat )
                app.CalibInit = SaveCalib ( 0   ) ; 
                cc = clock ; 
                app.CalibdateEditField.Value =  cc(3) + cc(2) * 100 + cc(1) * 10000 ; 
                app.CalibIDEditField.Value = 0 ; 
                app.CalibExist = 0 ;
            else
                app.CalibInit = SaveCalib ( []   ) ;
                app.CalibdateEditField.Value = app.CalibInit.CalibDate ; 
                app.CalibIDEditField.Value = app.CalibInit.CalibData ; 
                app.CalibExist = 1 ;
            end
            app.CalibexistsCheckBox.Value = app.CalibExist ; 
            app.CalibRslt = app.CalibInit ; 
        end
        
        function stat = SetMasterBlaster(app)
            stat = SendObjDisp(app,[hex2dec('2220'),2],hex2dec('12345'),app.DataType.long,'Set Master Blaster mode') ; 
        end
        
        function ManageMotorOn(app) % Revised for neck 
            if app.s.Bit.SystemMode == (app.Enums.SysModes.E_SysMotionModeAutomatic ) 
               app.MotorONButton.BackgroundColor = [1,1,1] * 0.75 ;
               app.MotorONButton.Text = 'Set to Manual' ; 
               app.ToggleBrakeButton.Enable = 'off' ; 
               % app.ReleaseCheckBox.Value = 0 ; 

            elseif app.s.Bit.SystemMode == ( app.Enums.SysModes.E_SysMotionModeFault ) 
                   app.MotorONButton.BackgroundColor = [1,0,0];
                   app.MotorONButton.Text = 'Reset Error' ; 
                   app.ToggleBrakeButton.Enable = 'on' ; 
            elseif app.s.Bit.MotorOn
               app.MotorONButton.BackgroundColor = [0,1,0];
               app.MotorONButton.Text = 'Motor Off' ; 
               app.ToggleBrakeButton.Enable = 'off' ; 
               %app.ReleaseCheckBox.Value = 0 ; 
            else
               app.MotorONButton.BackgroundColor = [0,1,1];
               app.MotorONButton.Text = 'Motor On' ; 
               app.ToggleBrakeButton.Enable = 'on' ; 
            end
            
            app.STOEditField.Value = app.s.base.StoVolts ; % Add neck 
            if ( app.s.Bit.StoEvent )
                app.STOEditField.BackgroundColor = [1 0 0 ] * 0.85; 
            else
                app.STOEditField.BackgroundColor = [0 1 0 ] * 0.85 ; 
            end 
        end
        
        function stat = FetchObjDisp(app,mux,datatype,msg)
            try 
                [stat,errstr]  = FetchObj( mux , datatype , msg) ;  
            catch 
                errstr = ['Could not fetch SDO :',msg] ; 
                stat   = -1 ; 
            end           
            if ~isempty(errstr) 
                try 
                    app.TransientExceptionLabel.Text = errstr ;
                catch 
                    app.TransientExceptionLabel.Text = 'General error' ;
                end
            end
        end
        
        function SetDialogTarget(app)
            global RecStruct ; 

            lockbup = app.Lock ; 
            app.Lock = 1 ;

            app.Card = RecStruct.Card  ; 
            app.Axis = RecStruct.Axis  ; 
            app.UseBlockDownload = 1 ; % Vandal, should be 1
%             switch app.Axis 
%                 case 'Neck' 
%                     app.UseBlockDownload = 1; 
%                 otherwise
%                     app.UseBlockDownload = 0; 
%             end

            app.Project = RecStruct.Proj ; 
            side = RecStruct.Side  ; 

            SetCanComTarget(app.Card,side,app.Axis,app.Project) ;
            
            if isequal(lower(app.Project(1:2)),'si') || isequal(lower(app.Card),'Intfc' ) || ...
                    startsWith(lower(app.Axis),'wheel') 
                app.IsLocalBrake = 1 ; 
            else
                app.IsLocalBrake = 0 ;
                if  isequal( lower(side),'right'  ) 
                    app.IntfcCardCanId = 24  ;                    
                else
                    app.IntfcCardCanId = 14  ;                    
                end
            end

            if startsWith(lower(app.Axis),'wheel')  
                app.IsWheel = 1 ; 
            else
                app.IsWheel = 0 ; 
            end

            app.Init = 1 ; 

            app.CfgTable = RecStruct.CfgTable ; 
            app.Enums = RecStruct.Enums ; 
            
            app.XlsFileName = RecStruct.ParsXlsFile ; 
            app.ParSheets = sheetnames( app.XlsFileName) ; 

            app.CfgXlsFile = RecStruct.CfgXlsFile ; 
            app.CfgSheets = sheetnames( app.CfgXlsFile) ; 

            app.SheetsDropDown.Items = app.ParSheets ; 
            app.SheetsDropDown.Value = 'DefaultPars'; 

            app.SheetsDropDownCfg.Items = app.CfgSheets ; 
            app.SheetsDropDownCfg.Value = 'DefaultCfg'; 

            [app.TabDefaultPars,app.rawPars,app.IndArray,app.TabDefaultCfg,app.CgfRaw,app.CfgInd] = InitDrvSetup(app.XlsFileName ,  app.CfgXlsFile ) ;
            app.ParTable.Data = app.TabDefaultPars ; 
            app.ParTable.ColumnName = app.TabDefaultPars.Properties.VariableNames ;
            app.ParTable.RowName = app.TabDefaultPars.Properties.RowNames ;
            app.ParTable.ColumnEditable = logical([1,0,0,1,0]);
            app.BupTable = app.ParTable.Data ; 

            %app.Lock = 1 ;
            app.CfgTabEdit.Data = app.TabDefaultCfg ; 
            app.CfgTabEdit.ColumnName = app.TabDefaultCfg.Properties.VariableNames ;
            app.CfgTabEdit.RowName = app.TabDefaultCfg.Properties.RowNames ;
            app.CfgTabEdit.ColumnEditable = logical([0,0,0,0,0,0,0,1]);
            app.CfgBupTable = app.CfgTabEdit.Data ; 


            
            app.SystemModesDict = MakeTableFromEnum(RecStruct.Enums.SysModes) ; 

            app.GetAnalogsList = RecStruct.AnalogsList ; 

            app.Lock = lockbup ; 

            % Get System data 
            GetSysData(app) ; 

        end
        
        function UpdateDisplayWrapper(app,~,~ ) 
            try 
                update_srv_display(app );
            catch myerr
                x = myerr.message ; %#ok<NASGU> 
            end 
            app.Lock = 0 ; 
        end
        
        function SetProjlabel(app)
            global RecStruct 
            global AtpCfg 
            app.RecStruct = RecStruct ;
            app.ProjName = char(AtpCfg.ProjListWithBoot(app.ProjId))  ;
            if  startsWith( lower(app.RecStruct.Proj ),'sing' )
                app.WheeldrivedialogLabel.Text = ['Single axis , Card:' , app.RecStruct.Card,' : ', app.ProjName , '  :VER:', DrvVersionString(app.RecStruct.SwVer)] ;  
                app.TestPositionButton.Text = "Test Position";
            else
                app.WheeldrivedialogLabel.Text = ['Wheels assy ,' , app.RecStruct.Axis, ' : ' , app.RecStruct.Side , '  :VER:', DrvVersionString(app.RecStruct.SwVer)];  
                %if startsWith(lower(app.RecStruct.Axis),'steer')
                    app.TestPositionButton.Text = "Test Speed";
                %else
                %    app.TestPositionButton.Text = "Test Speed";
                %end
            end
        end

        
        function RefreshConfigPanel(app)
            %global DataType  
            Cfg = SaveCfg([]) ; 
            ncol = find(strcmp( app.CfgTabEdit.ColumnName,'Value'),1) ; 
            f = fieldnames(Cfg) ;
            nf = length(f) ; 
            for cnt = 1:nf
                app.CfgTabEdit.Data{cnt,ncol} = num2cell(Cfg.(f{cnt}))  ; 
            end
            app.CfgBupTable = app.CfgTabEdit.Data ;  
        end
        
        function GetSysData(app)

            selectedButton = app.UnitsButtonGroup.SelectedObject;
            app.SysData = struct('Rev2Pos',GetFloatPar('ClaControlPars.Rev2Pos') ,'EncoderCountsFullRev', GetFloatPar('ControlPars.EncoderCountsFullRev') ,...
                'MaxPositionCmd',GetFloatPar('ControlPars.MaxPositionCmd'),'MinPositionCmd',GetFloatPar('ControlPars.MinPositionCmd') ,...
                'MaxCurCmd',GetFloatPar('ControlPars.MaxCurCmd') ,'PosUnitSelect',selectedButton.UserData)  ; 
        end
        
        function IsNew = RegisterRab(app , newdata)
            if nargin < 2 
                newdata = app.TabGroup.SelectedTab.UserData; 
            end
            if isequal(newdata,app.RegisteredTab ) 
                IsNew = 0 ; 
                return ; 
            else
                app.RegisteredTab  = newdata ; 
                IsNew = 1 ; 
            end 
        end
        
        function VerifyAxisConfig(app) 
           if ( ~app.s.Bit.Configured )
                if app.s.Bit.MotorOn 
                    SendObj([hex2dec('2220'),4],0,app.DataType.long,'Set motor enable/disable') ;
                end
                SaveCfg([],'StamCfg.jsn') ; 
                ProgCfg('StamCfg.jsn') ; 
           end
        end
        
        function  AtpBasicSetup(app)
            motor(0);
            VerifyAxisConfig(app) ; 
            switch app.Axis 
                case 'Neck' 
                    app.ExpMng = struct('CurLevel',3,'nCycle',5,'WaitTime',3,'CycleTime',1,'npp',4) ; 
                    % Experiment parameters 
                    ExperimentSafeLimits = struct( 'OverCurrent' , 16 , 'Undervoltage' , 20  , 'Overvoltage' , 60) ; 
                case 'Wheel'
            %        ExpMng = struct('R',0.38,'L',1.e-3,'CurLevel',2,'F1',100,'F2',300,'nPoints',3) ; 
                    app.ExpMng = struct('CurLevel',3,'nCycle',5,'WaitTime',3,'CycleTime',1,'npp',5) ; 
                    ExperimentSafeLimits = struct( 'OverCurrent' , 16 , 'Undervoltage' , 20  , 'Overvoltage' , 60) ; 
                case 'Steering'
            
                    app.ExpMng = struct('CurLevel',2,'nCycle',5,'WaitTime',1,'CycleTime',3,'npp',2) ; 
                    % Experiment parameters 
                    ExperimentSafeLimits = struct( 'OverCurrent' , 6 , 'Undervoltage' , 20  , 'Overvoltage' , 60) ;         
            
                otherwise
                    error ('Unknown axis ') ;
            end 
            app.ExpMng.ExperimentSafeLimits = ExperimentSafeLimits; 
            app.ExpMng.NextCnt = 0 ;

            % Set to manual mode
            SendObj([hex2dec('2220'),12],app.RecStruct.Enums.SysModes.E_SysMotionModeManual,app.DataType.long,'Set system mode to manual') ;

            % Reset any possible failure 
            SendObj([hex2dec('2220'),10],1,app.DataType.long,'Reset fault') ;

            SetFloatPar( 'ClaControlPars.PhaseOverCurrent', app.ExpMng.ExperimentSafeLimits.OverCurrent ) ; 
            SetFloatPar( 'ClaControlPars.VDcMax',app.ExpMng.ExperimentSafeLimits.Overvoltage ) ; 
            SetFloatPar( 'ClaControlPars.VDcMin', app.ExpMng.ExperimentSafeLimits.Undervoltage ) ; 

            % Kill the G generator 
            SetRefGen( struct('Gen','G','Type',app.RecStruct.Enums.SigRefTypes.E_S_Nothing,'On',0) ) ; 

            % Create the basis for the T generator 
            SetRefGen( struct('Gen','T','Type',app.RecStruct.Enums.SigRefTypes.E_S_Fixed,'On',0) ) ; 

            % Remove any brake override
            SendObj([hex2dec('2220'),23],0,app.DataType.long,'Brake set/release') ; 
        end
        
        
        function TestSpeedButtonPushed(app)

            AtpBasicSetup(app) ; 

            app.CurrentlimitEditFieldPos.Value = 6; 
            % Set to manual mode
            SendObj([hex2dec('2220'),12],app.RecStruct.Enums.SysModes.E_SysMotionModeManual,app.DataType.long,'Set system mode to manual') ;
            
            % set the current limit
            if ( app.SysData.MaxCurCmd > app.CurrentlimitEditFieldPos.Value ) 
                 app.CurrentlimitEditFieldPos.Value = app.SysData.MaxCurCmd   ; 
            end 
            SetCfgPar('CurrentLimitFactor', min([app.CurrentlimitEditFieldPos.Value/app.SysData.MaxCurCmd,0.8] ) ) ; 

            % Set motor off 
            motor(0) ;

            % Set to speed function 
            SendObj([hex2dec('2220'),8],app.RecStruct.Enums.LoopClosureModes.E_LC_Speed_Mode,app.DataType.long,'Set the loop closure mode to speed') ;                      

            VerifyAxisConfig(app) ; 

            % Set motor on
            motor(1);

            % Set the reference mode to debug
            SendObjDisp(app,[hex2dec('2220'),14],app.Enums.ReferenceModes.E_PosModeDebugGen,app.DataType.long,'Ref Gen to Debug') ; 

            pause(0.5) ; 

            % Create the basis for the T generator 
            SetRefGen( struct('Gen','T','Type',app.RecStruct.Enums.SigRefTypes.E_S_Fixed,'On',0) ) ; 

            % Create the basis for the G generator 
            SetRefGen( struct('Gen','G','Type',app.RecStruct.Enums.SigRefTypes.E_S_Square,...
                'Dc',0,'Amp',0.5,'F',2,'Duty',0.5,'On',1) ) ; 

            pause(0.5) ; 
            app.AutotimeCheckBox.Value = false ; 
            app.DropDownSpeedTrigType.Value = "Immediate"; 
            app.RecTimeEditField.Value = 1 ; 
            app.SpeedTriggerEditField.Value = 0 ; 
            app.EditTriggerPercent.Value = 10 ; 
            app.DropDownSpeedTrigSignal.Value = 'SpeedCommand' ;
            InitRecordButtonPushed (app) ; 

            app.TabGroup.SelectedTab = app.SpeedLoopTab ; 

            pause(1.0) ; 
            BringrecorderButton_2Pushed(app); 

            SetRefGen( struct('Gen','G','Type',app.RecStruct.Enums.SigRefTypes.E_S_Nothing,'On',0) ) ; 

            % Set motor off 
            motor(0) ;
            
        end            
        
        function CalibrateNeck(app)
            
            % Set the motor off
            SendObjDisp(app,[hex2dec('2223'),8],1,app.DataType.long,'Disable pot matching test') ;
            SendObjDisp(app,[hex2dec('2220'),4],0,app.DataType.long,'Set motor enable/disable') ;
            
            % Release the brakes
            SendObjDisp(app,[hex2dec('2220'),23],2,app.DataType.long,'Brake set/release manual enable ') ; 
            SendObjDisp(app,[hex2dec('2220'),20],1,app.DataType.long,'Brake set/release') ; 

            app.ExpMng.MessageToHumanity = {'Brakes are release, please set neck to level','Press NEXT when done'} ;
            app.InstructionsLabel.Text = app.ExpMng.MessageToHumanity  ;
            app.ExpMng.NextAction = 'CalibNeckCenter';
            app.ExpMng.NextCnt = 1 ; 
            app.InCalibExp = 1 ; 

            
        end
        
        
        function CalibrateSteer(app,side)
            % Set the motor off

            SendObjDisp(app,[hex2dec('2223'),8],1,app.DataType.long,'Disable pot matching test') ;
            SendObjDisp(app,[hex2dec('2220'),4],0,app.DataType.long,'Set motor enable/disable') ;

            SendObjDisp(app,[0x2223,8],1,app.DataType.long,'Dont test potentiometer matching') ;
            

            % Throw the position limits to kibini mat, as we dont know initial motor position 
            SetFloatPar('ControlPars.MaxPositionCmd',3) ;
            SetFloatPar('ControlPars.MinPositionCmd',-3) ;

            SendObjDisp(app,[hex2dec('2225'),18],-3.5,app.DataType.float,'Set MinPositionFb') ;
            SendObjDisp(app,[hex2dec('2225'),19], 3.5,app.DataType.float,'Set MaxPositionFb') ;

            SendObj([hex2dec('2220'),8],app.RecStruct.Enums.LoopClosureModes.E_LC_Pos_Mode,app.DataType.long,'Set the loop closure mode to position') ;                      


            SendObjDisp(app,[hex2dec('2220'),4],1,app.DataType.long,'Set motor enable/disable') ;
            
            % Release the brakes
            % SendObjDisp(app,[hex2dec('2220'),23],2,app.DataType.long,'Brake set/release manual enable ') ; 
            % SendObjDisp(app,[hex2dec('2220'),20],1,app.DataType.long,'Brake set/release') ; 

            %app.ExpMng.MessageToHumanity = {'Use the motor controls to set the steering to zero','Press NEXT when done'} ;
            app.ExpMng.MessageToHumanity = {'Use the motor controls to set the steering to more ot less zero','Press NEXT when done'} ;
            app.InstructionsLabel.Text = app.ExpMng.MessageToHumanity  ;
            app.ExpMng.NextAction = 'CalibSteerCenter';
            app.ExpMng.NextCnt = 1 ; 
            app.InCalibExp = 1 ;             
            app.ExpMng.side = side ; 

            SendObj([hex2dec('2221'),8],0,app.DataType.long,'bPeriodicPos') ; % Kill periodic position option 

        end
        
        
        function CalibrateRotator(app)
            % Set the motor off
            SendObjDisp(app,[hex2dec('2223'),8],1,app.DataType.long,'Disable pot matching test') ;
            SendObjDisp(app,[hex2dec('2220'),4],0,app.DataType.long,'Set motor enable/disable') ;
            
            % Release the brakes
            SendObjDisp(app,[hex2dec('2220'),23],2,app.DataType.long,'Brake set/release manual enable ') ; 
            SendObjDisp(app,[hex2dec('2220'),20],1,app.DataType.long,'Brake set/release') ; 

            app.ExpMng.MessageToHumanity = {'Brakes are release, please set rotator aligned with robot body','Press NEXT when done'} ;
            app.InstructionsLabel.Text = app.ExpMng.MessageToHumanity  ;
            app.ExpMng.NextAction = 'CalibRotatorCenter';
            app.ExpMng.NextCnt = 1 ; 
            app.InCalibExp = 1 ; 
            
        end
    end
    

    % Callbacks that handle component events
    methods (Access = private)

        % Code that executes after component creation
        function startupFcn(app)
            %global DataType %#ok<*GVMIS> 
            global DispT
            global RecStruct 

            evalin('base','AtpStart') ; % Will renew environment
            app.SelectMot = 0 ; 
            app.InCalibExp = 0 ; 
            app.RecStruct = RecStruct ;
            app.DataType = GetDataType() ;


            if app.RecStruct.ProjId == hex2dec('9900')
                uiwait(msgbox({'WheelDrv application','Is not intended','For direct connection','To the interface card'}) ) ; 
                WheelDrvUIFigureCloseRequest(app);
                return
            end

            if mod( app.RecStruct.ProjId ,256 ) == 240 
                uiwait(msgbox({'WheelDrv application','Is not intended','For direct connection','To BOOT mode units'}) ) ; 
                WheelDrvUIFigureCloseRequest(app);
                return
            end 

            if app.RecStruct.ProjId == hex2dec('9400')
                app.IsServoCard = 1 ;
                app.IntfcStr = struct( 'RecStruct',evalin('base','IntfcRecStruct')) ; 
                [~,b,~]=GetSignal('PotUser',[],app.IntfcStr.RecStruct) ; 
                app.IntfcStr.PotUserSubIndex = b ; 
                app.IntfcStr.IntfcCanId = mod(app.IntfcStr.RecStruct.TargetCanId,10) + ( app.RecStruct.TargetCanId - mod(app.RecStruct.TargetCanId,10)  ) ;
                [~,b,~]=GetSignal('PotFilt',[],app.IntfcStr.RecStruct) ; 
                app.IntfcStr.PotFiltSubIndex = b ; 
                [~,b,~]=GetSignal('PotentiometerRef',[],app.IntfcStr.RecStruct) ; 
                app.IntfcStr.PotentiometerRef = b ; 
                [~,b,~]=GetSignal('Pos1',[],app.IntfcStr.RecStruct) ; 
                app.IntfcStr.Pos1 = b ; 
                [~,b,~]=GetSignal('Pos2',[],app.IntfcStr.RecStruct) ; 
                app.IntfcStr.Pos2 = b ; 
                [~,b,~]=GetSignal('Pos3',[],app.IntfcStr.RecStruct) ; 
                app.IntfcStr.Pos3 = b ; 

                
            else
                app.IntfcStr = []  ; 
                app.IsServoCard = 0  ;
            end 



            fc = fieldnames ( app.RecStruct.Enums.CommutationModes) ; 
            app.CommModes = cell(1,4) ; 
            for cnt = 1:length(fc) 
                app.CommModes{app.RecStruct.Enums.CommutationModes.(fc{cnt})+1} =  fc{cnt} ; 
            end 

            app.TabGroup.SelectedTab = app.MotionTab;

            app.Lock = 1 ; 
            app.ModeEntryCnt = 0 ; 
            app.InAtpExperiment = 0 ; 
            app.IsLocalBrake = 1 ;
            app.IsWheel = 0 ;

            app.Init = 0 ; 
            app.RecTimeEditField.Value = 0.1 ;
 
            if ~exist('DispT','var') || ~isa(DispT,'DlgTimerObj')
                evalin('base','AtpStart') ; 
            end 

%             if isequal(lower(RecStruct.Proj(1:2)),'si' ) 
%                 app.ProjectSwitch.Value = 'Single' ; 
%             else
%                 app.ProjectSwitch.Value = 'Dual' ; 
%             end
% 
% 
%             if isequal(lower(RecStruct.Axis(1:2)),'wh' ) 
%                 app.AxisSelectSwitch.Value = 'Wheel' ; 
%             else
%                 app.AxisSelectSwitch.Value = 'Steering' ; 
%             end

%             if isequal(lower(RecStruct.Side(1:2)),'le' ) 
%                 app.SideSwitch.Value  = 'Left' ; 
%             else
%                 app.SideSwitch.Value  = 'Right' ; 
%             end
% 
% 
%             if  isequal(lower( RecStruct.Card(1:2) ) ,'se') 
%                  app.CardselectSwitch.Value = 'Servo'; 
%             else
%                  app.CardselectSwitch.Value = 'Intfc'; 
%             end 


            try 
                SetDialogTarget(app) ; 
                app.s = SGetState ; 
            catch
                uiwait(errordlg('Could not establish communication')) ; 
                WheelDrvUIFigureCloseRequest( app) ;
                return ;
            end
            app.ProjId= FetchObj([hex2dec('2303'),32],app.DataType.long,'ProjId') ; 


            SetProjlabel(app) ; 

            von = 'off' ; 
            if contains( app.ProjName,'PROJ_TYPE_TRAY_ROTATOR') 
                app.CalibrateplaterotatorButton.Text = 'Calibrate tray rotator';
            elseif contains( app.ProjName,'PROJ_TYPE_NECK') 
                app.CalibrateplaterotatorButton.Text = 'Calibrate neck';
            elseif contains(app.ProjName,'PROJ_TYPE_STEERING_R') 
                app.CalibrateplaterotatorButton.Text = 'Calibrate R steering';
                von = 'on' ; 
            elseif contains(app.ProjName,'PROJ_TYPE_STEERING_L') 
                app.CalibrateplaterotatorButton.Text = 'Calibrate L steering';
                von = 'on' ; 
            else
                app.CalibrateplaterotatorButton.Visible = 'off';
            end
            app.SteerUpButton.Visible  = von ; 
            app.SteerDnButton.Visible  = von ; 
            app.StepsizeDegEditField.Visible  = von ; 
            app.StepsizeDegEditField.Value = 1 ; 
            app.StepsizeDegEditField.Limits = [-100,100] ; 


            app.EvtObj = DlgUserObj(@app.UpdateDisplayWrapper,findobj(app) );
            app.EvtObj.MylistenToTimer(DispT) ;   


            app.ClosureModeStrings = makeheader(app,app.Enums.LoopClosureModes,'E_LC_','_Mode' ); 
            %app.ClosureModeStrings{7} = 'Homing' ;
            app.LC0Button.Text = app.ClosureModeStrings{1} ; app.LC0Button.UserData = 0 ; 
            app.LC1Button.Text = app.ClosureModeStrings{2} ; app.LC1Button.UserData = 1; 
            app.LC2Button.Text = app.ClosureModeStrings{3} ; app.LC2Button.UserData = 2 ; 
            app.LC3Button.Text = app.ClosureModeStrings{4} ; app.LC3Button.UserData = 3 ; 
            app.LC4Button.Text = app.ClosureModeStrings{5} ; app.LC4Button.UserData = 4 ; 
            app.LC5Button.Text = app.ClosureModeStrings{6} ; app.LC5Button.UserData = 5 ; 
            %app.LC6Button.Text = app.ClosureModeStrings{7} ; app.LC6Button.UserData = 6 ; 

            app.TriangleTorqueButton.UserData = 4 ; 
            app.SquareTorqueButton.UserData = 3 ; 
            app.SineTorqueButton.UserData = 2 ;
            app.FixedTorqueButton.UserData = 1 ;

            app.TriangleRefButton.UserData = 4 ; 
            app.SquareRefButton.UserData = 3 ; 
            app.SineRefButton.UserData = 2 ; 
            app.FixedRefButton.UserData = 1; 

            % SetClosureRadio(app,app.s.Bit.LoopClosure)  ; 


            app.MotionTab.UserData = 1 ; 
            app.CalibrateTab.UserData = 2 ; 
            app.ParametersTab.UserData = 3 ; 
            app.SigGenTab.UserData = 4 ; 
            app.CurrentLoopTab.UserData = 5 ; 
            app.ConfigTab.UserData = 6 ; 
            app.SpeedLoopTab.UserData = 7 ; 
            app.PositionTab.UserData = 8 ; 
            app.DisConnectionCnt = 0 ; 

            app.UserButton.UserData = 1 ; 
            app.MotorButton.UserData = 2 ; 
            app.EnccountsButton.UserData = 3 ; 

            app.CreateStruct = struct('Interpreter','tex','WindowStyle' , 'modal') ;
            
            %app.ReleaseCheckBox.Value = app.s.Bit.BrakeRelease ;

            TriggerTypes = {'Immediate','Rising','Falling'} ; 
            CurVarNames = {'vqd','Iq','CurrentCommandFiltered'}  ; 
            SpeedVarNames = {'SpeedCommand','UserSpeed','Iq','CurrentCommand','PIState','PiOut','SpeedError','UserPosDelta'} ; % ,'EncCounts'}  ; 
            PosVarNames = {'UserSpeed','UserPos','Iq'} ; 
            app.DropDownPosTrigSignal.Items = PosVarNames ; 
            app.DropDownPosTrigSignal.Value = PosVarNames{1} ; 
            app.DropDownPosTrigType.Items = TriggerTypes ; 
            app.DropDownPosTrigType.Value = 'Immediate' ; 
            app.PosTriggerEditField.Value = 0 ; 
            app.EditPosTriggerPercent.Value = 50 ; 
            app.PosRecTimeEditField.Value = 0.1 ; 
            app.DropDownSpeedTrigSignal.Items = SpeedVarNames ; 
            app.DropDownSpeedTrigSignal.Value = 'SpeedCommand' ; 
            app.DropDownSpeedTrigType.Items = TriggerTypes ; 
            app.DropDownSpeedTrigType.Value = 'Immediate' ; 
            app.EditTriggerPercent.Value = 50 ; 
            app.SpeedTriggerEditField.Value = 0 ; 
            
            app.RecMng = struct('PosRecOn',0,'SpeedRecOn',0,'CurRecOn',0,'CurVarNames',{CurVarNames},'SpeedVarNames',{SpeedVarNames},'PosVarNames',{PosVarNames}) ; 

            app.SystemModeDropDown.Items = fieldnames( app.RecStruct.Enums.SysModes) ; 

            app.SysData.PosUnitSelect = 1 ; 
            app.Lock = 0 ; 
            app.AtpState = zeros(1,5) ; 
            app.GotonextstepButton.Visible = 'off' ; 
            app.AborttestButton.Visible = 'off' ; 

            app.UseCase = GetUseCase() ;
            if app.UseCase.Sw1 == 0 && ~app.IsWheel 
                app.Din1Lamp.Visible = 'off' ; 
                app.DIN1Label.Visible = 'off' ; 
            end
            if app.UseCase.Sw2 == 0 
                app.Din2Lamp.Visible = 'off' ; 
                app.DIN2Label.Visible = 'off' ; 
            end

            if app.UseCase.Brake == 0 
                app.BrakePanel.Visible  ='off' ;
            end

            if app.UseCase.SupportHome

                switch app.UseCase.HomeMethod 
                    case app.RecStruct.Enums.HomeMethodTypes.EHM_Immediate
                        app.HomeButton.Text = 'Immediate homing';
                        app.PositivedirectionCheckBox.Enable = 'off' ; 
                        app.HomepositionEditField.Visible = 'off' ; 
                    case app.RecStruct.Enums.HomeMethodTypes.EHM_SwitchLimit
                        app.HomeButton.Text = 'Home by Limit switch';
                        app.PositivedirectionCheckBox.Enable = 'off' ; 
                    case app.RecStruct.Enums.HomeMethodTypes.EHM_CollideLimit
                        app.HomeButton.Text = {'Home by','collision'};
                end
                if (app.UseCase.HomeDirection >= 0 ) 
                    app.PositivedirectionCheckBox.Value = 1 ;
                else
                    app.PositivedirectionCheckBox.Value = 0 ;
                end
                if ( app.UseCase.HomeDirection < 0 )
                    app.HomepositionEditField.Value = FetchObj([hex2dec('2225'),13],app.DataType.float,'User home position FW') ;
                else
                    app.HomepositionEditField.Value = FetchObj([hex2dec('2225'),14],app.DataType.float,'User home position Reverse') ;
                end
            else
                app.HomeButton.Enable = 'off';
                app.PositivedirectionCheckBox.Visible = 'off';
                app.HomepositionEditField.Visible = 'off';
            end

        end

        % Close request function: WheelDrvUIFigure
        function WheelDrvUIFigureCloseRequest(app, event)
            global TmMgrTS
            try
                app.Lock = 1 ; 
                TmMgrTS.SetCounter('NBIT',-1000) ; 
                try
                    delete( app.EvtObj) ;
                catch
                end
            %delete( app.Timer ) ;
            catch 
            end
            delete(app)
            
        end

        % Selection changed function: LoopclosureButtonGroup
        function LoopclosureButtonGroupSelectionChanged(app, event)
            selectedButton = app.LoopclosureButtonGroup.SelectedObject;
            if ( selectedButton.UserData==0 )
                if SetMasterBlaster(app)
                    return ; 
                end
                SendObjDisp(app,[hex2dec('2220'),3],1,app.DataType.long,'Set to voltage mode') ; 
                return ; 
                % Voltage mode requires password 
            end 
            SendObjDisp(app,[hex2dec('2220'),8],selectedButton.UserData,app.DataType.long,'Set the loop closure mode') ;             
        end

        % Button down function: CalibrateTab
        function CalibrateTabButtonDown(app, event)

            if RegisterRab(app,app.CalibrateTab.UserData)==0 
                return ; % Act once on selection 
            end 

            RefreshCalibPanel(app) ; 
            app.NextButton.Visible = 'off' ; 
        end

        % Button pushed function: SaveExcelButton
        function SaveExcelButtonPushed(app, event)
            tabs = app.rawPars ; 
            [m,~] = size(tabs) ; 
            for cnt = 2:m 
                tabs(cnt,end-1) = app.ParTable.Data{cnt-1,end-1}; 
            end 
            SheetName = app.SheetsDropDown.Value ; 
            if isequal(char(SheetName),'DefaultPars' ) 
                uiwait( errordlg('You cant overwrite the defaults, choose another excel sheet') ) ;
                return ; 
            end 
            xlswrite(app.XlsFileName,tabs,SheetName) ; %#ok<*XLSWT> 
        end

        % Button pushed function: Download2driveButton
        function Download2driveButtonPushed(app, event)
            global DataType
            [m,~] = size(app.BupTable)  ;    
            
            for cnt = 1:m
                data = app.BupTable{cnt,end-1} ; 
                try
                    errstr = ['Dload parameter : ',num2str(app.IndArray(cnt)),' : ',num2str(data{1} )];
                    SendObj( [hex2dec('2208'),app.IndArray(cnt)] , data{1} , DataType.float , errstr ) ; 
                catch
                    app.TransientExceptionLabel.Text = errstr ; 
                end
            end 
         
        end

        % Display data changed function: ParTable
        function ParTableDisplayDataChanged(app, event)
            % newDisplayData = app.ParTable.DisplayData;
            
        end

        % Cell edit callback: ParTable
        function ParTableCellEdit(app, event)
            indices = event.Indices;
            newData = event.NewData;
            m = indices(1) ; 
            n = indices(2) ; 
            if n == 1 
                app.ParTable.Data{m,n} = app.BupTable{m,n} ; 
                return ; 
            end 
            minval = app.ParTable.Data{m,n-2}; 
            maxval = app.ParTable.Data{m,n-1}; 
            minval = minval{1}; 
            maxval = maxval{1}; 

            
            if ~isnumeric(newData) || isempty(newData) || ~isfinite(newData) 
                uiwait( errordlg('Cell must contain proper numeric value') ) ;    
                app.ParTable.Data{m,n} = app.BupTable{m,n} ; 
                return ; 
            end 
            if ( newData < minval || newData > maxval )
                uiwait( errordlg('Cell must contain data between the limits') ) ;                
                app.ParTable.Data{m,n} = app.BupTable{m,n} ; 
                return ; 
            end
            app.BupTable{m,n} = app.ParTable.Data{m,n}  ; 
        end

        % Button pushed function: ResetCalibButton
        function ResetCalibButtonPushed(app, event)

            SaveCalib ( 0  ,'Temporary.jsn' , app.RecStruct.CalibCfg) ; 
            ProgCalib ( 'Temporary.jsn' , 1 , app.RecStruct.CalibCfg ) ; 
            RefreshCalibPanel(app) ; 

        end

        % Button pushed function: MotorONButton
        function MotorONButtonPushed(app, event)
        
        try 
            mon = app.s.Bit.MotorOn ;
        catch
            app.TransientExceptionLabel.Text = 'Dont have the state to decide On/Off' ; 
            return 
        end

        if contains ( app.MotorONButton.Text,'Manual' )  
            SendObjDisp(app,[hex2dec('2223'),3],1,app.DataType.long,'Ignore host CW') ;
            SendObjDisp(app,[hex2dec('2220'),12],app.Enums.SysModes.E_SysMotionModeManual,app.DataType.long,'Set to manual mode') ;
           return 
        end


        if contains ( app.MotorONButton.Text,'Reset' ) 
            SendObjDisp(app,[hex2dec('2220'),12],app.Enums.SysModes.E_SysMotionModeManual,app.DataType.long,'Reset fault') ;
            return 
        end

        if mon 
            mon = 0 ; 
        else
            mon = 1 ; 
        end 
        
        try 
            SendObjDisp(app,[hex2dec('2223'),7],2,app.DataType.long,'Disable auto start/stop mechanism') ;
        catch 
        end
        SendObjDisp(app,[hex2dec('2220'),4],mon,app.DataType.long,'Set motor enable/disable') ;

        end

        % Button down function: AnalogsPanel
        function AnalogsPanelButtonDown(app, event)
            
        end

        % Selection changed function: TMethodButtonGroup
        function TMethodButtonGroupSelectionChanged(app, event)
            selectedButton = app.TMethodButtonGroup.SelectedObject;
            SendObjDisp(app,[hex2dec('2220'),201],selectedButton.UserData,app.DataType.long,'Ref Gen mode') ; 
        end

        % Selection changed function: MethodButtonGroup
        function MethodButtonGroupSelectionChanged(app, event)
            selectedButton = app.MethodButtonGroup.SelectedObject;
            SendObjDisp(app,[hex2dec('2220'),200],selectedButton.UserData,app.DataType.long,'Ref Gen mode') ;             
        end

        % Button down function: SigGenTab
        function SigGenTabButtonDown(app, event)
           
            if RegisterRab(app,app.SigGenTab.UserData)==0 
                return ; % Act once on selection 
            end 

            
            rgm = FetchObjDisp(app,[hex2dec('2220'),200],app.DataType.long,'Ref Gen mode') ; 
            n = length(app.MethodButtonGroup.Children) ; 
            for cnt = 1:n 
                if ( rgm == app.MethodButtonGroup.Children(cnt).UserData)
                    pp.MethodButtonGroup.Children(cnt).Value = 1 ; 
                end 
            end 
            rgt = FetchObjDisp(app,[hex2dec('2220'),201],app.DataType.long,'TRef Gen mode') ; 
            n = length(app.TMethodButtonGroup.Children) ; 
            for cnt = 1:n 
                if ( rgt == app.TMethodButtonGroup.Children(cnt).UserData)
                    pp.TMethodButtonGroup.Children(cnt).Value = 1 ; 
                end 
            end 

            app.DCEditField.Value = FetchObjDisp(app,[hex2dec('220d'),app.CfgTable.GRef_Dc.Ind],app.DataType.float,'Ref Gen parameter') ; 
            app.AmplitudeEditField.Value= FetchObjDisp(app,[hex2dec('220d'),app.CfgTable.GRef_Amp.Ind],app.DataType.float,'Ref Gen parameter') ; 
            app.FrequencyEditField.Value = FetchObjDisp(app,[hex2dec('220d'),app.CfgTable.GRef_F.Ind],app.DataType.float,'Ref Gen parameter') ; 
            app.DutyEditField.Value = FetchObjDisp(app,[hex2dec('220d'),app.CfgTable.GRef_Duty.Ind],app.DataType.float,'Ref Gen parameter') ; 
            % Set on Neck 
            app.AnglePeriodEditField.Value = FetchObjDisp(app,[hex2dec('220d'),app.CfgTable.GRef_AnglePeriod.Ind],app.DataType.float,'Ref Gen parameter') ; 
            app.SpeedCheckBox.Value = FetchObjDisp(app,[hex2dec('220d'),app.CfgTable.GRef_bAngleSpeed.Ind],app.DataType.long,'Ref Gen parameter') ; 
            

            app.TDCEditField.Value = FetchObjDisp(app,[hex2dec('220d'),app.CfgTable.TRef_Dc.Ind],app.DataType.float,'Ref Gen parameter') ; 
            app.TAmplitudeEditField.Value= FetchObjDisp(app,[hex2dec('220d'),app.CfgTable.TRef_Amp.Ind],app.DataType.float,'Ref Gen parameter') ; 
            app.TFrequencyEditField.Value = FetchObjDisp(app,[hex2dec('220d'),app.CfgTable.TRef_F.Ind],app.DataType.float,'Ref Gen parameter') ; 
            app.TDutyEditField.Value = FetchObjDisp(app,[hex2dec('220d'),app.CfgTable.TRef_Duty.Ind],app.DataType.float,'Ref Gen parameter') ; 

        end

        % Value changed function: RefOn
        function RefOnValueChanged(app, event)
            
            value = app.RefOn.Value;
            if isequal(value,'On')
                SendObj( [hex2dec('2220'),12] , app.RecStruct.Enums.SysModes.E_SysMotionModeManual , app.DataType.long ,'Set the system mode') ;  
                value = 1 ; 
            else
                value = 0 ; 
            end 
            % Refresh descriptors
            if ( value)
                DCEditFieldValueChanged(app) ; 
                AmplitudeEditFieldValueChanged(app); 
                FrequencyEditFieldValueChanged(app); 
                DutyEditFieldValueChanged(app); 
                AnglePeriodEditFieldValueChanged(app) ; 
                SpeedCheckBoxValueChanged(app); 
                MethodButtonGroupSelectionChanged(app) ;
            end 

            SendObjDisp(app,[hex2dec('2220'),14],app.Enums.ReferenceModes.E_PosModeDebugGen,app.DataType.long,'Ref Gen to Debug') ; 
            SendObjDisp(app,[hex2dec('2220'),202],value,app.DataType.long,'Ref Gen On') ; 

        end

        % Value changed function: TRefOn
        function TRefOnValueChanged(app, event)
            
            value = app.TRefOn.Value;
            if isequal(value,'On')
                value = 1 ; 
                SendObj( [hex2dec('2220'),12] , app.RecStruct.Enums.SysModes.E_SysMotionModeManual , app.DataType.long ,'Set the system mode') ;  
            else
                value = 0 ; 
            end 
            % Refresh descriptors
            if ( value)
                TDCEditFieldValueChanged(app) ; 
                TAmplitudeEditFieldValueChanged(app) ; 
                TFrequencyEditFieldValueChanged(app) ; 
                TDutyEditFieldValueChanged(app) ; 
                TMethodButtonGroupSelectionChanged(app) ;
            end 
            SendObjDisp(app,[hex2dec('2220'),14],app.Enums.ReferenceModes.E_PosModeDebugGen,app.DataType.long,'Ref Gen to Debug') ; 
            SendObjDisp(app,[hex2dec('2220'),203],value,app.DataType.long,'Ref Gen On') ; 

        end

        % Value changed function: DCEditField
        function DCEditFieldValueChanged(app, event)
            value = app.DCEditField.Value;
            SendObjDisp(app,[hex2dec('220d'),app.CfgTable.GRef_Dc.Ind],value,app.DataType.float,'Ref Gen parameter') ; 
        end

        % Value changed function: AmplitudeEditField
        function AmplitudeEditFieldValueChanged(app, event)
            value = app.AmplitudeEditField.Value;
            SendObjDisp(app,[hex2dec('220d'),app.CfgTable.GRef_Amp.Ind],value,app.DataType.float,'Ref Gen parameter') ; 
        end

        % Value changed function: FrequencyEditField
        function FrequencyEditFieldValueChanged(app, event)
            value = app.FrequencyEditField.Value;
            SendObjDisp(app,[hex2dec('220d'),app.CfgTable.GRef_F.Ind],value,app.DataType.float,'Ref Gen parameter') ; 
            
        end

        % Value changed function: DutyEditField
        function DutyEditFieldValueChanged(app, event)
            value = app.DutyEditField.Value;
            SendObjDisp(app,[hex2dec('220d'),app.CfgTable.GRef_Duty.Ind],value,app.DataType.float,'Ref Gen parameter') ; 
            
        end

        % Value changed function: TAmplitudeEditField
        function TAmplitudeEditFieldValueChanged(app, event)
            value = app.TAmplitudeEditField.Value;
            SendObjDisp(app,[hex2dec('220d'),app.CfgTable.TRef_Amp.Ind],value,app.DataType.float,'Ref Gen parameter') ; 
            
        end

        % Value changed function: TFrequencyEditField
        function TFrequencyEditFieldValueChanged(app, event)
            value = app.TFrequencyEditField.Value;
            SendObjDisp(app,[hex2dec('220d'),app.CfgTable.TRef_F.Ind],value,app.DataType.float,'Ref Gen parameter') ; 
            
        end

        % Value changed function: TDCEditField
        function TDCEditFieldValueChanged(app, event)
            value = app.TDCEditField.Value;
            SendObjDisp(app,[hex2dec('220d'),app.CfgTable.TRef_Dc.Ind],value,app.DataType.float,'Ref Gen parameter') ; 
            
        end

        % Value changed function: TDutyEditField
        function TDutyEditFieldValueChanged(app, event)
            value = app.TDutyEditField.Value;
            SendObjDisp(app,[hex2dec('220d'),app.CfgTable.TRef_Duty.Ind],value,app.DataType.float,'Ref Gen parameter') ; 
            
        end

        % Value changed function: AnglePeriodEditField
        function AnglePeriodEditFieldValueChanged(app, event)
            % Add to neck 
            value = app.AnglePeriodEditField.Value;
            SendObjDisp(app,[hex2dec('220d'),app.CfgTable.GRef_AnglePeriod.Ind],value,app.DataType.float,'Ref Gen parameter') ;             
        end

        % Value changed function: SpeedCheckBox
        function SpeedCheckBoxValueChanged(app, event)
            % Add to Neck 
            value = double( app.SpeedCheckBox.Value ) ;
            SendObjDisp(app,[hex2dec('220d'),app.CfgTable.GRef_bAngleSpeed.Ind],value,app.DataType.long,'Ref Gen parameter') ;             
            
        end

        % Button down function: CurrentLoopTab
        function CurrentLoopTabButtonDown(app, event)
% Add to neck 

            if RegisterRab(app,app.CurrentLoopTab.UserData)==0 
                return ; % Act once on selection 
            end 


            % Set the R, L , Amps, F1 and F2 by the axis select 
            app.CurKp = GetFloatPar('ClaControlPars.KpCur') ; % Description
            app.CurKi = GetFloatPar('ClaControlPars.KiCur')  ; % Description
            app.CurPrefSlope = GetFloatPar('ClaControlPars.MaxCurCmdDdt') ;
            app.CurPrefBw = GetFloatPar('ControlPars.CurrentFilterBWHz') ;
            app.KeHz = GetFloatPar('ClaControlPars.KeHz') ;
            app.PrefilterBWHzEditField.Value = app.CurPrefBw ;
            app.SlopelimitAmsecEditField.Value = app.CurPrefSlope * 1e-3 ; 
            app.KeVHzEditField.Value = app.KeHz  ;
            app.CurControllerKpEditField.Value = app.CurKp  ; 
            app.CurControllerKiEditField.Value = app.CurKi  ; 

%ClaControlPars.KeHz
        end

        % Callback function
        function ProjectSwitchValueChanged(app, event)
 %           value = app.ProjectSwitch.Value;
            app.Init = 0 ; 
        end

        % Callback function
        function CardselectSwitchValueChanged(app, event)
%            value = app.CardselectSwitch.Value;
            app.Init = 0 ;             
        end

        % Callback function
        function AxisSelectSwitchValueChanged(app, event)
%             value = app.AxisSelectSwitch.Value;
             app.Init = 0 ;             

        end

        % Callback function
        function SideSwitchValueChanged(app, event)
%            value = app.SideSwitch.Value;
             app.Init = 0 ;                        
        end

        % Button pushed function: SelectaxisButton
        function SelectaxisButtonPushed(app, event)
            global ActiveSetProj ;
            evalin('base','AtpStartNew');

            startupFcn(app) ; 
            %SetProjlabel(app) ; 
            %SetDialogTarget(app) ; 

        end

        % Button down function: ConfigTab
        function ConfigTabButtonDown(app, event)
            if RegisterRab(app,app.ConfigTab.UserData)==0 
                return ; % Act once on selection 
            end 

            
            RefreshConfigPanel(app) ;             
        end

        % Cell edit callback: CfgTabEdit
        function CfgTabEditCellEdit(app, event)
            indices = event.Indices;
            newData = event.NewData;
            item  = indices(1) ; 
            next = app.RecStruct.CfgFullTable(item);
            minval = next.MinVal ;
            maxval = next.MaxVal ;
            data   = app.CfgBupTable{item,indices(2)} ; 
            data  = data{1} ; 
            try 
                if newData >= minval && newData <= maxval 
                    data = newData ; 
                end 
            catch
            end 
            app.CfgBupTable{item,indices(2)} = num2cell( data) ; 
            app.CfgTabEdit.Data{item,indices(2)}= num2cell( data) ;  
            
        end

        % Button pushed function: Download2driveButtonCfg
        function Download2driveButtonCfgPushed(app, event)
            CfgObj = hex2dec('220d') ; 
            nCfg   = FetchObj( [CfgObj,255] , app.DataType.long , 'Get the number of CFG pars' ) ;
            indvalue = find( strcmp( app.CfgTabEdit.ColumnName,'Value'), 1) ; 
            for item = 2:nCfg
                next = app.RecStruct.CfgFullTable(item);
                if ( contains(next.Name , 'FloatParRevision'))
                    continue ; 
                end
                data   = app.CfgTabEdit.Data{item,indvalue} ; 
                data   = data{1} ; 
                if bitand(next.Flags,2)  
                    SendObj( [CfgObj,next.Ind] , data , app.DataType.float , next.Name ) ;
                else
                    SendObj( [CfgObj,next.Ind] , data , app.DataType.long , next.Name ) ;
                end
            end 
% Approve, for manual work only
            SendObj( [CfgObj,0] , 1.0 , app.DataType.float , 'Approve configuration' ) ;

% If was automatic, set the mode to manual 
            if ( app.s.Bit.SystemMode == app.RecStruct.Enums.SysModes.E_SysMotionModeAutomatic ) 
                SendObj( [hex2dec('2220'),12] , app.RecStruct.Enums.SysModes.E_SysMotionModeManual, app.DataType.long , 'Set manual mode' ) ;            
            end
            
        end

        % Button pushed function: LoadCfgExcelButton
        function LoadCfgExcelButtonPushed(app, event)
            [~,~,aa] = xlsread(fname,'DefaultCfg'); %#ok<*XLSRD> 
            CfgTab =table(aa(2:end,2),aa(2:end,3),aa(2:end,4),aa(2:end,5),aa(2:end,6),aa(2:end,7),aa(2:end,8),aa(2:end,9)) ;
            CfgTab.Properties.VariableNames = aa(1,2:end) ; 
            RowNames = cell(5,1); 
            %[m,~] = size(aa) ; 
            CfgTab.Properties.RowNames = RowNames ; 
            app.CfgTabEdit.Data = CfgTab.Data ; 
        end

        % Button pushed function: SaveCfgExcelButton
        function SaveCfgExcelButtonPushed(app, event)
            tabs = app.app.CgfRaw ; 
            [m,~] = size(tabs) ; 
            for cnt = 2:m 
                tabs(cnt,end-1) = app.CfgTabEdit.Data{cnt-1,end-1}; 
            end 
            SheetName = app.SheetsDropDownCfg.Value ; 
            if isequal(char(SheetName),'DefaultCfg' ) 
                uiwait( errordlg('You cant overwrite the default cofiguration, choose another excel sheet') ) ;
                return ; 
            end 
            xlswrite(app.XlsFileName,tabs,SheetName) ; %#ok<*XLSWT>             
        end

        % Value changed function: PrefilterBWHzEditField
        function PrefilterBWHzEditFieldValueChanged(app, event)
            value = app.PrefilterBWHzEditField.Value;
            try 
                SetFloatPar('ControlPars.CurrentFilterBWHz',value) ; 
                app.CurPrefBw = value ; 
            catch 
                app.PrefilterBWHzEditField.Value = app.CurPrefBw  ;  
            end
        end

        % Value changed function: SlopelimitAmsecEditField
        function SlopelimitAmsecEditFieldValueChanged(app, event)
            value = app.SlopelimitAmsecEditField.Value;
            try 
                SetFloatPar('ClaControlPars.MaxCurCmdDdt',value*1e3) ; 
                app.CurPrefSlope = value ; 
            catch 
                app.SlopelimitAmsecEditField.Value = app.CurPrefSlope * 1e-3 ;  
            end
            
        end

        % Value changed function: KeVHzEditField
        function KeVHzEditFieldValueChanged(app, event)
            value = app.KeVHzEditField.Value;
            try 
                SetFloatPar('ClaControlPars.KeHz',value) ; 
                app.KeHz = value ; 
            catch 
                app.KeVHzEditField.Value = app.KeHz   ;  
            end
           
        end

        % Value changed function: CurControllerKpEditField
        function CurControllerKpEditFieldValueChanged(app, event)
            value = app.CurControllerKpEditField.Value;
            try 
                SetFloatPar('ClaControlPars.KpCur',value) ; 
                app.CurKp = value ; 
            catch 
                app.CurControllerKpEditField.Value = app.CurKp   ;  
            end
            
        end

        % Value changed function: CurControllerKiEditField
        function CurControllerKiEditFieldValueChanged(app, event)
            value = app.CurControllerKiEditField.Value;
            try 
                SetFloatPar('ClaControlPars.KiCur',value) ; 
                app.CurKi = value ; 
            catch 
                app.CurControllerKiEditField.Value = app.CurKi  ;  
            end
            
        end

        % Button pushed function: InitRecorderButton
        function InitRecorderButtonPushed(app, event)
            % Init recorder for current (owner = 30001 ) 
            global RecStruct
            RecStruct.Sync2C = 1 ; 
            f = FetchObjDisp(app,[hex2dec('220d'),app.CfgTable.TRef_F.Ind],app.DataType.float,'Ref Gen parameter') ; 

            RecTime = 3 / max(f,1) ; 
            MaxRecLen = 1000 ; 
            RecAction = struct( 'InitRec' ,  1, 'BringRec' , 0 ,'ProgRec' , 1 ,'Struct' , 1 ,'T' , RecTime ,'MaxLen', MaxRecLen ,'BlockUpLoad',0 ,'OwnerFlag',30001) ; 
            % RecNames = {'vqd','Iq'}  ; 
            Recorder(app.RecMng.CurVarNames , RecStruct , RecAction   );
            app.RecorderReadyLamp.Color = [1,1,1] * 0.8 ; 

        end

        % Value changed function: KillprefilterCheckBox
        function KillprefilterCheckBoxValueChanged(app, event)
            value = app.KillprefilterCheckBox.Value;
            SendObjDisp(app,[hex2dec('2220'),204],double(value),app.DataType.long,'Kill current prefilter');
        end

        % Button down function: SpeedLoopTab
        function SpeedLoopTabButtonDown(app, event)

            if RegisterRab(app,app.SpeedLoopTab.UserData)==0 
                return ; % Act once on selection 
            end 

            app.SpeedCtlVars = struct('SpeedKp',GetCfgPar('SpeedKp'),...
            'SpeedKi',GetCfgPar('SpeedKi'),'qf0Cfg',GetCfgPar('qf0Cfg'),'qf1Cfg',GetCfgPar('qf1Cfg'),...
            'CurMax',GetFloatPar('ControlPars.MaxCurCmd') ) ; 
            app.SpeedKpEditField.Value = app.SpeedCtlVars.SpeedKp ;
            app.SpeedKiEditField.Value = app.SpeedCtlVars.SpeedKi ;
            app.CurrentlimitEditField.Value = app.SpeedCtlVars.CurMax; 
            app.Includefilter1CheckBox.Value = logical( bitand( app.SpeedCtlVars.qf0Cfg,3)  ) ; 
            app.Includefilter2CheckBox.Value = logical( bitand( app.SpeedCtlVars.qf1Cfg,3)  ) ; 

        end

        % Value changed function: Includefilter2CheckBox
        function Includefilter2CheckBoxValueChanged(app, event)
            value = app.Includefilter2CheckBox.Value;
            qf1Cfg = bitand( GetCfgPar('qf1Cfg'), 3 ) ; 
            if value
                qf1Cfg = qf1Cfg + 1 ;
            end
            SetCfgPar('qf1Cfg',qf1Cfg); 
        end

        % Value changed function: Includefilter1CheckBox
        function Includefilter1CheckBoxValueChanged(app, event)
            value = app.Includefilter1CheckBox.Value;
            qf0Cfg = bitand( GetCfgPar('qf0Cfg'), 3 ) ; 
            if value
                qf0Cfg = qf0Cfg + 1 ;
            end
            SetCfgPar('qf0Cfg',qf0Cfg); 
            
        end

        % Value changed function: CurrentlimitEditField
        function CurrentlimitEditFieldValueChanged(app, event)
            value = app.CurrentlimitEditField.Value;
            try
                SetFloatPar('ControlPars.MaxCurCmd',value) ; 
            catch 
                value = app.SpeedCtlVars.CurMax ; 
                SetFloatPar('ControlPars.MaxCurCmd',value) ; 
            end
            app.SpeedCtlVars.CurMax = value ;
            app.CurrentlimitEditFieldPos.Value = value;

        end

        % Value changed function: SpeedKpEditField
        function SpeedKpEditFieldValueChanged(app, event)
            value = app.SpeedKpEditField.Value;
            try
                SetCfgPar('SpeedKp',value) ; 
            catch 
                value = app.SpeedCtlVars.SpeedKp;  
                SetCfgPar('SpeedKp',value) ; 
            end
            app.SpeedCtlVars.SpeedKp = value ;
            
        end

        % Value changed function: SpeedKiEditField
        function SpeedKiEditFieldValueChanged(app, event)
            value = app.SpeedKiEditField.Value;
            try
                SetCfgPar('SpeedKi',value) ; 
            catch 
                value = app.SpeedCtlVars.SpeedKi;  
                SetCfgPar('SpeedKi',value) ; 
            end
            app.SpeedCtlVars.SpeedKi = value ;
            
        end

        % Button pushed function: InitRecordButton
        function InitRecordButtonPushed(app, event)
            % Init recorder for speed (Owner = 30000) 
            global RecStruct
            RecStruct.Sync2C = 1 ; 

            if app.AutotimeCheckBox.Value

                f = FetchObjDisp(app,[hex2dec('220d'),app.CfgTable.GRef_F.Ind],app.DataType.float,'Ref Gen parameter') ; 
                RecTime = 3 / max(f,1) ; 
            else
                RecTime = max( [app.RecTimeEditField.Value , 1e-4] ) ; 
            end 

            MaxRecLen = 1000 ; 
            app.RecMng.SpeedRecOn = 1 ; 
            switch app.DropDownSpeedTrigType.Value
                case 'Immediate'
                    RecStruct.TrigType = 0 ; 
                case 'Rising'
                    RecStruct.TrigType = 1 ; 
                case 'Falling'
                    RecStruct.TrigType = 2 ;
            end
            RecStruct.TrigVal = app.SpeedTriggerEditField.Value  ; 
            RecAction = struct( 'PreTrigPercent',app.EditTriggerPercent.Value,...
                'InitRec' ,  1, 'BringRec' , 0 ,'ProgRec' , 1 ,'Struct' , 1 ,'T' , RecTime ,'MaxLen', MaxRecLen ,'BlockUpLoad',0,'OwnerFlag',30000 ) ; 

            if RecStruct.TrigType 
                RecStruct.TrigSigName = app.DropDownSpeedTrigSignal.Value ; 
                RecStruct.PreTrigPercent = app.EditTriggerPercent.Value ;
            end 

            Recorder(app.RecMng.SpeedVarNames , RecStruct , RecAction   );
            app.RecorderReadyLamp.Color = [1,1,1] * 0.8 ; 

        end

        % Button pushed function: BringrecorderButton_2
        function BringrecorderButton_2Pushed(app, event)
            % Bring recorder for speed (owner = 30000) 
            global RecStruct

            owner = FetchObjDisp(app,[hex2dec('2000'),111],app.DataType.long,'Get recorder owner') ; 
            RecAction = struct( 'InitRec' ,  0, 'BringRec' , 1 ,'ProgRec' , 0 ,'Struct' , 1  ,'BlockUpLoad',app.UseBlockDownload,'OwnerFlag',30000 ) ; 
            if ~(owner==30000)
                app.TransientExceptionLabel.Text = 'Recorder ownership conflict' ; 
                return ;
            end
            [~,~,r] = Recorder(app.RecMng.SpeedVarNames , RecStruct , RecAction   );

            %RecNames = {'HallAngle','EncCounts','MotSpeedHz'','ThetaElect','EncoderCounts','Encoder4Hall','OldEncoder','ComStat'}  ; 
            %RecNames = {'SpeedCommand','UserSpeed','MotSpeedHz','Iq','PIState','PiOut','SpeedError'} ; % ,'EncCounts'}  ; 
            %[~,~,r] = Recorder(RecNames , RecStruct , RecAction   );
            plot( app.UIAxes , r.t , r.SpeedCommand , r.t , r.UserSpeed ); 
            legend(app.UIAxes , 'Cmd','Feedback') ; grid ( app.UIAxes,'on') ;
            plot( app.UIAxes2 , r.t , r.CurrentCommand , r.t , r.Iq ) ; 
            legend(app.UIAxes2 , 'Cur Cmd','Current') ; grid(app.UIAxes2,'on')  ;
            
            save RecordSpeedRslt.mat r        

            app.InstructionsLabel.Text = 'Recorder results are in RecordSpeedRslt.mat' ; 
        end

        % Button pushed function: BringrecorderButton
        function BringrecorderButtonPushed(app, event)
            global RecStruct
            % Bring recorder for current (owner = 30001 ) 
            owner = FetchObjDisp(app,[hex2dec('2000'),111],app.DataType.long,'Get recorder owner') ; 
%            RecAction = struct( 'InitRec' ,  0, 'BringRec' , 1 ,'ProgRec' , 0 ,'Struct' , 1  ,'BlockUpLoad',app.UseBlockDownload,'OwnerFlag',30001 ) ; 
            RecAction = struct( 'InitRec' ,  0, 'BringRec' , 1 ,'ProgRec' , 0 ,'Struct' , 1  ,'BlockUpLoad',1,'OwnerFlag',30001 ) ; 
            if ~(owner==RecAction.OwnerFlag)
                app.TransientExceptionLabel.Text = 'Recorder ownership conflict' ; 
                return ;
            end

            [~,~,r] = Recorder(app.RecMng.CurVarNames , RecStruct , RecAction   );
            plot( app.UIAxesCurrent , r.t , r.CurrentCommandFiltered , r.t , r.Iq) ; 
            legend(app.UIAxesCurrent,{'Iref','Iq'}) ; 
            grid (app.UIAxesCurrent,'on')
            plot( app.UIAxesVoltage , r.t , r.vqd ) ; legend(app.UIAxesVoltage ,'Volts') ; grid (app.UIAxesCurrent,'on'); 

            save RecordCurRslt.mat r             
            app.InstructionsLabel.Text = 'Recorder results are in RecordCurRslt.mat' ; 

        end

        % Button pushed function: MotorcurrentsButton
        function MotorcurrentsButtonPushed(app, event)
            app.Lock = 1 ; 
            try 
                CurrentCalibExp() ; 
                app.TransientExceptionLabel.Text = 'Current calibration experiment complete' ; 
            catch
                app.TransientExceptionLabel.Text = 'Current calibration experiment failed' ; 
            end
            app.Lock = 0 ; 

        end

        % Button pushed function: CommutationButton
        function CommutationButtonPushed(app, event)
            app.Lock = 1 ; 
            try 
                CommutationExp() ; 
                app.TransientExceptionLabel.Text = 'Commutation calibration experiment complete' ; 
            catch
                app.TransientExceptionLabel.Text = 'Commutation calibration experiment failed' ; 
            end
            app.Lock = 0 ; 
                
        end

        % Button pushed function: HelpButton
        function HelpButtonPushed(app, event)
            HelpDrv(); 
        end

        % Selection changed function: UnitsButtonGroup
        function UnitsButtonGroupSelectionChanged(app, event)
            selectedButton = app.UnitsButtonGroup.SelectedObject;

            if ~(app.SysData.PosUnitSelect == selectedButton.UserData ) 

            switch pp.SysData.PosUnitSelect 
                case 1 % User 
                    fac = 1 ; 
                case 2 % Motor
                    fac = app.SysData.Rev2Pos ; 
                case 3 % Encoder
                    fac = app.SysData.Rev2Pos / app.SysData.EncoderCountsFullRev; 
            end
                
            switch selectedButton.UserData
                case 1 % User 
                    fac = fac * 1 ; 
                case 2 % Motor
                    fac = fac / app.SysData.Rev2Pos  ; 
                case 3 % Encoder
                    fac = app.SysData.Rev2Pos  * app.SysData.EncoderCountsFullRev ;
            end
            app.TargetLEditField.Value = SetNumResolution(app.TargetLEditField.Value * fac,-4) ; 
            app.TargetHEditField.Value = SetNumResolution(app.TargetHEditField.Value * fac ,-4); 
            app.SysData.PosUnitSelect = selectedButton.UserData ;
            end
        end

        % Button pushed function: InitRecordButtonPos
        function InitRecordButtonPosPushed(app, event)
            % Init recorder for speed (Owner = 30000) 
            global RecStruct
            RecStruct.Sync2C = 1 ; 

            if app.AutotimeCheckBoxPos.Value

                f = 1/(0.2+GetTrapezeTime( abs(app.TargetHEditField.Value-app.TargetLEditField.Value) , app.PosTrajSpeedEditField ,...
                    app.AccelerationEditField.Value, app.DecelerationEditField.Value) )  ; 
                RecTime = 3 / max(f,0.1) ; 
            else
                RecTime = max( [app.PosRecTimeEditField.Value , 1e-4] ) ; 
            end 

            MaxRecLen = 1000 ; 
            app.RecMng.PosRecOn = 1 ; 
            switch app.DropDownPosTrigType.Value
                case 'Immediate'
                    RecStruct.TrigType = 0 ; 
                case 'Rising'
                    RecStruct.TrigType = 1 ; 
                case 'Falling'
                    RecStruct.TrigType = 2 ;
            end

           selectedButton = app.UnitsButtonGroup.SelectedObject;
           switch selectedButton.UserData
               case 1
                    app.RecMng.PosVarNames = {'PosReference','FilteredPosReference','SpeedCommand','UserSpeed','PosFeedBack','CurrentCommand','Iq','SpeedReference','UserPos','OuterPos'} ; 
               case 2
                    app.RecMng.PosVarNames = {'PosReference','FilteredPosReference','SpeedCommand','MotSpeedHz','MotorPos','CurrentCommand','Iq','SpeedReference'} ; 
               otherwise
                    app.RecMng.PosVarNames = {'PosReference','FilteredPosReference','SpeedCommand','MotSpeedHz','EncCounts','CurrentCommand','Iq','SpeedReference'} ; 
           end 

            RecStruct.TrigVal = app.PosTriggerEditField.Value  ; 
            RecAction = struct( 'PreTrigPercent',app.EditTriggerPercent.Value,...
                'InitRec' ,  1, 'BringRec' , 0 ,'ProgRec' , 1 ,'Struct' , 1 ,'T' , RecTime ,'MaxLen', MaxRecLen ,'BlockUpLoad',0,'OwnerFlag',30005 ) ; 
            
            if RecStruct.TrigType 
                RecStruct.TrigSigName = app.DropDownPosTrigSignal.Value ; 
                RecStruct.PreTrigPercent = app.EditPosTriggerPercent.Value ;
            end 

            Recorder(app.RecMng.PosVarNames , RecStruct , RecAction   );
            app.RecorderReadyLamp.Color = [1,1,1] * 0.8 ;             
        end

        % Button pushed function: BringrecorderButtonPos
        function BringrecorderButtonPosPushed(app, event)
            % Bring recorder for speed (owner = 30000) 
            global RecStruct

            owner = FetchObjDisp(app,[hex2dec('2000'),111],app.DataType.long,'Get recorder owner') ; 
            RecAction = struct( 'InitRec' ,  0, 'BringRec' , 1 ,'ProgRec' , 0 ,'Struct' , 1  ,'BlockUpLoad',app.UseBlockDownload,'OwnerFlag',30005 ) ; 
            if ~(owner==30005)
                app.TransientExceptionLabel.Text = 'Position record expected: Recorder ownership conflict' ; 
                return ;
            end
            [~,~,r] = Recorder(app.RecMng.PosVarNames , RecStruct , RecAction   );

            % First axis : Position reference 
            GetSysData(app); 
            Rev2Pos = max( app.SysData.Rev2Pos, 1e-5) ; 
            Ecnt    = max(app.SysData.EncoderCountsFullRev,1) ; 
            if any(strcmp(app.RecMng.PosVarNames ,'PosFeedBack')) 
                plot( app.UIAxesPosH, r.t , r.PosReference , r.t , r.FilteredPosReference , r.t , r.PosFeedBack ); 
                legend(app.UIAxesPosH , 'User Cmd','Filt Cmd','PosFeedBack') ;
                grid(app.UIAxesPosH,'on') ;
            elseif any(strcmp(app.RecMng.PosVarNames ,'MotorPos') ) 
                plot( app.UIAxesPosH, r.t , r.PosReference /Rev2Pos , r.t , r.FilteredPosReference/Rev2Pos , r.t , r.MotorPos ); 
                legend(app.UIAxesPosH , 'Motor Cmd','Filt Cmd','Motor Pos') ; 
                grid(app.UIAxesPosH,'on') ;
            elseif any(strcmp(app.RecMng.PosVarNames ,'EncCounts') )
                plot( app.UIAxesPosH, r.t , r.PosReference * Ecnt /Rev2Pos , r.t , r.FilteredPosReference * Ecnt /Rev2Pos , r.t , r.MotorPos ); 
                legend(app.UIAxesPosH , 'Enc Cnt Cmd','Filt Cmd','Enc Cnt Pos') ; 
                grid(app.UIAxesPosH,'on') ;
            else
                app.TransientExceptionLabel.Text = 'Un recognized position variable' ; 
                return ;
            end

            yyaxis(app.UIAxesPosL,'right') ; 
            if any(strcmp(app.RecMng.PosVarNames ,'PosFeedBack') )
                plot( app.UIAxesPosL, r.t , r.SpeedCommand , r.t , r.UserSpeed ); 
                legendstr ={'User Speed Cmd','User Speed'} ; 
                grid(app.UIAxesPosL,'on') ;
            elseif any(strcmp(app.RecMng.PosVarNames ,'MotorPos') )
                plot( app.UIAxesPosL, r.t , r.SpeedCommand /Rev2Pos , r.t , r.MotSpeedHz ); 
                legendstr = {'Motor Speed Cmd','Motor Speed'} ; 
                grid(app.UIAxesPosL,'on') ;
            elseif any(strcmp(app.RecMng.PosVarNames ,'EncCounts') )
                plot( app.UIAxesPosL, r.t , r.SpeedCommand * Ecnt/Rev2Pos , r.t , r.MotSpeedHz * Ecnt ); 
                legendstr ={'Enc Speed Cmd','Enc speed'} ; 
                grid(app.UIAxesPosL,'on') ;
            end

            yyaxis(app.UIAxesPosL,'left') ; 
            plot( app.UIAxesPosL , r.t , r.CurrentCommand , r.t , r.Iq ) ; 
            legendstr = [{'Cur Cmd','Current'}, legendstr ]; 
            legend(app.UIAxesPosL , legendstr) ; 
            grid(app.UIAxesPosL,'on') ;
            ylabel(app.UIAxesPosL,'Amp') 
            
            save RecordPosRslt.mat r        

            app.InstructionsLabel.Text = 'Recorder results are in RecordPosRslt.mat' ;             
        end

        % Button down function: PositionTab
        function PositionTabButtonDown(app, event)
            
            if RegisterRab(app,app.PositionTab.UserData)==0 
                return ; % Act once on selection 
            end 


            if ~( (app.s.Bit.LoopClosure == app.Enums.LoopClosureModes.E_LC_Pos_Mode ) || ...
                 (app.s.Bit.LoopClosure == app.Enums.LoopClosureModes.E_LC_Dual_Pos_Mode ) ) 
                app.TransientExceptionLabel.Text = "Position loop closure is necessary to enter Position Control tab"; 
                app.SelectMot = 1 ; 
                % drawnow ;
                return ; 
            end 

            % Test that the position mode is supported
            GetSysData(app) ; 
            
            app.AccelerationEditField.Value = GetCfgPar('ProfileAcc') ; 
            app.DecelerationEditField.Value  = GetCfgPar('ProfileDec') ; 
            app.PosTrajSpeedEditField.Value  = GetCfgPar('ProfileSpeed') ; 
            %app.CurrentlimitEditFieldPos.Value = GetCfgPar('CurrentLimitFactor') * GetFloatPar('ControlPars.MaxCurCmd') ;
            app.CurrentlimitEditFieldPos.Value =  GetFloatPar('ControlPars.MaxCurCmd') ;
            app.MaxAccEditField.Value = GetCfgPar('MaxAcc') ; 
            app.KpEditField.Value = GetCfgPar('PosKp') ; 
            
            switch app.SysData.PosUnitSelect 
                case 1 % User 
                    pos = GetSignal('UserPos')  ; 
                case 2 % Motor
                    pos = GetSignal('MotorPos')  ; 
                case 3 % Encoder
                    pos = GetSignal('EncCounts')  ; 
            end
                
            app.TargetLEditField.Value = SetNumResolution(pos,-4) ; 
            app.TargetHEditField.Value = SetNumResolution(pos,-4) ; 

            app.PeriodicCheckBox.Value  = logical(app.s.Bit.bPeriodicProf) ; 

        end

        % Button down function: SignalsPanel
        function SignalsPanelButtonDown(app, event)
            
        end

        % Value changed function: PeriodicCheckBox
        function PeriodicCheckBoxValueChanged(app, event)
            value = app.PeriodicCheckBox.Value;
            SendObj([hex2dec('2221'),8],double(value),GetDataType('long'),'bPeriodicPos') ;
        end

        % Button pushed function: GoButton
        function GoButtonPushed(app, event)
             %value = app.PeriodicCheckBox.Value;
             SetCfgPar('ProfileAcc',app.AccelerationEditField.Value) ; 
             SetCfgPar('ProfileDec',app.DecelerationEditField.Value) ; 
             SetCfgPar('ProfileSpeed',app.PosTrajSpeedEditField.Value) ; 

             
             if ( app.SysData.MaxCurCmd > app.CurrentlimitEditFieldPos.Value ) 
                 app.CurrentlimitEditFieldPos.Value = app.SysData.MaxCurCmd   ; 
             end 
             %SetCfgPar('CurrentLimitFactor',app.CurrentlimitEditFieldPos.Value/app.SysData.MaxCurCmd ) ; 

             SendObj([hex2dec('2220'),4],1,app.DataType.long,'Set motor enable/disable') ;
             SendObj([hex2dec('2220'),11],0,app.DataType.long,'Release quick stop') ;
             SendObj([hex2dec('2220'),14],app.Enums.ReferenceModes.E_PosModePTP,app.DataType.long,'Set reference mode') ;
             if ( app.PeriodicCheckBox.Value )
    
                 SendObj([hex2dec('2400'),41],app.TargetLEditField.Value,app.DataType.float,'Set target position 1') ;
                 SendObj([hex2dec('2400'),42],app.TargetHEditField.Value,app.DataType.float,'Set target position 2') ;                              
                 SendObj([hex2dec('2221'),8],1,app.DataType.long,'bPeriodicPos') ; 
             else
                 SendObj([hex2dec('2221'),8],0,app.DataType.long,'bPeriodicPos') ; 
                 SendObj([hex2dec('2400'),32],0,app.DataType.float,'Reset profiler') ;
                 SendObj([hex2dec('2400'),3],app.TargetLEditField.Value,app.DataType.float,'Set target position') ;
             end

        end

        % Value changed function: CurrentlimitEditFieldPos
        function CurrentlimitEditFieldPosValueChanged(app, event)
            value = app.CurrentlimitEditFieldPos.Value;
            try
                SetFloatPar('ControlPars.MaxCurCmd',value) ; 
            catch 
                value = GetFloatPar('ControlPars.MaxCurCmd')  ; 
            end
            app.CurrentlimitEditFieldPos.Value = value;
            app.CurrentlimitEditField.Value = value  ;

        end

        % Button pushed function: StopButton
        function StopButtonPushed(app, event)
             SendObj([hex2dec('2220'),14],app.Enums.ReferenceModes.E_PosModeStayInPlace,app.DataType.long,'Set reference mode') ;                        
        end

        % Value changed function: MaxAccEditField
        function MaxAccEditFieldValueChanged(app, event)
            value = app.MaxAccEditField.Value;
            if ( value < 0 || value > 50000)
                value = GetCfgPar('MaxAcc') ; 
                app.MaxAccEditField.Value = value ; 
            else
                SetCfgPar('MaxAcc',value) 
            end
        end

        % Value changed function: KpEditField
        function KpEditFieldValueChanged(app, event)
            value = app.KpEditField.Value;
            if ( value < 0 || value > 500)
                value = GetCfgPar('PosKp') ; 
                app.KpEditField.Value = value ; 
            else
                SetCfgPar('PosKp',value) 
            end
            
        end

        % Button down function: ParametersTab
        function ParametersTabButtonDown(app, event)
            if RegisterRab(app,app.ParametersTab.UserData)==0 
                return ; % Act once on selection 
            end 
            
        end

        % Button down function: MotionTab
        function MotionTabButtonDown(app, event)
            if RegisterRab(app,app.MotionTab.UserData)==0 
                return ; % Act once on selection 
            end 
            
        end

        % Button pushed function: TestencodersandHallsButton
        function TestencodersandHallsButtonPushed(app, event)
            if app.InAtpExperiment 
                msgbox({'\fontsize{12} Other experiment is running, terminate it first'},app.CreateStruct); 
                return 
            end

            app.Lock = 1 ;
            runok = 1 ; 

            try 
                AtpBasicSetup(app) ; 

                TestStructFields(app.ExpMng,{'CurLevel','nCycle','WaitTime','CycleTime','npp'},'ExpMng') ; 
                % Get Vdc 
                Vdc = GetSignal('Vdc') ; 
                if  app.ExpMng.CurLevel < 0.1 || app.ExpMng.CycleTime < 0.1 || app.ExpMng.CycleTime > 100 || ...
                        app.ExpMng.CurLevel > app.ExpMng.ExperimentSafeLimits.OverCurrent * 0.9 || Vdc < app.ExpMng.ExperimentSafeLimits.Undervoltage * 0.9  
                    error ('Bad experiment setup') ; 
                end 

                % Set to open loop commutation 
                SendObj([hex2dec('220d'),app.RecStruct.CfgTable.CommutationMode.Ind],app.RecStruct.Enums.CommutationModes.COM_OPEN_LOOP ,app.DataType.long,'Set open loop commutation') ;
    
                % Set the loop closure mode
                SendObj([hex2dec('2220'),8],app.RecStruct.Enums.LoopClosureModes.E_LC_OpenLoopField_Mode,app.DataType.long,'Set the loop closure mode to open loop commutation') ; 

                motor(1) ; 

                pause(0.3) ; 

                % Set the reference mode 
                SendObj([hex2dec('2220'),14],app.RecStruct.Enums.ReferenceModes.E_PosModeDebugGen,app.DataType.long,'Set reference mode') ;

                % Bring the motor to standstill
                TGenStr = struct('Gen','T','Type',app.RecStruct.Enums.SigRefTypes.E_S_Fixed,'On',1,...
                    'Dc',app.ExpMng.CurLevel,'Amp',0,'F',1,'Duty',0.5,'bAngleSpeed',0)  ;
                
                Gdc = 1/app.ExpMng.CycleTime ; 
                GGenStr = struct('Gen','G','Type',app.RecStruct.Enums.SigRefTypes.E_S_Fixed,'On',1,...
                    'Dc',Gdc,'Amp',0,'F',1,'Duty',0.5,'bAngleSpeed',1,'AnglePeriod',1)  ;


                rslt = zeros( 6, 10000) ; 

                % Setup the recorder 
                % RecInitAction = struct( 'InitRec' , 1 , 'BringRec' , 0 ,'ProgRec' , 1 ,'Struct' , 1 ,'T' , RecTime ,'MaxLen', MaxRecLen ) ; 
                % RecBringAction = struct( 'InitRec' , 0 , 'BringRec' , 1 ,'ProgRec' , 0 ,'Struct' , 1 ,'BlockUpLoad', app.UseBlockDownload  ) ; 
                app.ExpMng.RecNames = {'Iq','EncCounts','HallKey','ThetaElect','CBit'}  ; 
                % L_RecStruct = RecStruct ;
                % L_RecStruct.BlockUpLoad = 0 ; 
                app.ExpMng.TypeFlags = SetSnap( app.ExpMng.RecNames ) ; 
                
                SetRefGen(  TGenStr ) ; % Let the torque converge 
                
                dstr = ["Test will take nearly 1 minute. Be patient... ","Initiating direction #1 "] ; 
                app.TextAreaAtpResult.Value = dstr ; 
                pause(1) ; 

                cnt = 0 ; 
                tStart = tic ; 
                tStep  = tStart ; 
                state = 0 ; 
                SetRefGen(  GGenStr ) ; % Start rotation
                tclk = clock() ; 

                while cnt < 10000  
                    
                    % s = SGetState() ; 
                %     if ( s.Bit.MotorOn == 0 )
                %         uiwait( msgbox({'\fontsize{12}Motor turned off'},CreateStruct) ) ; 
                %         break ; 
                %     end 
                
                    r = GetSnap(app.ExpMng.RecNames,app.ExpMng.TypeFlags) ; 
                
                    if ( bitand(r.CBit,1) == 0 )
                        excp =  GetSignal('KillingException') ; 
                        excpInd = find( app.ecStruct.ErrCodes.Code== excp,1) ; 
                        if isempty( excpInd)
                            errstr = 'Unknown error' ; 
                        else
                            errstr = app.RecStruct.ErrCodes.Formal{excpInd} ; 
                        end
                        error(['Motor turned off by fault','Exception code:',errstr]) ; 
                    end 
                
                    cnt = cnt+ 1 ; 
                    rslt(1,cnt) = r.HallKey ;
                    rslt(2,cnt) = r.EncCounts ;
                    rslt(3,cnt) = r.TimeUsec ; 
                    rslt(4,cnt) = state ;
                    rslt(5,cnt) = r.ThetaElect ; 
                    rslt(6,cnt) = etime(clock , tclk )  ; 
                
                    n = 4 * 4 ; 

                    app.InstructionsLabel.Text = "Wait while the motor is turning" ;

                    switch state
                
                        case 0
                            if toc(tStep) >= app.ExpMng.WaitTime 
                                tStep = tic ; 
                                dstr = [dstr , "Starting direction #1 "]; %#ok<AGROW> 
                                app.TextAreaAtpResult.Value = dstr ; 
                                drawnow ; 
                                state = 1 ; 
                            end
                        case 1
                            if toc(tStep) >= app.ExpMng.CycleTime * n   
                                dstr = [dstr , "Stopping direction #1 "];%#ok<AGROW> 
                                app.TextAreaAtpResult.Value = dstr ; 
                                drawnow ; 
                                GGenStr.Dc = 0 ; 
                                SetRefGen(  GGenStr ) ; % Start rotation
                                tStep = tic ; 
                                state = 2 ; 
                            end
                        case 2
                            if toc(tStep) >= app.ExpMng.WaitTime 
                                dstr = [dstr , "Starting direction #2"];%#ok<AGROW> 
                                app.TextAreaAtpResult.Value = dstr ; 
                                drawnow ; 
                                GGenStr.Dc = -Gdc ; 
                                SetRefGen(  GGenStr ) ; % Start rotation
                                tStep = tic ; 
                                state = 3 ; 
                            end
                        case 3
                            if toc(tStep) >= app.ExpMng.CycleTime * n 
                                dstr = [dstr , "Stopping direction #2"];%#ok<AGROW> 
                                app.TextAreaAtpResult.Value = dstr ; 
                                drawnow ; 
                                GGenStr.Dc = 0 ; 
                                SetRefGen(  GGenStr ) ; % Start rotation
                                tStep = tic ; 
                                state = 4 ; 
                            end
                        case 4
                            if toc(tStep) >= app.ExpMng.WaitTime 
                                %disp( 'Done ') ; 
                                state = 6 ; %#ok<NASGU,NASGU> 
                                break ; 
                            end
                    end
                            
                end 
                
                motor(0) ;
                rslt = rslt(:,1:cnt) ; % Keep only filled entries
                ExpMngSave = app.ExpMng ;
                save AtpComm.mat rslt ExpMngSave
                               
                
    
                

            catch Me 
                disp(Me.message) ;
                for cnt = 1 : length(Me.stack)
                    disp(Me.stack(cnt));
                end
                runok = 0 ; 
            end

            motor(0);
            app.Lock = 0 ;

            if runok
                [~,errmsg,str] = AtpAnalyze('EncoderAndHalls') ; 
                if ~isempty(errmsg) 
                    app.TextAreaAtpResult.Value = ["Error:" , string(errmsg) ] ; 
                else
                    app.TextAreaAtpResult.Value = ["Success:" , string(str) ] ; 
                end
            end 

            return ; 

        end

        % Button pushed function: GotonextstepButton
        function GotonextstepButtonPushed(app, event)
            app.ExpMng.NextCnt = app.ExpMng.NextCnt + 1 ; 

        end

        % Button pushed function: TestcurrentloopButton
        function TestcurrentloopButtonPushed(app, event)
            
            if app.InAtpExperiment 
                msgbox({'\fontsize{12} Other experiment is running, terminate it first'},app.CreateStruct); 
                return 
            end
            % Shut the motor 
            motor(0);
            app.Lock = 1 ;
            Saved = 0 ; 
            try 

                AtpBasicSetup(app) ; 

                % Get ADC offsets 
                AdcOffset = zeros(1,3) ;
                AdcOffset(1) = FetchObj([hex2dec('2222'),0],app.DataType.float,'ADC offset') ; 
                AdcOffset(2) = FetchObj([hex2dec('2222'),1],app.DataType.float,'ADC offset') ; 
                AdcOffset(3) = FetchObj([hex2dec('2222'),2],app.DataType.float,'ADC offset') ; 

                good = 'Pass' ; 
                if any(abs(AdcOffset) > 150 )
                    good = 'Fail' ; 
                end
                app.TextAreaAtpResult.Value = {['ADC A offset:', num2str(AdcOffset(1)) ],['ADC B offset:', num2str(AdcOffset(2)) ],['ADC C offset:', num2str(AdcOffset(3)) ],['Result: ',good]} ; 

                if ( isequal(good,'Fail')) 
                    app.InstructionsLabel.Text = 'Failed ADC offsets, test will not proceed' ; 
                end

                % Set to open loop commutation 
                SendObj([hex2dec('220d'),app.RecStruct.CfgTable.CommutationMode.Ind],app.RecStruct.Enums.CommutationModes.COM_OPEN_LOOP ,app.DataType.long,'Set open loop commutation') ;
    
                % Set the loop closure mode
                SendObj([hex2dec('2220'),8],app.RecStruct.Enums.LoopClosureModes.E_LC_OpenLoopField_Mode,app.DataType.long,'Set the loop closure mode to open loop commutation') ;                      
    
    
                % Set brake Engage 
                SendObjDisp(app,[hex2dec('2220'),23],4,app.DataType.long,'Brake set/release') ; 
                SendObjDisp(app,[hex2dec('2220'),20],0,app.DataType.long,'Brake set/release') ; 
    
                
    
                % Start the motor 
                motor(1);
    
                % Set the reference mode 
                SendObj([hex2dec('2220'),14],app.RecStruct.Enums.ReferenceModes.E_PosModeDebugGen,app.DataType.long,'Set reference mode') ;

                app.ExpMng.RecNames = {'Iq','Id','ThetaElect','CBit','PhaseCur0','PhaseCur1','PhaseCur2','vqd','vdd','CurrentCommandFiltered'}  ; 
    
                str = struct('Gen','T','Dc',0,'Amp',app.ExpMng.CurLevel,'F',100,'Duty',0.5,'Type',app.RecStruct.Enums.SigRefTypes.E_S_Square,'On',1);
                SetRefGen( str, 0 ) ; 
                
                recstruct = app.RecStruct  ; 

                recstruct.Sync2C = 1 ; 
                recstruct.TrigType = 1 ; % Trigger rising
                recstruct.TrigSigName = 'CurrentCommandFiltered' ; 

    
                RecTime = 0.02 ; 
                MaxRecLen = 1000 ; 
                % RecAction = struct( 'InitRec' ,  1, 'BringRec' , 1 ,'ProgRec' , 1 ,'Struct' , 1 ,'T' , RecTime ,'MaxLen', MaxRecLen ,'BlockUpLoad',app.UseBlockDownload ,...
                RecAction = struct( 'InitRec' ,  1, 'BringRec' , 0 ,'ProgRec' , 1 ,'Struct' , 1 ,'T' , RecTime ,'MaxLen', MaxRecLen ,'BlockUpLoad',1 ,...
                    'PreTrigPercent',1,'OwnerFlag',30001) ; 
                Recorder(app.ExpMng.RecNames , recstruct , RecAction   );
                
                pause(0.2) ;
                motor(0) ; 
                RecAction = struct( 'InitRec' ,  0 , 'BringRec' , 1 ,'ProgRec' , 0 ,'Struct' , 1 ,'T' , RecTime ,'MaxLen', MaxRecLen ,'BlockUpLoad',1 ,...
                    'PreTrigPercent',1,'OwnerFlag',30001) ; 
                [~,~,r]  = Recorder(app.ExpMng.RecNames , recstruct , RecAction   );
    
                Saved = 1 ; 
                save AtpCurrentLoop r 

            catch Me
                disp(Me.message) ;
            end

            motor(0);

            app.Lock = 0 ;
            if Saved
                figure(50) ; clf 
                AtpAnalyze('CurrentLoop') ; 
            end
        end

        % Button pushed function: CalibphasecurrentsButton
        function CalibphasecurrentsButtonPushed(app, event)
            
        end

        % Button pushed function: TestcurrentscalesButton
        function TestcurrentscalesButtonPushed(app, event)
            try 
                app.Lock = 1 ; 
                AtpBasicSetup(app) ; 

                % get the ADC offsets

                % Kill amplitude calibration
                SetCalibPar('ACurGainCorr',0.0) ; 
                SetCalibPar('BCurGainCorr',0.0) ; 
                SetCalibPar('CCurGainCorr',0.0) ; 
                

                % Set to open loop commutation 
                SendObj([hex2dec('220d'),app.RecStruct.CfgTable.CommutationMode.Ind],app.RecStruct.Enums.CommutationModes.COM_OPEN_LOOP ,app.DataType.long,'Set open loop commutation') ;
    
                % Set the loop closure mode
                SendObj([hex2dec('2220'),8],app.RecStruct.Enums.LoopClosureModes.E_LC_OpenLoopField_Mode,app.DataType.long,'Set the loop closure mode to open loop commutation') ;                      
    
                % Set brake Engage 
                SendObjDisp(app,[hex2dec('2220'),23],4,app.DataType.long,'Brake set/release') ; 
                SendObjDisp(app,[hex2dec('2220'),20],0,app.DataType.long,'Brake set/release') ; 
    
                % Start the motor 
                motor(1);
    
                % Set the reference mode 
                SendObj([hex2dec('2220'),14],app.RecStruct.Enums.ReferenceModes.E_PosModeDebugGen,app.DataType.long,'Set reference mode') ;

                app.ExpMng.RecNames = {'Iq','Id','ThetaElect','CBit','PhaseCur0','PhaseCur1','PhaseCur2','CurrentCommandFiltered',...
                    'PhaseCurUncalibA','PhaseCurUncalibB','PhaseCurUncalibC'}  ; 
    
                str = struct('Gen','T','Dc',app.ExpMng.CurLevel,'Amp',0,'F',100,'Duty',0.5,'Type',app.RecStruct.Enums.SigRefTypes.E_S_Fixed,'On',1);
                SetRefGen( str, 0 ) ; 
                
                strG = struct('Gen','G','Dc',50,'Amp',0,'F',100,'Duty',0.5,'Type',app.RecStruct.Enums.SigRefTypes.E_S_Fixed,'On',1,'bAngleSpeed',1,'AnglePeriod',1);
                SetRefGen( strG, 0 ) ; 

                app.InstructionsLabel.Text = {'Use a current probe to measure the 3 motor wires', 'Fill the extreme p-p resul in the dialog','And press "Go To next step"'};  
                app.GotonextstepButton.Visible = 1 ; 


                pause(0.3) ; 
                RecAction = struct( 'InitRec' ,  1, 'BringRec' , 1 ,'ProgRec' , 1 ,'Struct' , 1 ,'T' , 0.02 ,'MaxLen', 600 ,'PreTrigPercent',11,'BlockUpLoad',1 ,'OwnerFlag',40001) ; 

                recstruct = app.RecStruct ; 
                recstruct.TrigSigName = 'ThetaElect' ; 
                recstruct.TrigType = 1 ; 
                recstruct.TrigVal = 0.1 ; 

                [~,~,r]  = Recorder(app.ExpMng.RecNames , recstruct , RecAction   );
    
%                 Saved = 1 ; 
                save AtpCurrentGains r 

                psfig = CurrentGainCalib(app.ExpMng.CurLevel) ; 
                while isvalid(psfig)
                    pause(0.5);
                end

                x = load('CurCalibMsg.mat') ;  
                x = x.rslt ; 
                if isempty(x.errmsg) 
                    app.TextAreaAtpResult.Value = ['Gains: ' ,num2str(x.v(1)),':',num2str(x.v(2)) ,':',num2str(x.v(3))]; 
                else
                    app.TextAreaAtpResult.Value = x.errmsg ; 
                end

            catch Me
                disp(Me.message) ;
            end

            motor(0);

            app.Lock = 0 ;
%             if Saved
%                 figure(50) ; clf 
%                 AtpAnalyze('CurrentLoop') ; 
%             end
            
        end

        % Value changed function: SystemModeDropDown
        function SystemModeDropDownValueChanged(app, event)
            value = app.SystemModeDropDown.Value;
            sysmode = app.RecStruct.Enums.SysModes.(value) ; 
            if  contains(value,'Automatic')
                 SendObjDisp(app,[hex2dec('2223'),3],0,app.DataType.long,'Un Ignore host CW') ;
            end

            SendObj( [hex2dec('2220'),12] , sysmode , app.DataType.long ,'Set the system mode') ;  

        end

        % Button pushed function: HomeButton
        function HomeButtonPushed(app, event)
            
            if app.UseCase.SupportHome == 0 
                uiwait( errordlg('This unit does not support homing mode') ) ;
                return ; 
            end
            if app.UseCase.HomeMethod == app.RecStruct.Enums.HomeMethodTypes.EHM_Immediate
                try
                    SendObj( [hex2dec('2220'),25] , 1234 , app.DataType.long ,'Set homing') ;          
                catch
                    app.InstructionsLabel.Text = {'Cant do immediate homing','Possibly because in single-feedback position control'} ;
                end
                return ;
            end

            if contains ( app.MotorONButton.Text,'Manual' )  
                h = errordlg({'The motor is on automatic control','Set to MANUAL first'}); 
                while isvalid(h) 
                    pause(0.2);
                end
                return 
            end
            
            if ~app.s.Bit.MotorOn 

                if contains ( app.MotorONButton.Text,'Reset' ) 
                    h = errordlg({'The motor is ar fault','Reset the fault first'}); 
                    while isvalid(h) 
                        pause(0.2);
                    end
                    return 
                end

                yesno = questdlg({'Motor is off.', 'Do you want ot set it on?'}, ...
                                         'Decision', ...
                                         'Yes', 'No', 'Yes');     
                if ~isequal(yesno,'Yes')
                    return ; 
                end
                % Set the motor on
                SendObjDisp(app,[hex2dec('2220'),4],1,app.DataType.long,'Set motor enable') ;
            end
            SendObj([hex2dec('2220'),8],app.RecStruct.Enums.LoopClosureModes.E_LC_Speed_Mode,app.DataType.long,...
                'Set the loop closure mode to speed') ;     

            SendObj([hex2dec('2220'),14],app.RecStruct.Enums.ReferenceModes.E_PosModeStayInPlace,app.DataType.long,...
                'Set the loop reference mode to stay') ;                      
            SendObj([hex2dec('2223'),6],0,app.DataType.long,'SKill homing') ;                      

            homeval = app.HomepositionEditField.Value ; 
            if app.PositivedirectionCheckBox.Value
                SendObj([hex2dec('2223'),0],1,app.DataType.long,'Homing direction');
                SendObj([hex2dec('2225'),13],homeval,app.DataType.float,'Homing position');
            else
                SendObj([hex2dec('2223'),0],-1,app.DataType.long,'Homing direction');
                SendObj([hex2dec('2225'),14],homeval,app.DataType.float,'Homing position');
            end
            

            SendObj([hex2dec('2220'),14],app.RecStruct.Enums.ReferenceModes.E_RefModeSpeed2Home,app.DataType.long,...
                'Set the loop reference mode to homing') ;                      


        end

        % Button pushed function: TestPositionButton
        function TestPositionButtonPushed(app, event)
            
            if contains(app.TestPositionButton.Text,'Speed') 
                TestSpeedButtonPushed(app); 
                return ; 
            end
            
            app.PeriodicCheckBox.Value = 1 ; 
            app.AccelerationEditField.Value = 6 ; 
            app.DecelerationEditField.Value = 6 ; 
            app.PosTrajSpeedEditField.Value = 2 ; 
            app.CurrentlimitEditFieldPos.Value  = 7 ; 
            CurrentlimitEditFieldPosValueChanged(app) ;

            app.TargetLEditField.Value = -0.1 ; 
            app.TargetHEditField.Value = 0.1 ; 

            app.PosRecTimeEditField.Value =  2; 
            app.AutotimeCheckBoxPos.Value = false ; 

            % Set to manual mode
            SendObj([hex2dec('2220'),12],app.RecStruct.Enums.SysModes.E_SysMotionModeManual,app.DataType.long,'Set system mode to manual') ;
            
            % Set motor off 
            SendObj([hex2dec('2220'),4],0,app.DataType.long,'Set motor enable/disable') ;

            % Home 
            if app.UseCase.HomeMethod == app.RecStruct.Enums.HomeMethodTypes.EHM_Immediate 
                HomeButtonPushed(app, event);
            end

            % Set to dual loop function 
            SendObj([hex2dec('2220'),8],app.RecStruct.Enums.LoopClosureModes.E_LC_Dual_Pos_Mode,app.DataType.long,'Set the loop closure mode to outer position') ;                      

            VerifyAxisConfig(app) ; 

            % Set motor on
            SendObj([hex2dec('2220'),4],0,app.DataType.long,'Set motor enable/disable') ;

            pause(0.5) ; 

            GoButtonPushed(app, event) ; 
            pause(0.5) ; 
            InitRecordButtonPosPushed(app, event) ; 

            app.TabGroup.SelectedTab = app.PositionTab ; 

            pause(2.5) ; 
            BringrecorderButtonPosPushed(app, event); 

            StopButtonPushed(app, event)

            % Set motor off 
            SendObj([hex2dec('2220'),4],0,app.DataType.long,'Set motor enable/disable') ;
            
        end

        % Button pushed function: HereButton
        function HereButtonPushed(app, event)
            pos = GetSignal('UserPos')  ; 
            app.TargetLEditField.Value = SetNumResolution(pos,-4) ; 
        end

        % Button pushed function: HereButton_2
        function HereButton_2Pushed(app, event)
            pos = GetSignal('UserPos')  ; 
            app.TargetHEditField.Value = SetNumResolution(pos,-4) ;             
        end

        % Button pushed function: ToggleBrakeButton
        function ToggleBrakeButtonPushed(app, event)
            if ( app.s.Bit.BrakeRelease )
                value = 0 ; 
            else
                value = 1 ; 
            end
            if app.IsLocalBrake
                SendObjDisp(app,[hex2dec('2220'),23],2,app.DataType.long,'Brake set/release') ; 
                SendObjDisp(app,[hex2dec('2220'),20],value,app.DataType.long,'Brake set/release') ; 
            else
                SendObjDisp(app,[hex2dec('2220'),23,app.IntfcCardCanId],2,app.DataType.long,'Brake set/release') ; 
                % SendObjDisp(app,[hex2dec('2220'),19,app.IntfcCardCanId],16.5,app.DataType.float,'Brake voltage') ; 
                SendObjDisp(app,[hex2dec('2220'),20,app.IntfcCardCanId],value,app.DataType.long,'Brake set/release') ; 
            end
            
        end

        % Value changed function: PositivedirectionCheckBox
        function PositivedirectionCheckBoxValueChanged(app, event)
            value = app.PositivedirectionCheckBox.Value;
            if value
                pos = FetchObj([hex2dec('2225'),13],app.DataType.float,'Homing position');
            else
                pos = FetchObj([hex2dec('2225'),14],app.DataType.float,'Homing position');
            end
            app.HomepositionEditField.Value = SetNumResolution(pos,-3);


        end

        % Value changed function: TargetLEditField
        function TargetLEditFieldValueChanged(app, event)
            value = app.TargetLEditField.Value;
            
        end

        % Button pushed function: CalibrateplaterotatorButton
        function CalibrateplaterotatorButtonPushed(app, event)

            SendObjDisp(app,[hex2dec('2223'),3],1,app.DataType.long,'Ignore host CW') ;

            if app.s.Bit.StoEvent
                 h= errordlg({'\fontsize{12}STO is down .', 'Please power the STO','Should be ON if connected to robot','And mushroom not depressed'},...
                    'Error',app.CreateStruct) ; 
                 while isvalid(h) 
                     set( h ,'WindowStyle','modal');
                     pause(0.2) ; 
                 end
                 return 
            end

            if contains ( app.MotorONButton.Text,'Manual' )  
                yesno = questdlg({'\fontsize{12}Drive in automatic mode..', 'Do you want to set it to MANUAL?'}, ...
                                         'Decision', ...
                                         'Yes', 'Abort', struct ('Default','Abort','Interpreter','tex') ) ;     
                SendObjDisp(app,[hex2dec('2220'),12],app.Enums.SysModes.E_SysMotionModeManual,app.DataType.long,'Set to manual mode') ;
                if ~isequal(yesno,'Yes')
                    return ; 
                end
            end

            if app.s.Bit.Configured == 0 
                yesno = questdlg({'\fontsize{12}Drive not configured..', 'Do you want to configure it?'}, ...
                                         'Decision', ...
                                         'Yes', 'Abort', struct ('Default','Abort','Interpreter','tex') ) ;     
                if ~isequal(yesno,'Yes')
                    return ; 
                end
                SaveCfg([],'StamCfg.jsn') ; 
                ProgCfg('StamCfg.jsn') ; 
            end
            
            if app.s.Bit.Fault || (app.s.Bit.SystemMode < 0 )
                yesno = questdlg({'\fontsize{12}Drive at FAULT..', 'Do you want to clear the fault?'}, ...
                                         'Decision', ...
                                         'Yes', 'Abort', struct ('Default','Abort','Interpreter','tex') ) ;     
                if ~isequal(yesno,'Yes')
                    return ; 
                end
                SendObjDisp(app,[hex2dec('2220'),12],app.Enums.SysModes.E_SysMotionModeManual,app.DataType.long,'Reset fault') ;
            end
            

            if contains( app.ProjName,'PROJ_TYPE_NECK') 
                app.CalibrateNeck() ; 
            elseif contains(app.ProjName,'PROJ_TYPE_STEERING_R') 
                app.CalibrateSteer('R') ; 
            elseif contains(app.ProjName,'PROJ_TYPE_STEERING_L') 
                app.CalibrateSteer('L') ; 
            elseif contains( app.ProjName,'PROJ_TYPE_TRAY_ROTATOR') 
                app.CalibrateRotator() ; 
            else
                h = errordlg('No calibration applicable to thie axis type') ; 
                while isvalid(h) 
                    pause(0.2) ; 
                end
            end

        end

        % Button pushed function: NextButton
        function NextButtonPushed(app, event)
            app.ExpMng.NextCnt = app.ExpMng.NextCnt+ 1 ; 

        end

        % Button pushed function: SteerUpButton
        function SteerUpButtonPushed(app, event)
                 
            value = app.StepsizeDegEditField.Value ; 
            SendObj([hex2dec('2220'),4],1,app.DataType.long,'Set motor enable/disable') ;
            SendObj([hex2dec('2220'),11],0,app.DataType.long,'Release quick stop') ;
            SendObj([hex2dec('2220'),14],app.Enums.ReferenceModes.E_PosModePTP,app.DataType.long,'Set reference mode') ;
            
            nextpos = max( min( app.s.base.UserPos *  57.2958  + value , 110 ) ,-110) * 0.017453292519943 ;
            SendObj([hex2dec('2400'),32],0,app.DataType.float,'Reset profiler') ;
            SendObj([hex2dec('2400'),3],nextpos,app.DataType.float,'Set target position') ;
            
        end

        % Button pushed function: SteerDnButton
        function SteerDnButtonPushed(app, event)
            value = -app.StepsizeDegEditField.Value ; 
            SendObj([hex2dec('2220'),4],1,app.DataType.long,'Set motor enable/disable') ;
            SendObj([hex2dec('2220'),11],0,app.DataType.long,'Release quick stop') ;
            SendObj([hex2dec('2220'),14],app.Enums.ReferenceModes.E_PosModePTP,app.DataType.long,'Set reference mode') ;
            
            nextpos = max( min( app.s.base.UserPos *  57.2958  + value , 110 ) ,-110) * 0.017453292519943 ;
            SendObj([hex2dec('2400'),32],0,app.DataType.float,'Reset profiler') ;
            SendObj([hex2dec('2400'),3],nextpos,app.DataType.float,'Set target position') ;
            
        end

        % Button pushed function: AbortCalibButton
        function AbortCalibButtonPushed(app, event)
             app.ExpMng.NextCnt = 0  ;
             app.InCalibExp  = 0 ; 
             app.InstructionsLabel.Text= {'Calibration aborted','You can stay and have 30% discount'}; 
            
        end

        % Button pushed function: ConfigButton
        function ConfigButtonPushed(app, event)
            RefreshConfigPanel(app) ;
            Download2driveButtonCfgPushed(app, event) ;
        end
    end

    % Component initialization
    methods (Access = private)

        % Create UIFigure and components
        function createComponents(app)

            % Create WheelDrvUIFigure and hide until all components are created
            app.WheelDrvUIFigure = uifigure('Visible', 'off');
            app.WheelDrvUIFigure.Position = [100 100 1163 733];
            app.WheelDrvUIFigure.Name = 'WheelDrv';
            app.WheelDrvUIFigure.CloseRequestFcn = createCallbackFcn(app, @WheelDrvUIFigureCloseRequest, true);

            % Create WheeldrivedialogLabel
            app.WheeldrivedialogLabel = uilabel(app.WheelDrvUIFigure);
            app.WheeldrivedialogLabel.FontSize = 20;
            app.WheeldrivedialogLabel.FontWeight = 'bold';
            app.WheeldrivedialogLabel.FontAngle = 'italic';
            app.WheeldrivedialogLabel.FontColor = [1 0 0];
            app.WheeldrivedialogLabel.Position = [60 700 561 26];
            app.WheeldrivedialogLabel.Text = 'Wheel drive dialog';

            % Create InstructionsLabel
            app.InstructionsLabel = uilabel(app.WheelDrvUIFigure);
            app.InstructionsLabel.BackgroundColor = [1 1 0];
            app.InstructionsLabel.FontWeight = 'bold';
            app.InstructionsLabel.FontAngle = 'italic';
            app.InstructionsLabel.Position = [49 88 799 51];
            app.InstructionsLabel.Text = 'Instructions';

            % Create ExceptionLabel
            app.ExceptionLabel = uilabel(app.WheelDrvUIFigure);
            app.ExceptionLabel.BackgroundColor = [0.651 0.651 0.651];
            app.ExceptionLabel.FontWeight = 'bold';
            app.ExceptionLabel.FontAngle = 'italic';
            app.ExceptionLabel.Position = [49 14 766 27];
            app.ExceptionLabel.Text = 'Exception';

            % Create TabGroup
            app.TabGroup = uitabgroup(app.WheelDrvUIFigure);
            app.TabGroup.Position = [49 147 768 506];

            % Create MotionTab
            app.MotionTab = uitab(app.TabGroup);
            app.MotionTab.Title = 'Motion';
            app.MotionTab.ButtonDownFcn = createCallbackFcn(app, @MotionTabButtonDown, true);

            % Create LoopclosureButtonGroup
            app.LoopclosureButtonGroup = uibuttongroup(app.MotionTab);
            app.LoopclosureButtonGroup.SelectionChangedFcn = createCallbackFcn(app, @LoopclosureButtonGroupSelectionChanged, true);
            app.LoopclosureButtonGroup.Title = 'Loop closure';
            app.LoopclosureButtonGroup.Position = [22 239 137 217];

            % Create LC0Button
            app.LC0Button = uiradiobutton(app.LoopclosureButtonGroup);
            app.LC0Button.Text = 'Voltage';
            app.LC0Button.Position = [11 171 62 22];
            app.LC0Button.Value = true;

            % Create LC1Button
            app.LC1Button = uiradiobutton(app.LoopclosureButtonGroup);
            app.LC1Button.Text = 'Open loop field';
            app.LC1Button.Position = [11 149 103 22];

            % Create LC2Button
            app.LC2Button = uiradiobutton(app.LoopclosureButtonGroup);
            app.LC2Button.Text = 'Torque';
            app.LC2Button.Position = [11 127 65 22];

            % Create LC3Button
            app.LC3Button = uiradiobutton(app.LoopclosureButtonGroup);
            app.LC3Button.Text = 'Speed';
            app.LC3Button.Position = [11 106 65 22];

            % Create LC4Button
            app.LC4Button = uiradiobutton(app.LoopclosureButtonGroup);
            app.LC4Button.Text = 'Position';
            app.LC4Button.Position = [11 85 65 22];

            % Create LC5Button
            app.LC5Button = uiradiobutton(app.LoopclosureButtonGroup);
            app.LC5Button.Text = 'DualPosition';
            app.LC5Button.Position = [12 64 89 22];

            % Create MotorvariablesPanel
            app.MotorvariablesPanel = uipanel(app.MotionTab);
            app.MotorvariablesPanel.Title = 'Motor variables';
            app.MotorvariablesPanel.Position = [161 239 210 216];

            % Create Enc1PosEditFieldLabel
            app.Enc1PosEditFieldLabel = uilabel(app.MotorvariablesPanel);
            app.Enc1PosEditFieldLabel.HorizontalAlignment = 'right';
            app.Enc1PosEditFieldLabel.Position = [18 108 63 22];
            app.Enc1PosEditFieldLabel.Text = 'Enc#1 Pos';

            % Create Enc1PosEditField
            app.Enc1PosEditField = uieditfield(app.MotorvariablesPanel, 'numeric');
            app.Enc1PosEditField.ValueDisplayFormat = '%d';
            app.Enc1PosEditField.Position = [96 108 100 22];

            % Create Enc2PosEditFieldLabel
            app.Enc2PosEditFieldLabel = uilabel(app.MotorvariablesPanel);
            app.Enc2PosEditFieldLabel.HorizontalAlignment = 'right';
            app.Enc2PosEditFieldLabel.Position = [18 77 63 22];
            app.Enc2PosEditFieldLabel.Text = 'Enc#2 Pos';

            % Create Enc2PosEditField
            app.Enc2PosEditField = uieditfield(app.MotorvariablesPanel, 'numeric');
            app.Enc2PosEditField.ValueDisplayFormat = '%.3f';
            app.Enc2PosEditField.Position = [96 77 100 22];

            % Create UserposEditFieldLabel
            app.UserposEditFieldLabel = uilabel(app.MotorvariablesPanel);
            app.UserposEditFieldLabel.HorizontalAlignment = 'right';
            app.UserposEditFieldLabel.Position = [28 49 53 22];
            app.UserposEditFieldLabel.Text = 'User pos';

            % Create UserposEditField
            app.UserposEditField = uieditfield(app.MotorvariablesPanel, 'numeric');
            app.UserposEditField.ValueDisplayFormat = '%11.4f';
            app.UserposEditField.Position = [96 49 100 22];

            % Create AnalogsPanel
            app.AnalogsPanel = uipanel(app.MotionTab);
            app.AnalogsPanel.Title = 'Analogs';
            app.AnalogsPanel.ButtonDownFcn = createCallbackFcn(app, @AnalogsPanelButtonDown, true);
            app.AnalogsPanel.Position = [373 237 196 216];

            % Create POT1EditFieldLabel
            app.POT1EditFieldLabel = uilabel(app.AnalogsPanel);
            app.POT1EditFieldLabel.HorizontalAlignment = 'right';
            app.POT1EditFieldLabel.FontSize = 16;
            app.POT1EditFieldLabel.FontWeight = 'bold';
            app.POT1EditFieldLabel.Position = [23 123 47 22];
            app.POT1EditFieldLabel.Text = 'POT1';

            % Create POT1EditField
            app.POT1EditField = uieditfield(app.AnalogsPanel, 'numeric');
            app.POT1EditField.FontSize = 16;
            app.POT1EditField.FontWeight = 'bold';
            app.POT1EditField.Position = [85 123 100 22];

            % Create POT2EditFieldLabel
            app.POT2EditFieldLabel = uilabel(app.AnalogsPanel);
            app.POT2EditFieldLabel.HorizontalAlignment = 'right';
            app.POT2EditFieldLabel.FontSize = 16;
            app.POT2EditFieldLabel.FontWeight = 'bold';
            app.POT2EditFieldLabel.Position = [24 89 47 22];
            app.POT2EditFieldLabel.Text = 'POT2';

            % Create POT2EditField
            app.POT2EditField = uieditfield(app.AnalogsPanel, 'numeric');
            app.POT2EditField.FontSize = 16;
            app.POT2EditField.FontWeight = 'bold';
            app.POT2EditField.Position = [86 89 100 22];

            % Create VdcEditFieldLabel
            app.VdcEditFieldLabel = uilabel(app.AnalogsPanel);
            app.VdcEditFieldLabel.HorizontalAlignment = 'right';
            app.VdcEditFieldLabel.Position = [44 156 26 22];
            app.VdcEditFieldLabel.Text = 'Vdc';

            % Create VdcEditField
            app.VdcEditField = uieditfield(app.AnalogsPanel, 'numeric');
            app.VdcEditField.Position = [85 156 100 22];

            % Create BrakeVoltsLabel
            app.BrakeVoltsLabel = uilabel(app.AnalogsPanel);
            app.BrakeVoltsLabel.HorizontalAlignment = 'right';
            app.BrakeVoltsLabel.Position = [19 56 66 22];
            app.BrakeVoltsLabel.Text = 'Brake Volts';

            % Create BrakeVoltsEditField
            app.BrakeVoltsEditField = uieditfield(app.AnalogsPanel, 'numeric');
            app.BrakeVoltsEditField.Position = [99 56 84 22];

            % Create RailsensorPNPCheckBox
            app.RailsensorPNPCheckBox = uicheckbox(app.AnalogsPanel);
            app.RailsensorPNPCheckBox.Text = 'Rail sensor PNP';
            app.RailsensorPNPCheckBox.Position = [53 32 110 22];

            % Create RailsensorNPNCheckBox
            app.RailsensorNPNCheckBox = uicheckbox(app.AnalogsPanel);
            app.RailsensorNPNCheckBox.Text = 'Rail sensor NPN';
            app.RailsensorNPNCheckBox.Position = [53 10 111 22];

            % Create CommutationPanel
            app.CommutationPanel = uipanel(app.MotionTab);
            app.CommutationPanel.Title = 'Commutation';
            app.CommutationPanel.Position = [26 84 269 146];

            % Create SecEditFieldLabel
            app.SecEditFieldLabel = uilabel(app.CommutationPanel);
            app.SecEditFieldLabel.HorizontalAlignment = 'right';
            app.SecEditFieldLabel.Position = [112 6 26 22];
            app.SecEditFieldLabel.Text = 'Sec';

            % Create SecEditField
            app.SecEditField = uieditfield(app.CommutationPanel, 'numeric');
            app.SecEditField.Position = [153 6 51 22];

            % Create CodeEditFieldLabel
            app.CodeEditFieldLabel = uilabel(app.CommutationPanel);
            app.CodeEditFieldLabel.HorizontalAlignment = 'right';
            app.CodeEditFieldLabel.Position = [5 6 34 22];
            app.CodeEditFieldLabel.Text = 'Code';

            % Create CodeEditField
            app.CodeEditField = uieditfield(app.CommutationPanel, 'numeric');
            app.CodeEditField.Position = [54 6 51 22];

            % Create ALampLabel
            app.ALampLabel = uilabel(app.CommutationPanel);
            app.ALampLabel.HorizontalAlignment = 'right';
            app.ALampLabel.Position = [4 37 25 22];
            app.ALampLabel.Text = 'A';

            % Create ALamp
            app.ALamp = uilamp(app.CommutationPanel);
            app.ALamp.Position = [44 37 20 20];

            % Create BLampLabel
            app.BLampLabel = uilabel(app.CommutationPanel);
            app.BLampLabel.HorizontalAlignment = 'right';
            app.BLampLabel.Position = [72 36 25 22];
            app.BLampLabel.Text = 'B';

            % Create BLamp
            app.BLamp = uilamp(app.CommutationPanel);
            app.BLamp.Position = [112 36 20 20];

            % Create CLampLabel
            app.CLampLabel = uilabel(app.CommutationPanel);
            app.CLampLabel.HorizontalAlignment = 'right';
            app.CLampLabel.Position = [141 37 25 22];
            app.CLampLabel.Text = 'C';

            % Create CLamp
            app.CLamp = uilamp(app.CommutationPanel);
            app.CLamp.Position = [181 37 20 20];

            % Create HallsLabel
            app.HallsLabel = uilabel(app.CommutationPanel);
            app.HallsLabel.FontSize = 14;
            app.HallsLabel.FontWeight = 'bold';
            app.HallsLabel.Position = [15 62 39 22];
            app.HallsLabel.Text = 'Halls';

            % Create OkLampLabel
            app.OkLampLabel = uilabel(app.CommutationPanel);
            app.OkLampLabel.HorizontalAlignment = 'right';
            app.OkLampLabel.Position = [8 88 25 22];
            app.OkLampLabel.Text = 'Ok';

            % Create OkLamp
            app.OkLamp = uilamp(app.CommutationPanel);
            app.OkLamp.Position = [48 88 20 20];

            % Create CommangleEditFieldLabel
            app.CommangleEditFieldLabel = uilabel(app.CommutationPanel);
            app.CommangleEditFieldLabel.HorizontalAlignment = 'right';
            app.CommangleEditFieldLabel.Position = [77 86 73 22];
            app.CommangleEditFieldLabel.Text = 'Comm angle';

            % Create CommangleEditField
            app.CommangleEditField = uieditfield(app.CommutationPanel, 'numeric');
            app.CommangleEditField.Position = [165 86 100 22];

            % Create ElectangleEditFieldLabel
            app.ElectangleEditFieldLabel = uilabel(app.CommutationPanel);
            app.ElectangleEditFieldLabel.HorizontalAlignment = 'right';
            app.ElectangleEditFieldLabel.Position = [86 65 64 22];
            app.ElectangleEditFieldLabel.Text = 'Elect angle';

            % Create ElectangleEditField
            app.ElectangleEditField = uieditfield(app.CommutationPanel, 'numeric');
            app.ElectangleEditField.Position = [165 65 100 22];

            % Create ATPPanel
            app.ATPPanel = uipanel(app.MotionTab);
            app.ATPPanel.Title = 'ATP';
            app.ATPPanel.Position = [327 10 429 222];

            % Create TestencodersandHallsButton
            app.TestencodersandHallsButton = uibutton(app.ATPPanel, 'push');
            app.TestencodersandHallsButton.ButtonPushedFcn = createCallbackFcn(app, @TestencodersandHallsButtonPushed, true);
            app.TestencodersandHallsButton.Position = [24 99 143 24];
            app.TestencodersandHallsButton.Text = 'Test encoders and Halls';

            % Create GotonextstepButton
            app.GotonextstepButton = uibutton(app.ATPPanel, 'push');
            app.GotonextstepButton.ButtonPushedFcn = createCallbackFcn(app, @GotonextstepButtonPushed, true);
            app.GotonextstepButton.BackgroundColor = [0.9294 0.6941 0.1255];
            app.GotonextstepButton.FontSize = 14;
            app.GotonextstepButton.Position = [16 10 110 26];
            app.GotonextstepButton.Text = 'Go to next step';

            % Create AborttestButton
            app.AborttestButton = uibutton(app.ATPPanel, 'push');
            app.AborttestButton.FontSize = 14;
            app.AborttestButton.Position = [145 9 114 26];
            app.AborttestButton.Text = 'Abort test';

            % Create TestcurrentloopButton
            app.TestcurrentloopButton = uibutton(app.ATPPanel, 'push');
            app.TestcurrentloopButton.ButtonPushedFcn = createCallbackFcn(app, @TestcurrentloopButtonPushed, true);
            app.TestcurrentloopButton.Position = [24 167 143 24];
            app.TestcurrentloopButton.Text = 'Test current loop';

            % Create TestcurrentscalesButton
            app.TestcurrentscalesButton = uibutton(app.ATPPanel, 'push');
            app.TestcurrentscalesButton.ButtonPushedFcn = createCallbackFcn(app, @TestcurrentscalesButtonPushed, true);
            app.TestcurrentscalesButton.Position = [25 133 143 24];
            app.TestcurrentscalesButton.Text = 'Test current scales ';

            % Create TextAreaAtpResult
            app.TextAreaAtpResult = uitextarea(app.ATPPanel);
            app.TextAreaAtpResult.Position = [203 48 220 124];

            % Create ATPresultsLabel
            app.ATPresultsLabel = uilabel(app.ATPPanel);
            app.ATPresultsLabel.Position = [204 171 66 22];
            app.ATPresultsLabel.Text = 'ATP results';

            % Create TestPositionButton
            app.TestPositionButton = uibutton(app.ATPPanel, 'push');
            app.TestPositionButton.ButtonPushedFcn = createCallbackFcn(app, @TestPositionButtonPushed, true);
            app.TestPositionButton.Position = [25 65 142 23];
            app.TestPositionButton.Text = 'Test Position';

            % Create SystemModeDropDownLabel
            app.SystemModeDropDownLabel = uilabel(app.MotionTab);
            app.SystemModeDropDownLabel.HorizontalAlignment = 'right';
            app.SystemModeDropDownLabel.Position = [5 22 75 22];
            app.SystemModeDropDownLabel.Text = 'SystemMode';

            % Create SystemModeDropDown
            app.SystemModeDropDown = uidropdown(app.MotionTab);
            app.SystemModeDropDown.ValueChangedFcn = createCallbackFcn(app, @SystemModeDropDownValueChanged, true);
            app.SystemModeDropDown.Position = [95 22 204 22];

            % Create HomeSWPanel
            app.HomeSWPanel = uipanel(app.MotionTab);
            app.HomeSWPanel.Title = 'Home & SW';
            app.HomeSWPanel.Position = [571 238 178 214];

            % Create HomeButton
            app.HomeButton = uibutton(app.HomeSWPanel, 'push');
            app.HomeButton.ButtonPushedFcn = createCallbackFcn(app, @HomeButtonPushed, true);
            app.HomeButton.Position = [14 139 100 46];
            app.HomeButton.Text = 'Home';

            % Create Din1Lamp
            app.Din1Lamp = uilamp(app.HomeSWPanel);
            app.Din1Lamp.Position = [70 45 20 20];
            app.Din1Lamp.Color = [0.9412 0.9412 0.9412];

            % Create DIN1Label
            app.DIN1Label = uilabel(app.HomeSWPanel);
            app.DIN1Label.Position = [20 44 36 22];
            app.DIN1Label.Text = 'DIN 1';

            % Create DIN2Label
            app.DIN2Label = uilabel(app.HomeSWPanel);
            app.DIN2Label.Position = [20 17 36 22];
            app.DIN2Label.Text = 'DIN 2';

            % Create Din2Lamp
            app.Din2Lamp = uilamp(app.HomeSWPanel);
            app.Din2Lamp.Position = [70 18 20 20];

            % Create PositivedirectionCheckBox
            app.PositivedirectionCheckBox = uicheckbox(app.HomeSWPanel);
            app.PositivedirectionCheckBox.ValueChangedFcn = createCallbackFcn(app, @PositivedirectionCheckBoxValueChanged, true);
            app.PositivedirectionCheckBox.Text = 'Positive direction';
            app.PositivedirectionCheckBox.Position = [14 115 113 22];

            % Create HomepositionEditFieldLabel
            app.HomepositionEditFieldLabel = uilabel(app.HomeSWPanel);
            app.HomepositionEditFieldLabel.HorizontalAlignment = 'right';
            app.HomepositionEditFieldLabel.Position = [10 93 82 22];
            app.HomepositionEditFieldLabel.Text = 'Home position';

            % Create HomepositionEditField
            app.HomepositionEditField = uieditfield(app.HomeSWPanel, 'numeric');
            app.HomepositionEditField.Position = [15 71 100 22];

            % Create CalibrateTab
            app.CalibrateTab = uitab(app.TabGroup);
            app.CalibrateTab.Title = 'Calibrate';
            app.CalibrateTab.ButtonDownFcn = createCallbackFcn(app, @CalibrateTabButtonDown, true);

            % Create CalibrationdataPanel
            app.CalibrationdataPanel = uipanel(app.CalibrateTab);
            app.CalibrationdataPanel.Title = 'Calibration data ';
            app.CalibrationdataPanel.Position = [13 385 286 79];

            % Create CalibexistsCheckBox
            app.CalibexistsCheckBox = uicheckbox(app.CalibrationdataPanel);
            app.CalibexistsCheckBox.Text = 'Calib exists';
            app.CalibexistsCheckBox.Position = [198 17 83 22];

            % Create CalibIDEditFieldLabel
            app.CalibIDEditFieldLabel = uilabel(app.CalibrationdataPanel);
            app.CalibIDEditFieldLabel.HorizontalAlignment = 'right';
            app.CalibIDEditFieldLabel.Position = [19 1 48 22];
            app.CalibIDEditFieldLabel.Text = 'Calib ID';

            % Create CalibIDEditField
            app.CalibIDEditField = uieditfield(app.CalibrationdataPanel, 'numeric');
            app.CalibIDEditField.ValueDisplayFormat = '%d';
            app.CalibIDEditField.Position = [82 1 100 22];

            % Create CalibdateEditFieldLabel
            app.CalibdateEditFieldLabel = uilabel(app.CalibrationdataPanel);
            app.CalibdateEditFieldLabel.HorizontalAlignment = 'right';
            app.CalibdateEditFieldLabel.Position = [7 33 59 22];
            app.CalibdateEditFieldLabel.Text = 'Calib date';

            % Create CalibdateEditField
            app.CalibdateEditField = uieditfield(app.CalibrationdataPanel, 'numeric');
            app.CalibdateEditField.ValueDisplayFormat = '%d';
            app.CalibdateEditField.Position = [81 33 100 22];

            % Create ResetCalibButton
            app.ResetCalibButton = uibutton(app.CalibrateTab, 'push');
            app.ResetCalibButton.ButtonPushedFcn = createCallbackFcn(app, @ResetCalibButtonPushed, true);
            app.ResetCalibButton.Tooltip = {'Reset the calibration parameters to zero and store in flash '};
            app.ResetCalibButton.Position = [328 441 100 23];
            app.ResetCalibButton.Text = 'ResetCalib';

            % Create AnalogsPanel_2
            app.AnalogsPanel_2 = uipanel(app.CalibrateTab);
            app.AnalogsPanel_2.Title = 'Analogs';
            app.AnalogsPanel_2.Position = [12 27 423 221];

            % Create AcurrentEditFieldLabel
            app.AcurrentEditFieldLabel = uilabel(app.AnalogsPanel_2);
            app.AcurrentEditFieldLabel.HorizontalAlignment = 'right';
            app.AcurrentEditFieldLabel.Position = [20 171 53 22];
            app.AcurrentEditFieldLabel.Text = 'A current';

            % Create AcurrentEditField
            app.AcurrentEditField = uieditfield(app.AnalogsPanel_2, 'numeric');
            app.AcurrentEditField.Position = [88 171 100 22];

            % Create BcurrentEditFieldLabel
            app.BcurrentEditFieldLabel = uilabel(app.AnalogsPanel_2);
            app.BcurrentEditFieldLabel.HorizontalAlignment = 'right';
            app.BcurrentEditFieldLabel.Position = [19 138 54 22];
            app.BcurrentEditFieldLabel.Text = 'B current';

            % Create BcurrentEditField
            app.BcurrentEditField = uieditfield(app.AnalogsPanel_2, 'numeric');
            app.BcurrentEditField.Position = [88 138 100 22];

            % Create CcurrentEditFieldLabel
            app.CcurrentEditFieldLabel = uilabel(app.AnalogsPanel_2);
            app.CcurrentEditFieldLabel.HorizontalAlignment = 'right';
            app.CcurrentEditFieldLabel.Position = [19 103 55 22];
            app.CcurrentEditFieldLabel.Text = 'C current';

            % Create CcurrentEditField
            app.CcurrentEditField = uieditfield(app.AnalogsPanel_2, 'numeric');
            app.CcurrentEditField.Position = [89 103 100 22];

            % Create AAdcRawEditFieldLabel
            app.AAdcRawEditFieldLabel = uilabel(app.AnalogsPanel_2);
            app.AAdcRawEditFieldLabel.HorizontalAlignment = 'right';
            app.AAdcRawEditFieldLabel.Position = [202 171 63 22];
            app.AAdcRawEditFieldLabel.Text = 'A Adc Raw';

            % Create AAdcRawEditField
            app.AAdcRawEditField = uieditfield(app.AnalogsPanel_2, 'numeric');
            app.AAdcRawEditField.Position = [280 171 100 22];

            % Create BAdcRawEditFieldLabel
            app.BAdcRawEditFieldLabel = uilabel(app.AnalogsPanel_2);
            app.BAdcRawEditFieldLabel.HorizontalAlignment = 'right';
            app.BAdcRawEditFieldLabel.Position = [202 138 63 22];
            app.BAdcRawEditFieldLabel.Text = 'B Adc Raw';

            % Create BAdcRawEditField
            app.BAdcRawEditField = uieditfield(app.AnalogsPanel_2, 'numeric');
            app.BAdcRawEditField.Position = [280 138 100 22];

            % Create CAdcRawEditFieldLabel
            app.CAdcRawEditFieldLabel = uilabel(app.AnalogsPanel_2);
            app.CAdcRawEditFieldLabel.HorizontalAlignment = 'right';
            app.CAdcRawEditFieldLabel.Position = [202 103 64 22];
            app.CAdcRawEditFieldLabel.Text = 'C Adc Raw';

            % Create CAdcRawEditField
            app.CAdcRawEditField = uieditfield(app.AnalogsPanel_2, 'numeric');
            app.CAdcRawEditField.Position = [281 103 100 22];

            % Create HallsExperimentButton
            app.HallsExperimentButton = uibutton(app.CalibrateTab, 'push');
            app.HallsExperimentButton.Tooltip = {'Reset the calibration parameters to zero and store in flash '};
            app.HallsExperimentButton.Position = [457 76 125 23];
            app.HallsExperimentButton.Text = 'Halls Experiment';

            % Create CalibphasecurrentsButton
            app.CalibphasecurrentsButton = uibutton(app.CalibrateTab, 'push');
            app.CalibphasecurrentsButton.ButtonPushedFcn = createCallbackFcn(app, @CalibphasecurrentsButtonPushed, true);
            app.CalibphasecurrentsButton.Tooltip = {'Reset the calibration parameters to zero and store in flash '};
            app.CalibphasecurrentsButton.Position = [452 119 125 23];
            app.CalibphasecurrentsButton.Text = 'Calib phase currents';

            % Create MotorcurrentsButton
            app.MotorcurrentsButton = uibutton(app.CalibrateTab, 'push');
            app.MotorcurrentsButton.ButtonPushedFcn = createCallbackFcn(app, @MotorcurrentsButtonPushed, true);
            app.MotorcurrentsButton.Position = [610 441 100 23];
            app.MotorcurrentsButton.Text = 'Motor currents';

            % Create CommutationButton
            app.CommutationButton = uibutton(app.CalibrateTab, 'push');
            app.CommutationButton.ButtonPushedFcn = createCallbackFcn(app, @CommutationButtonPushed, true);
            app.CommutationButton.Position = [609 406 100 23];
            app.CommutationButton.Text = 'Commutation';

            % Create TextArea
            app.TextArea = uitextarea(app.CalibrateTab);
            app.TextArea.Position = [600 310 150 82];
            app.TextArea.Value = {'Its better to run these experiments with the WheelDrv closed: run'; 'CurrentCalibExp'; 'CommutationExp. '};

            % Create TextArea_2
            app.TextArea_2 = uitextarea(app.CalibrateTab);
            app.TextArea_2.Position = [600 214 150 77];
            app.TextArea_2.Value = {'Use PlantIdentification.m'; 'for frequency response of mechanics'; 'LoopDes (.mlapp) '; 'for control design '};

            % Create PotentiometercalibrationPanel
            app.PotentiometercalibrationPanel = uipanel(app.CalibrateTab);
            app.PotentiometercalibrationPanel.Title = 'Potentiometer calibration';
            app.PotentiometercalibrationPanel.Position = [15 250 419 132];

            % Create CalibrateplaterotatorButton
            app.CalibrateplaterotatorButton = uibutton(app.PotentiometercalibrationPanel, 'push');
            app.CalibrateplaterotatorButton.ButtonPushedFcn = createCallbackFcn(app, @CalibrateplaterotatorButtonPushed, true);
            app.CalibrateplaterotatorButton.BackgroundColor = [0.302 0.7451 0.9333];
            app.CalibrateplaterotatorButton.FontSize = 14;
            app.CalibrateplaterotatorButton.FontWeight = 'bold';
            app.CalibrateplaterotatorButton.Position = [13 43 185 60];
            app.CalibrateplaterotatorButton.Text = 'Calibrate plate rotator';

            % Create StepsizeDegEditFieldLabel
            app.StepsizeDegEditFieldLabel = uilabel(app.PotentiometercalibrationPanel);
            app.StepsizeDegEditFieldLabel.HorizontalAlignment = 'right';
            app.StepsizeDegEditFieldLabel.Position = [208 51 79 22];
            app.StepsizeDegEditFieldLabel.Text = 'Step size Deg';

            % Create StepsizeDegEditField
            app.StepsizeDegEditField = uieditfield(app.PotentiometercalibrationPanel, 'numeric');
            app.StepsizeDegEditField.Limits = [-45 45];
            app.StepsizeDegEditField.Position = [302 51 88 22];

            % Create NextButton
            app.NextButton = uibutton(app.PotentiometercalibrationPanel, 'push');
            app.NextButton.ButtonPushedFcn = createCallbackFcn(app, @NextButtonPushed, true);
            app.NextButton.BackgroundColor = [0.9294 0.6941 0.1255];
            app.NextButton.FontSize = 14;
            app.NextButton.FontAngle = 'italic';
            app.NextButton.Position = [24 6 163 26];
            app.NextButton.Text = 'Next';

            % Create SteerUpButton
            app.SteerUpButton = uibutton(app.PotentiometercalibrationPanel, 'push');
            app.SteerUpButton.ButtonPushedFcn = createCallbackFcn(app, @SteerUpButtonPushed, true);
            app.SteerUpButton.Position = [333 81 59 23];
            app.SteerUpButton.Text = 'SteerUp';

            % Create SteerDnButton
            app.SteerDnButton = uibutton(app.PotentiometercalibrationPanel, 'push');
            app.SteerDnButton.ButtonPushedFcn = createCallbackFcn(app, @SteerDnButtonPushed, true);
            app.SteerDnButton.Position = [269 81 59 23];
            app.SteerDnButton.Text = 'SteerDn';

            % Create AbortCalibButton
            app.AbortCalibButton = uibutton(app.PotentiometercalibrationPanel, 'push');
            app.AbortCalibButton.ButtonPushedFcn = createCallbackFcn(app, @AbortCalibButtonPushed, true);
            app.AbortCalibButton.BackgroundColor = [0.9294 0.6941 0.1255];
            app.AbortCalibButton.FontSize = 14;
            app.AbortCalibButton.FontAngle = 'italic';
            app.AbortCalibButton.Position = [225 6 163 26];
            app.AbortCalibButton.Text = 'AbortCalib';

            % Create ParametersTab
            app.ParametersTab = uitab(app.TabGroup);
            app.ParametersTab.Title = 'Parameters';
            app.ParametersTab.ButtonDownFcn = createCallbackFcn(app, @ParametersTabButtonDown, true);

            % Create ParTable
            app.ParTable = uitable(app.ParametersTab);
            app.ParTable.ColumnName = {'''1'''; '''2'''; '''3'''; '''4'''; '''5'''; '''6'''};
            app.ParTable.RowName = {};
            app.ParTable.CellEditCallback = createCallbackFcn(app, @ParTableCellEdit, true);
            app.ParTable.DisplayDataChangedFcn = createCallbackFcn(app, @ParTableDisplayDataChanged, true);
            app.ParTable.Position = [31 44 718 369];

            % Create LoadExcelButton
            app.LoadExcelButton = uibutton(app.ParametersTab, 'push');
            app.LoadExcelButton.Position = [37 434 100 23];
            app.LoadExcelButton.Text = 'Load Excel';

            % Create SaveExcelButton
            app.SaveExcelButton = uibutton(app.ParametersTab, 'push');
            app.SaveExcelButton.ButtonPushedFcn = createCallbackFcn(app, @SaveExcelButtonPushed, true);
            app.SaveExcelButton.Position = [171 434 100 23];
            app.SaveExcelButton.Text = 'Save Excel';

            % Create Download2driveButton
            app.Download2driveButton = uibutton(app.ParametersTab, 'push');
            app.Download2driveButton.ButtonPushedFcn = createCallbackFcn(app, @Download2driveButtonPushed, true);
            app.Download2driveButton.Position = [298 434 108 23];
            app.Download2driveButton.Text = 'Download 2 drive';

            % Create SheetsDropDownLabel
            app.SheetsDropDownLabel = uilabel(app.ParametersTab);
            app.SheetsDropDownLabel.HorizontalAlignment = 'right';
            app.SheetsDropDownLabel.Position = [428 434 43 22];
            app.SheetsDropDownLabel.Text = 'Sheets';

            % Create SheetsDropDown
            app.SheetsDropDown = uidropdown(app.ParametersTab);
            app.SheetsDropDown.Position = [486 434 100 22];

            % Create SigGenTab
            app.SigGenTab = uitab(app.TabGroup);
            app.SigGenTab.Title = 'SigGen';
            app.SigGenTab.ButtonDownFcn = createCallbackFcn(app, @SigGenTabButtonDown, true);

            % Create MainreferenceGPanel
            app.MainreferenceGPanel = uipanel(app.SigGenTab);
            app.MainreferenceGPanel.Title = 'Main reference (G)';
            app.MainreferenceGPanel.Position = [31 58 238 366];

            % Create MethodButtonGroup
            app.MethodButtonGroup = uibuttongroup(app.MainreferenceGPanel);
            app.MethodButtonGroup.SelectionChangedFcn = createCallbackFcn(app, @MethodButtonGroupSelectionChanged, true);
            app.MethodButtonGroup.Title = 'Method';
            app.MethodButtonGroup.Position = [6 216 107 126];

            % Create FixedRefButton
            app.FixedRefButton = uiradiobutton(app.MethodButtonGroup);
            app.FixedRefButton.Text = 'Fixed';
            app.FixedRefButton.Position = [11 80 58 22];
            app.FixedRefButton.Value = true;

            % Create SineRefButton
            app.SineRefButton = uiradiobutton(app.MethodButtonGroup);
            app.SineRefButton.Text = 'Sine';
            app.SineRefButton.Position = [11 58 65 22];

            % Create SquareRefButton
            app.SquareRefButton = uiradiobutton(app.MethodButtonGroup);
            app.SquareRefButton.Text = 'Square';
            app.SquareRefButton.Position = [11 36 65 22];

            % Create TriangleRefButton
            app.TriangleRefButton = uiradiobutton(app.MethodButtonGroup);
            app.TriangleRefButton.Text = 'Triangle';
            app.TriangleRefButton.Position = [11 12 65 22];

            % Create DCEditFieldLabel
            app.DCEditFieldLabel = uilabel(app.MainreferenceGPanel);
            app.DCEditFieldLabel.HorizontalAlignment = 'right';
            app.DCEditFieldLabel.Position = [65 172 25 22];
            app.DCEditFieldLabel.Text = 'DC';

            % Create DCEditField
            app.DCEditField = uieditfield(app.MainreferenceGPanel, 'numeric');
            app.DCEditField.ValueChangedFcn = createCallbackFcn(app, @DCEditFieldValueChanged, true);
            app.DCEditField.Position = [105 172 100 22];

            % Create AmplitudeEditFieldLabel
            app.AmplitudeEditFieldLabel = uilabel(app.MainreferenceGPanel);
            app.AmplitudeEditFieldLabel.HorizontalAlignment = 'right';
            app.AmplitudeEditFieldLabel.Position = [31 142 59 22];
            app.AmplitudeEditFieldLabel.Text = 'Amplitude';

            % Create AmplitudeEditField
            app.AmplitudeEditField = uieditfield(app.MainreferenceGPanel, 'numeric');
            app.AmplitudeEditField.ValueChangedFcn = createCallbackFcn(app, @AmplitudeEditFieldValueChanged, true);
            app.AmplitudeEditField.Position = [104 142 100 22];

            % Create FrequencyEditFieldLabel
            app.FrequencyEditFieldLabel = uilabel(app.MainreferenceGPanel);
            app.FrequencyEditFieldLabel.HorizontalAlignment = 'right';
            app.FrequencyEditFieldLabel.Position = [27 113 62 22];
            app.FrequencyEditFieldLabel.Text = 'Frequency';

            % Create FrequencyEditField
            app.FrequencyEditField = uieditfield(app.MainreferenceGPanel, 'numeric');
            app.FrequencyEditField.ValueChangedFcn = createCallbackFcn(app, @FrequencyEditFieldValueChanged, true);
            app.FrequencyEditField.Position = [104 113 100 22];

            % Create FrequencyEditField_2Label_2
            app.FrequencyEditField_2Label_2 = uilabel(app.MainreferenceGPanel);
            app.FrequencyEditField_2Label_2.HorizontalAlignment = 'right';
            app.FrequencyEditField_2Label_2.Position = [58 78 30 22];
            app.FrequencyEditField_2Label_2.Text = 'Duty';

            % Create DutyEditField
            app.DutyEditField = uieditfield(app.MainreferenceGPanel, 'numeric');
            app.DutyEditField.ValueChangedFcn = createCallbackFcn(app, @DutyEditFieldValueChanged, true);
            app.DutyEditField.Position = [103 78 100 22];

            % Create AnglePeriodEditFieldLabel
            app.AnglePeriodEditFieldLabel = uilabel(app.MainreferenceGPanel);
            app.AnglePeriodEditFieldLabel.HorizontalAlignment = 'right';
            app.AnglePeriodEditFieldLabel.Position = [17 44 71 22];
            app.AnglePeriodEditFieldLabel.Text = 'AnglePeriod';

            % Create AnglePeriodEditField
            app.AnglePeriodEditField = uieditfield(app.MainreferenceGPanel, 'numeric');
            app.AnglePeriodEditField.ValueChangedFcn = createCallbackFcn(app, @AnglePeriodEditFieldValueChanged, true);
            app.AnglePeriodEditField.Position = [103 44 100 22];

            % Create SpeedCheckBox
            app.SpeedCheckBox = uicheckbox(app.MainreferenceGPanel);
            app.SpeedCheckBox.ValueChangedFcn = createCallbackFcn(app, @SpeedCheckBoxValueChanged, true);
            app.SpeedCheckBox.Text = 'Speed';
            app.SpeedCheckBox.Position = [101 11 57 22];

            % Create TorquereferenceTPanel
            app.TorquereferenceTPanel = uipanel(app.SigGenTab);
            app.TorquereferenceTPanel.Title = 'Torque reference (T)';
            app.TorquereferenceTPanel.Position = [285 131 222 288];

            % Create TMethodButtonGroup
            app.TMethodButtonGroup = uibuttongroup(app.TorquereferenceTPanel);
            app.TMethodButtonGroup.SelectionChangedFcn = createCallbackFcn(app, @TMethodButtonGroupSelectionChanged, true);
            app.TMethodButtonGroup.Title = 'Method';
            app.TMethodButtonGroup.Position = [10 138 107 125];

            % Create FixedTorqueButton
            app.FixedTorqueButton = uiradiobutton(app.TMethodButtonGroup);
            app.FixedTorqueButton.Text = 'Fixed';
            app.FixedTorqueButton.Position = [11 79 58 22];
            app.FixedTorqueButton.Value = true;

            % Create SineTorqueButton
            app.SineTorqueButton = uiradiobutton(app.TMethodButtonGroup);
            app.SineTorqueButton.Text = 'Sine';
            app.SineTorqueButton.Position = [11 57 65 22];

            % Create SquareTorqueButton
            app.SquareTorqueButton = uiradiobutton(app.TMethodButtonGroup);
            app.SquareTorqueButton.Text = 'Square';
            app.SquareTorqueButton.Position = [11 33 65 22];

            % Create TriangleTorqueButton
            app.TriangleTorqueButton = uiradiobutton(app.TMethodButtonGroup);
            app.TriangleTorqueButton.Text = 'Triangle';
            app.TriangleTorqueButton.Position = [12 10 65 22];

            % Create DCEditField_2Label
            app.DCEditField_2Label = uilabel(app.TorquereferenceTPanel);
            app.DCEditField_2Label.HorizontalAlignment = 'right';
            app.DCEditField_2Label.Position = [53 95 25 22];
            app.DCEditField_2Label.Text = 'DC';

            % Create TDCEditField
            app.TDCEditField = uieditfield(app.TorquereferenceTPanel, 'numeric');
            app.TDCEditField.ValueChangedFcn = createCallbackFcn(app, @TDCEditFieldValueChanged, true);
            app.TDCEditField.Position = [93 95 100 22];

            % Create FrequencyEditField_2Label
            app.FrequencyEditField_2Label = uilabel(app.TorquereferenceTPanel);
            app.FrequencyEditField_2Label.HorizontalAlignment = 'right';
            app.FrequencyEditField_2Label.Position = [13 35 62 22];
            app.FrequencyEditField_2Label.Text = 'Frequency';

            % Create TFrequencyEditField
            app.TFrequencyEditField = uieditfield(app.TorquereferenceTPanel, 'numeric');
            app.TFrequencyEditField.ValueChangedFcn = createCallbackFcn(app, @TFrequencyEditFieldValueChanged, true);
            app.TFrequencyEditField.Position = [93 35 100 22];

            % Create AmplitudeEditField_2Label
            app.AmplitudeEditField_2Label = uilabel(app.TorquereferenceTPanel);
            app.AmplitudeEditField_2Label.HorizontalAlignment = 'right';
            app.AmplitudeEditField_2Label.Position = [19 64 59 22];
            app.AmplitudeEditField_2Label.Text = 'Amplitude';

            % Create TAmplitudeEditField
            app.TAmplitudeEditField = uieditfield(app.TorquereferenceTPanel, 'numeric');
            app.TAmplitudeEditField.ValueChangedFcn = createCallbackFcn(app, @TAmplitudeEditFieldValueChanged, true);
            app.TAmplitudeEditField.Position = [93 64 100 22];

            % Create DutyEditField_2Label
            app.DutyEditField_2Label = uilabel(app.TorquereferenceTPanel);
            app.DutyEditField_2Label.HorizontalAlignment = 'right';
            app.DutyEditField_2Label.Position = [48 5 30 22];
            app.DutyEditField_2Label.Text = 'Duty';

            % Create TDutyEditField
            app.TDutyEditField = uieditfield(app.TorquereferenceTPanel, 'numeric');
            app.TDutyEditField.ValueChangedFcn = createCallbackFcn(app, @TDutyEditFieldValueChanged, true);
            app.TDutyEditField.Position = [93 5 100 22];

            % Create Label
            app.Label = uilabel(app.SigGenTab);
            app.Label.WordWrap = 'on';
            app.Label.Position = [35 424 519 56];
            app.Label.Text = 'In voltage mode T is voltage in %,  G is angle. In torque mode only T applies, in open loop T is torque and G is angle. In speed mode G is speed and T is feed forward current';

            % Create CurrentLoopTab
            app.CurrentLoopTab = uitab(app.TabGroup);
            app.CurrentLoopTab.Title = 'CurrentLoop';
            app.CurrentLoopTab.ButtonDownFcn = createCallbackFcn(app, @CurrentLoopTabButtonDown, true);

            % Create UIAxesCurrent
            app.UIAxesCurrent = uiaxes(app.CurrentLoopTab);
            title(app.UIAxesCurrent, 'Current')
            xlabel(app.UIAxesCurrent, 'X')
            ylabel(app.UIAxesCurrent, 'Y')
            zlabel(app.UIAxesCurrent, 'Z')
            app.UIAxesCurrent.XGrid = 'on';
            app.UIAxesCurrent.YGrid = 'on';
            app.UIAxesCurrent.Position = [31 191 718 163];

            % Create UIAxesVoltage
            app.UIAxesVoltage = uiaxes(app.CurrentLoopTab);
            title(app.UIAxesVoltage, 'Voltage')
            xlabel(app.UIAxesVoltage, 'X')
            ylabel(app.UIAxesVoltage, 'Y')
            zlabel(app.UIAxesVoltage, 'Z')
            app.UIAxesVoltage.XGrid = 'on';
            app.UIAxesVoltage.YGrid = 'on';
            app.UIAxesVoltage.Position = [34 19 715 163];

            % Create PrefilterBWHzEditFieldLabel
            app.PrefilterBWHzEditFieldLabel = uilabel(app.CurrentLoopTab);
            app.PrefilterBWHzEditFieldLabel.HorizontalAlignment = 'right';
            app.PrefilterBWHzEditFieldLabel.Position = [39 428 87 22];
            app.PrefilterBWHzEditFieldLabel.Text = 'Prefilter BW Hz';

            % Create PrefilterBWHzEditField
            app.PrefilterBWHzEditField = uieditfield(app.CurrentLoopTab, 'numeric');
            app.PrefilterBWHzEditField.ValueChangedFcn = createCallbackFcn(app, @PrefilterBWHzEditFieldValueChanged, true);
            app.PrefilterBWHzEditField.Position = [141 428 100 22];

            % Create SlopelimitAmsecEditFieldLabel
            app.SlopelimitAmsecEditFieldLabel = uilabel(app.CurrentLoopTab);
            app.SlopelimitAmsecEditFieldLabel.HorizontalAlignment = 'right';
            app.SlopelimitAmsecEditFieldLabel.Position = [23 397 103 22];
            app.SlopelimitAmsecEditFieldLabel.Text = 'Slope limit A/msec';

            % Create SlopelimitAmsecEditField
            app.SlopelimitAmsecEditField = uieditfield(app.CurrentLoopTab, 'numeric');
            app.SlopelimitAmsecEditField.ValueChangedFcn = createCallbackFcn(app, @SlopelimitAmsecEditFieldValueChanged, true);
            app.SlopelimitAmsecEditField.Position = [141 397 100 22];

            % Create CurControllerKpEditFieldLabel
            app.CurControllerKpEditFieldLabel = uilabel(app.CurrentLoopTab);
            app.CurControllerKpEditFieldLabel.HorizontalAlignment = 'right';
            app.CurControllerKpEditFieldLabel.Position = [259 434 98 22];
            app.CurControllerKpEditFieldLabel.Text = 'Cur Controller Kp';

            % Create CurControllerKpEditField
            app.CurControllerKpEditField = uieditfield(app.CurrentLoopTab, 'numeric');
            app.CurControllerKpEditField.ValueChangedFcn = createCallbackFcn(app, @CurControllerKpEditFieldValueChanged, true);
            app.CurControllerKpEditField.Position = [372 434 100 22];

            % Create CurControllerKiEditFieldLabel
            app.CurControllerKiEditFieldLabel = uilabel(app.CurrentLoopTab);
            app.CurControllerKiEditFieldLabel.HorizontalAlignment = 'right';
            app.CurControllerKiEditFieldLabel.Position = [264 402 94 22];
            app.CurControllerKiEditFieldLabel.Text = 'Cur Controller Ki';

            % Create CurControllerKiEditField
            app.CurControllerKiEditField = uieditfield(app.CurrentLoopTab, 'numeric');
            app.CurControllerKiEditField.ValueChangedFcn = createCallbackFcn(app, @CurControllerKiEditFieldValueChanged, true);
            app.CurControllerKiEditField.Position = [373 402 100 22];

            % Create InitRecorderButton
            app.InitRecorderButton = uibutton(app.CurrentLoopTab, 'push');
            app.InitRecorderButton.ButtonPushedFcn = createCallbackFcn(app, @InitRecorderButtonPushed, true);
            app.InitRecorderButton.Position = [497 433 100 23];
            app.InitRecorderButton.Text = 'Init Recorder';

            % Create KeVHzEditFieldLabel
            app.KeVHzEditFieldLabel = uilabel(app.CurrentLoopTab);
            app.KeVHzEditFieldLabel.HorizontalAlignment = 'right';
            app.KeVHzEditFieldLabel.Position = [76 366 49 22];
            app.KeVHzEditFieldLabel.Text = 'Ke V/Hz';

            % Create KeVHzEditField
            app.KeVHzEditField = uieditfield(app.CurrentLoopTab, 'numeric');
            app.KeVHzEditField.ValueChangedFcn = createCallbackFcn(app, @KeVHzEditFieldValueChanged, true);
            app.KeVHzEditField.Position = [140 366 100 22];

            % Create KillprefilterCheckBox
            app.KillprefilterCheckBox = uicheckbox(app.CurrentLoopTab);
            app.KillprefilterCheckBox.ValueChangedFcn = createCallbackFcn(app, @KillprefilterCheckBoxValueChanged, true);
            app.KillprefilterCheckBox.Text = 'Kill prefilter';
            app.KillprefilterCheckBox.Position = [143 455 81 22];

            % Create BringrecorderButton
            app.BringrecorderButton = uibutton(app.CurrentLoopTab, 'push');
            app.BringrecorderButton.ButtonPushedFcn = createCallbackFcn(app, @BringrecorderButtonPushed, true);
            app.BringrecorderButton.Position = [498 401 100 23];
            app.BringrecorderButton.Text = 'Bring recorder';

            % Create ConfigTab
            app.ConfigTab = uitab(app.TabGroup);
            app.ConfigTab.Title = 'Config';
            app.ConfigTab.ButtonDownFcn = createCallbackFcn(app, @ConfigTabButtonDown, true);

            % Create CfgTabEdit
            app.CfgTabEdit = uitable(app.ConfigTab);
            app.CfgTabEdit.ColumnName = {'Column 1'; 'Column 2'; 'Column 3'; 'Column 4'};
            app.CfgTabEdit.RowName = {};
            app.CfgTabEdit.CellEditCallback = createCallbackFcn(app, @CfgTabEditCellEdit, true);
            app.CfgTabEdit.Position = [32 22 717 397];

            % Create LoadCfgExcelButton
            app.LoadCfgExcelButton = uibutton(app.ConfigTab, 'push');
            app.LoadCfgExcelButton.ButtonPushedFcn = createCallbackFcn(app, @LoadCfgExcelButtonPushed, true);
            app.LoadCfgExcelButton.Position = [37 434 100 23];
            app.LoadCfgExcelButton.Text = 'Load Excel';

            % Create SaveCfgExcelButton
            app.SaveCfgExcelButton = uibutton(app.ConfigTab, 'push');
            app.SaveCfgExcelButton.ButtonPushedFcn = createCallbackFcn(app, @SaveCfgExcelButtonPushed, true);
            app.SaveCfgExcelButton.Position = [171 434 100 23];
            app.SaveCfgExcelButton.Text = 'Save Excel';

            % Create Download2driveButtonCfg
            app.Download2driveButtonCfg = uibutton(app.ConfigTab, 'push');
            app.Download2driveButtonCfg.ButtonPushedFcn = createCallbackFcn(app, @Download2driveButtonCfgPushed, true);
            app.Download2driveButtonCfg.Position = [298 434 108 23];
            app.Download2driveButtonCfg.Text = 'Download 2 drive';

            % Create SheetsDropDown_2Label
            app.SheetsDropDown_2Label = uilabel(app.ConfigTab);
            app.SheetsDropDown_2Label.HorizontalAlignment = 'right';
            app.SheetsDropDown_2Label.Position = [428 434 43 22];
            app.SheetsDropDown_2Label.Text = 'Sheets';

            % Create SheetsDropDownCfg
            app.SheetsDropDownCfg = uidropdown(app.ConfigTab);
            app.SheetsDropDownCfg.Position = [486 434 100 22];

            % Create SpeedLoopTab
            app.SpeedLoopTab = uitab(app.TabGroup);
            app.SpeedLoopTab.Title = 'SpeedLoop';
            app.SpeedLoopTab.ButtonDownFcn = createCallbackFcn(app, @SpeedLoopTabButtonDown, true);

            % Create UIAxes
            app.UIAxes = uiaxes(app.SpeedLoopTab);
            title(app.UIAxes, 'Speed')
            xlabel(app.UIAxes, 'Time')
            ylabel(app.UIAxes, 'Rev/Sec')
            zlabel(app.UIAxes, 'Z')
            app.UIAxes.Position = [23 201 717 185];

            % Create UIAxes2
            app.UIAxes2 = uiaxes(app.SpeedLoopTab);
            title(app.UIAxes2, 'Current')
            xlabel(app.UIAxes2, 'Time')
            ylabel(app.UIAxes2, 'Amps')
            zlabel(app.UIAxes2, 'Z')
            app.UIAxes2.Position = [20 16 720 185];

            % Create SpeedKpEditFieldLabel
            app.SpeedKpEditFieldLabel = uilabel(app.SpeedLoopTab);
            app.SpeedKpEditFieldLabel.HorizontalAlignment = 'right';
            app.SpeedKpEditFieldLabel.Position = [568 433 58 22];
            app.SpeedKpEditFieldLabel.Text = 'Speed Kp';

            % Create SpeedKpEditField
            app.SpeedKpEditField = uieditfield(app.SpeedLoopTab, 'numeric');
            app.SpeedKpEditField.ValueChangedFcn = createCallbackFcn(app, @SpeedKpEditFieldValueChanged, true);
            app.SpeedKpEditField.Position = [641 433 100 22];

            % Create SpeedKiEditFieldLabel
            app.SpeedKiEditFieldLabel = uilabel(app.SpeedLoopTab);
            app.SpeedKiEditFieldLabel.HorizontalAlignment = 'right';
            app.SpeedKiEditFieldLabel.Position = [571 403 54 22];
            app.SpeedKiEditFieldLabel.Text = 'Speed Ki';

            % Create SpeedKiEditField
            app.SpeedKiEditField = uieditfield(app.SpeedLoopTab, 'numeric');
            app.SpeedKiEditField.ValueChangedFcn = createCallbackFcn(app, @SpeedKiEditFieldValueChanged, true);
            app.SpeedKiEditField.Position = [640 403 100 22];

            % Create InitRecordButton
            app.InitRecordButton = uibutton(app.SpeedLoopTab, 'push');
            app.InitRecordButton.ButtonPushedFcn = createCallbackFcn(app, @InitRecordButtonPushed, true);
            app.InitRecordButton.Position = [27 455 100 23];
            app.InitRecordButton.Text = 'Init Record';

            % Create CurrentlimitEditFieldLabel
            app.CurrentlimitEditFieldLabel = uilabel(app.SpeedLoopTab);
            app.CurrentlimitEditFieldLabel.HorizontalAlignment = 'right';
            app.CurrentlimitEditFieldLabel.Position = [364 401 70 22];
            app.CurrentlimitEditFieldLabel.Text = 'Current limit';

            % Create CurrentlimitEditField
            app.CurrentlimitEditField = uieditfield(app.SpeedLoopTab, 'numeric');
            app.CurrentlimitEditField.ValueChangedFcn = createCallbackFcn(app, @CurrentlimitEditFieldValueChanged, true);
            app.CurrentlimitEditField.Position = [449 401 100 22];

            % Create Includefilter1CheckBox
            app.Includefilter1CheckBox = uicheckbox(app.SpeedLoopTab);
            app.Includefilter1CheckBox.ValueChangedFcn = createCallbackFcn(app, @Includefilter1CheckBoxValueChanged, true);
            app.Includefilter1CheckBox.Text = 'Include filter 1';
            app.Includefilter1CheckBox.Position = [502 455 97 22];

            % Create Includefilter2CheckBox
            app.Includefilter2CheckBox = uicheckbox(app.SpeedLoopTab);
            app.Includefilter2CheckBox.ValueChangedFcn = createCallbackFcn(app, @Includefilter2CheckBoxValueChanged, true);
            app.Includefilter2CheckBox.Text = 'Include filter 2';
            app.Includefilter2CheckBox.Position = [641 454 97 22];

            % Create AutotimeCheckBox
            app.AutotimeCheckBox = uicheckbox(app.SpeedLoopTab);
            app.AutotimeCheckBox.Text = 'Auto time';
            app.AutotimeCheckBox.Position = [388 454 73 22];

            % Create RecTimeEditFieldLabel
            app.RecTimeEditFieldLabel = uilabel(app.SpeedLoopTab);
            app.RecTimeEditFieldLabel.HorizontalAlignment = 'right';
            app.RecTimeEditFieldLabel.Position = [379 428 52 22];
            app.RecTimeEditFieldLabel.Text = 'RecTime';

            % Create RecTimeEditField
            app.RecTimeEditField = uieditfield(app.SpeedLoopTab, 'numeric');
            app.RecTimeEditField.Position = [446 428 100 22];

            % Create BringrecorderButton_2
            app.BringrecorderButton_2 = uibutton(app.SpeedLoopTab, 'push');
            app.BringrecorderButton_2.ButtonPushedFcn = createCallbackFcn(app, @BringrecorderButton_2Pushed, true);
            app.BringrecorderButton_2.Position = [26 428 100 23];
            app.BringrecorderButton_2.Text = 'Bring recorder';

            % Create TriggerPanel
            app.TriggerPanel = uipanel(app.SpeedLoopTab);
            app.TriggerPanel.Title = 'Trigger';
            app.TriggerPanel.Position = [132 403 227 73];

            % Create ValueEditFieldLabel
            app.ValueEditFieldLabel = uilabel(app.TriggerPanel);
            app.ValueEditFieldLabel.HorizontalAlignment = 'right';
            app.ValueEditFieldLabel.Position = [-2 4 35 22];
            app.ValueEditFieldLabel.Text = 'Value';

            % Create SpeedTriggerEditField
            app.SpeedTriggerEditField = uieditfield(app.TriggerPanel, 'numeric');
            app.SpeedTriggerEditField.Position = [48 4 73 22];

            % Create Label_2
            app.Label_2 = uilabel(app.TriggerPanel);
            app.Label_2.HorizontalAlignment = 'right';
            app.Label_2.Position = [130 4 25 22];
            app.Label_2.Text = '%';

            % Create EditTriggerPercent
            app.EditTriggerPercent = uieditfield(app.TriggerPanel, 'numeric');
            app.EditTriggerPercent.Limits = [1 99];
            app.EditTriggerPercent.RoundFractionalValues = 'on';
            app.EditTriggerPercent.ValueDisplayFormat = '%d';
            app.EditTriggerPercent.Position = [170 4 39 22];
            app.EditTriggerPercent.Value = 1;

            % Create DropDownSpeedTrigSignal
            app.DropDownSpeedTrigSignal = uidropdown(app.TriggerPanel);
            app.DropDownSpeedTrigSignal.Position = [121 28 100 22];

            % Create DropDownSpeedTrigType
            app.DropDownSpeedTrigType = uidropdown(app.TriggerPanel);
            app.DropDownSpeedTrigType.Position = [16 28 100 22];

            % Create PositionTab
            app.PositionTab = uitab(app.TabGroup);
            app.PositionTab.Title = 'Position';
            app.PositionTab.ButtonDownFcn = createCallbackFcn(app, @PositionTabButtonDown, true);
            app.PositionTab.Interruptible = 'off';

            % Create UIAxesPosL
            app.UIAxesPosL = uiaxes(app.PositionTab);
            title(app.UIAxesPosL, 'Title')
            xlabel(app.UIAxesPosL, 'X')
            ylabel(app.UIAxesPosL, 'Y')
            zlabel(app.UIAxesPosL, 'Z')
            app.UIAxesPosL.Position = [17 8 728 174];

            % Create UIAxesPosH
            app.UIAxesPosH = uiaxes(app.PositionTab);
            title(app.UIAxesPosH, 'Title')
            xlabel(app.UIAxesPosH, 'X')
            ylabel(app.UIAxesPosH, 'Y')
            zlabel(app.UIAxesPosH, 'Z')
            app.UIAxesPosH.Position = [21 187 728 165];

            % Create InitRecordButtonPos
            app.InitRecordButtonPos = uibutton(app.PositionTab, 'push');
            app.InitRecordButtonPos.ButtonPushedFcn = createCallbackFcn(app, @InitRecordButtonPosPushed, true);
            app.InitRecordButtonPos.Position = [34 455 100 23];
            app.InitRecordButtonPos.Text = 'Init Record';

            % Create AutotimeCheckBoxPos
            app.AutotimeCheckBoxPos = uicheckbox(app.PositionTab);
            app.AutotimeCheckBoxPos.Text = 'Auto time';
            app.AutotimeCheckBoxPos.Position = [32 381 73 22];

            % Create BringrecorderButtonPos
            app.BringrecorderButtonPos = uibutton(app.PositionTab, 'push');
            app.BringrecorderButtonPos.ButtonPushedFcn = createCallbackFcn(app, @BringrecorderButtonPosPushed, true);
            app.BringrecorderButtonPos.Position = [33 428 100 23];
            app.BringrecorderButtonPos.Text = 'Bring recorder';

            % Create TriggerPanel_2
            app.TriggerPanel_2 = uipanel(app.PositionTab);
            app.TriggerPanel_2.Title = 'Trigger';
            app.TriggerPanel_2.Position = [134 405 227 73];

            % Create ValueEditFieldLabel_2
            app.ValueEditFieldLabel_2 = uilabel(app.TriggerPanel_2);
            app.ValueEditFieldLabel_2.HorizontalAlignment = 'right';
            app.ValueEditFieldLabel_2.Position = [-2 4 35 22];
            app.ValueEditFieldLabel_2.Text = 'Value';

            % Create PosTriggerEditField
            app.PosTriggerEditField = uieditfield(app.TriggerPanel_2, 'numeric');
            app.PosTriggerEditField.Position = [48 4 73 22];

            % Create Label_3
            app.Label_3 = uilabel(app.TriggerPanel_2);
            app.Label_3.HorizontalAlignment = 'right';
            app.Label_3.Position = [130 4 25 22];
            app.Label_3.Text = '%';

            % Create EditPosTriggerPercent
            app.EditPosTriggerPercent = uieditfield(app.TriggerPanel_2, 'numeric');
            app.EditPosTriggerPercent.Limits = [1 99];
            app.EditPosTriggerPercent.RoundFractionalValues = 'on';
            app.EditPosTriggerPercent.ValueDisplayFormat = '%d';
            app.EditPosTriggerPercent.Position = [170 4 39 22];
            app.EditPosTriggerPercent.Value = 1;

            % Create DropDownPosTrigSignal
            app.DropDownPosTrigSignal = uidropdown(app.TriggerPanel_2);
            app.DropDownPosTrigSignal.Position = [121 28 100 22];

            % Create DropDownPosTrigType
            app.DropDownPosTrigType = uidropdown(app.TriggerPanel_2);
            app.DropDownPosTrigType.Position = [16 28 100 22];

            % Create CurrentlimitEditField_2Label
            app.CurrentlimitEditField_2Label = uilabel(app.PositionTab);
            app.CurrentlimitEditField_2Label.HorizontalAlignment = 'right';
            app.CurrentlimitEditField_2Label.Position = [580 387 70 22];
            app.CurrentlimitEditField_2Label.Text = 'Current limit';

            % Create CurrentlimitEditFieldPos
            app.CurrentlimitEditFieldPos = uieditfield(app.PositionTab, 'numeric');
            app.CurrentlimitEditFieldPos.ValueChangedFcn = createCallbackFcn(app, @CurrentlimitEditFieldPosValueChanged, true);
            app.CurrentlimitEditFieldPos.Position = [665 387 100 22];

            % Create SecEditField_2Label
            app.SecEditField_2Label = uilabel(app.PositionTab);
            app.SecEditField_2Label.HorizontalAlignment = 'right';
            app.SecEditField_2Label.Position = [8 401 26 22];
            app.SecEditField_2Label.Text = 'Sec';

            % Create PosRecTimeEditField
            app.PosRecTimeEditField = uieditfield(app.PositionTab, 'numeric');
            app.PosRecTimeEditField.Position = [33 403 100 22];

            % Create SpeedEditField_2Label
            app.SpeedEditField_2Label = uilabel(app.PositionTab);
            app.SpeedEditField_2Label.HorizontalAlignment = 'right';
            app.SpeedEditField_2Label.Position = [609 410 39 22];
            app.SpeedEditField_2Label.Text = 'Speed';

            % Create PosTrajSpeedEditField
            app.PosTrajSpeedEditField = uieditfield(app.PositionTab, 'numeric');
            app.PosTrajSpeedEditField.Position = [665 410 100 22];

            % Create AccelerationEditFieldLabel
            app.AccelerationEditFieldLabel = uilabel(app.PositionTab);
            app.AccelerationEditFieldLabel.HorizontalAlignment = 'right';
            app.AccelerationEditFieldLabel.Position = [586 458 71 22];
            app.AccelerationEditFieldLabel.Text = 'Acceleration';

            % Create AccelerationEditField
            app.AccelerationEditField = uieditfield(app.PositionTab, 'numeric');
            app.AccelerationEditField.Position = [666 458 100 22];

            % Create DecelerationEditFieldLabel
            app.DecelerationEditFieldLabel = uilabel(app.PositionTab);
            app.DecelerationEditFieldLabel.HorizontalAlignment = 'right';
            app.DecelerationEditFieldLabel.Position = [585 433 72 22];
            app.DecelerationEditFieldLabel.Text = 'Deceleration';

            % Create DecelerationEditField
            app.DecelerationEditField = uieditfield(app.PositionTab, 'numeric');
            app.DecelerationEditField.Position = [666 434 100 22];

            % Create TargetLEditFieldLabel
            app.TargetLEditFieldLabel = uilabel(app.PositionTab);
            app.TargetLEditFieldLabel.HorizontalAlignment = 'right';
            app.TargetLEditFieldLabel.Position = [381 454 48 22];
            app.TargetLEditFieldLabel.Text = 'Target L';

            % Create TargetLEditField
            app.TargetLEditField = uieditfield(app.PositionTab, 'numeric');
            app.TargetLEditField.ValueChangedFcn = createCallbackFcn(app, @TargetLEditFieldValueChanged, true);
            app.TargetLEditField.Position = [444 454 100 22];

            % Create GoButton
            app.GoButton = uibutton(app.PositionTab, 'push');
            app.GoButton.ButtonPushedFcn = createCallbackFcn(app, @GoButtonPushed, true);
            app.GoButton.Position = [444 403 100 23];
            app.GoButton.Text = 'Go';

            % Create PeriodicCheckBox
            app.PeriodicCheckBox = uicheckbox(app.PositionTab);
            app.PeriodicCheckBox.ValueChangedFcn = createCallbackFcn(app, @PeriodicCheckBoxValueChanged, true);
            app.PeriodicCheckBox.Text = 'Periodic';
            app.PeriodicCheckBox.Position = [445 382 65 22];

            % Create TargetHEditFieldLabel
            app.TargetHEditFieldLabel = uilabel(app.PositionTab);
            app.TargetHEditFieldLabel.HorizontalAlignment = 'right';
            app.TargetHEditFieldLabel.Position = [377 430 51 22];
            app.TargetHEditFieldLabel.Text = 'Target H';

            % Create TargetHEditField
            app.TargetHEditField = uieditfield(app.PositionTab, 'numeric');
            app.TargetHEditField.Position = [443 430 100 22];

            % Create StopButton
            app.StopButton = uibutton(app.PositionTab, 'push');
            app.StopButton.ButtonPushedFcn = createCallbackFcn(app, @StopButtonPushed, true);
            app.StopButton.BackgroundColor = [1 0 0];
            app.StopButton.FontSize = 14;
            app.StopButton.FontWeight = 'bold';
            app.StopButton.FontAngle = 'italic';
            app.StopButton.FontColor = [1 1 1];
            app.StopButton.Position = [374 385 56 40];
            app.StopButton.Text = 'Stop';

            % Create ControlPanel
            app.ControlPanel = uipanel(app.PositionTab);
            app.ControlPanel.Title = 'Control';
            app.ControlPanel.Position = [133 351 228 52];

            % Create KpEditFieldLabel
            app.KpEditFieldLabel = uilabel(app.ControlPanel);
            app.KpEditFieldLabel.HorizontalAlignment = 'right';
            app.KpEditFieldLabel.Position = [143 7 25 22];
            app.KpEditFieldLabel.Text = 'Kp';

            % Create KpEditField
            app.KpEditField = uieditfield(app.ControlPanel, 'numeric');
            app.KpEditField.ValueChangedFcn = createCallbackFcn(app, @KpEditFieldValueChanged, true);
            app.KpEditField.Position = [174 7 47 22];

            % Create MaxAccEditFieldLabel
            app.MaxAccEditFieldLabel = uilabel(app.ControlPanel);
            app.MaxAccEditFieldLabel.HorizontalAlignment = 'right';
            app.MaxAccEditFieldLabel.Position = [9 7 47 22];
            app.MaxAccEditFieldLabel.Text = 'MaxAcc';

            % Create MaxAccEditField
            app.MaxAccEditField = uieditfield(app.ControlPanel, 'numeric');
            app.MaxAccEditField.ValueChangedFcn = createCallbackFcn(app, @MaxAccEditFieldValueChanged, true);
            app.MaxAccEditField.Position = [60 7 82 22];

            % Create HereButton
            app.HereButton = uibutton(app.PositionTab, 'push');
            app.HereButton.ButtonPushedFcn = createCallbackFcn(app, @HereButtonPushed, true);
            app.HereButton.Position = [545 454 41 23];
            app.HereButton.Text = 'Here';

            % Create HereButton_2
            app.HereButton_2 = uibutton(app.PositionTab, 'push');
            app.HereButton_2.ButtonPushedFcn = createCallbackFcn(app, @HereButton_2Pushed, true);
            app.HereButton_2.Position = [546 428 41 23];
            app.HereButton_2.Text = 'Here';

            % Create TransientExceptionLabel
            app.TransientExceptionLabel = uilabel(app.WheelDrvUIFigure);
            app.TransientExceptionLabel.BackgroundColor = [0.651 0.651 0.651];
            app.TransientExceptionLabel.FontWeight = 'bold';
            app.TransientExceptionLabel.FontAngle = 'italic';
            app.TransientExceptionLabel.Position = [51 49 764 27];
            app.TransientExceptionLabel.Text = 'TransientException';

            % Create ConnectedLabel
            app.ConnectedLabel = uilabel(app.WheelDrvUIFigure);
            app.ConnectedLabel.BackgroundColor = [1 1 0.0667];
            app.ConnectedLabel.FontSize = 14;
            app.ConnectedLabel.FontWeight = 'bold';
            app.ConnectedLabel.Position = [63 673 118 22];
            app.ConnectedLabel.Text = 'Connected';

            % Create MotorONButton
            app.MotorONButton = uibutton(app.WheelDrvUIFigure, 'push');
            app.MotorONButton.ButtonPushedFcn = createCallbackFcn(app, @MotorONButtonPushed, true);
            app.MotorONButton.Position = [839 605 137 43];
            app.MotorONButton.Text = 'Motor ON';

            % Create STOEditFieldLabel
            app.STOEditFieldLabel = uilabel(app.WheelDrvUIFigure);
            app.STOEditFieldLabel.HorizontalAlignment = 'right';
            app.STOEditFieldLabel.Position = [816 659 30 22];
            app.STOEditFieldLabel.Text = 'STO';

            % Create STOEditField
            app.STOEditField = uieditfield(app.WheelDrvUIFigure, 'numeric');
            app.STOEditField.Position = [861 659 100 22];

            % Create SelectaxisButton
            app.SelectaxisButton = uibutton(app.WheelDrvUIFigure, 'push');
            app.SelectaxisButton.ButtonPushedFcn = createCallbackFcn(app, @SelectaxisButtonPushed, true);
            app.SelectaxisButton.Position = [208 673 100 23];
            app.SelectaxisButton.Text = 'Select axis';

            % Create BrakePanel
            app.BrakePanel = uipanel(app.WheelDrvUIFigure);
            app.BrakePanel.Title = 'Brake';
            app.BrakePanel.Position = [845 534 155 55];

            % Create Lamp
            app.Lamp = uilamp(app.BrakePanel);
            app.Lamp.Position = [130 7 20 20];

            % Create BrakeLabel
            app.BrakeLabel = uilabel(app.BrakePanel);
            app.BrakeLabel.Position = [74 6 53 22];
            app.BrakeLabel.Text = 'Engaged';

            % Create ToggleBrakeButton
            app.ToggleBrakeButton = uibutton(app.BrakePanel, 'push');
            app.ToggleBrakeButton.ButtonPushedFcn = createCallbackFcn(app, @ToggleBrakeButtonPushed, true);
            app.ToggleBrakeButton.Position = [5 6 62 23];
            app.ToggleBrakeButton.Text = 'Toggle';

            % Create RecorderReadyLampLabel
            app.RecorderReadyLampLabel = uilabel(app.WheelDrvUIFigure);
            app.RecorderReadyLampLabel.HorizontalAlignment = 'right';
            app.RecorderReadyLampLabel.Position = [892 465 92 22];
            app.RecorderReadyLampLabel.Text = 'Recorder Ready';

            % Create RecorderReadyLamp
            app.RecorderReadyLamp = uilamp(app.WheelDrvUIFigure);
            app.RecorderReadyLamp.Position = [999 465 20 20];

            % Create HelpButton
            app.HelpButton = uibutton(app.WheelDrvUIFigure, 'push');
            app.HelpButton.ButtonPushedFcn = createCallbackFcn(app, @HelpButtonPushed, true);
            app.HelpButton.BackgroundColor = [0.4667 0.6745 0.1882];
            app.HelpButton.Position = [374 672 100 23];
            app.HelpButton.Text = 'Help';

            % Create ReferencegenPanel
            app.ReferencegenPanel = uipanel(app.WheelDrvUIFigure);
            app.ReferencegenPanel.Title = 'Reference gen';
            app.ReferencegenPanel.Position = [862 135 161 89];

            % Create TRefOn
            app.TRefOn = uiswitch(app.ReferencegenPanel, 'slider');
            app.TRefOn.ValueChangedFcn = createCallbackFcn(app, @TRefOnValueChanged, true);
            app.TRefOn.Position = [84 43 45 20];

            % Create TLabel
            app.TLabel = uilabel(app.ReferencegenPanel);
            app.TLabel.FontWeight = 'bold';
            app.TLabel.Position = [15 42 25 22];
            app.TLabel.Text = 'T';

            % Create RefOn
            app.RefOn = uiswitch(app.ReferencegenPanel, 'slider');
            app.RefOn.ValueChangedFcn = createCallbackFcn(app, @RefOnValueChanged, true);
            app.RefOn.Position = [85 11 45 20];

            % Create GLabel
            app.GLabel = uilabel(app.ReferencegenPanel);
            app.GLabel.FontWeight = 'bold';
            app.GLabel.Position = [16 12 25 22];
            app.GLabel.Text = 'G';

            % Create SignalsPanel
            app.SignalsPanel = uipanel(app.WheelDrvUIFigure);
            app.SignalsPanel.Title = 'Signals';
            app.SignalsPanel.ButtonDownFcn = createCallbackFcn(app, @SignalsPanelButtonDown, true);
            app.SignalsPanel.Position = [833 272 191 187];

            % Create CurrentEditFieldLabel
            app.CurrentEditFieldLabel = uilabel(app.SignalsPanel);
            app.CurrentEditFieldLabel.HorizontalAlignment = 'right';
            app.CurrentEditFieldLabel.Position = [17 137 45 22];
            app.CurrentEditFieldLabel.Text = 'Current';

            % Create CurrentEditField
            app.CurrentEditField = uieditfield(app.SignalsPanel, 'numeric');
            app.CurrentEditField.Position = [77 137 100 22];

            % Create SpeedEditFieldLabel
            app.SpeedEditFieldLabel = uilabel(app.SignalsPanel);
            app.SpeedEditFieldLabel.HorizontalAlignment = 'right';
            app.SpeedEditFieldLabel.Position = [25 107 39 22];
            app.SpeedEditFieldLabel.Text = 'Speed';

            % Create SpeedEditField
            app.SpeedEditField = uieditfield(app.SignalsPanel, 'numeric');
            app.SpeedEditField.Position = [79 107 100 22];

            % Create OuterPosEditFieldLabel
            app.OuterPosEditFieldLabel = uilabel(app.SignalsPanel);
            app.OuterPosEditFieldLabel.HorizontalAlignment = 'right';
            app.OuterPosEditFieldLabel.Position = [8 41 55 22];
            app.OuterPosEditFieldLabel.Text = 'OuterPos';

            % Create OuterPosEditField
            app.OuterPosEditField = uieditfield(app.SignalsPanel, 'numeric');
            app.OuterPosEditField.ValueDisplayFormat = '%.4f';
            app.OuterPosEditField.Position = [78 41 100 22];

            % Create MotorPosEditFieldLabel
            app.MotorPosEditFieldLabel = uilabel(app.SignalsPanel);
            app.MotorPosEditFieldLabel.HorizontalAlignment = 'right';
            app.MotorPosEditFieldLabel.Position = [5 74 59 22];
            app.MotorPosEditFieldLabel.Text = 'Motor Pos';

            % Create MotorPosEditField
            app.MotorPosEditField = uieditfield(app.SignalsPanel, 'numeric');
            app.MotorPosEditField.Position = [79 74 100 22];

            % Create TemperatureEditFieldLabel
            app.TemperatureEditFieldLabel = uilabel(app.SignalsPanel);
            app.TemperatureEditFieldLabel.HorizontalAlignment = 'right';
            app.TemperatureEditFieldLabel.Position = [2 6 72 22];
            app.TemperatureEditFieldLabel.Text = 'Temperature';

            % Create TemperatureEditField
            app.TemperatureEditField = uieditfield(app.SignalsPanel, 'numeric');
            app.TemperatureEditField.Position = [77 6 100 22];

            % Create UnitsButtonGroup
            app.UnitsButtonGroup = uibuttongroup(app.WheelDrvUIFigure);
            app.UnitsButtonGroup.SelectionChangedFcn = createCallbackFcn(app, @UnitsButtonGroupSelectionChanged, true);
            app.UnitsButtonGroup.Title = 'Units';
            app.UnitsButtonGroup.Position = [893 14 123 106];

            % Create UserButton
            app.UserButton = uiradiobutton(app.UnitsButtonGroup);
            app.UserButton.Text = 'User';
            app.UserButton.Position = [11 60 58 22];
            app.UserButton.Value = true;

            % Create MotorButton
            app.MotorButton = uiradiobutton(app.UnitsButtonGroup);
            app.MotorButton.Text = 'Motor';
            app.MotorButton.Position = [11 38 65 22];

            % Create EnccountsButton
            app.EnccountsButton = uiradiobutton(app.UnitsButtonGroup);
            app.EnccountsButton.Text = 'Enc counts';
            app.EnccountsButton.Position = [11 16 81 22];

            % Create RefModeEditFieldLabel
            app.RefModeEditFieldLabel = uilabel(app.WheelDrvUIFigure);
            app.RefModeEditFieldLabel.HorizontalAlignment = 'right';
            app.RefModeEditFieldLabel.Position = [815 244 54 22];
            app.RefModeEditFieldLabel.Text = 'RefMode';

            % Create RefModeEditField
            app.RefModeEditField = uieditfield(app.WheelDrvUIFigure, 'text');
            app.RefModeEditField.Position = [875 244 142 22];

            % Create IdentifyOkLampLabel
            app.IdentifyOkLampLabel = uilabel(app.WheelDrvUIFigure);
            app.IdentifyOkLampLabel.HorizontalAlignment = 'right';
            app.IdentifyOkLampLabel.Position = [489 670 66 22];
            app.IdentifyOkLampLabel.Text = 'Identify Ok ';

            % Create IdentifyOkLamp
            app.IdentifyOkLamp = uilamp(app.WheelDrvUIFigure);
            app.IdentifyOkLamp.Position = [570 670 20 20];

            % Create ONLampLabel
            app.ONLampLabel = uilabel(app.WheelDrvUIFigure);
            app.ONLampLabel.HorizontalAlignment = 'right';
            app.ONLampLabel.Position = [991 638 25 22];
            app.ONLampLabel.Text = 'ON';

            % Create ONLamp
            app.ONLamp = uilamp(app.WheelDrvUIFigure);
            app.ONLamp.Position = [999 614 20 20];

            % Create FaultLampLabel
            app.FaultLampLabel = uilabel(app.WheelDrvUIFigure);
            app.FaultLampLabel.HorizontalAlignment = 'right';
            app.FaultLampLabel.Position = [842 56 31 22];
            app.FaultLampLabel.Text = 'Fault';

            % Create FaultLamp
            app.FaultLamp = uilamp(app.WheelDrvUIFigure);
            app.FaultLamp.Position = [849 30 20 20];

            % Create CBITPanel
            app.CBITPanel = uipanel(app.WheelDrvUIFigure);
            app.CBITPanel.Title = 'CBIT';
            app.CBITPanel.Position = [1032 312 122 358];

            % Create QuickStopLampLabel
            app.QuickStopLampLabel = uilabel(app.CBITPanel);
            app.QuickStopLampLabel.HorizontalAlignment = 'right';
            app.QuickStopLampLabel.Position = [10 237 60 22];
            app.QuickStopLampLabel.Text = 'QuickStop';

            % Create QuickStopLamp
            app.QuickStopLamp = uilamp(app.CBITPanel);
            app.QuickStopLamp.Position = [99 238 20 20];

            % Create HomedLampLabel
            app.HomedLampLabel = uilabel(app.CBITPanel);
            app.HomedLampLabel.HorizontalAlignment = 'right';
            app.HomedLampLabel.Position = [28 201 43 22];
            app.HomedLampLabel.Text = 'Homed';

            % Create HomedLamp
            app.HomedLamp = uilamp(app.CBITPanel);
            app.HomedLamp.Position = [99 202 20 20];

            % Create ReadyLampLabel
            app.ReadyLampLabel = uilabel(app.CBITPanel);
            app.ReadyLampLabel.HorizontalAlignment = 'right';
            app.ReadyLampLabel.Position = [32 269 39 22];
            app.ReadyLampLabel.Text = 'Ready';

            % Create ReadyLamp
            app.ReadyLamp = uilamp(app.CBITPanel);
            app.ReadyLamp.Position = [99 270 20 20];

            % Create ProfileConvLampLabel
            app.ProfileConvLampLabel = uilabel(app.CBITPanel);
            app.ProfileConvLampLabel.HorizontalAlignment = 'right';
            app.ProfileConvLampLabel.Position = [1 165 73 22];
            app.ProfileConvLampLabel.Text = 'Profile Conv.';

            % Create ProfileConvLamp
            app.ProfileConvLamp = uilamp(app.CBITPanel);
            app.ProfileConvLamp.Position = [99 166 20 20];

            % Create MotionConvLabel
            app.MotionConvLabel = uilabel(app.CBITPanel);
            app.MotionConvLabel.HorizontalAlignment = 'right';
            app.MotionConvLabel.Position = [-3 130 75 22];
            app.MotionConvLabel.Text = 'Motion Conv.';

            % Create MotionConvLamp
            app.MotionConvLamp = uilamp(app.CBITPanel);
            app.MotionConvLamp.Position = [99 131 20 20];

            % Create CalibratedLampLabel
            app.CalibratedLampLabel = uilabel(app.CBITPanel);
            app.CalibratedLampLabel.HorizontalAlignment = 'right';
            app.CalibratedLampLabel.Position = [10 15 59 22];
            app.CalibratedLampLabel.Text = 'Calibrated';

            % Create CalibratedLamp
            app.CalibratedLamp = uilamp(app.CBITPanel);
            app.CalibratedLamp.Position = [99 16 20 20];

            % Create StartStopenaLampLabel
            app.StartStopenaLampLabel = uilabel(app.CBITPanel);
            app.StartStopenaLampLabel.HorizontalAlignment = 'right';
            app.StartStopenaLampLabel.Position = [-3 93 82 22];
            app.StartStopenaLampLabel.Text = 'Start/Stop ena';

            % Create StartStopenaLamp
            app.StartStopenaLamp = uilamp(app.CBITPanel);
            app.StartStopenaLamp.Position = [99 94 20 20];

            % Create AutoStopLampLabel
            app.AutoStopLampLabel = uilabel(app.CBITPanel);
            app.AutoStopLampLabel.HorizontalAlignment = 'right';
            app.AutoStopLampLabel.Position = [11 54 58 22];
            app.AutoStopLampLabel.Text = 'Auto Stop';

            % Create AutoStopLamp
            app.AutoStopLamp = uilamp(app.CBITPanel);
            app.AutoStopLamp.Position = [99 55 20 20];

            % Create ConfigButton
            app.ConfigButton = uibutton(app.CBITPanel, 'push');
            app.ConfigButton.ButtonPushedFcn = createCallbackFcn(app, @ConfigButtonPushed, true);
            app.ConfigButton.Position = [16 302 100 23];
            app.ConfigButton.Text = 'Configured';

            % Show the figure after all components are created
            app.WheelDrvUIFigure.Visible = 'on';
        end
    end

    % App creation and deletion
    methods (Access = public)

        % Construct app
        function app = WheelDrv_exported

            % Create UIFigure and components
            createComponents(app)

            % Register the app with App Designer
            registerApp(app, app.WheelDrvUIFigure)

            % Execute the startup function
            runStartupFcn(app, @startupFcn)

            if nargout == 0
                clear app
            end
        end

        % Code that executes before app deletion
        function delete(app)

            % Delete UIFigure when app is deleted
            delete(app.WheelDrvUIFigure)
        end
    end
end