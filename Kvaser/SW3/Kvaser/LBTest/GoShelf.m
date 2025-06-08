function varargout = GoShelf(varargin)
% GOSHELF MATLAB code for GoShelf.fig
%      GOSHELF, by itself, creates a new GOSHELF or raises the existing
%      singleton*.
%
%      H = GOSHELF returns the handle to a new GOSHELF or the handle to
%      the existing singleton*.
%
%      GOSHELF('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GOSHELF.M with the given input arguments.
%
%      GOSHELF('Property','Value',...) creates a new GOSHELF or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before GoShelf_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to GoShelf_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help GoShelf

% Last Modified by GUIDE v2.5 27-Apr-2018 13:46:28

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @GoShelf_OpeningFcn, ...
                   'gui_OutputFcn',  @GoShelf_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


function CheckMotionMode() 
% error ( 'CheckMotionMode MUST be implemented, to check motion at least manual') ; 
x  = 1 ;

function Chg = UpdateRadio( handles , value  ) 
global DataType
    if nargin < 2 || isempty(value)   
        value = FetchObj( [hex2dec('2207'),16] , DataType.float ,'Shelf mode') ;
        if ~any( value == [1,2,3,4,5,6] )
            value = 1 ; 
        end 
    end 
    
    Chg = 0 ;
    OldMode = handles.ModeCmd.ShelfMode ; 
    valueset = 0:6 ; 
    if ~any( value == valueset )
        return ;  % Protection 
    end 

    arr = valueset * 0  ; 
    arr( value + 1 ) = 1; 

    set( handles.RadioGroundNav, 'Value' , arr(1) ) ; 
    set( handles.RadioArc, 'Value' , arr(2) ) ; 
    set( handles.RadioPole, 'Value' , arr(3) ) ; 
    set( handles.RadioJunction, 'Value' , arr(4) ) ; 
    set( handles.RadioRunShelf, 'Value' , arr(5) ) ; 
    set( handles.RadioShelfAuto, 'Value' , arr(6) ) ; 
    set( handles.RadioJuncCorrect, 'Value' , arr(7) ) ; 
    
    handles.ModeCmd.ShelfMode =  value ; 
    % Mode switch implies an immediate stop
    if ~(OldMode == value ) 
        % CheckMotionMode() ; 
        % DriveIt (  handles.ManDesc,[],0) ; 
        Chg = 1;
    end 

%     set( handles.CheckLassieHome,'Value',0) ;
%     set( handles.CheckGoPackage,'Value',0) ;
    
    if (value == 4 || value == 5  )
        % Shelf run mode, enable lassie
        set( handles.CheckLassieHome,'Visible','On') ;
        set( handles.CheckGoPackage,'Visible','On') ;
        set( handles.EditPackPosM,'Visible','On') ;
        set( handles.TextLabelPosM,'Visible','On') ;
        
    else
        set( handles.CheckLassieHome,'Visible','Off') ;
        set( handles.CheckGoPackage,'Visible','Off') ;
        set( handles.EditPackPosM,'Visible','Off') ;
        set( handles.TextLabelPosM,'Visible','Off') ;
    end
        
    
    guidata(handles.hObject, handles);


% --- Executes just before GoShelf is made visible.
function GoShelf_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to GoShelf (see VARARGIN)

% Choose default command line output for GoShelf
global DataType 
handles.output = hObject;

AtpStart ; 
handles.ManDesc = GetDrive( [], 1 );
handles.ManDesc.FirstWheelCorr = 0 ; 
handles.ManDesc.FollowerCorrect = 0 ; 

handles.UpdateDisplayActive = 01 ; 
handles.hObject = hObject ; 
guidata(hObject, handles);

set( handles.EditFirstWheelCorr,'String',num2str(handles.ManDesc.FirstWheelCorr ) ) ; 
set( handles.EditArcSpeedCmd,'String',num2str(handles.ManDesc.ArcSpeed ) ) ; 
set( handles.EditFollowerCorrect,'String',num2str(handles.ManDesc.FollowerCorrect ) ) ; 
set( handles.EditShelfSpeed,'String',num2str(handles.ManDesc.ShelfSpeed ) ) ; 
set( handles.EditAcceleration,'String',num2str(handles.ManDesc.PoleLineAcc ) ) ; 

set( handles.EditNeckStretchGain,'String',num2str(handles.ManDesc.NeckStretchGain ) ) ; 
set( handles.EditLeaderSw2Twist,'String' , num2str(handles.ManDesc.LeaderSw2Twist) ) ; 
set( handles.EditShelfSeparation,'String' , num2str(handles.ManDesc.ShelfSeparation) ) ; 
set( handles.EditDistStopDown,'String' , num2str(handles.ManDesc.StopAfterLeaderEncountersSwM) ) ; 
set( handles.EditPackPosM,'String',num2str(handles.ManDesc.PackPosM) ) ; 


smode = FetchObj( [hex2dec('2207'),16] , DataType.float ,'Get Shelf mode') ;

handles.ModeCmd = struct('ShelfMode', smode ) ; % Assure life will start with a complete stop 
handles.AutoNeck =  FetchObj( [hex2dec('2207'),30] , DataType.float , 'AutoNeck' ) ;
set(handles.CheckAutoNeck,'Value',handles.AutoNeck) ; 

UpdateRadio( handles,handles.ModeCmd.ShelfMode) ; 


    RsteerAngle = FetchObj( [hex2dec('2204'),30] , DataType.float ,'RsteerAngle') ;
    LsteerAngle = FetchObj( [hex2dec('2204'),31] , DataType.float ,'LsteerAngle') ;
    handles.ManDesc.CrabCrawl = FetchObj( [hex2dec('2207'),10] , DataType.float ,'CrabCrawl');
    CrabPropose = 0 ; 
    if ( abs(RsteerAngle-pi/2) < 0.02 && abs(LsteerAngle-pi/2) ) 
        CrabPropose = -1; 
        str = 'Left' ; 
    end
    if ( abs(RsteerAngle+pi/2) < 0.02 && abs(LsteerAngle+pi/2) ) 
        CrabPropose = 1; 
        str = 'Right' ; 
    end
    
%     if ( CrabPropose == 0 )
%         errordlg('Steering angle is no good for shelf', 'Achalta Ota');
%         error ('So sad') ; 
%     end
%     
%     if ( handles.ManDesc.CrabCrawl == 0 ) 
%         ButtonName = questdlg({'You are entering shelf control';'But crabbing direction is not defined';...
%             ['Proceed at crab to the ',str,'?']}, ...
%                          'Attention', ...
%                          'Yes', 'No', 'No'  );
%         if ~isequal(ButtonName,'Yes') 
%             error ('So sad') ; 
%         end
%         handles.ManDesc.CrabCrawl = CrabPropose ; 
%         SendObj( [hex2dec('2207'),1] , handles.ManDesc.CrabCrawl , DataType.float , 'CrabCrawl') ;
%         guidata(hObject, handles);
%     end 


update_screen(handles) ; 
global AtpCfg 

handles.timer = timer(...
    'ExecutionMode', 'fixedSpacing', ...       % Run timer repeatedly.
    'Period', AtpCfg.GuiTimerPeriod , ...                        % Initial period is 1 sec.
    'TimerFcn', {@update_manroute_display,hObject}); % Specify callback function.% Update handles structure
guidata(hObject, handles);
start (handles.timer) ;

% Update handles structure
guidata(hObject, handles);


% UIWAIT makes GoShelf wait for user response (see UIRESUME)
% uiwait(handles.figure1);
function update_manroute_display( varargin) 
    handles = guidata(varargin{3}) ; 
    try
    update_screen(handles) ; 
    catch 
    end
 
   
function update_screen(handles) 
    global DataType 

    if  ~isfield(handles,'UpdateDisplayActive') || ~handles.UpdateDisplayActive 
        return ; 
    end 
    ManDesc = GetDrive([],1); 
    
    % AllowNeckFeedFw = bitget ( ManDesc.GenStat, 10 ); 
    AllowArcCorrect = bitget ( ManDesc.GenStat, 11 ); 
    set ( handles.CheckNormalActionStarting , 'Value' , AllowArcCorrect ) ; 
   
%     handles.ManDesc = ManDesc ; 
    RsteerReached = bitget ( ManDesc.GenStat, 1 ) ; 
    LsteerReached = bitget ( ManDesc.GenStat, 2 ) ; 
    RWStop = bitget ( ManDesc.GenStat, 3 ) ; 
    LWStop = bitget ( ManDesc.GenStat, 4 ) ; 
    NewCrabFlag  = bitget ( ManDesc.GenStat, 5 ) ; 
    % CrabCrawl = sum( bitget ( ManDesc.GenStat, (6:7) ) .* [2,1] )  ; 
    InductiveR = bitget ( ManDesc.GenStat, 8 ) ; 
    InductiveL = bitget ( ManDesc.GenStat, 9 ) ; 

    set( handles.CheckTransition,'Value',NewCrabFlag ) ; 
    set( handles.CheckStopped,'Value',RWStop * LWStop ) ; 
    set( handles.CheckConverged,'Value',RsteerReached * LsteerReached ) ; 
    
    set( handles.CheckInductiveL,'Value',InductiveL) ; 
    set( handles.CheckInductiveR,'Value',InductiveR) ; 

    set( handles.TextLineSpeed,'String',num2str(ManDesc.LineSpeed)  ) ; 

    NeckAngle = FetchObj( [hex2dec('2204'),32] , DataType.float ,'NeckAngle') ;
    set( handles.TextNeckAngle,'String', num2str(NeckAngle * 180 / pi )  ) ; 

    NeckDiff = FetchObj( [hex2dec('2204'),33] , DataType.float ,'NeckDiff') ;
    set( handles.TextNeckDiff,'String', num2str(NeckDiff * 180 / pi )  ) ; 
    
    Roll = FetchObj( [hex2dec('2204'),54] , DataType.float ,'Roll') ;
    set( handles.TextAccTilt,'String', num2str(Roll * 180 / pi )  ) ; 
    
    TravelM = 0 ; %% Vandal FetchObj( [hex2dec('2207'),200] , DataType.float ,'Travel Meters') ;
    set( handles.TextTravelM,'String', num2str(TravelM )  ) ; 
    
    SubMode = 0 ; %% Vandal FetchObj( [hex2dec('2207'),199] , DataType.float ,'SubMode') ;
    set( handles.TextSubmode,'String', num2str(SubMode )  ) ;

%     guidata(handles.hObject, handles);

    
   

% --- Outputs from this function are returned to the command line.
function varargout = GoShelf_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;




% --- Executes on button press in PushButtonStop.
function PushButtonStop_Callback(hObject, eventdata, handles)
% hObject    handle to PushButtonStop (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.ManDesc.Go = 0; 
CheckMotionMode() ; 
       DriveIt (  handles.ManDesc,[],handles.ModeCmd.ShelfMode) ; 



function EditArcSpeedCmd_Callback(hObject, eventdata, handles)
% hObject    handle to EditArcSpeedCmd (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of EditArcSpeedCmd as text
%        str2double(get(hObject,'String')) returns contents of EditArcSpeedCmd as a double
    try 
        value = str2num( get ( handles.EditArcSpeedCmd,'String')) ; %#ok<*ST2NM>
        if ( value >= -2.5 && value <= 2.5 ) 
            if abs(value) < 1e-3 , value = 0 ; end 
            handles.ManDesc.ArcSpeed = value ; 
            guidata(handles.hObject, handles);
        end 
    catch
    end 
    set( handles.EditArcSpeedCmd,'String' , num2str(handles.ManDesc.ArcSpeed) ) ; 


% --- Executes during object creation, after setting all properties.
function EditArcSpeedCmd_CreateFcn(hObject, eventdata, handles)
% hObject    handle to EditArcSpeedCmd (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function EditFirstWheelCorr_Callback(hObject, eventdata, handles)
% hObject    handle to EditFirstWheelCorr (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of EditFirstWheelCorr as text
%        str2double(get(hObject,'String')) returns contents of EditFirstWheelCorr as a double
% --- Executes during object creation, after setting all properties.
global DataType 
    try 
        value = str2num( get ( handles.EditFirstWheelCorr,'String')) ; %#ok<*ST2NM>
        ManDesc = handles.ManDesc ;
        if ( value >= -0.02  && value <= 0.02 ) 
            if abs(value) < 1e-4 , value = 0 ; end 
            ManDesc.FirstWheelCorr = value ; 
            handles.ManDesc = ManDesc ;

            SendObj( [hex2dec('2207'),31] , handles.ManDesc.FirstWheelCorr , DataType.float , 'FirstWheelCorr' ) ;
            
            guidata(handles.hObject, handles);
        end 
    catch
    end 
    set( handles.EditFirstWheelCorr,'String' , num2str(handles.ManDesc.FirstWheelCorr) ) ; 

function EditFirstWheelCorr_CreateFcn(hObject, eventdata, handles)
% hObject    handle to EditFirstWheelCorr (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



% --- Executes on button press in RadioArc.
function RadioArc_Callback(hObject, eventdata, handles)
% hObject    handle to RadioArc (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of RadioArc
global DataType 
if ( handles.ManDesc.CrabCrawl ==0 ) 
    ButtonName = questdlg('What is the crab state you want?', ...
                         'Crab=0 for climb...', ...
                         'Right', 'Left', 'Cancel', 'Cancel');
    if ( isequal( ButtonName  , 'Cancel'  ) )
        set( handles.RadioArc,'Value',0) ; 
        return ; 
    end 
    if ( isequal( ButtonName  , 'Right'  ) )
        handles.ManDesc.CrabCrawl = 1 ; 
    else
        handles.ManDesc.CrabCrawl = -1 ; 
    end 
    SendObj( [hex2dec('2207'),10] , handles.ManDesc.CrabCrawl , DataType.float ,'CrabCrawl cmd') ;
    SendObj( [hex2dec('2207'),99] , handles.ManDesc.CrabCrawl , DataType.float ,'CrabCrawl cmd') ;
end 


Aneck = FetchObj( [hex2dec('2207'),30] , DataType.float , 'AutoNeck' ) ;
if ( Aneck == 0 )
    ButtonName = questdlg({'Do you want';'Auto stablized neck?'}, ...
                         'It should be...', ...
                         'Yes', 'No', 'Yes');    
    if isequal(ButtonName,'Yes')    
        handles.AutoNeck = 1  ; 
        SendObj( [hex2dec('2207'),30] ,handles.AutoNeck , DataType.float , 'Auto neck get') ;
        set(handles.CheckAutoNeck,'Value',handles.AutoNeck) ; 
        guidata(handles.hObject, handles);
    end 
end 


UpdateRadio( handles , 1  );
handles.ManDesc.Go = 0; 

CheckMotionMode() ; 
	DriveIt(handles.ManDesc , [] ,1  ) ; 


% --- Executes on button press in CheckStopped.
function CheckStopped_Callback(hObject, eventdata, handles)
% hObject    handle to CheckStopped (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of CheckStopped


% --- Executes on button press in CheckConverged.
function CheckConverged_Callback(hObject, eventdata, handles)
% hObject    handle to CheckConverged (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of CheckConverged


% --- Executes on button press in CheckTransition.
function CheckTransition_Callback(hObject, eventdata, handles)
% hObject    handle to CheckTransition (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of CheckTransition


% --- Executes on button press in CheckInductiveR.
function CheckInductiveR_Callback(hObject, eventdata, handles)
% hObject    handle to CheckInductiveR (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of CheckInductiveR


% --- Executes on button press in CheckInductiveL.
function CheckInductiveL_Callback(hObject, eventdata, handles)
% hObject    handle to CheckInductiveL (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of CheckInductiveL


% --- Executes on button press in PushUp.
function PushUp_Callback(hObject, eventdata, handles)
% hObject    handle to PushUp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles.ManDesc.Go = 1; 
CheckMotionMode() ; 
DriveIt(handles.ManDesc , [] ,handles.ModeCmd.ShelfMode  ) ; 


% --- Executes on button press in PushDown.
function PushDown_Callback(hObject, eventdata, handles)
% hObject    handle to PushDown (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.ManDesc.Go = -1; 
CheckMotionMode() ; 
	DriveIt(handles.ManDesc , [] ,handles.ModeCmd.ShelfMode  ) ; 



function EditFollowerCorrect_Callback(hObject, eventdata, handles)
% hObject    handle to EditFollowerCorrect (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of EditFollowerCorrect as text
%        str2double(get(hObject,'String')) returns contents of EditFollowerCorrect as a double
global DataType 
    try 
        value = str2num( get ( handles.EditFollowerCorrect,'String')) ; 
        if ( value >= -0.02  && value <= 0.02 ) 
            if abs(value) < 1e-4 , value = 0 ; end 
            handles.ManDesc.FollowerCorrect = value ; 
            SendObj( [hex2dec('2207'),32] , handles.ManDesc.FollowerCorrect , DataType.float , 'FollowerCorrect' ) ;
            guidata(handles.hObject, handles);
        end 
    catch
    end 
    set( handles.EditFollowerCorrect,'String' , num2str(handles.ManDesc.FollowerCorrect) ) ; 




% --- Executes during object creation, after setting all properties.
function EditFollowerCorrect_CreateFcn(hObject, eventdata, handles)
% hObject    handle to EditFollowerCorrect (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function EditShelfSpeed_Callback(hObject, eventdata, handles)
% hObject    handle to EditShelfSpeed (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of EditShelfSpeed as text
%        str2double(get(hObject,'String')) returns contents of EditShelfSpeed as a double
    try 
        value = str2num( get ( handles.EditShelfSpeed,'String')) ; %#ok<*ST2NM>
        if ( value >= -2  && value <= 2 ) 
            if abs(value) < 1e-3 , value = 0 ; end 
            handles.ManDesc.ShelfSpeed = value ; 
            guidata(handles.hObject, handles);
        end 
    catch
    end 
    set( handles.EditShelfSpeed,'String' , num2str(handles.ManDesc.ShelfSpeed) ) ; 


% --- Executes during object creation, after setting all properties.
function EditShelfSpeed_CreateFcn(hObject, eventdata, handles)
% hObject    handle to EditShelfSpeed (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function EditDistStopDown_Callback(hObject, eventdata, handles)
% hObject    handle to EditDistStopDown (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of EditDistStopDown as text
%        str2double(get(hObject,'String')) returns contents of EditDistStopDown as a double
    try 
        value = str2num( get ( handles.EditDistStopDown,'String')) ; %#ok<*ST2NM>
        if ( value >= 0.01  && value <= 2 ) 
            handles.ManDesc.StopAfterLeaderEncountersSwM = value ; 
            guidata(handles.hObject, handles);
        end 
    catch
    end 
    set( handles.EditDistStopDown,'String' , num2str(handles.ManDesc.StopAfterLeaderEncountersSwM) ) ; 


% --- Executes during object creation, after setting all properties.
function EditDistStopDown_CreateFcn(hObject, eventdata, handles)
% hObject    handle to EditDistStopDown (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function EditNeckStretchGain_Callback(hObject, eventdata, handles)
% hObject    handle to EditNeckStretchGain (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of EditNeckStretchGain as text
%        str2double(get(hObject,'String')) returns contents of EditNeckStretchGain as a double
    try 
        value = str2num( get ( handles.EditNeckStretchGain,'String')) ; %#ok<*ST2NM>
        if ( value >= 2  && value <= 2 ) 
            if abs(value) < 1e-3 , value = 0 ; end 
            handles.ManDesc.NeckStretchGain = value ; 
            guidata(handles.hObject, handles);
        end 
    catch
    end 
    set( handles.EditNeckStretchGain,'String' , num2str(handles.ManDesc.NeckStretchGain) ) ; 


% --- Executes during object creation, after setting all properties.
function EditNeckStretchGain_CreateFcn(hObject, eventdata, handles)
% hObject    handle to EditNeckStretchGain (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function EditAcceleration_Callback(hObject, eventdata, handles)
% hObject    handle to EditAcceleration (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of EditAcceleration as text
%        str2double(get(hObject,'String')) returns contents of EditAcceleration as a double
    try 
        value = str2num( get ( handles.EditAcceleration,'String')) ; %#ok<*ST2NM>
        if ( value > 0   && value <= 2 ) 
            if abs(value) < 1e-3 , value = 0 ; end 
            handles.ManDesc.PoleLineAcc = value ; 
            guidata(handles.hObject, handles);
        end 
    catch
    end 
    set( handles.EditAcceleration,'String' , num2str(handles.ManDesc.PoleLineAcc) ) ; 


% --- Executes during object creation, after setting all properties.
function EditAcceleration_CreateFcn(hObject, eventdata, handles)
% hObject    handle to EditAcceleration (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in RadioPole.
function RadioPole_Callback(hObject, eventdata, handles)
% hObject    handle to RadioPole (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of RadioPole
chg = UpdateRadio( handles , 2  );
if ( chg ) 
    handles.ManDesc.Go = 0; 
    CheckMotionMode() ; 
    DriveIt (  handles.ManDesc,[],2) ; 
end 


% --- Executes on button press in RadioJunction.
function RadioJunction_Callback(hObject, eventdata, handles)
% hObject    handle to RadioJunction (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of RadioJunction
chg = UpdateRadio( handles , 3  );

if ( chg ) 
    handles.ManDesc.Go = 0; 
    CheckMotionMode() ; 
    DriveIt (  handles.ManDesc,[],3) ; 
end 


% --- Executes on button press in RadioRunShelf.
function RadioRunShelf_Callback(hObject, eventdata, handles)
% hObject    handle to RadioRunShelf (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of RadioRunShelf
% chg = UpdateRadio( handles , 4  );
% if ( chg ) 
%     handles.ManDesc.Go = 0; 
%     CheckMotionMode() ; 
%     DriveIt (  handles.ManDesc,[],4) ; 
% end 



% --- Executes on button press in RadioGroundNav.
function RadioGroundNav_Callback(hObject, eventdata, handles)
% hObject    handle to RadioGroundNav (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of RadioGroundNav
UpdateRadio( handles , 0  );
CheckMotionMode() ; 
DriveIt (  handles.ManDesc,[],0) ; 


% --- Executes on button press in CheckAutoNeck.
function CheckAutoNeck_Callback(hObject, eventdata, handles)
% hObject    handle to CheckAutoNeck (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of CheckAutoNeck
global DataType
val = get(handles.CheckAutoNeck,'Value') ; 
SendObj( [hex2dec('2207'),30] ,val , DataType.float , 'Auto neck get') ;
handles.AutoNeck = val ; 
guidata(handles.hObject, handles);


% --- Executes on button press in RadioJuncCorrect.
function RadioJuncCorrect_Callback(hObject, eventdata, handles)
% hObject    handle to RadioJuncCorrect (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of RadioJuncCorrect
chg = UpdateRadio( handles , 6  );

if ( chg ) 
    handles.ManDesc.Go = 0; 
    CheckMotionMode() ; 
    DriveIt (  handles.ManDesc,[],6) ; 
end 


% --- Executes on button press in PushEmergency.
function PushEmergency_Callback(hObject, eventdata, handles)
% hObject    handle to PushEmergency (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global DataType
SendObj( [hex2dec('2220'),5] ,hex2dec('1234') , DataType.short , 'Wizard permission') ;
SendObj( [hex2dec('2220'),6] ,hex2dec('c820') , DataType.short , 'Cut motors') ; % Cut all the motors 
SendObj( [hex2dec('2220'),11] , 0  , DataType.short , 'Kill 54v') ; % Kill servo supply



function EditLeaderSw2Twist_Callback(hObject, eventdata, handles)
% hObject    handle to EditLeaderSw2Twist (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of EditLeaderSw2Twist as text
%        str2double(get(hObject,'String')) returns contents of EditLeaderSw2Twist as a double
    try 
        value = str2num( get ( handles.EditLeaderSw2Twist,'String')) ; %#ok<*ST2NM>
        if ( value >= 0.01  && value <= 5 ) 
            handles.ManDesc.LeaderSw2Twist = value ; 
            guidata(handles.hObject, handles);
        end 
    catch
    end 
    set( handles.EditLeaderSw2Twist,'String' , num2str(handles.ManDesc.LeaderSw2Twist) ) ; 


% --- Executes during object creation, after setting all properties.
function EditLeaderSw2Twist_CreateFcn(hObject, eventdata, handles)
% hObject    handle to EditLeaderSw2Twist (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function EditShelfSeparation_Callback(hObject, eventdata, handles)
% hObject    handle to EditShelfSeparation (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of EditShelfSeparation as text
%        str2double(get(hObject,'String')) returns contents of EditShelfSeparation as a double
    try 
        value = str2num( get ( handles.EditShelfSeparation,'String')) ; %#ok<*ST2NM>
        if ( value >= 0.01  && value <= 1.0 ) 
            handles.ManDesc.ShelfSeparation = value ; 
            guidata(handles.hObject, handles);
        end 
    catch
    end 
    set( handles.EditShelfSeparation,'String' , num2str(handles.ManDesc.ShelfSeparation) ) ; 


% --- Executes during object creation, after setting all properties.
function EditShelfSeparation_CreateFcn(hObject, eventdata, handles)
% hObject    handle to EditShelfSeparation (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in CheckLassieHome.
function CheckLassieHome_Callback(hObject, eventdata, handles)
% hObject    handle to CheckLassieHome (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of CheckLassieHome
global DataType 
SendObj( [hex2dec('2207'),198] , 0 , DataType.float , 'Shelf position' ) ;

%     gohome = get( handles.CheckLassieHome,'Value') ; 
%     set( handles.CheckGoPackage,'Value',0) ; 
%     if gohome, 
%         SendObj( [hex2dec('2207'),23] , handles.ManDesc.ShelfSpeed , DataType.float , 'ShelfSpeed' ) ;
%         SendObj( [hex2dec('2207'),199] , 1 , DataType.float , 'Submode to Lassie' ) ;
%     else
%         SendObj( [hex2dec('2207'),23] , 0 , DataType.float , 'ShelfSpeed' ) ;
%         SendObj( [hex2dec('2207'),199] , 0 , DataType.float , 'Submode to Normal (Lassie off)' ) ;
%     end 
    


% --- Executes on button press in CheckGoPackage.
function CheckGoPackage_Callback(hObject, eventdata, handles)
% hObject    handle to CheckGoPackage (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of CheckGoPackage
global DataType 
SendObj( [hex2dec('2207'),197] , handles.ManDesc.PackPosM , DataType.float , 'Shelf position' ) ;


%     packmode = get( handles.CheckGoPackage,'Value') ; 
%     set( handles.CheckLassieHome,'Value',0) ; 
%     if packmode, 
%         SendObj( [hex2dec('2207'),23] , handles.ManDesc.ShelfSpeed , DataType.float , 'ShelfSpeed' ) ;
%         SendObj( [hex2dec('2207'),199] , 2 , DataType.float , 'Submode to package' ) ;
%     else
%         SendObj( [hex2dec('2207'),199] , 0 , DataType.float , 'Submode to Normal (package off)' ) ;
%     end 



function EditPackPosM_Callback(hObject, eventdata, handles)
% hObject    handle to EditPackPosM (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of EditPackPosM as text
%        str2double(get(hObject,'String')) returns contents of EditPackPosM as a double
    try 
        value = str2num( get ( handles.EditPackPosM,'String')) ; %#ok<*ST2NM>
        if ( value >= -10  && value <= 10 ) 
            handles.ManDesc.PackPosM = value ; 
            guidata(handles.hObject, handles);
        end 
    catch
    end 
    set( handles.EditPackPosM,'String' , num2str(handles.ManDesc.PackPosM) ) ; 


% --- Executes during object creation, after setting all properties.
function EditPackPosM_CreateFcn(hObject, eventdata, handles)
% hObject    handle to EditPackPosM (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object deletion, before destroying properties.
function figure1_DeleteFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
stop (handles.timer) ;
delete (handles.timer) ;


% --- Executes on button press in CheckNormalActionStarting.
function CheckNormalActionStarting_Callback(hObject, eventdata, handles)
% hObject    handle to CheckNormalActionStarting (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of CheckNormalActionStarting
global DataType ; 
state = get(handles.CheckNormalActionStarting,'Value') ; 
if  state 
    SendObj( [hex2dec('2220'),41] , 1 , DataType.short , 'Set allow distance correction' ) ;
else
    SendObj( [hex2dec('2220'),41] , 0 , DataType.short , 'Set dis-allow distance correction' ) ;
end 


% --- Executes on button press in PushStartClimbMode.
function PushStartClimbMode_Callback(hObject, eventdata, handles)
% hObject    handle to PushStartClimbMode (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in RadioShelfAuto.
function RadioShelfAuto_Callback(hObject, eventdata, handles)
% hObject    handle to RadioShelfAuto (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of RadioShelfAuto
chg = UpdateRadio( handles , 5  );
if ( chg ) 
    handles.ManDesc.Go = 0; 
    CheckMotionMode() ; 
    DriveIt (  handles.ManDesc,[],5) ; 
end 
