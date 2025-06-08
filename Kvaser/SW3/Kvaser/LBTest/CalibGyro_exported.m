classdef CalibGyro_exported < matlab.apps.AppBase

    % Properties that correspond to app components
    properties (Access = public)
        UIFigure                    matlab.ui.Figure
        NeckbrakereleasedLamp       matlab.ui.control.Lamp
        NeckbrakereleasedLampLabel  matlab.ui.control.Label
        ReleaseneckbrakeButton      matlab.ui.control.Button
        DoneButton                  matlab.ui.control.Button
        CalibrateIMUButton          matlab.ui.control.Button
        ExceptionLabel              matlab.ui.control.Label
        CalibrationdataPanel        matlab.ui.container.Panel
        CalibdateEditField          matlab.ui.control.NumericEditField
        CalibdateEditFieldLabel     matlab.ui.control.Label
        CalibIDEditField            matlab.ui.control.NumericEditField
        CalibIDEditFieldLabel       matlab.ui.control.Label
        CalibexistsCheckBox         matlab.ui.control.CheckBox
        DebugPanel                  matlab.ui.container.Panel
        DegreesLabel                matlab.ui.control.Label
        YawEditField                matlab.ui.control.NumericEditField
        YawEditFieldLabel           matlab.ui.control.Label
        PitchEditField              matlab.ui.control.NumericEditField
        PitchEditFieldLabel         matlab.ui.control.Label
        RollEditField               matlab.ui.control.NumericEditField
        RollEditFieldLabel          matlab.ui.control.Label
        InstructionsLabel           matlab.ui.control.Label
        IMUcalibraitondialogLabel   matlab.ui.control.Label
    end

    
    properties (Access = private)
        EvtObj % Description
        Timer  % Description
        CalibInit % Description
        CalibRslt % Description
        CalibExist % Description
        InLCalib % Description
        CalibratingIMU % Description
        CalibratingState % Description
        PushActionDone % Description
        quat0Rslt % Description
        Lock % Description
        DataType % Description
        DonePressed % Description
        RecStruct  % Description
        Brake % Description
        version % Description
    end
    
    methods (Access = private)
        
        function update_warm_display(app,~,~ )
            global DataType 

            global TmMgrT
        
            try
                cnt = TmMgrT.GetCounter('CAL_IMU') ; 
                
                if cnt < -0.5e-6 
                    UIFigureCloseRequest(app, []); 
                    %delete( hobj) ; 
                else
                    TmMgrT.IncrementCounter('CAL_IMU',2) ; 
                end     
                    
            catch 
            end

            if app.Lock
                return ; 
            end

            try
                Edata = GetExtData(app) ;
                app.RollEditField.Value = Edata.GyroRoll * 180 / pi; 
                app.PitchEditField.Value = Edata.GyroPitch * 180 / pi; 
                app.YawEditField.Value = Edata.Heading * 180 / pi;
                app.Brake = Edata.NeckBIT.BrakesReleaseCmd ; 

                if ( app.Brake == 0) 
                    app.NeckbrakereleasedLamp.Color = [1,1,1] * 0.7 ; 
                    app.ReleaseneckbrakeButton.Text   = 'Release brake' ; 
                else
                    app.NeckbrakereleasedLamp.Color = [0,1,0]  ; 
                     app.ReleaseneckbrakeButton.Text   = 'Auto brake Mng' ; 
               end
    
                if app.CalibratingIMU 
                    app.CalibrateIMUButton.Enable = 'off' ; 
                else
                    app.CalibrateIMUButton.Enable = 'on' ; 
                end 
    
                if ( app.CalibratingIMU  )
                    ImuCalibFunc(app) ;
                end
            catch 
            end
        end
        
        
        
        
        
        
        
        
        
        function Edata = GetExtData(app)
            GyroRoll =  FetchObj( [hex2dec('2204'),56,124] , app.DataType.float , 'Gyro roll' ) ;
            GyroPitch =  FetchObj( [hex2dec('2204'),57,124] , app.DataType.float , 'Gyro pitch' ) ;
            Heading =  FetchObj( [hex2dec('2204'),111,124] , app.DataType.float , 'Gyro pitch' ) ;
            NeckBIT = GetAxisCBit(5) ; 
            Edata = struct ( 'GyroRoll' , GyroRoll ,'GyroPitch',GyroPitch,'Heading',Heading','NeckBIT',NeckBIT);  
            
        end
        
        
        function ImuCalibFunc(app)
            app.InstructionsLabel.Visible = 'on' ; 

            if ( app.CalibratingState == 0 )
                if ( app.DonePressed == 0 )
                    app.InstructionsLabel.Text = {'Bring the neck to level';'Bring heading to zero';'Press Done'};
                    return ; 
                end
            end
            app.InstructionsLabel.Text = {'Recording data';'and analyzing';'Please wait'} ; 

            TrigSig   = 1 ; % find( strcmpi( SigNames ,'RawQuat0')) ;  
            TrigTypes = struct('Immediate', 0 , 'Rising' , 1 , 'Falling' , 2 ,'Equal' , 3) ; 
            RecNames = {'RawQuat0','RawQuat1','RawQuat2','RawQuat3'} ; 


            RecStructUser = struct('TrigSig',TrigSig,'TrigType',TrigTypes.Immediate ,'TrigVal',0,...
                'Sync2C', 1 , 'Gap' , 2 , 'Len' , 300 ) ; 
            RecStructUser.PreTrigCnt = RecStructUser.Len / 4;

            RecStructUser = MergeStruct ( app.RecStruct, RecStructUser)  ; 

            %Flags (set only one of them to 1) : 
            % ProgRec = 1 just programs the signals, recorder remains inactive waiting an activating event 
            % InitRec = 1 initates the recorder and makes it work 
            % BringRec = 1 Programs the recorder, waits completion, and brings the
            % results immediately
            options = struct( 'InitRec' , 1 , 'BringRec' , 1 ,'ProgRec' , 1 , 'BlockUpLoad', 1 ,'Struct' , 1  ); 

            [~,~,r]= Recorder(RecNames , RecStructUser , options  ) ; 

            t = r.t ; %#ok<NASGU,NASGU> 
            q0 = mean(r.RawQuat0) ; 
            q1 = mean(r.RawQuat1) ; 
            q2 = mean(r.RawQuat2) ; 
            q3 = mean(r.RawQuat3) ; 
            qsys = [0 1 1 0 ] / sqrt(2) ; 

            qq = [q0, q1, q2, q3] ; 
            if abs(norm(qq) - 1) > 0.05 
                uiwait( errordlg('Failed to narmalized quaternion') ) ; 
                app.CalibratingIMU = 0 ; 
            end
            qq = qq / norm(qq) ;
            qflip = [0 0 1 0] ; % Quaternion to nominal position for robot G3 
            qqFlipped = QuatOnQuat( qq , qflip ) ;
            [yy,pp,rr]= Quat2Euler( qqFlipped)  ;     %#ok<ASGLU> % qq is q(g'->N
            app.quat0Rslt =  InvertQuat( QuatOnQuat(euler2quat(0, pp,rr),qflip));

            %[yy,pp,rr]= Quat2Euler( qq)  ;     %#ok<ASGLU> % qq is q(g'->N
            %QgTagToG_ENU = InvertQuat(euler2quat(0, pp,rr)) ; % Null the yew - This goes to calibration mat 
            
            % app.quat0Rslt =  QuatOnQuat(QuatOnQuat(qsys,QgTagToG_ENU),qsys);   

            app.CalibratingIMU = 0 ;
            app.PushActionDone = 0 ; 
            app.CalibratingState = 0 ; 

            app.CalibInit.qImu2Body0 = app.quat0Rslt (1) ;
            app.CalibInit.qImu2Body1 = app.quat0Rslt (2) ;
            app.CalibInit.qImu2Body2 = app.quat0Rslt (3) ;
            app.CalibInit.qImu2Body3 = app.quat0Rslt (4) ;
   
            SendObj( [hex2dec('2302'),16,124] ,app.quat0Rslt (1) , app.DataType.float , 'qImu2Body0 calib') ;
            SendObj( [hex2dec('2302'),17,124] ,app.quat0Rslt (2) , app.DataType.float , 'qImu2Body1 calib') ;
            SendObj( [hex2dec('2302'),18,124] ,app.quat0Rslt (3) , app.DataType.float , 'qImu2Body2 calib') ;
            SendObj( [hex2dec('2302'),19,124] ,app.quat0Rslt (4) , app.DataType.float , 'qImu2Body3 calib') ;

            % apply calibration 
            SendObj( [hex2dec('2302'),249,124] ,0 , app.DataType.float , 'Apply calibration') ;

            [fname,PathName] = uiputfile('*.jsn','Select the calibration JSON file');
            SaveCalib( app.CalibInit,[PathName,fname] ) ;
            dcd = questdlg('Save to flash?', ...
                                     'Please specify', ...
                                     'Yes', 'No' , 'No');  
            if isequal( dcd , 'Yes' )                 
                ProgCalib([PathName,fname], 1 ); 
                app.InstructionsLabel.Text =' Succesfully saved to flash ';
            end 
        end
    end
    

    % Callbacks that handle component events
    methods (Access = private)

        % Code that executes after component creation
        function startupFcn(app)
            global DataType %#ok<*GVMIS,*GVMIS> 
            global DispT
            global RecStruct 


            %OBB moved to here
            if ~exist('DispT','var') || ~isa(DispT,'DlgTimerObj')
                evalin('base','AtpStart') ; 
            end 

            %OBB keep check for compiled version debugging.
            try %%
                RecStruct.SigList; %%
            catch ME %%
                uiwait( errordlg({'stratupFnc, missing or problematic RecStruct. ';ME.message}) ); %added for debugging
            end %%

            app.version = '1.3';
            app.IMUcalibraitondialogLabel.Text = ['Gyro Calibration, Version ', app.version]; 

            try 
            dbgstate = FetchObj( [hex2dec('2222'),24] , DataType.long , 'SysState.Debug') ; % Left 
            dbgwa  = bitand(dbgstate,1)  ; 
            app.DebugmodeCheckBox.Value = dbgwa ; 
            app.DebugModeButton.Value= dbgwa ;
            catch
            end
            
            app.CalibratingIMU = 0 ; 
            app.CalibratingState = 0 ;
            app.PushActionDone= 0 ; 
            app.DonePressed = 0 ; 
            app.RecStruct = RecStruct ; 

            app.Lock = 0 ; 
            app.DataType = GetDataType();
 
%             if ~exist('DispT','var') || ~isa(DispT,'DlgTimerObj')
%                 evalin('base','AtpStart') ; 
%             end 
            app.EvtObj = DlgUserObj(@app.update_warm_display,findobj(app) );
            app.EvtObj.MylistenToTimer(DispT) ;   
            
            % Bring calibration from flash 
            stat = SendObj( [hex2dec('2302'),251] , 0 , DataType.long ,'Load the calibration from the flash to the programming struct') ;  
            if ( stat )
                app.CalibInit = SaveCalib ( 0   ) ; 
                app.CalibdateEditField.Value = 0 ; 
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

        % Close request function: UIFigure
        function UIFigureCloseRequest(app, event)
            global TmMgrT
            try
                app.Lock = 1 ; 
                TmMgrT.SetCounter('TEST_WARM',-1000) ; 
                delete( app.EvtObj) ;
            %delete( app.Timer ) ;
            catch 
            end
            delete(app)
            
        end

        % Callback function
        function DebugModeButtonValueChanged(app, event)
            
        end

        % Button pushed function: CalibrateIMUButton
        function CalibrateIMUButtonPushed(app, event)
            app.CalibratingIMU = 1 ; 
            app.CalibratingState = 0 ;
            app.DonePressed = 0 ; 
        end

        % Button pushed function: DoneButton
        function DoneButtonPushed(app, event)
            app.DonePressed = 1 ;
        end

        % Button pushed function: ReleaseneckbrakeButton
        function ReleaseneckbrakeButtonPushed(app, event)
            if ( app.Brake==0)
                SendObj( [hex2dec('2220'),41] , 1 , app.DataType.long ,'Release brake') ;  
            else
                SendObj( [hex2dec('2220'),41] ,  0, app.DataType.long ,'Auto brake') ;  
            end
        end
    end

    % Component initialization
    methods (Access = private)

        % Create UIFigure and components
        function createComponents(app)

            % Create UIFigure and hide until all components are created
            app.UIFigure = uifigure('Visible', 'off');
            app.UIFigure.Position = [100 100 728 404];
            app.UIFigure.Name = 'MATLAB App';
            app.UIFigure.CloseRequestFcn = createCallbackFcn(app, @UIFigureCloseRequest, true);

            % Create IMUcalibraitondialogLabel
            app.IMUcalibraitondialogLabel = uilabel(app.UIFigure);
            app.IMUcalibraitondialogLabel.FontSize = 20;
            app.IMUcalibraitondialogLabel.FontWeight = 'bold';
            app.IMUcalibraitondialogLabel.FontAngle = 'italic';
            app.IMUcalibraitondialogLabel.FontColor = [1 0 0];
            app.IMUcalibraitondialogLabel.Position = [56 342 214 26];
            app.IMUcalibraitondialogLabel.Text = 'IMU calibraiton dialog';

            % Create InstructionsLabel
            app.InstructionsLabel = uilabel(app.UIFigure);
            app.InstructionsLabel.BackgroundColor = [1 1 0];
            app.InstructionsLabel.FontWeight = 'bold';
            app.InstructionsLabel.FontAngle = 'italic';
            app.InstructionsLabel.Position = [72 103 634 51];
            app.InstructionsLabel.Text = 'Instructions';

            % Create DebugPanel
            app.DebugPanel = uipanel(app.UIFigure);
            app.DebugPanel.Title = 'Debug';
            app.DebugPanel.Position = [49 185 339 148];

            % Create RollEditFieldLabel
            app.RollEditFieldLabel = uilabel(app.DebugPanel);
            app.RollEditFieldLabel.HorizontalAlignment = 'right';
            app.RollEditFieldLabel.FontSize = 20;
            app.RollEditFieldLabel.Position = [23 93 46 26];
            app.RollEditFieldLabel.Text = 'Roll';

            % Create RollEditField
            app.RollEditField = uieditfield(app.DebugPanel, 'numeric');
            app.RollEditField.FontSize = 20;
            app.RollEditField.FontColor = [0.6353 0.0784 0.1843];
            app.RollEditField.BackgroundColor = [0.0588 1 1];
            app.RollEditField.Position = [84 89 166 27];

            % Create PitchEditFieldLabel
            app.PitchEditFieldLabel = uilabel(app.DebugPanel);
            app.PitchEditFieldLabel.HorizontalAlignment = 'right';
            app.PitchEditFieldLabel.FontSize = 20;
            app.PitchEditFieldLabel.Position = [19 58 50 26];
            app.PitchEditFieldLabel.Text = 'Pitch';

            % Create PitchEditField
            app.PitchEditField = uieditfield(app.DebugPanel, 'numeric');
            app.PitchEditField.FontSize = 20;
            app.PitchEditField.FontColor = [0.6353 0.0784 0.1843];
            app.PitchEditField.BackgroundColor = [0.0588 1 1];
            app.PitchEditField.Position = [84 54 166 27];

            % Create YawEditFieldLabel
            app.YawEditFieldLabel = uilabel(app.DebugPanel);
            app.YawEditFieldLabel.HorizontalAlignment = 'right';
            app.YawEditFieldLabel.FontSize = 20;
            app.YawEditFieldLabel.Position = [23 20 46 26];
            app.YawEditFieldLabel.Text = 'Yaw';

            % Create YawEditField
            app.YawEditField = uieditfield(app.DebugPanel, 'numeric');
            app.YawEditField.FontSize = 20;
            app.YawEditField.FontColor = [0.6353 0.0784 0.1843];
            app.YawEditField.BackgroundColor = [0.0588 1 1];
            app.YawEditField.Position = [84 16 166 27];

            % Create DegreesLabel
            app.DegreesLabel = uilabel(app.DebugPanel);
            app.DegreesLabel.FontSize = 18;
            app.DegreesLabel.Position = [257 54 73 23];
            app.DegreesLabel.Text = 'Degrees';

            % Create CalibrationdataPanel
            app.CalibrationdataPanel = uipanel(app.UIFigure);
            app.CalibrationdataPanel.Title = 'Calibration data ';
            app.CalibrationdataPanel.Position = [408 254 286 79];

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

            % Create ExceptionLabel
            app.ExceptionLabel = uilabel(app.UIFigure);
            app.ExceptionLabel.BackgroundColor = [0.651 0.651 0.651];
            app.ExceptionLabel.FontWeight = 'bold';
            app.ExceptionLabel.FontAngle = 'italic';
            app.ExceptionLabel.Position = [70 62 636 27];
            app.ExceptionLabel.Text = 'Exception';

            % Create CalibrateIMUButton
            app.CalibrateIMUButton = uibutton(app.UIFigure, 'push');
            app.CalibrateIMUButton.ButtonPushedFcn = createCallbackFcn(app, @CalibrateIMUButtonPushed, true);
            app.CalibrateIMUButton.Position = [408 205 112 32];
            app.CalibrateIMUButton.Text = 'Calibrate IMU';

            % Create DoneButton
            app.DoneButton = uibutton(app.UIFigure, 'push');
            app.DoneButton.ButtonPushedFcn = createCallbackFcn(app, @DoneButtonPushed, true);
            app.DoneButton.Position = [408 179 112 23];
            app.DoneButton.Text = 'Done';

            % Create ReleaseneckbrakeButton
            app.ReleaseneckbrakeButton = uibutton(app.UIFigure, 'push');
            app.ReleaseneckbrakeButton.ButtonPushedFcn = createCallbackFcn(app, @ReleaseneckbrakeButtonPushed, true);
            app.ReleaseneckbrakeButton.Position = [573 205 121 32];
            app.ReleaseneckbrakeButton.Text = 'Release neck brake';

            % Create NeckbrakereleasedLampLabel
            app.NeckbrakereleasedLampLabel = uilabel(app.UIFigure);
            app.NeckbrakereleasedLampLabel.HorizontalAlignment = 'right';
            app.NeckbrakereleasedLampLabel.Position = [544 178 115 22];
            app.NeckbrakereleasedLampLabel.Text = 'Neck brake released';

            % Create NeckbrakereleasedLamp
            app.NeckbrakereleasedLamp = uilamp(app.UIFigure);
            app.NeckbrakereleasedLamp.Position = [674 178 20 20];

            % Show the figure after all components are created
            app.UIFigure.Visible = 'on';
        end
    end

    % App creation and deletion
    methods (Access = public)

        % Construct app
        function app = CalibGyro_exported

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