function varargout = TestSw(varargin)
% TESTSW MATLAB code for TestSw.fig
%      TESTSW, by itself, creates a new TESTSW or raises the existing
%      singleton*.
%
%      H = TESTSW returns the handle to a new TESTSW or the handle to
%      the existing singleton*.
%
%      TESTSW('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in TESTSW.M with the given input arguments.
%
%      TESTSW('Property','Value',...) creates a new TESTSW or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before TestSw_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to TestSw_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help TestSw

% Last Modified by GUIDE v2.5 13-Jul-2022 18:13:12

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @TestSw_OpeningFcn, ...
                   'gui_OutputFcn',  @TestSw_OutputFcn, ...
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


% --- Executes just before TestSw is made visible.
function TestSw_OpeningFcn(hObject, ~, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to TestSw (see VARARGIN)

% Choose default command line output for TestSw
% global LsTimer 
global DispT
global DataType 
% global AtpCfg

handles.output = hObject;
% try 
%     stop(LsTimer) ; 
% end 

% handles.timer = LsTimer ; 
% set( LsTimer, ...
%     'ExecutionMode', 'fixedSpacing', ...       % Run timer repeatedly.
%     'Period', AtpCfg.GuiTimerPeriod , ...                        % Initial period is 1 sec.
%     'TimerFcn', {@update_sw_display,hObject}); % Specify callback function.% Update handles structure

if ~exist('DispT','var') || ~isa(DispT,'DlgTimerObj')
    evalin('base','AtpStart') ; 
end 
handles.EvtObj = DlgUserObj(@update_sw_display,hObject);
handles.EvtObj.listenToTimer(DispT) ; 
    
handles.Colors = struct( 'Grey', rgb('DarkGray'),'Green',rgb('Lime'),'Cyan' , rgb('Cyan') ,'Red' , rgb('Red')); 
SendObj( [hex2dec('2222'),2] , 1 , DataType.long , 'Start SW recording' ) ;
handles.RecordLength = 20 ; 
handles.RecStruct = [] ; 

handles.Meter2WheelEncoder = FetchObj( [hex2dec('2226'),12] , DataType.float , 'Get Meter2WheelEncoder') ;
%handles.Meter2WheelEncoder  = ( GetFloatPar('Geom.WheelCntRad') * GetFloatPar('Geom.WheelMotCntRadRail') ) / ...
%        (GetFloatPar('Geom.rrailnom') * GetFloatPar('Geom.WheelMotCntRadGnd')) ; 
handles.Wheel2EncoderMeter = 1 / handles.Meter2WheelEncoder ; 


set(handles.EditRecordLen,'String',num2str(handles.RecordLength)) ;
set(handles.CheckFastRecsUpload,'Value',1) ; 


% start(LsTimer) ; 


% Update handles structure
guidata(hObject, handles);

% UIWAIT makes TestSw wait for user response (see UIRESUME)
% uiwait(handles.figure1);
% UIWAIT makes BIT wait for user response (see UIRESUME)
% uiwait(handles.figure1);
function update_sw_display( hobj) 
    global TmMgrT
    handles = guidata(hobj) ; 

    try
    cnt = TmMgrT.GetCounter('TESTSW') ; 

    if cnt < -1e5 
        delete( hobj) ; 
    else
        update_screen(handles) ; 
        TmMgrT.IncrementCounter('TESTSW',2) ; 
    end     
        
    catch 
    end
 
   
function update_screen(handles) 
global DataType
RCaptEncoderL =  FetchObj( [hex2dec('2220'),101] , DataType.long ,'Right CaptEncoderL') ;
RCaptEncoderH =  FetchObj( [hex2dec('2220'),102] , DataType.long ,'Right CaptEncoderH') ;
RStatRaw = FetchObj( [hex2dec('2220'),103] , DataType.long ,'Right Stat') ;
LCaptEncoderL =  FetchObj( [hex2dec('2220'),104] , DataType.long ,'Left CaptEncoderL') ;
LCaptEncoderH =  FetchObj( [hex2dec('2220'),105] , DataType.long ,'Left CaptEncoderH') ;
LStatRaw = FetchObj( [hex2dec('2220'),106] , DataType.long ,'Left Stat') ;

REncoder=  FetchObj( [hex2dec('2204'),20] , DataType.float ,'Right encoder') ;
LEncoder=  FetchObj( [hex2dec('2204'),21] , DataType.float ,'Left encoder') ;


s99 = FetchObj( [hex2dec('2000'),99] , DataType.short ,'Get records state') ; 
%         s99= KvaserCom( 8 , [1536+TargetCanId ,1408+TargetCanId ,8192,99,DataType.short,0,100] ); % Get records
if ( s99 == 23 ) 
    RecReady = 1 ; % Activated and ready 
    set( handles.PushBringRecorder,'Visible','on');
    set( handles.CheckFastRecsUpload,'Visible','on');
else
    RecReady = 0 ; 
    set( handles.PushBringRecorder,'Visible','off');
    set( handles.CheckFastRecsUpload,'Visible','off');
end 

set(handles.CheckRecorderReady,'Value',RecReady) ; 

set( handles.TextRightEnc,'String',num2str(REncoder)) ; 
set( handles.TextLeftEnc,'String',num2str(LEncoder)) ; 

next = RStatRaw; 
RStat = struct('ExpectedDir',bitget(next,[1:2])*[1;2] , 'FallMarker',bitget(next,3) ,'RiseMarker' ,...
    bitget(next,4),'PresentValue' ,bitget(next,5),'InductiveSensor',bitget(next,6),'DetectMarker',bitget(next,7)); 
next = LStatRaw; 
LStat = struct('ExpectedDir',bitget(next,[1:2])*[1;2] , 'FallMarker',bitget(next,3) ,'RiseMarker' ,...
    bitget(next,4),'PresentValue' ,bitget(next,5),'InductiveSensor',bitget(next,6),'DetectMarker',bitget(next,7)); 
 

% 
% if  RStat.RiseMarker
%     set( handles.TextRightEncH,'BackgroundColor', handles.Colors.Cyan ,'String',num2str(RCaptEncoderH) ) ;     set(handles.CheckRightH,'Value', 1 )  ; 
% else
%     set(handles.CheckRightH,'Value', 0 )  ; 
%     set( handles.TextRightEncH,'BackgroundColor', handles.Colors.Grey ,'String','') ; 
% end 
% 
% if RStat.FallMarker
%     set( handles.TextRightEncL,'BackgroundColor', handles.Colors.Cyan ,'String',num2str(RCaptEncoderL)) ; 
%     set(handles.CheckRightL,'Value', 1 )  ; 
% else
%     set( handles.TextRightEncL,'BackgroundColor', handles.Colors.Grey ,'String','') ; 
%     set(handles.CheckRightL,'Value', 0 )  ; 
% end 

% if LStat.RiseMarker
%     set(handles.CheckLeftH,'Value', 1 )  ; 
%     set( handles.TextLeftEncH,'BackgroundColor', handles.Colors.Cyan ,'String',num2str(LCaptEncoderH)) ; 
% else
%     set( handles.TextLeftEncH,'BackgroundColor', handles.Colors.Grey ,'String','') ; 
%     set(handles.CheckLeftH,'Value', 0 )  ; 
% end 

% if LStat.FallMarker
%     set(handles.CheckLeftL,'Value', 1 )  ;
%     set( handles.TextLeftEncL,'BackgroundColor', handles.Colors.Cyan ,'String',num2str(LCaptEncoderL)) ; 
% else
%     set(handles.CheckLeftL,'Value', 0 )  ;
%     set( handles.TextLeftEncL,'BackgroundColor', handles.Colors.Grey ,'String','') ; 
% end 


if RStat.PresentValue 
    set( handles.TextRSwOn,'BackgroundColor', handles.Colors.Green,'String','On') ; 
else
    set( handles.TextRSwOn,'BackgroundColor', handles.Colors.Grey,'String','Off') ; 
end
if LStat.PresentValue 
    set( handles.TextLSwOn,'BackgroundColor', handles.Colors.Green,'String','On') ; 
else
    set( handles.TextLSwOn,'BackgroundColor', handles.Colors.Grey,'String','Off') ; 
end

if RStat.DetectMarker
    set( handles.TextRightEncCenter,'BackgroundColor', handles.Colors.Grey ,'String','') ; 
    set( handles.TextInvRight,'BackgroundColor', handles.Colors.Grey ,'String','') ; 
    switch RStat.ExpectedDir 
        case 1
            set( handles.PushArmRightFor,'BackgroundColor', handles.Colors.Green ) ; 
            set( handles.PushArmRightBack,'BackgroundColor', handles.Colors.Grey ) ; 
        case 3
            set( handles.PushArmRightFor,'BackgroundColor', handles.Colors.Grey ) ; 
            set( handles.PushArmRightBack,'BackgroundColor', handles.Colors.Green ) ; 
    end
else
    set( handles.PushArmRightFor,'BackgroundColor', handles.Colors.Grey ) ; 
    set( handles.PushArmRightBack,'BackgroundColor', handles.Colors.Grey ) ; 
    set( handles.TextRightEncCenter,'BackgroundColor', handles.Colors.Cyan ,'String',num2str(mean([RCaptEncoderL,RCaptEncoderH]) ) ) ;         
    encwidth = abs(RCaptEncoderL-RCaptEncoderH) ; 
    if ( encwidth) 
        set( handles.TextInvRight,'BackgroundColor', handles.Colors.Green ,'String',encwidth * handles.Wheel2EncoderMeter ) ; 
        %set( handles.TextInvRight,'BackgroundColor', handles.Colors.Grey ,'String',num2str(1/ encwidth)) ; 
    else
        set( handles.TextInvRight,'BackgroundColor', handles.Colors.Grey ,'String','' ) ; 
    end
    set( handles.TextRightEncL,'String',num2str(RCaptEncoderL)) ; 
    set( handles.TextRightEncH,'String',num2str(RCaptEncoderH)) ; 
    
end


if LStat.DetectMarker
    set( handles.TagLeftEncCenter,'BackgroundColor', handles.Colors.Grey ,'String','') ; 
    set( handles.TextInvLeft,'BackgroundColor', handles.Colors.Grey ,'String','') ; 

    switch LStat.ExpectedDir 
        case 1
            set( handles.PushArmLeftForward,'BackgroundColor', handles.Colors.Green ) ; 
            set( handles.PushArmLeftBack,'BackgroundColor', handles.Colors.Grey ) ; 
        case 3
            set( handles.PushArmLeftForward,'BackgroundColor', handles.Colors.Grey ) ; 
            set( handles.PushArmLeftBack,'BackgroundColor', handles.Colors.Green ) ; 
    end 
else
    set( handles.PushArmLeftForward,'BackgroundColor', handles.Colors.Grey ) ; 
    set( handles.PushArmLeftBack,'BackgroundColor', handles.Colors.Grey ) ; 
    set( handles.TagLeftEncCenter,'BackgroundColor', handles.Colors.Cyan ,'String',num2str(mean([LCaptEncoderL,LCaptEncoderH]) ) ) ; 
    encwidth = abs(LCaptEncoderL-LCaptEncoderH) ; 
    if ( encwidth) 
        set( handles.TextInvLeft,'BackgroundColor', handles.Colors.Green ,'String',encwidth * handles.Wheel2EncoderMeter ) ; 
        % set( handles.TextInvLeft,'BackgroundColor', handles.Colors.Grey ,'String',num2str(1/ encwidth)) ; 
    else
        set( handles.TextInvRight,'BackgroundColor', handles.Colors.Grey ,'String','' ) ; 
    end 
    set( handles.TextLeftEncL,'String',num2str(LCaptEncoderL)) ; 
    set( handles.TextLeftEncH,'String',num2str(LCaptEncoderH)) ; 
end





% --- Outputs from this function are returned to the command line.
function varargout = TestSw_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in PushArmRightFor.
function PushArmRightFor_Callback(hObject, eventdata, handles)
% hObject    handle to PushArmRightFor (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global DataType ; 
SendObj( [hex2dec('2220'),42] , 1 , DataType.long ,'Arm right forward') ;

% --- Executes on button press in PushArmLeftForward.
function PushArmLeftForward_Callback(hObject, eventdata, handles)
% hObject    handle to PushArmLeftForward (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global DataType ; 
SendObj( [hex2dec('2220'),43] , 1 , DataType.long ,'Arm left forward') ;



% --- Executes on button press in CheckRightH.
function CheckRightH_Callback(hObject, eventdata, handles)
% hObject    handle to CheckRightH (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of CheckRightH


% --- Executes on button press in CheckRightL.
function CheckRightL_Callback(hObject, eventdata, handles)
% hObject    handle to CheckRightL (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of CheckRightL


% --- Executes on button press in PushArmRightBack.
function PushArmRightBack_Callback(hObject, eventdata, handles)
% hObject    handle to PushArmRightBack (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global DataType ; 
SendObj( [hex2dec('2220'),42] , -1 , DataType.long ,'Arm right back') ;


% --- Executes on button press in PushArmLeftBack.
function PushArmLeftBack_Callback(hObject, eventdata, handles)
% hObject    handle to PushArmLeftBack (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global DataType ; 
SendObj( [hex2dec('2220'),43] , -1 , DataType.long ,'Arm left back') ;


% --- Executes on button press in CheckLeftH.
function CheckLeftH_Callback(hObject, eventdata, handles)
% hObject    handle to CheckLeftH (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of CheckLeftH

% --- Executes on button press in CheckLeftL.
function CheckLeftL_Callback(hObject, eventdata, handles)
% hObject    handle to CheckLeftL (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of CheckLeftL


% --- Executes during object deletion, before destroying properties.
function figure1_DeleteFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% global LsTimer 
% stop(LsTimer)
global DataType 
SendObj( [hex2dec('2222'),2] , 0 , DataType.long , 'Stop SW recording' ) ;

delete( handles.EvtObj) ;


% --- Executes on button press in PushRecord.
function PushRecord_Callback(hObject, eventdata, handles)
% hObject    handle to PushRecord (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
reclen = str2num(get(handles.EditRecordLen,'String') ) ; 
AnaSwitchRecord( 1 , reclen ) ;
guidata(hObject, handles);



% --- Executes during object creation, after setting all properties.
function figure1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called



function EditRecordLen_Callback(hObject, eventdata, handles)
% hObject    handle to EditRecordLen (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of EditRecordLen as text
%        str2double(get(hObject,'String')) returns contents of EditRecordLen as a double
str = get(handles.EditRecordLen,'String') ; 
try
    rcand = str2num( str) ;  %#ok<*ST2NM>
catch
    rcand = 0 ; 
end    
if isempty(rcand) || rcand < 0.1 || rcand > 100 
    rcand = handles.RecordLength ; 
end
handles.RecordLength = rcand ;
set( handles.EditRecordLen ,'String', num2str(rcand)) ; 
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function EditRecordLen_CreateFcn(hObject, eventdata, handles)
% hObject    handle to EditRecordLen (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in CheckRecorderReady.
function CheckRecorderReady_Callback(hObject, eventdata, handles)
% hObject    handle to CheckRecorderReady (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of CheckRecorderReady


% --- Executes on button press in PushBringRecorder.
function PushBringRecorder_Callback(hObject, eventdata, handles)
% hObject    handle to PushBringRecorder (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
AnaSwitchRecord( 4 , [] ,get(handles.CheckFastRecsUpload,'Value') ) ;
guidata(hObject, handles);


% --- Executes on button press in CheckFastRecsUpload.
function CheckFastRecsUpload_Callback(hObject, eventdata, handles)
% hObject    handle to CheckFastRecsUpload (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of CheckFastRecsUpload
