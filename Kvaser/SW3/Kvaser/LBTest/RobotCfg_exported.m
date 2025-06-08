classdef RobotCfg_exported < matlab.apps.AppBase

    % Properties that correspond to app components
    properties (Access = public)
        UIFigure                      matlab.ui.Figure
        MessagetotheuserLabel         matlab.ui.control.Label
        SaveButton                    matlab.ui.control.Button
        RailteethPitchListBox         matlab.ui.control.ListBox
        RailteethPitchListBoxLabel    matlab.ui.control.Label
        WheelArmListBox               matlab.ui.control.ListBox
        WheelArmListBoxLabel          matlab.ui.control.Label
        ManipulatorTypeListBox        matlab.ui.control.ListBox
        ManipulatorTypeListBoxLabel   matlab.ui.control.Label
        ConfiguiratorforRobotV3Label  matlab.ui.control.Label
    end

    
    properties (Access = private)
        Cfg % Description
        E_ManipulatorType % Description
        E_WheelArmType % Description       
        E_VerticalRailPitchType % Description
        CalibStr % Description
    end
    
    methods (Access = private)
        
    end
    

    % Callbacks that handle component events
    methods (Access = private)

        % Code that executes after component creation
        function startupFcn(app)

            try %OBB section added to start AtpStart if deployed
                if isdeployed && ~exist('AtpCfg','var')
                    AtpStart();
                end
            catch
                uiwait(errordlg({'Cant run AtpStart'},'Error') ); 
            end

            % See manipulator type 
            try 
                app.CalibStr = SaveCalib ( [] , 'SetManipTypeParamsBackup.jsn' ); 
            catch 
                uiwait( errordlg(["Cannot comunicate with robot","for reading its configuration"],"Error") )  ; 
                app.UIFigureCloseRequest(app) ; 
                return ; 
            end 
            try 
               app.Cfg = app.CalibStr.RobotConfig ;  
            catch
                uiwait( errordlg(["SW version does not","support robot configuration"],"Error") ) ;                 
                app.UIFigureCloseRequest(app) ; 
                return ; 
            end
            app.E_ManipulatorType = struct( 'None', 0 , 'Scara' , 1 , 'Flex_Arm' , 2 )  ; 
            app.E_WheelArmType    = struct( 'Rigid' , 0 , 'Wheel_Arm28' , 1, 'Wheel_Arm24' , 2 )  ; 
            app.E_VerticalRailPitchType  = struct( 'Old_6p28' , 0 , 'New_6p35' , 1)  ; 




            ManipType = bitand( app.CalibStr.RobotConfig , 15) ;
            switch ManipType 
                case app.E_ManipulatorType.None 
                    app.ManipulatorTypeListBox.Value = 'None';
                case app.E_ManipulatorType.Scara 
                    app.ManipulatorTypeListBox.Value = 'Scara';
                case app.E_ManipulatorType.Flex_Arm 
                    app.ManipulatorTypeListBox.Value = 'Flex_Arm';
                otherwise
                    app.ManipulatorTypeListBox.Value = 'Scara';
                    uiwait( warndlg(["Unidentified manipulator configuration","Default to Scara"],"Warning") ) ;                 
            end

            WheelArmType = bitand( bitshift(app.CalibStr.RobotConfig,-4) , 3) ;
            switch WheelArmType 
                case app.E_WheelArmType.Rigid 
                    app.WheelArmListBox.Value = 'Rigid';
                case app.E_WheelArmType.Wheel_Arm28 
                    app.WheelArmListBox.Value = 'Wheel_Arm28';
                case app.E_WheelArmType.Wheel_Arm24 
                    app.WheelArmListBox.Value = 'Wheel_Arm24';
                otherwise
                    app.WheelArmListBox.Value = 'Rigid';
                    uiwait( warndlg(["Unidentified wheel arm configuration","Default to Rigid"],"Warning") ) ;                 
            end
            

            VerticalRailPitchType = bitand( bitshift(app.CalibStr.RobotConfig,-8) , 7) ;
            switch VerticalRailPitchType 
                case app.E_VerticalRailPitchType.Old_6p28 
                    app.RailteethPitchListBox.Value = 'Old_6p28';
                case app.E_VerticalRailPitchType.New_6p35 
                    app.RailteethPitchListBox.Value = 'New_6p35';
                otherwise
                    app.RailteethPitchListBox.Value = 'New_6p35';
                    uiwait( warndlg(["Unidentified vertical pitch configuration","Default to Old_6p28"],"Warning") ) ;                 
            end
            
            
            
            app.MessagetotheuserLabel.Text = "Data was read from robot" ;
        end

        % Button pushed function: SaveButton
        function SaveButtonPushed(app, event)

            switch app.ManipulatorTypeListBox.Value 
                case 'None' 
                    ManipType = app.E_ManipulatorType.None; 
                case 'Scara' 
                    ManipType = app.E_ManipulatorType.Scara; 
                case 'Flex_Arm' 
                    ManipType = app.E_ManipulatorType.Flex_Arm; 
                otherwise
                    uiwait( warndlg(["Unidentified manipulator configuration","Default to Scara"],"Warning") ) ; 
                    ManipType = app.E_ManipulatorType.Scara; 
            end

%             WheelArmType = bitand( bitshift(CalibStr.RobotConfig,-4) , 3) ;
            switch app.WheelArmListBox.Value 
                case 'Rigid' 
                    WheelArmType = app.E_WheelArmType.Rigid ;
                case 'Wheel_Arm28' 
                    WheelArmType = app.E_WheelArmType.Wheel_Arm28 ;
                case 'Wheel_Arm24' 
                    WheelArmType = app.E_WheelArmType.Wheel_Arm24 ;
                otherwise
                    WheelArmType = app.E_WheelArmType.Rigid ;
                    uiwait( warndlg(["Unidentified wheel arm configuration","Default to Rigid"],"Warning") ) ;                 
            end
            

            switch app.RailteethPitchListBox.Value 
                case  'Old_6p28'
                     VerticalRailPitchType = app.E_VerticalRailPitchType.Old_6p28 ;
                case  'New_6p35'
                     VerticalRailPitchType = app.E_VerticalRailPitchType.New_6p35 ;
                otherwise
                     VerticalRailPitchType = app.E_VerticalRailPitchType.Old_6p28 ;
                    uiwait( warndlg(["Unidentified vertical pitch configuration","Default to Old_6p28"],"Warning") ) ;                 
            end
            
            
    
            app.CalibStr.RobotConfig = ManipType + bitshift( WheelArmType , 4 ) + bitshift( VerticalRailPitchType,8);
            
            try
                SaveCalib ( app.CalibStr , 'SetManipTypeParamsNew.jsn' );        
                ProgCalib('SetManipTypeParamsNew.jsn', 1 );
                uiwait( warndlg(["Configuration will only be valid","At the next robot power up"],"Warning") )  ;            
                app.MessagetotheuserLabel.Text = "Configuration programmed into robot" ;
            catch
                app.MessagetotheuserLabel.Text = "Could not program robot" ;
            end
            
        end

        % Close request function: UIFigure
        function UIFigureCloseRequest(app, event)
            delete(app)
            
        end
    end

    % Component initialization
    methods (Access = private)

        % Create UIFigure and components
        function createComponents(app)

            % Create UIFigure and hide until all components are created
            app.UIFigure = uifigure('Visible', 'off');
            app.UIFigure.Position = [100 100 602 389];
            app.UIFigure.Name = 'MATLAB App';
            app.UIFigure.CloseRequestFcn = createCallbackFcn(app, @UIFigureCloseRequest, true);

            % Create ConfiguiratorforRobotV3Label
            app.ConfiguiratorforRobotV3Label = uilabel(app.UIFigure);
            app.ConfiguiratorforRobotV3Label.FontSize = 24;
            app.ConfiguiratorforRobotV3Label.FontWeight = 'bold';
            app.ConfiguiratorforRobotV3Label.FontAngle = 'italic';
            app.ConfiguiratorforRobotV3Label.FontColor = [1 0 0];
            app.ConfiguiratorforRobotV3Label.Position = [25 311 311 79];
            app.ConfiguiratorforRobotV3Label.Text = 'Configuirator for Robot V3';

            % Create ManipulatorTypeListBoxLabel
            app.ManipulatorTypeListBoxLabel = uilabel(app.UIFigure);
            app.ManipulatorTypeListBoxLabel.HorizontalAlignment = 'right';
            app.ManipulatorTypeListBoxLabel.Position = [25 252 98 22];
            app.ManipulatorTypeListBoxLabel.Text = 'Manipulator Type';

            % Create ManipulatorTypeListBox
            app.ManipulatorTypeListBox = uilistbox(app.UIFigure);
            app.ManipulatorTypeListBox.Items = {'None', 'Scara', 'Flex_Arm'};
            app.ManipulatorTypeListBox.Position = [138 220 100 56];
            app.ManipulatorTypeListBox.Value = 'Scara';

            % Create WheelArmListBoxLabel
            app.WheelArmListBoxLabel = uilabel(app.UIFigure);
            app.WheelArmListBoxLabel.HorizontalAlignment = 'right';
            app.WheelArmListBoxLabel.Position = [289 250 65 22];
            app.WheelArmListBoxLabel.Text = 'Wheel Arm';

            % Create WheelArmListBox
            app.WheelArmListBox = uilistbox(app.UIFigure);
            app.WheelArmListBox.Items = {'Rigid', 'Wheel_Arm28', 'Wheel_Arm24'};
            app.WheelArmListBox.Position = [369 203 100 71];
            app.WheelArmListBox.Value = 'Rigid';

            % Create RailteethPitchListBoxLabel
            app.RailteethPitchListBoxLabel = uilabel(app.UIFigure);
            app.RailteethPitchListBoxLabel.HorizontalAlignment = 'right';
            app.RailteethPitchListBoxLabel.Position = [268 166 86 22];
            app.RailteethPitchListBoxLabel.Text = 'Rail teeth Pitch';

            % Create RailteethPitchListBox
            app.RailteethPitchListBox = uilistbox(app.UIFigure);
            app.RailteethPitchListBox.Items = {'Old_6p28', 'New_6p35'};
            app.RailteethPitchListBox.Position = [369 149 100 41];
            app.RailteethPitchListBox.Value = 'Old_6p28';

            % Create SaveButton
            app.SaveButton = uibutton(app.UIFigure, 'push');
            app.SaveButton.ButtonPushedFcn = createCallbackFcn(app, @SaveButtonPushed, true);
            app.SaveButton.BackgroundColor = [1 0.4118 0.1608];
            app.SaveButton.FontSize = 24;
            app.SaveButton.FontWeight = 'bold';
            app.SaveButton.FontAngle = 'italic';
            app.SaveButton.FontColor = [1 1 1];
            app.SaveButton.Position = [164 90 280 36];
            app.SaveButton.Text = 'Save';

            % Create MessagetotheuserLabel
            app.MessagetotheuserLabel = uilabel(app.UIFigure);
            app.MessagetotheuserLabel.BackgroundColor = [1 1 0];
            app.MessagetotheuserLabel.FontSize = 16;
            app.MessagetotheuserLabel.FontWeight = 'bold';
            app.MessagetotheuserLabel.Position = [76 55 470 22];
            app.MessagetotheuserLabel.Text = 'Message to the user';

            % Show the figure after all components are created
            app.UIFigure.Visible = 'on';
        end
    end

    % App creation and deletion
    methods (Access = public)

        % Construct app
        function app = RobotCfg_exported

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