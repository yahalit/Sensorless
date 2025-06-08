classdef BurnIdentity_exported < matlab.apps.AppBase

    % Properties that correspond to app components
    properties (Access = public)
        UIFigure                        matlab.ui.Figure
        ValidDatabaseLamp               matlab.ui.control.Lamp
        ValidDatabaseLampLabel          matlab.ui.control.Label
        ProblemTextArea                 matlab.ui.control.TextArea
        ValidIdentityLamp               matlab.ui.control.Lamp
        ValidIdentityLampLabel          matlab.ui.control.Label
        TabGroup                        matlab.ui.container.TabGroup
        IdentityTab                     matlab.ui.container.Tab
        ClearIdentityButton             matlab.ui.control.Button
        NowRevButton                    matlab.ui.control.Button
        NowProdButton                   matlab.ui.control.Button
        ProjTypeEditField               matlab.ui.control.EditField
        ProjTypeEditFieldLabel          matlab.ui.control.Label
        HardwaretypeEditField           matlab.ui.control.NumericEditField
        HardwaretypeEditFieldLabel      matlab.ui.control.Label
        WarningTextArea                 matlab.ui.control.TextArea
        WarningTextAreaLabel            matlab.ui.control.Label
        DownloadButton                  matlab.ui.control.Button
        DatabasePanel                   matlab.ui.container.Panel
        SNEditField                     matlab.ui.control.NumericEditField
        SNEditFieldLabel                matlab.ui.control.Label
        CardnameEditField               matlab.ui.control.EditField
        CardnameEditFieldLabel          matlab.ui.control.Label
        SelectButton                    matlab.ui.control.Button
        WriteButton                     matlab.ui.control.Button
        ReadButton                      matlab.ui.control.Button
        FilenameEditField               matlab.ui.control.EditField
        FilenameEditFieldLabel          matlab.ui.control.Label
        ChecksumEditField               matlab.ui.control.NumericEditField
        ChecksumEditFieldLabel          matlab.ui.control.Label
        IdentityrevisionEditField       matlab.ui.control.EditField
        IdentityrevisionEditFieldLabel  matlab.ui.control.Label
        ProductionBatchcodeEditField    matlab.ui.control.NumericEditField
        ProductionBatchcodeEditFieldLabel  matlab.ui.control.Label
        SerialnumberEditField           matlab.ui.control.NumericEditField
        SerialnumberEditFieldLabel      matlab.ui.control.Label
        HardwarerevisionDropDown        matlab.ui.control.DropDown
        HardwarerevisionDropDownLabel   matlab.ui.control.Label
        RevisiondateDatePicker          matlab.ui.control.DatePicker
        RevisiondateDatePickerLabel     matlab.ui.control.Label
        ProductiondateDatePicker        matlab.ui.control.DatePicker
        ProductiondateDatePickerLabel   matlab.ui.control.Label
        SelectroleintherobotTab         matlab.ui.container.Tab
        DownloadandsaveButton           matlab.ui.control.Button
        ProjecttypeDropDown             matlab.ui.control.DropDown
        ProjecttypeDropDownLabel        matlab.ui.control.Label
        IdentityBurnerLabel             matlab.ui.control.Label
    end

    
    properties (Access = private)
        IsValidIdentity % Description
        IdRevision % Description
        OldCheckSum % Description
        DataType  % Description
        ProjType % Description
        HardRevs % Description
        FracasFile % 
        FracasDataStore   % Description
        CardTypeSheet % Description
        SNList % Description
        FracasData % Description
        ProjNames % Description
        ProjNumbers % Description
        HardwareRevision % Description
        ProductionDate % Description
        RevisionDate % Description
        HardwareType 
        SerialNumber % Description
        ProductionBatchCode % Description
        ThisCard % Description
        IsValidDbase % Description
        ProjId % Description
        CreateStruct % Description
    end
    
    methods (Access = private)
        
        function code = Date2Code(~,date)
             vec = fix(datevec( date)) ;
             code = (vec(1)-2000)*2^16+vec(2)*2^8 + vec(3)  ; 
        end
        
        function date = Code2Date(~,code)
            day = mod(code,256) ; 
            mon = mod ((code - day)/256, 256); 
            yr  = mod ((code - mon * 256 - day)/65536 , 256); 
            date = datetime( yr , mon , day ) ; 
        end
        
        function str = Rev2String(~,rev)
            rev = fix( max(rev,0) ); 
            str = [ num2str(bitand(rev,256*255)/256),'.',num2str(bitand(rev,255))]; 
        end

        function str = HardRev2String(~,rev)
            str = [ num2str(rev(1)),'.',num2str(rev(2))]; 
        end
        
        
        
        function str = Proj2String(~,code)
            switch(code)
                case hex2dec('9300') 
                    str = "Neck" ; 
                case hex2dec('9400') 
                    str = "WheelServo" ; 
                case hex2dec('9600') 
                    str = "TapeArm" ; 
                case hex2dec('9900') 
                    str = "Interface" ; 
                otherwise
                    str = "Unknown" ; 
            end
        end
        
        function errmsg = TestValidity(app)
            errmsg = [] ; 
            try 
                FetchObj( [hex2dec('2301') ,5],app.DataType.long,'Get Project type' ); 
            catch 
                evalin('base','AtpStartNew');
            end 

            XProjType = FetchObj( [hex2dec('2301') ,5],app.DataType.long,'Get Project type' ); 
            [~,IsOperational]    = GetProjTypeString( XProjType ) ;
            if ~IsOperational
                errmsg = 'Encountered a BOOT';
                return ; 
            end 

            app.IsValidIdentity = FetchObj([hex2dec('2303'),251],app.DataType.long,'Identity valid') ; 
            app.IsValidDbase    = FetchObj([hex2dec('2303'),252],app.DataType.long,'Database valid') ; 
            app.IdRevision = FetchObj([hex2dec('2303'),254],app.DataType.long,'Identity revision') ; 
            app.ThisCard = FetchObj([hex2dec('2301'),8],app.DataType.long,'ThisCard') ; 
            app.IdentityrevisionEditField.Value = app.Rev2String(app.IdRevision) ; 
            app.ProjId= FetchObj([hex2dec('2303'),32],app.DataType.long,'ProjId') ; 
            if ( app.IsValidIdentity )

                % Get the Hardware revision , production date, Revision data
                % Hardware type, serial number, production batch code
                app.HardwareRevision = FetchObj([hex2dec('2303'),2],app.DataType.long,'HardwareRevision') ;  % Description
                app.ProductionDate = Code2Date(app,FetchObj([hex2dec('2303'),3],app.DataType.long,'ProductionDate')) ;  % Description
                app.RevisionDate = Code2Date(app,FetchObj([hex2dec('2303'),4],app.DataType.long,'RevisionDate')) ; % Description
                app.HardwareType = FetchObj([hex2dec('2303'),5],app.DataType.long,'HardwareType')  ;
                app.SerialNumber = FetchObj([hex2dec('2303'),6],app.DataType.long,'SerialNumber') ; % Description
                app.ProductionBatchCode = FetchObj([hex2dec('2303'),7],app.DataType.long,'ProductionBatchCode') ;  % Description
                app.OldCheckSum = FetchObj([hex2dec('2303'),253],app.DataType.long,'Identity revision') ; 
                app.ChecksumEditField.Value = app.OldCheckSum ; 
                %app.UploadButton.Visible = 1 ; 

                % Check identity data makes sense 
                if ( app.HardwareType ~= app.ThisCard  ) 
                    app.ProblemTextArea.Value   = "Problem: Hardware type and card type mismatch" ; 
                    app.ProblemTextArea.Visible = 'on' ; 
                    app.IsValidIdentity  = 0 ; 
                end 

                if ( app.HardwareRevision < 0 || app.HardwareRevision > 65535 ) 
                    app.ProblemTextArea.Value   = "Problem: Hardware revision out of range" ; 
                    app.ProblemTextArea.Visible = 'on' ; 
                    app.IsValidIdentity  = 0 ; 
                else
                    x = mod(app.HardwareRevision ,256 ) ; 
                    y = (app.HardwareRevision - x) / 256 ; 
                    app.HardwareRevision = [y,x] ; 
                end 
            end

            if ~app.IsValidIdentity
                app.IsValidDbase = 0 ; 
            end

            if ( app.IsValidDbase )
               app.ValidDatabaseLamp.Color = [0 1 0] ; 
            else
               app.ValidDatabaseLamp.Color = [1 0 0] ; 
            end

            if ( app.IsValidIdentity )
                app.ValidIdentityLamp.Color = [0 1 0] ; 
            else
                app.ValidIdentityLamp.Color = [1 0 0 ] ;
                app.ChecksumEditField.Visible = 'off' ; 
                app.OldCheckSum = 2^32 - 1 ; 
                %app.UploadButton.Visible = 'off' ;             
                app.HardwareRevision = [2,1] ;% Description
                app.ProductionDate = datetime("now")  ;
                app.RevisionDate = app.ProductionDate  ; % Description
                app.HardwareType = app.ThisCard  ;
                app.SerialNumber = 1 ; % Description
                app.ProductionBatchCode = 0 ;  % Description
            end
            
        end
        
        function value = GetListValue( ~,ctl )
            val = ctl.Value ; 
            list = ctl.Items ; 
            value = find( strcmp(list,val) , 1); 
        end
        
        function ok = FillIdTable(app)
            n = app.SNEditField.Value ;
            f = find (n==app.SNList (:,1)) ; 
            if ~(length(f) == 1 ) 
                ok = 0 ; 
                return ; 
            end 
            ok = 1 ; 
            row = pp.SNList(f,2) ; 
            HwVersion = GetHwVersion(app,row) ; 
            if isempty(HwVersion) 
                ok = 0; 
            end
            [m,~] = size( app.HardRevs ) ; 
            found = [] ; 
            for cnt = 1:m 
                if isequal(HwVersion,app.HardRevs(cnt,:)) 
                    found = cnt ;
                    break ; 
                end
            end 
            if isempty(found) 
                app.HardRevs = [app.HardRevs ; HwVersion]; 
                app.HardwarerevisionDropDown.Items = {   app.HardwarerevisionDropDown.Items  , app.HardRev2String(app.HardRevs(found,:)) } ;
                found = m+ 1; 
            end 
            app.HardwarerevisionDropDown.Value = app.HardwarerevisionDropDown.Items{found} ;
        end

        
        function results = GetHwVersion(app,row)
            hdr = app.FracasData(1,:) ; 
            col = find( strcmp(hdr,'HW rev') , 1 ) ; 
            num = app.FracasData{row,col} ; 
            str = num2str(num) ; 
            place = strfind( str,'.');
            if isempty(place)
                num2 = 0 ; 
            else
                num2 = fix( str2double(str(place+1:end) ) ) ; 
            end
            num = fix(num) ; 
            if ( num < 0 ||num > 255 || num2 < 0 ||num2 > 255 )
                results = [] ; 
            else
                results = [ fix(num) , fix(num2)  ];
            end 
        end
        
        function isok = isgoodprojname(app,name)
            isok = 0 ; 
            if contains(lower(name),'boot')
                return ; 
            end 

            if app.ProjType == hex2dec('9900')
                if contains( lower(name),'intfc')
                    isok = 1 ; 
                end
                return ; 
            end 
            if app.ProjType == hex2dec('9400')
                % Wheel 
                switch app.ProjId
                    case 1
                        if contains( lower(name),'type_wheel_')
                            isok = 1 ; 
                        end
                    case 2
                        if contains( lower(name),'type_steer')
                            isok = 1 ; 
                        end
                    case 3
                        if contains( lower(name),'type_wheel_')
                            isok = 1 ; 
                        end
                    case 4
                        if contains( lower(name),'type_steer')
                            isok = 1 ; 
                        end
                end
                return ; 
            end
            if app.ProjType == hex2dec('9300')
                % Steer 
                if ~contains( lower(name),'type_steer') && ~contains( lower(name),'type_wheel_') && ...
                        ~contains( lower(name),'intfc')
                    isok = 1 ; 
                end
                return ; 
            end

        end
    end
    

    % Callbacks that handle component events
    methods (Access = private)

        % Code that executes after component creation
        function startupFcn(app)
            
            global AtpCfg ; %#ok<GVMIS> 
            app.CreateStruct = struct('Interpreter','tex','WindowStyle' , 'modal') ; 
            app.DataType = GetDataType() ;

            evalin('base','AtpStartNew');

            try 
                errmsg = app.TestValidity();
            catch 
                UIFigureCloseRequest(app) ; 
                h= errordlg({'\fontsize{12}Cannot establish communication','Maybe only boot is loaded?',...
                    'You need operational SW.','Aborting'},'Error',struct('Interpreter','tex','WindowStyle' , 'modal')) ;
                while isvalid(h) 
                    pause(0.2) ; 
                end 
                return 
            end 
            if ~isempty(errmsg) 
                UIFigureCloseRequest(app) ; 
                h= msgbox({'errmsg','Aborting'}) ; 
                while isvalid(h) 
                    pause(0.2) ; 
                end 
                return 
            end 

            app.HardRevs = [2,1] ; 
            [m,~] = size(app.HardRevs) ; 
            if app.IsValidIdentity
                for cnt = 1:m 
                    if isequal( app.HardRevs(cnt,:) , app.HardwareRevision ) 
                        app.HardRevs(cnt,:) = [] ; 
                        break ; 
                    end
                end 
                app.HardRevs = [app.HardwareRevision ; app.HardRevs  ] ; 
            end
                        
            [m,~] = size(app.HardRevs) ; 
            hitems = cell(1,m) ; 
            for cnt = 1:m 
                hitems{cnt} = app.HardRev2String(app.HardRevs(cnt,:)); 
            end 
            app.HardwarerevisionDropDown.Items = hitems ;  
            app.HardwarerevisionDropDown.Value = hitems{1} ; 
            
            app.ProductiondateDatePicker.Value = app.ProductionDate; 
            app.RevisiondateDatePicker.Value = app.RevisionDate ; 
            app.HardwaretypeEditField.Value = app.HardwareType ; 
            app.SerialnumberEditField.Value = app.SerialNumber ; 
            app.ProductionBatchcodeEditField.Value = app.ProductionBatchCode ; 

            app.ProjType = FetchObj([hex2dec('2301'),5],app.DataType.long,'Project type') ; 
            app.ProjId = FetchObj([hex2dec('2303'),32],app.DataType.long,'Project ID') ; 
            if  mod( app.ProjType, 256 ) 
                h= msgbox({'Identified boot project','Need operational project to work'}) ; 
                while isvalid(h) 
                    pause(0.2) ; 
                end 
                UIFigureCloseRequest(app) ;
            end

            str = app.Proj2String(app.ProjType) ; 

            nS = find( strcmp(["Neck","TapeArm","WheelServo","Interface"] ,str), 1 ); 
            if isempty(nS) 
                uiwait( msgbox('You have a boot or an unknown project')  ) ; 
                app.UIFigureCloseRequest(app); 
                app.ProjTypeEditField.Value = 'Unknown' ;  
            else
                app.ProjTypeEditField.Value = str ;  
            end 


            l = length(AtpCfg.ProjListWithBoot); 
            app.ProjNumbers = zeros(1,l); 
            app.ProjNames = string( app.ProjNumbers ) ; 

            next = 0 ; 
             
            for cnt = 1:l 
                nextname = AtpCfg.ProjListWithBoot{cnt};
                if  isgoodprojname(app,nextname) 
                    next = next+1 ;
                    app.ProjNumbers(next) = cnt ; 
                    app.ProjNames(next) = nextname ; 
                end 
            end 
            app.ProjNumbers = app.ProjNumbers(1:next) ; 
            app.ProjNames = app.ProjNames(1:next) ; 

            app.ProjecttypeDropDown.Items = app.ProjNames  ; 
            app.ProjecttypeDropDown.Value = app.ProjNames( find(app.ProjNumbers==app.ProjId) ) ; 

            app.SNEditField.Visible = 'off' ;                
            %evalin('base','AtpStartNew') ; 


        end

        % Button pushed function: DownloadButton
        function DownloadButtonPushed(app, event)
            SendObj([hex2dec('2303'),1],hex2dec('12345678'),app.DataType.long,'Password'); 
            s = strsplit(app.HardwarerevisionDropDown.Value,'.') ; 
            hardver = str2double(s{1})* 256 + str2double(s{2}) ; 
            SendObj([hex2dec('2303'),2],hardver,app.DataType.long,'Hardware revision'); 
            % proddate = convertTo(app.ProductiondateDatePicker.Value, 'datenum')  ; 
            SendObj([hex2dec('2303'),3],app.Date2Code(app.ProductiondateDatePicker.Value),app.DataType.long,'Production date'); 
            % revdate = convertTo( app.RevisiondateDatePicker.Value, 'datenum')    ; 
            SendObj([hex2dec('2303'),4],app.Date2Code(app.RevisiondateDatePicker.Value),app.DataType.long,'Revision date'); 
            SendObj([hex2dec('2303'),5],app.HardwareType,app.DataType.long,'Hardware type'); 
            SendObj([hex2dec('2303'),6],app.SerialnumberEditField.Value,app.DataType.long,'ProductionBatchCode[0]'); 
            SendObj([hex2dec('2303'),7],app.ProductionBatchcodeEditField.Value,app.DataType.long,'ProductionBatchCode[1]'); 
            SendObj([hex2dec('2303'),253],1,app.DataType.long,'Burn identity'); 

            app.TestValidity();

            % Kill (reset) calibration 
            junk = SaveCalib(0);
            ProgCalib( junk ,1,struct('ProjType','NotLp','NoDoneMsg',1)) ; 

            h = msgbox({'\fontsize{12} Identity downloaded','Power Off/On', 'before starting motor'},app.CreateStruct) ; 
            while (isvalid(h)) 
                pause(0.2 ) ; 
            end 

        end

        % Close request function: UIFigure
        function UIFigureCloseRequest(app, event)
            delete(app)
            
        end

        % Button pushed function: DownloadandsaveButton
        function DownloadandsaveButtonPushed(app, event)
            if ~app.IsValidIdentity
                h = msgbox({'Please set identidy','Before setting parameters'}) ; 
                while (isvalid(h)) 
                    pause(0.2 ) ; 
                end 
                app.TabGroup.SelectedTab = app.IdentityTab ; 
                return ;
            end 
                        
            SendObj([hex2dec('2304'),1],hex2dec('12345678'),app.DataType.long,'Password'); 
            nextitem = app.ProjNumbers( app.GetListValue(app.ProjecttypeDropDown)) ; 
            SendObj([hex2dec('2304'),250],nextitem,app.DataType.long,'Password'); 
            SendObj([hex2dec('2304'),253],1,app.DataType.long,'Password'); 
            try 
                % Not expected to return, set new CAN ID if applicable 
                SendObj([hex2dec('2304'),254],1,app.DataType.long,'Password'); 
            catch 
            end 
            h = msgbox({'\fontsize{12}Parameters downloaded','Power Off/On', 'before starting motor'},app.CreateStruct) ; 
            while (isvalid(h)) 
                pause(0.2 ) ; 
            end 

            if  ~isequal(app.ProjecttypeDropDown.Value ,app.ProjNames( find(app.ProjNumbers==app.ProjId) ) )
                evalin('base','AtpStartNew') ; 
            end 


            % CAN Target ID may be now changed , so we need run target identification again 
            app.TestValidity();
           
        end

        % Button pushed function: SelectButton
        function SelectButtonPushed(app, event)
             [~,~,~,~,~,~,FracasDir] = GetProjDirInfo(); 
            [filename, pathname] = uigetfile({'*.xlsx'},'Select Excel File for card registration',[FracasDir,'Fracas.xlsx']);
            if isequal(filename,0)
                return ; 
            end 
            app.FracasFile = [pathname,filename] ;
            app.FracasDataStore = spreadsheetDatastore(app.FracasFile); 
            try 
                datapass = DataPassHandle() ; 
                projlist = sheetnames(app.FracasDataStore ,app.FracasFile) ; 
                for cnt = length(projlist):-1:1
                    if ~startsWith(projlist{cnt},'CardType') 
                        projlist(cnt) = [] ; 
                    end
                end 
                datapass.DataArea =  struct('List',projlist,'Value',[])   ; 
                h = SelectFromList(datapass) ; 
                while isvalid(h)
                    pause(0.1); 
                end
                app.CardTypeSheet = datapass.DataArea.Value ; 
                if ~isempty(app.CardTypeSheet) 
                    app.FilenameEditField.Value = app.FracasFile ; 
                    app.CardnameEditField.Value = app.CardTypeSheet ; 
                    app.FracasData = readcell(app.FracasFile,'Sheet',app.CardTypeSheet ,'Range','A:L');
                    SNTab = app.FracasData(:,1) ;
                    Slist = zeros( length(SNTab) , 2 )  ; 
                    numsn = 0 ; 
                    for cnt = 1:length(SNTab)
                        if isnumeric(SNTab{cnt}) 
                            numsn = numsn + 1 ; 
                            Slist(numsn,1) = SNTab{cnt} ; 
                            Slist(numsn,2) = cnt ; 
                        end 
                    end 
                    app.SNList = Slist(1:numsn,:) ; 
                    app.SNEditField.Value = app.SNList(1,1) ;
                    app.SNEditField.Visible = 'on' ; 
                    app.FillIdTable();
                end 
            catch 
            end
            clear datapass ; 
        end

        % Button pushed function: NowProdButton
        function NowProdButtonPushed(app, event)
            app.ProductiondateDatePicker.Value = datetime("now") ;
            ProductiondateDatePickerValueChanged(app,event) ; 
        end

        % Button pushed function: NowRevButton
        function NowRevButtonPushed(app, event)
            app.RevisiondateDatePicker.Value =  datetime("now") ;
            RevisiondateDatePickerValueChanged(app,event) ; 

        end

        % Value changed function: ProductiondateDatePicker
        function ProductiondateDatePickerValueChanged(app, event)
            value = app.ProductiondateDatePicker.Value;
            app.ProductionDate = value ; 

        end

        % Value changed function: RevisiondateDatePicker
        function RevisiondateDatePickerValueChanged(app, event)
            value = app.RevisiondateDatePicker.Value;
            app.RevisionDate = value ;
        end

        % Button pushed function: ClearIdentityButton
        function ClearIdentityButtonPushed(app, event)
            SendObj([hex2dec('2303'),252],12345,app.DataType.long,'Clear Identity'); 
            SendObj([hex2dec('2304'),252],12345,app.DataType.long,'Clear Parameters'); 
            TestValidity(app);
        end

        % Button down function: SelectroleintherobotTab
        function SelectroleintherobotTabButtonDown(app, event)
            % Set the drop list to the correct project 
        end
    end

    % Component initialization
    methods (Access = private)

        % Create UIFigure and components
        function createComponents(app)

            % Create UIFigure and hide until all components are created
            app.UIFigure = uifigure('Visible', 'off');
            app.UIFigure.Position = [100 100 707 660];
            app.UIFigure.Name = 'MATLAB App';
            app.UIFigure.CloseRequestFcn = createCallbackFcn(app, @UIFigureCloseRequest, true);

            % Create IdentityBurnerLabel
            app.IdentityBurnerLabel = uilabel(app.UIFigure);
            app.IdentityBurnerLabel.FontSize = 18;
            app.IdentityBurnerLabel.FontWeight = 'bold';
            app.IdentityBurnerLabel.FontAngle = 'italic';
            app.IdentityBurnerLabel.FontColor = [1 0.4118 0.1608];
            app.IdentityBurnerLabel.Position = [67 541 133 23];
            app.IdentityBurnerLabel.Text = 'Identity Burner';

            % Create TabGroup
            app.TabGroup = uitabgroup(app.UIFigure);
            app.TabGroup.Position = [68 57 596 470];

            % Create IdentityTab
            app.IdentityTab = uitab(app.TabGroup);
            app.IdentityTab.Title = 'Identity';

            % Create ProductiondateDatePickerLabel
            app.ProductiondateDatePickerLabel = uilabel(app.IdentityTab);
            app.ProductiondateDatePickerLabel.HorizontalAlignment = 'right';
            app.ProductiondateDatePickerLabel.Position = [109 366 89 22];
            app.ProductiondateDatePickerLabel.Text = 'Production date';

            % Create ProductiondateDatePicker
            app.ProductiondateDatePicker = uidatepicker(app.IdentityTab);
            app.ProductiondateDatePicker.ValueChangedFcn = createCallbackFcn(app, @ProductiondateDatePickerValueChanged, true);
            app.ProductiondateDatePicker.Position = [213 366 150 22];

            % Create RevisiondateDatePickerLabel
            app.RevisiondateDatePickerLabel = uilabel(app.IdentityTab);
            app.RevisiondateDatePickerLabel.HorizontalAlignment = 'right';
            app.RevisiondateDatePickerLabel.Position = [121 325 78 22];
            app.RevisiondateDatePickerLabel.Text = 'Revision date';

            % Create RevisiondateDatePicker
            app.RevisiondateDatePicker = uidatepicker(app.IdentityTab);
            app.RevisiondateDatePicker.ValueChangedFcn = createCallbackFcn(app, @RevisiondateDatePickerValueChanged, true);
            app.RevisiondateDatePicker.Position = [214 325 150 22];

            % Create HardwarerevisionDropDownLabel
            app.HardwarerevisionDropDownLabel = uilabel(app.IdentityTab);
            app.HardwarerevisionDropDownLabel.HorizontalAlignment = 'right';
            app.HardwarerevisionDropDownLabel.Position = [110 407 102 22];
            app.HardwarerevisionDropDownLabel.Text = 'Hardware revision';

            % Create HardwarerevisionDropDown
            app.HardwarerevisionDropDown = uidropdown(app.IdentityTab);
            app.HardwarerevisionDropDown.Position = [215 407 151 22];

            % Create SerialnumberEditFieldLabel
            app.SerialnumberEditFieldLabel = uilabel(app.IdentityTab);
            app.SerialnumberEditFieldLabel.HorizontalAlignment = 'right';
            app.SerialnumberEditFieldLabel.Position = [102 246 79 22];
            app.SerialnumberEditFieldLabel.Text = 'Serial number';

            % Create SerialnumberEditField
            app.SerialnumberEditField = uieditfield(app.IdentityTab, 'numeric');
            app.SerialnumberEditField.Position = [214 246 149 22];

            % Create ProductionBatchcodeEditFieldLabel
            app.ProductionBatchcodeEditFieldLabel = uilabel(app.IdentityTab);
            app.ProductionBatchcodeEditFieldLabel.HorizontalAlignment = 'right';
            app.ProductionBatchcodeEditFieldLabel.Position = [54 211 126 22];
            app.ProductionBatchcodeEditFieldLabel.Text = 'Production Batch code';

            % Create ProductionBatchcodeEditField
            app.ProductionBatchcodeEditField = uieditfield(app.IdentityTab, 'numeric');
            app.ProductionBatchcodeEditField.Position = [213 211 149 22];

            % Create IdentityrevisionEditFieldLabel
            app.IdentityrevisionEditFieldLabel = uilabel(app.IdentityTab);
            app.IdentityrevisionEditFieldLabel.HorizontalAlignment = 'right';
            app.IdentityrevisionEditFieldLabel.Position = [54 173 91 22];
            app.IdentityrevisionEditFieldLabel.Text = 'Identity  revision';

            % Create IdentityrevisionEditField
            app.IdentityrevisionEditField = uieditfield(app.IdentityTab, 'text');
            app.IdentityrevisionEditField.Editable = 'off';
            app.IdentityrevisionEditField.Position = [214 173 148 22];

            % Create ChecksumEditFieldLabel
            app.ChecksumEditFieldLabel = uilabel(app.IdentityTab);
            app.ChecksumEditFieldLabel.HorizontalAlignment = 'right';
            app.ChecksumEditFieldLabel.Position = [86 137 62 22];
            app.ChecksumEditFieldLabel.Text = 'Checksum';

            % Create ChecksumEditField
            app.ChecksumEditField = uieditfield(app.IdentityTab, 'numeric');
            app.ChecksumEditField.Editable = 'off';
            app.ChecksumEditField.Position = [214 137 148 22];

            % Create DatabasePanel
            app.DatabasePanel = uipanel(app.IdentityTab);
            app.DatabasePanel.Title = 'Database';
            app.DatabasePanel.Position = [21 1 517 124];

            % Create FilenameEditFieldLabel
            app.FilenameEditFieldLabel = uilabel(app.DatabasePanel);
            app.FilenameEditFieldLabel.HorizontalAlignment = 'right';
            app.FilenameEditFieldLabel.Position = [25 52 58 22];
            app.FilenameEditFieldLabel.Text = 'File name';

            % Create FilenameEditField
            app.FilenameEditField = uieditfield(app.DatabasePanel, 'text');
            app.FilenameEditField.Position = [30 31 480 22];

            % Create ReadButton
            app.ReadButton = uibutton(app.DatabasePanel, 'push');
            app.ReadButton.Position = [266 72 100 23];
            app.ReadButton.Text = 'Read';

            % Create WriteButton
            app.WriteButton = uibutton(app.DatabasePanel, 'push');
            app.WriteButton.Position = [153 72 100 23];
            app.WriteButton.Text = 'Write';

            % Create SelectButton
            app.SelectButton = uibutton(app.DatabasePanel, 'push');
            app.SelectButton.ButtonPushedFcn = createCallbackFcn(app, @SelectButtonPushed, true);
            app.SelectButton.Position = [28 72 100 23];
            app.SelectButton.Text = 'Select';

            % Create CardnameEditFieldLabel
            app.CardnameEditFieldLabel = uilabel(app.DatabasePanel);
            app.CardnameEditFieldLabel.HorizontalAlignment = 'right';
            app.CardnameEditFieldLabel.Position = [28 7 67 22];
            app.CardnameEditFieldLabel.Text = 'Card name ';

            % Create CardnameEditField
            app.CardnameEditField = uieditfield(app.DatabasePanel, 'text');
            app.CardnameEditField.Position = [110 7 157 22];

            % Create SNEditFieldLabel
            app.SNEditFieldLabel = uilabel(app.DatabasePanel);
            app.SNEditFieldLabel.HorizontalAlignment = 'right';
            app.SNEditFieldLabel.Position = [370 73 25 22];
            app.SNEditFieldLabel.Text = 'SN';

            % Create SNEditField
            app.SNEditField = uieditfield(app.DatabasePanel, 'numeric');
            app.SNEditField.Position = [410 73 100 22];

            % Create DownloadButton
            app.DownloadButton = uibutton(app.IdentityTab, 'push');
            app.DownloadButton.ButtonPushedFcn = createCallbackFcn(app, @DownloadButtonPushed, true);
            app.DownloadButton.Position = [473 366 100 23];
            app.DownloadButton.Text = 'Download';

            % Create WarningTextAreaLabel
            app.WarningTextAreaLabel = uilabel(app.IdentityTab);
            app.WarningTextAreaLabel.HorizontalAlignment = 'right';
            app.WarningTextAreaLabel.FontColor = [1 0 0];
            app.WarningTextAreaLabel.Position = [423 335 49 22];
            app.WarningTextAreaLabel.Text = 'Warning';

            % Create WarningTextArea
            app.WarningTextArea = uitextarea(app.IdentityTab);
            app.WarningTextArea.FontColor = [1 0 0];
            app.WarningTextArea.Position = [423 276 150 60];
            app.WarningTextArea.Value = {'Downloading identity will reset any existing calibration'};

            % Create HardwaretypeEditFieldLabel
            app.HardwaretypeEditFieldLabel = uilabel(app.IdentityTab);
            app.HardwaretypeEditFieldLabel.HorizontalAlignment = 'right';
            app.HardwaretypeEditFieldLabel.Position = [116 286 83 22];
            app.HardwaretypeEditFieldLabel.Text = 'Hardware type';

            % Create HardwaretypeEditField
            app.HardwaretypeEditField = uieditfield(app.IdentityTab, 'numeric');
            app.HardwaretypeEditField.Editable = 'off';
            app.HardwaretypeEditField.Position = [214 286 148 22];

            % Create ProjTypeEditFieldLabel
            app.ProjTypeEditFieldLabel = uilabel(app.IdentityTab);
            app.ProjTypeEditFieldLabel.HorizontalAlignment = 'right';
            app.ProjTypeEditFieldLabel.Position = [403 246 55 22];
            app.ProjTypeEditFieldLabel.Text = 'Proj Type';

            % Create ProjTypeEditField
            app.ProjTypeEditField = uieditfield(app.IdentityTab, 'text');
            app.ProjTypeEditField.Editable = 'off';
            app.ProjTypeEditField.Position = [473 246 100 22];

            % Create NowProdButton
            app.NowProdButton = uibutton(app.IdentityTab, 'push');
            app.NowProdButton.ButtonPushedFcn = createCallbackFcn(app, @NowProdButtonPushed, true);
            app.NowProdButton.Position = [368 366 48 23];
            app.NowProdButton.Text = 'Now';

            % Create NowRevButton
            app.NowRevButton = uibutton(app.IdentityTab, 'push');
            app.NowRevButton.ButtonPushedFcn = createCallbackFcn(app, @NowRevButtonPushed, true);
            app.NowRevButton.Position = [368 324 48 23];
            app.NowRevButton.Text = 'Now';

            % Create ClearIdentityButton
            app.ClearIdentityButton = uibutton(app.IdentityTab, 'push');
            app.ClearIdentityButton.ButtonPushedFcn = createCallbackFcn(app, @ClearIdentityButtonPushed, true);
            app.ClearIdentityButton.Position = [472 406 100 23];
            app.ClearIdentityButton.Text = 'Clear Identity';

            % Create SelectroleintherobotTab
            app.SelectroleintherobotTab = uitab(app.TabGroup);
            app.SelectroleintherobotTab.Title = 'Select role in the robot';
            app.SelectroleintherobotTab.ButtonDownFcn = createCallbackFcn(app, @SelectroleintherobotTabButtonDown, true);

            % Create ProjecttypeDropDownLabel
            app.ProjecttypeDropDownLabel = uilabel(app.SelectroleintherobotTab);
            app.ProjecttypeDropDownLabel.HorizontalAlignment = 'right';
            app.ProjecttypeDropDownLabel.Position = [40 395 71 22];
            app.ProjecttypeDropDownLabel.Text = 'Project  type';

            % Create ProjecttypeDropDown
            app.ProjecttypeDropDown = uidropdown(app.SelectroleintherobotTab);
            app.ProjecttypeDropDown.Position = [126 395 238 22];

            % Create DownloadandsaveButton
            app.DownloadandsaveButton = uibutton(app.SelectroleintherobotTab, 'push');
            app.DownloadandsaveButton.ButtonPushedFcn = createCallbackFcn(app, @DownloadandsaveButtonPushed, true);
            app.DownloadandsaveButton.Position = [138 345 122 23];
            app.DownloadandsaveButton.Text = 'Download and save';

            % Create ValidIdentityLampLabel
            app.ValidIdentityLampLabel = uilabel(app.UIFigure);
            app.ValidIdentityLampLabel.HorizontalAlignment = 'right';
            app.ValidIdentityLampLabel.Position = [537 553 73 22];
            app.ValidIdentityLampLabel.Text = 'Valid Identity';

            % Create ValidIdentityLamp
            app.ValidIdentityLamp = uilamp(app.UIFigure);
            app.ValidIdentityLamp.Position = [625 553 20 20];

            % Create ProblemTextArea
            app.ProblemTextArea = uitextarea(app.UIFigure);
            app.ProblemTextArea.FontColor = [1 0 0];
            app.ProblemTextArea.BackgroundColor = [1 1 0];
            app.ProblemTextArea.Visible = 'off';
            app.ProblemTextArea.Position = [67 26 559 24];

            % Create ValidDatabaseLampLabel
            app.ValidDatabaseLampLabel = uilabel(app.UIFigure);
            app.ValidDatabaseLampLabel.HorizontalAlignment = 'right';
            app.ValidDatabaseLampLabel.Position = [524 592 86 22];
            app.ValidDatabaseLampLabel.Text = 'Valid Database';

            % Create ValidDatabaseLamp
            app.ValidDatabaseLamp = uilamp(app.UIFigure);
            app.ValidDatabaseLamp.Position = [625 592 20 20];

            % Show the figure after all components are created
            app.UIFigure.Visible = 'on';
        end
    end

    % App creation and deletion
    methods (Access = public)

        % Construct app
        function app = BurnIdentity_exported

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