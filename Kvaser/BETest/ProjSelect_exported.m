classdef ProjSelect_exported < matlab.apps.AppBase

    % Properties that correspond to app components
    properties (Access = public)
        ProjectselectorUIFigure         matlab.ui.Figure
        NoteTextArea                    matlab.ui.control.TextArea
        ListofdetectedCANslavesListBox  matlab.ui.control.ListBox
        ListofdetectedCANslavesListBoxLabel  matlab.ui.control.Label
        SelectexitButton                matlab.ui.control.Button
    end

    
    properties (Access = private)
        Projects % Description
        CanIdList % Description
        ProjIdList  % Description
        SwVer % Description
    end
    

    % Callbacks that handle component events
    methods (Access = private)

        % Code that executes after component creation
        function startupFcn(app, ProjList, DetectedSlaves)
            global ActiveSetProj %#ok<GVMIS> 
            % app.ActiveSel  = ActiveSetProj ; 

            ActiveSetProj = 1 ; 

%             if (app.ActiveSel  )
                app.SelectexitButton.Text = 'Config & exit ' ; 
%             end
            app.CanIdList = DetectedSlaves(:,3) ;
            app.Projects = ProjList( DetectedSlaves(:,1)) ;
            app.ProjIdList = DetectedSlaves(:,2) ;
            app.SwVer = DetectedSlaves(:,4) ;

            for cnt = 1:length(app.Projects ) 
                if contains( lower(app.Projects{cnt}) ,'boot' )
                    app.NoteTextArea.Visible = "on";
                end
            end 

            app.ListofdetectedCANslavesListBox.Items = app.Projects;
            app.ListofdetectedCANslavesListBox.Value = app.Projects{1}; 



%             app.LeftwheelButton.UserData = 'leftwheel' ; % struct( 'Card' , 'Servo' ,'Side','Left' ,'Axis','Wheel','Proj','Dual') ; 
%             app.LeftsteeringButton.UserData = 'leftsteer' ; % struct( 'Card' , 'Servo' ,'Side','Left' ,'Axis','Steering','Proj','Dual') ; 
% 
%             app.RightwheelButton.UserData = 'rightwheel' ; % struct( 'Card' , 'Servo' ,'Side','Right' ,'Axis','Wheel','Proj','Dual') ; 
%             app.RightsteeringButton.UserData = 'rightsteer' ; % struct( 'Card' , 'Servo' ,'Side','Right' ,'Axis','Steering','Proj','Dual') ; 
% 
%             app.LeftinterfaceButton.UserData = 'leftintfc' ; % struct( 'Card' , 'Intfc' ,'Side','Left' ,'Axis','None','Proj','Dual') ; 
%             app.RightinterfaceButton.UserData = 'rightintfc' ; % struct( 'Card' , 'Intfc' ,'Side','Left' ,'Axis','None','Proj','Dual') ; 
% 
%             app.NeckButton.UserData = 'neck' ; % truct( 'Card' , 'Neck' ,'Side','Neck' ,'Axis','Neck','Proj','Single') ; 

        end

        % Close request function: ProjectselectorUIFigure
        function ProjectselectorUIFigureCloseRequest(app, event)
            delete(app)
            
        end

        % Button pushed function: SelectexitButton
        function SelectexitButtonPushed(app, event)

            nsel = find(strcmpi(app.ListofdetectedCANslavesListBox.Items,app.ListofdetectedCANslavesListBox.Value)) ; 
            data = GetProjectAttributesByName ( app.ListofdetectedCANslavesListBox.Value)  ;
            data.CanId = app.CanIdList(nsel) ; 
            data.ProjId = app.ProjIdList(nsel); 
            data.SwVer = app.SwVer(nsel) ;
            
            save  .\Mat\ProjSelectOutput data

            ProjectselectorUIFigureCloseRequest(app, event);
        end
    end

    % Component initialization
    methods (Access = private)

        % Create UIFigure and components
        function createComponents(app)

            % Create ProjectselectorUIFigure and hide until all components are created
            app.ProjectselectorUIFigure = uifigure('Visible', 'off');
            app.ProjectselectorUIFigure.Position = [100 100 356 297];
            app.ProjectselectorUIFigure.Name = 'Project selector';
            app.ProjectselectorUIFigure.CloseRequestFcn = createCallbackFcn(app, @ProjectselectorUIFigureCloseRequest, true);

            % Create SelectexitButton
            app.SelectexitButton = uibutton(app.ProjectselectorUIFigure, 'push');
            app.SelectexitButton.ButtonPushedFcn = createCallbackFcn(app, @SelectexitButtonPushed, true);
            app.SelectexitButton.Position = [129 27 100 23];
            app.SelectexitButton.Text = 'Select & exit';

            % Create ListofdetectedCANslavesListBoxLabel
            app.ListofdetectedCANslavesListBoxLabel = uilabel(app.ProjectselectorUIFigure);
            app.ListofdetectedCANslavesListBoxLabel.HorizontalAlignment = 'right';
            app.ListofdetectedCANslavesListBoxLabel.Position = [36 179 152 22];
            app.ListofdetectedCANslavesListBoxLabel.Text = 'List of detected CAN slaves';

            % Create ListofdetectedCANslavesListBox
            app.ListofdetectedCANslavesListBox = uilistbox(app.ProjectselectorUIFigure);
            app.ListofdetectedCANslavesListBox.Position = [30 65 275 115];

            % Create NoteTextArea
            app.NoteTextArea = uitextarea(app.ProjectselectorUIFigure);
            app.NoteTextArea.Visible = 'off';
            app.NoteTextArea.Position = [30 200 275 74];
            app.NoteTextArea.Value = {'Boots are present, the detected slaves list may be filtered to include only the next "have to download".'; 'Program all drives with valid FW to get slave picture'};

            % Show the figure after all components are created
            app.ProjectselectorUIFigure.Visible = 'on';
        end
    end

    % App creation and deletion
    methods (Access = public)

        % Construct app
        function app = ProjSelect_exported(varargin)

            runningApp = getRunningApp(app);

            % Check for running singleton app
            if isempty(runningApp)

                % Create UIFigure and components
                createComponents(app)

                % Register the app with App Designer
                registerApp(app, app.ProjectselectorUIFigure)

                % Execute the startup function
                runStartupFcn(app, @(app)startupFcn(app, varargin{:}))
            else

                % Focus the running singleton app
                figure(runningApp.ProjectselectorUIFigure)

                app = runningApp;
            end

            if nargout == 0
                clear app
            end
        end

        % Code that executes before app deletion
        function delete(app)

            % Delete UIFigure when app is deleted
            delete(app.ProjectselectorUIFigure)
        end
    end
end