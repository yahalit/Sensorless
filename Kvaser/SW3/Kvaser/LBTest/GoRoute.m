function varargout = GoRoute(varargin)
% GOROUTE MATLAB code for GoRoute.fig
%      GOROUTE, by itself, creates a new GOROUTE or raises the existing
%      singleton*.
%
%      H = GOROUTE returns the handle to a new GOROUTE or the handle to
%      the existing singleton*.
%
%      GOROUTE('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GOROUTE.M with the given input arguments.
%
%      GOROUTE('Property','Value',...) creates a new GOROUTE or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before GoRoute_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to GoRoute_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help GoRoute

% Last Modified by GUIDE v2.5 15-Aug-2018 22:14:50

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @GoRoute_OpeningFcn, ...
                   'gui_OutputFcn',  @GoRoute_OutputFcn, ...
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


function UpdateRadio( handles , value  ) 
global DataType
if nargin < 2 
    value = handles.ManDesc.CrabCrawl; 
end 
arr = [0 0 0 ] ; 

arr( value + 2 ) = 1; 

set( handles.RadioCrabLeft, 'Value' , arr(1) ) ; 
set( handles.RadioDriveAhead, 'Value' , arr(2) ) ; 
set( handles.RadioCrabRight, 'Value' , arr(3) ) ; 
handles.ManDesc.CrabCrawl = value ; 

SendObj( [hex2dec('2207'),38] , 0.5 , DataType.float , 'Timeout for crab action' ) ;

try 
DriveIt (  handles.ManDesc) ; 
catch 
    uiwait( errordlg('Robot must be in the operational mode') ) ; 
    Stack = dbstack ; 
    Stack = Stack(1) ; 
    
    errstruct  = struct ('message','Could not load Ground Navigation dialog','identifier','CalibNeck:InitConditions','stack',Stack) ; 

    error(errstruct);    
end 
guidata(handles.hObject, handles);



% --- Executes just before GoRoute is made visible.
function GoRoute_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to GoRoute (see VARARGIN)

% Choose default command line output for GoRoute
handles.output = hObject;
global DataType
global TargetCanId

AtpStart ; 
handles.ManDesc = GetDrive( );
handles.UpdateDisplayActive = 1 ; 
handles.hObject = hObject ; 
guidata(hObject, handles);


    set( handles.EditCurvatureCmd,'String',num2str(handles.ManDesc.CurvatureCmd ) ) ; 
    set( handles.EditLineSpeedCmd,'String',num2str(handles.ManDesc.LineSpeedCmd ) ) ; 
    UpdateRadio( handles) ; 
    
    update_screen(handles) ; 


    global DispT
    if ~exist('DispT','var') || ~isa(DispT,'DlgTimerObj')
        evalin('base','AtpStart') ; 
    end 
    handles.EvtObj = DlgUserObj(@update_sw_display,hObject);
    handles.EvtObj.MylistenToTimer(DispT) ;   
    handles.Colors = struct( 'Grey', rgb('DarkGray'),'Green',rgb('Lime'),'Cyan' , rgb('Cyan') ,'Red' , rgb('Red')); 
    
% handles.timer = timer(...
%     'ExecutionMode', 'fixedSpacing', ...       % Run timer repeatedly.
%     'Period', AtpCfg.GuiTimerPeriod, ...                        % Initial period is 1 sec.
%     'TimerFcn', {@update_manroute_display,hObject}); % Specify callback function.% Update handles structure
guidata(hObject, handles);
% start (handles.timer) ;

% Update handles structure
guidata(hObject, handles);




function update_sw_display( hobj) 
    global TmMgrT
    handles = guidata(hobj) ; 

    try
    cnt = TmMgrT.GetCounter('GND_TRAVEL') ; 

    if cnt < -1e5 
        delete( hobj) ; 
    else
        update_screen(handles) ; 
        TmMgrT.IncrementCounter('GND_TRAVEL',2) ; 
    end     
        
    catch 
    end


% UIWAIT makes GoRoute wait for user response (see UIRESUME)
% uiwait(handles.figure1);
% function update_manroute_display( varargin) 
%     handles = guidata(varargin{3}) ; 
%     try
%     update_screen(handles) ; 
%     catch 
%     end
 
   
function update_screen(handles)    
    if  ~isfield(handles,'UpdateDisplayActive') || ~handles.UpdateDisplayActive 
        return ; 
    end 
    ManDesc = GetDrive(); 
    handles.ManDesc = ManDesc ; 
    RsteerReached = bitget ( ManDesc.GenStat, 1 ) ; 
    LsteerReached = bitget ( ManDesc.GenStat, 2 ) ; 
    RWStop = bitget ( ManDesc.GenStat, 3 ) ; 
    LWStop = bitget ( ManDesc.GenStat, 4 ) ; 
    NewCrabFlag  = bitget ( ManDesc.GenStat, 5 ) ; 
    CrabCrawl = sum( bitget ( ManDesc.GenStat, (6:7) ) .* [2,1] )  ; 
    InductiveR = bitget ( ManDesc.GenStat, 8 ) ; 
    InductiveL = bitget ( ManDesc.GenStat, 9 ) ; 
    
    set( handles.CheckTransition,'Value',NewCrabFlag ) ; 
    set( handles.CheckStopped,'Value',RWStop * LWStop ) ; 
    set( handles.CheckConverged,'Value',RsteerReached * LsteerReached ) ; 
    
    set( handles.CheckInductiveL,'Value',InductiveL) ; 
    set( handles.CheckInductiveR,'Value',InductiveR) ; 

    set( handles.TextLineSpeed,'String',num2str(ManDesc.LineSpeed)  ) ; 
    set( handles.TextCurvature,'String',num2str(ManDesc.Curvature)  ) ; 
    guidata(handles.hObject, handles);
    
%     DriveIt (  handles.ManDesc)

    
    
function SetCurvatureCmd(handles, inc, mode ) 
if nargin > 2  && ~isempty(mode)
    handles.ManDesc.CurvatureCmd = 0 ; 
end 
handles.ManDesc.CurvatureCmd = handles.ManDesc.CurvatureCmd + inc ; 
if abs(handles.ManDesc.CurvatureCmd) < 1e-3 
    handles.ManDesc.CurvatureCmd =  0 ; 
end

set( handles.EditCurvatureCmd,'String',num2str(handles.ManDesc.CurvatureCmd ) ) ;
DriveIt (  handles.ManDesc) ; 
guidata(handles.hObject, handles);
    
function SetLineSpeedCmd(handles, inc, mode ) 
if nargin > 2   && ~isempty(mode)
    handles.ManDesc.LineSpeedCmd = 0 ; 
end 
handles.ManDesc.LineSpeedCmd = handles.ManDesc.LineSpeedCmd + inc ;
if abs(handles.ManDesc.LineSpeedCmd) < 1e-3 
    handles.ManDesc.LineSpeedCmd = 0 ; 
end 

set( handles.EditLineSpeedCmd,'String',num2str(handles.ManDesc.LineSpeedCmd ) ) ; 
DriveIt (  handles.ManDesc) ; 
guidata(handles.hObject, handles);
    

% --- Outputs from this function are returned to the command line.
function varargout = GoRoute_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in PushUp10cmsec.
function PushUp10cmsec_Callback(hObject, eventdata, handles)
% hObject    handle to PushUp10cmsec (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
SetLineSpeedCmd(handles, 0.1);  

% --- Executes on button press in PushUp1cmsec.
function PushUp1cmsec_Callback(hObject, eventdata, handles)
% hObject    handle to PushUp1cmsec (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
SetLineSpeedCmd(handles, 0.01);  


% --- Executes on button press in PushDn10cmsec.
function PushDn10cmsec_Callback(hObject, eventdata, handles)
% hObject    handle to PushDn10cmsec (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
SetLineSpeedCmd(handles, -0.1);  


% --- Executes on button press in PushDn1cmsec.
function PushDn1cmsec_Callback(hObject, eventdata, handles)
% hObject    handle to PushDn1cmsec (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
SetLineSpeedCmd(handles, -0.01);  


% --- Executes on button press in PushUp1msec.
function PushUp1msec_Callback(hObject, eventdata, handles)
% hObject    handle to PushUp1msec (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
SetLineSpeedCmd(handles, 1);  


% --- Executes on button press in PushDn1msec.
function PushDn1msec_Callback(hObject, eventdata, handles)
% hObject    handle to PushDn1msec (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
SetLineSpeedCmd(handles, -1);  


% --- Executes on button press in PushUpRad10cm.
function PushUpRad10cm_Callback(hObject, eventdata, handles)
% hObject    handle to PushUpRad10cm (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
SetCurvatureCmd(handles, 0.1); 

% --- Executes on button press in PushUpRad1cm.
function PushUpRad1cm_Callback(hObject, eventdata, handles)
% hObject    handle to PushUpRad1cm (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
SetCurvatureCmd(handles, 0.01); 


% --- Executes on button press in PushDnRad10cm.
function PushDnRad10cm_Callback(hObject, eventdata, handles)
% hObject    handle to PushDnRad10cm (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
SetCurvatureCmd(handles, -0.1); 


% --- Executes on button press in PushDnRad1cm.
function PushDnRad1cm_Callback(hObject, eventdata, handles)
% hObject    handle to PushDnRad1cm (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
SetCurvatureCmd(handles, -0.01); 


% --- Executes on button press in PushUpRad1m.
function PushUpRad1m_Callback(hObject, eventdata, handles)
% hObject    handle to PushUpRad1m (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
SetCurvatureCmd(handles, 1); 


% --- Executes on button press in PushDnRad1m.
function PushDnRad1m_Callback(hObject, eventdata, handles)
% hObject    handle to PushDnRad1m (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
SetCurvatureCmd(handles, -1); 


% --- Executes on button press in PushButtonStop.
function PushButtonStop_Callback(hObject, eventdata, handles)
% hObject    handle to PushButtonStop (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
SetLineSpeedCmd(handles, 0,0); 



function EditLineSpeedCmd_Callback(hObject, eventdata, handles)
% hObject    handle to EditLineSpeedCmd (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of EditLineSpeedCmd as text
%        str2double(get(hObject,'String')) returns contents of EditLineSpeedCmd as a double
try 
value = str2num( get ( handles.EditLineSpeedCmd,'String')) ;
if ( value >= -2.5 && value <= 2.5 ) 
    SetLineSpeedCmd(handles, value,0); 
end 
catch
end 


% --- Executes during object creation, after setting all properties.
function EditLineSpeedCmd_CreateFcn(hObject, eventdata, handles)
% hObject    handle to EditLineSpeedCmd (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function EditCurvatureCmd_Callback(hObject, eventdata, handles)
% hObject    handle to EditCurvatureCmd (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of EditCurvatureCmd as text
%        str2double(get(hObject,'String')) returns contents of EditCurvatureCmd as a double
try 
value = str2num(get ( handles.EditCurvatureCmd,'String'))  ;
if ( value >= -2.5 && value <= 2.5 ) 
    SetCurvatureCmd(handles, value,0); 
end 
catch
end 

% --- Executes during object creation, after setting all properties.
function EditCurvatureCmd_CreateFcn(hObject, eventdata, handles)
% hObject    handle to EditCurvatureCmd (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end




function EditNeckCmd_Callback(hObject, eventdata, handles)
% hObject    handle to EditNeckCmd (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of EditNeckCmd as text
%        str2double(get(hObject,'String')) returns contents of EditNeckCmd as a double


% --- Executes during object creation, after setting all properties.
function EditNeckCmd_CreateFcn(hObject, eventdata, handles)
% hObject    handle to EditNeckCmd (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in RadioDriveAhead.
function RadioDriveAhead_Callback(hObject, eventdata, handles)
% hObject    handle to RadioDriveAhead (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of RadioDriveAhead
UpdateRadio( handles , 0  );

% --- Executes on button press in RadioCrabRight.
function RadioCrabRight_Callback(hObject, eventdata, handles)
% hObject    handle to RadioCrabRight (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of RadioCrabRight
UpdateRadio( handles , 1  );


% --- Executes on button press in RadioCrabLeft.
function RadioCrabLeft_Callback(hObject, eventdata, handles)
% hObject    handle to RadioCrabLeft (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of RadioCrabLeft
UpdateRadio( handles , -1  );


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


% --- Executes on button press in PushEmergency.
function PushEmergency_Callback(hObject, eventdata, handles)
% hObject    handle to PushEmergency (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global DataType
SendObj( [hex2dec('2220'),5] ,hex2dec('1234') , DataType.short , 'Wizard permission') ;
SendObj( [hex2dec('2220'),6] ,hex2dec('c820') , DataType.short , 'Cut motors') ; % Cut all the motors 
SendObj( [hex2dec('2220'),11] , 0  , DataType.short , 'Kill 54v') ; % Kill servo supply


% --- Executes during object deletion, before destroying properties.
function figure1_DeleteFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
try 
delete( handles.EvtObj) ;    
% stop  ( handles.timer )  ; 
% delete( handles.timer ) ; 
catch 
end
