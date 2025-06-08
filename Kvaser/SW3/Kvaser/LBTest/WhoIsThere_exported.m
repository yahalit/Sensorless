classdef WhoIsThere_exported < matlab.apps.AppBase

    % Properties that correspond to app components
    properties (Access = public)
        UIFigure                 matlab.ui.Figure
        WhoisthereappforRobotV3versionLabel  matlab.ui.control.Label
        RestartconnectionButton  matlab.ui.control.Button
        CANresponsestoNMTmessageTextAreaLabel_2  matlab.ui.control.Label
        UITable                  matlab.ui.control.Table
        WhoisthereButton         matlab.ui.control.Button
    end

    
    properties (Access = private)
        IndexToName % Description
        version % Description
    end
    
    methods (Access = private)
        
        function name = startConnection(app, index)
            try %OBB section added to start AtpStart if deployed
                % if isdeployed && ~exist('AtpCfg','var')
                %     AtpStart();
                % end
                AtpStart();
            catch
                uiwait(errordlg({'Cant communicate with LP, verify connection to CAN1.'},'Error') ); 
            end
        end
        
    end
  

    % Callbacks that handle component events
    methods (Access = private)

        % Code that executes after component creation
        function StartupFnc(app)
            global DataType %#ok<*GVMIS,*GVMIS> 
            global DispT
            global RecStruct 

            app.version = '1.1'; 
            MatDir   = '.\Mat\'; 

            app.WhoisthereappforRobotV3versionLabel.Text = ['WhoIsThere for Robot V3, version  ', app.version]; 
            
            load ([MatDir, 'IndexToName.mat']); %OBB
            app.IndexToName = IndexToName;
           
            %app.IndexToName = {1, 'WHEEL_R'; 2, 'STEERING_R'; 3, 'WHEEL_L'; 4, 'STEERING_L'; 5, 'NECK';...
            %                   6, 'NECK2'; 7, 'NECK3'; 8, 'TRAY_ROTATOR'; 9, 'TRAY_SHIFTER';...
            %                   10, 'TAPE_MOTOR'; 25, 'unknown' ; 30 , 'neck_boot_check_with_yahali_why_not_66!' ; 40 , 'INTERFACE_R'; 41 , 'INTERFACE_L' ; 65, 'BOOT_NECK'; 66 , 'BOOT_WHEEL' ; 67 , 'BOOT_INTFC'; 68 , 'BOOT_STEER' ;  97, 'EEF'};
            % IndexToName = app;
            % save ([MatDir, 'IndexToName.mat'], 'IndexToName'); %OBB

            startConnection(app);
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

        % Button pushed function: WhoisthereButton
        function WhoisthereButtonPushed(app, event)
            app.UITable.Data = [];
            try
                InitialDetectedSlaves = [KvaserCom(32),KvaserCom(35)] ; %send NMT with service code 100 (the drivers will answer, the EEF will answer only to 105).
            catch
                msgbox('Error using KvaserCom.');
            end
            
            %TODO: add another kvaserCom(42) for sending NMT 42

            if isempty(InitialDetectedSlaves)
                msgbox('No devices found');
            else
                transSlaves = transpose(InitialDetectedSlaves);
                slaveList = transSlaves(:,1);
                ProjIDList = bitshift(slaveList, -24);
                
                SlaveNames = getProjFromID(app.IndexToName, ProjIDList);

                app.UITable.Data = [SlaveNames];

                for i=1:size(transSlaves,1)
                    app.UITable.Data{i,2} = num2str((transSlaves(i,2)));
                end

                %app.UITable.Data (:,1) =  string(ProjNameList);
                %app.UITable.Data (:,2) =  string(ProjNameList);

                %     Msg.data[0] = ( PROJ_TYPE << 8  ) + (((unsigned long)ProjId & 255)<<24)  ;              
                %     Msg.data[1] = SubverPatch ;
                %     #define SubverPatch ( ((SRV_FIRM_YR-2000) << 24 ) + (SRV_FIRM_MONTH<<20) + (SRV_FIRM_DAY <<15)  +(SRV_FIRM_VER << 8) + (SRV_FIRM_SUBVER<<4) + SRV_FIRM_PATCH )
            end
        end

        % Button pushed function: RestartconnectionButton
        function RestartconnectionButtonPushed(app, event)
            startConnection(app);
        end
    end

    % Component initialization
    methods (Access = private)

        % Create UIFigure and components
        function createComponents(app)

            % Create UIFigure and hide until all components are created
            app.UIFigure = uifigure('Visible', 'off');
            app.UIFigure.Position = [100 100 645 425];
            app.UIFigure.Name = 'MATLAB App';
            app.UIFigure.CloseRequestFcn = createCallbackFcn(app, @UIFigureCloseRequest, true);

            % Create WhoisthereButton
            app.WhoisthereButton = uibutton(app.UIFigure, 'push');
            app.WhoisthereButton.ButtonPushedFcn = createCallbackFcn(app, @WhoisthereButtonPushed, true);
            app.WhoisthereButton.FontSize = 20;
            app.WhoisthereButton.Position = [351 317 184 40];
            app.WhoisthereButton.Text = 'Who is there ?';

            % Create UITable
            app.UITable = uitable(app.UIFigure);
            app.UITable.ColumnName = {'Device'; 'SW version'};
            app.UITable.RowName = {};
            app.UITable.Position = [81 32 493 235];

            % Create CANresponsestoNMTmessageTextAreaLabel_2
            app.CANresponsestoNMTmessageTextAreaLabel_2 = uilabel(app.UIFigure);
            app.CANresponsestoNMTmessageTextAreaLabel_2.HorizontalAlignment = 'right';
            app.CANresponsestoNMTmessageTextAreaLabel_2.Position = [53 278 187 22];
            app.CANresponsestoNMTmessageTextAreaLabel_2.Text = 'CAN responses to NMT message:';

            % Create RestartconnectionButton
            app.RestartconnectionButton = uibutton(app.UIFigure, 'push');
            app.RestartconnectionButton.ButtonPushedFcn = createCallbackFcn(app, @RestartconnectionButtonPushed, true);
            app.RestartconnectionButton.FontSize = 20;
            app.RestartconnectionButton.Position = [103 317 184 40];
            app.RestartconnectionButton.Text = 'Restart connection';

            % Create WhoisthereappforRobotV3versionLabel
            app.WhoisthereappforRobotV3versionLabel = uilabel(app.UIFigure);
            app.WhoisthereappforRobotV3versionLabel.FontSize = 24;
            app.WhoisthereappforRobotV3versionLabel.FontWeight = 'bold';
            app.WhoisthereappforRobotV3versionLabel.FontAngle = 'italic';
            app.WhoisthereappforRobotV3versionLabel.FontColor = [1 0 0];
            app.WhoisthereappforRobotV3versionLabel.Position = [15 375 560 42];
            app.WhoisthereappforRobotV3versionLabel.Text = 'Who is there app for Robot V3, version ';

            % Show the figure after all components are created
            app.UIFigure.Visible = 'on';
        end
    end

    % App creation and deletion
    methods (Access = public)

        % Construct app
        function app = WhoIsThere_exported

            % Create UIFigure and components
            createComponents(app)

            % Register the app with App Designer
            registerApp(app, app.UIFigure)

            % Execute the startup function
            runStartupFcn(app, @StartupFnc)

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