function varargout = Package(varargin)
% PACKAGE MATLAB code for Package.fig
%      PACKAGE, by itself, creates a new PACKAGE or raises the existing
%      singleton*.
%
%      H = PACKAGE returns the handle to a new PACKAGE or the handle to
%      the existing singleton*.
%
%      PACKAGE('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in PACKAGE.M with the given input arguments.
%
%      PACKAGE('Property','Value',...) creates a new PACKAGE or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Package_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Package_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Package

% Last Modified by GUIDE v2.5 07-Sep-2022 09:32:06

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Package_OpeningFcn, ...
                   'gui_OutputFcn',  @Package_OutputFcn, ...
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

function ShowRadioDir(handles) 

set ( handles.EditIncidence , 'String' , num2str(handles.PackageIncidence,'%4.3f') );  
set ( handles.EditDepth , 'String' , num2str(handles.PackageDepth,'%4.3f') );  
switch handles.Direction  
    case 1
        set( handles.RadioRight , 'Value' , 1 ) ; 
        set( handles.RadioLeft , 'Value' , 0 ) ; 
    case 2
        set( handles.RadioRight , 'Value' , 0 ) ; 
        set( handles.RadioLeft , 'Value' , 1 ) ; 
end        

% --- Executes just before Package is made visible.
function Package_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Package (see VARARGIN)

% Choose default command line output for Package
handles.output = hObject;
handles.ComboString = { 'Push', 'Get', 'Standby', 'ResetManipPower','Repush' };
set( handles.ComboSelectJob,'String', handles.ComboString) ; 

handles.Direction = 1 ; 
handles.Action    = 1 ; 
handles.PackageDepth = 0.17 ; 
handles.PackageIncidence = 6   ; 

t1 = GetFloatPar( 'ManGeo.TimeInGoodCurrent4Pull','2')   ; 
t2 = GetFloatPar( 'ManGeo.TimeForEntireSuck','2' )   ; 
handles.SuckWaitSec = max([t2,t1])  ; 


set( handles.EditSuckWait , 'String' , num2str(handles.SuckWaitSec)  ); 


ShowRadioDir(handles) ; 
set( handles.ComboSelectJob ,'Value', handles.Action ) ; 

handles.actions = struct('None', [0,-1] , 'Standby' , [1,-1] , 'Repush' , [2,0] , 'GetRetry' , [3,1] , ...
    'Laser' , [4,-1] , 'ResetManipPower' , [8,-1] ,'Push',[14,0],'Get',[14,1],'RstCmd' , [15,-1] ) ; 
handles.sides   = struct('Right', 2 , 'Left' , 1 ) ; 
handles.styles  = struct('Object', 1 , 'SPI' , 2 ) ; 


handles.Geo = struct ( 'XDistWheelShoulderPivot', 0.24, 'YDistWheelShoulderPivot' , 0.28  ) ;

global DispT
if ~exist('DispT','var') || ~isa(DispT,'DlgTimerObj')
    evalin('base','AtpStart') ; 
end 
handles.EvtObj = DlgUserObj(@update_sw_display,hObject);
handles.EvtObj.listenToTimer(DispT) ;   
handles.Colors = struct( 'Grey', rgb('DarkGray'),'Green',rgb('Lime'),'Cyan' , rgb('Cyan') ,'Red' , rgb('Red')); 


% Update handles structure
guidata(hObject, handles);

% UIWAIT makes Package wait for user response (see UIRESUME)
% uiwait(handles.figure1);



function update_sw_display( hobj) 
    global TmMgrT
    handles = guidata(hobj) ; 

    try
    cnt = TmMgrT.GetCounter('PACKAGE') ; 

    if cnt < -1e5 
        delete( hobj) ; 
    else
        update_screen(handles) ; 
        TmMgrT.IncrementCounter('PACKAGE',2) ; 
    end     
        
    catch 
    end
    
function  x = update_screen(handles)
    x = 1 ; 
    

% --- Outputs from this function are returned to the command line.
function varargout = Package_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in RadioRight.
function RadioRight_Callback(hObject, eventdata, handles)
% hObject    handle to RadioRight (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of RadioRight
handles.Direction = 1 ; 
ShowRadioDir(handles) ; 
guidata(hObject, handles);


% --- Executes on button press in RadioLeft.
function RadioLeft_Callback(hObject, eventdata, handles)
% hObject    handle to RadioLeft (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of RadioLeft
handles.Direction = 2 ; 
ShowRadioDir(handles) ; 
guidata(hObject, handles);


% --- Executes on selection change in ComboSelectJob.
function ComboSelectJob_Callback(hObject, eventdata, handles)
% hObject    handle to ComboSelectJob (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns ComboSelectJob contents as cell array
%        contents{get(hObject,'Value')} returns selected item from ComboSelectJob


% --- Executes during object creation, after setting all properties.
function ComboSelectJob_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ComboSelectJob (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in ToggleGo.
function ToggleGo_Callback(hObject, eventdata, handles)
% hObject    handle to ToggleGo (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of ToggleGo
global DataType 
global RecStruct 
dirstr = {'Right','Left'} ;
action = handles.ComboString{get(handles.ComboSelectJob,'Value') } ;
ActInstruct = handles.actions.(action) ;

% Go to manual
SendObj( [hex2dec('220b'),2] , RecStruct.Enums.MotionModes.E_SysMotionModeManualTravel , DataType.long ,'Set to manual mode') ;

SimPack = struct('Action', ActInstruct(1) , 'Get', ActInstruct(2), 'Side' ,  handles.sides.(dirstr{handles.Direction}) , 'IncidenceDeg' , handles.PackageIncidence  , ...
    'PackageXOffset', -(handles.Geo.XDistWheelShoulderPivot+0.335) ,...
    'PackageDepth', handles.PackageDepth ) ; % 0.44-Geo.YDistWheelShoulderPivot ) ; 
    
    if ( SimPack.Get >= 0 ) 
        SendObj( [hex2dec('2207'),51] , SimPack.Get , DataType.long ,'Package get') ;
    end 
    
    ypos = SimPack.PackageDepth; 
    if SimPack.Side == 1
    %    ypos = -ypos ;
    end
    
    SendObj( [hex2dec('2207'),52] , SimPack.Side , DataType.long ,'Package side') ;
    SendObj( [hex2dec('2207'),53] , SimPack.IncidenceDeg * pi / 180  , DataType.float ,'Incidence Radians') ;
    SendObj( [hex2dec('2207'),54] , SimPack.PackageXOffset , DataType.float ,'X position') ;
    SendObj( [hex2dec('2207'),55] , ypos , DataType.float ,'Y position') ;
    SendObj( [hex2dec('2207'),56] , SimPack.Action , DataType.long ,'Action') ;
    % return 
    CrabCrawl = FetchObj( [hex2dec('2207'),60] , DataType.float ,'CrabCrawl cmd') ;
    if  CrabCrawl == 0 
        Rsteer = -FetchObj( [hex2dec('2204'),30] , DataType.float ,'Right steer angle') ;
        Lsteer = -FetchObj( [hex2dec('2204'),31] , DataType.float ,'Left steer angle') ;

        if ( abs(Rsteer) > 0.1 || abs(Lsteer) > 0.1 ) 
            ButtonName = questdlg({'After package handling', 'steering will return to zero','Continue?'}, ...
                         'What do you want', ...
                         'Continue', 'Abort', 'Abort');
           switch ButtonName
             case 'Abort'
                 return 
           end 
        end
    end 
    [~,RetStr] = SendObj( [hex2dec('2207'),60] , 1 , DataType.long ,'Activate package action') ;
    if ~isempty(RetStr) 
        uiwait(errordlg({'Could not command manipulator',RetStr}) ) ; 
    end


% --- If Enable == 'on', executes on mouse press in 5 pixel border.
% --- Otherwise, executes on mouse press in 5 pixel border or over TextPackDepth.
function TextPackDepth_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to TextPackDepth (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



function EditDepth_Callback(hObject, eventdata, handles)
% hObject    handle to EditDepth (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of EditDepth as text
%        str2double(get(hObject,'String')) returns contents of EditDepth as a double
try
    junk = str2num(get(handles.EditDepth,'String')) ; 
    if ( junk > 0 && junk < 0.6 )
        handles.PackageDepth = junk ; 
        guidata(hObject, handles);

    end 
catch
end
ShowRadioDir(handles) ;

% --- Executes during object creation, after setting all properties.
function EditDepth_CreateFcn(hObject, eventdata, handles)
% hObject    handle to EditDepth (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function EditIncidence_Callback(hObject, eventdata, handles)
% hObject    handle to EditIncidence (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of EditIncidence as text
%        str2double(get(hObject,'String')) returns contents of EditIncidence as a double
try
    junk = str2num( get( handles.EditIncidence,'String') ); 
    if ( junk >= -30 && junk < 30 )
        handles.PackageIncidence = junk ; 
        guidata(hObject, handles);
    end 
catch
end 
ShowRadioDir(handles) ; 


% --- Executes during object creation, after setting all properties.
function EditIncidence_CreateFcn(hObject, eventdata, handles)
% hObject    handle to EditIncidence (see GCBO)
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
delete( handles.EvtObj) ;


% --- Executes on slider movement.
function slider1_Callback(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function slider1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


function SetDebugAddAngle(AngDeg ) 
global DataType 
%     SendObj( [hex2dec('2207'),50] , ( AngDeg * pi / 180 ) , DataType.float ,'Package side') ; 

function SetSuckWait( TimeSec )
    SetFloatPar( 'ManGeo.TimeInGoodCurrent4Pull'  , TimeSec,'2')   ; 
    SetFloatPar( 'ManGeo.TimeForEntireSuck'  , TimeSec,'2')   ; 
    

% --- Executes on button press in PushZeroDebugAngle.
function PushZeroDebugAngle_Callback(hObject, eventdata, handles)
% hObject    handle to PushZeroDebugAngle (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

    

function EditAddAngleDeg_Callback(hObject, eventdata, handles)
% hObject    handle to EditAddAngleDeg (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%SetDebugAddAngle(handles.DebugAddAngle) ; 



% --- Executes during object creation, after setting all properties.
function EditAddAngleDeg_CreateFcn(hObject, eventdata, handles)
% hObject    handle to EditAddAngleDeg (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in PushDebugAngleSetValue.
function PushDebugAngleSetValue_Callback(hObject, eventdata, handles)



% --- Executes on button press in PushSuckWaitSetValue.
function PushSuckWaitSetValue_Callback(hObject, eventdata, handles)
% hObject    handle to PushSuckWaitSetValue (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



function EditSuckWait_Callback(hObject, eventdata, handles)
% hObject    handle to EditSuckWait (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of EditSuckWait as text
%        str2double(get(hObject,'String')) returns contents of EditSuckWait as a double
try
    junk = str2num( get( handles.EditSuckWait,'String') ); 
    if ( junk >= 0 && junk < 80 )
        handles.SuckWaitSec = junk ; 
        guidata(hObject, handles);
    end 
catch
end 
set(handles.EditSuckWait,'String', num2str(handles.SuckWaitSec) ) 
SetSuckWait(handles.SuckWaitSec) ; 


% --- Executes during object creation, after setting all properties.
function EditSuckWait_CreateFcn(hObject, eventdata, handles)
% hObject    handle to EditSuckWait (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton5.
function pushbutton5_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
