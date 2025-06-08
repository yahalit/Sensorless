function varargout = AnalogsFig(varargin)
% ENCPOTFIG MATLAB code for EncPotFig.fig
%      ENCPOTFIG, by itself, creates a new ENCPOTFIG or raises the existing
%      singleton*.
%
%      H = ENCPOTFIG returns the handle to a new ENCPOTFIG or the handle to
%      the existing singleton*.
%
%      ENCPOTFIG('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in ENCPOTFIG.M with the given input arguments.
%
%      ENCPOTFIG('Property','Value',...) creates a new ENCPOTFIG or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before EncPotFig_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to EncPotFig_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help EncPotFig

% Last Modified by GUIDE v2.5 05-Jan-2017 09:21:52

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @EncPotFig_OpeningFcn, ...
                   'gui_OutputFcn',  @EncPotFig_OutputFcn, ...
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
end

% --- Executes just before EncPotFig is made visible.
function EncPotFig_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to EncPotFig (see VARARGIN)

% Choose default command line output for EncPotFig
handles.output = hObject;

handles.timer = timer(...
    'ExecutionMode', 'fixedRate', ...       % Run timer repeatedly.
    'Period', 0.5, ...                        % Initial period is 1 sec.
    'TimerFcn', {@update_display,hObject}); % Specify callback function.% Update handles structure
start (handles.timer) ;

guidata(hObject, handles);
end

function update_display( varargin) 
    handles = guidata(varargin{3}) ; 
    
    s = GetAnalogs() ; 
    set( handles.EditEncoder,'String' , num2str( fix( s.Position1 ) )  ) ;
    set( handles.edit6,'String' , num2str( fix( s.Position2 ) )  ) ;
    set( handles.EditPot,'String' , num2str( fix( s.NkPot1 * 10000 ) / 10000 )  ) ;
    set( handles.EditPotNk2,'String' , num2str( fix( s.NkPot2 * 10000 ) / 10000 )  ) ;
    set( handles.EditPotSteer1,'String' , num2str( fix( s.SteerPot1 * 10000 ) / 10000 )  ) ;
    set( handles.EditPotSteer2,'String' , num2str( fix( s.SteerPot2 * 10000 ) / 10000 )  ) ;
    
    
end 

% UIWAIT makes EncPotFig wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = EncPotFig_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;
end


function EditEncoder_Callback(hObject, eventdata, handles)
% hObject    handle to EditEncoder (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of EditEncoder as text
%        str2double(get(hObject,'String')) returns contents of EditEncoder as a double
end

% --- Executes during object creation, after setting all properties.
function EditEncoder_CreateFcn(hObject, eventdata, handles)
% hObject    handle to EditEncoder (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end


function EditPot_Callback(hObject, eventdata, handles)
% hObject    handle to EditPot (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of EditPot as text
%        str2double(get(hObject,'String')) returns contents of EditPot as a double
end

% --- Executes during object creation, after setting all properties.
function EditPot_CreateFcn(hObject, eventdata, handles)
% hObject    handle to EditPot (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end



function EditPotNk2_Callback(hObject, eventdata, handles)
% hObject    handle to EditPotNk2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of EditPotNk2 as text
%        str2double(get(hObject,'String')) returns contents of EditPotNk2 as a double
end

% --- Executes during object creation, after setting all properties.
function EditPotNk2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to EditPotNk2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end


function EditPotSteer1_Callback(hObject, eventdata, handles)
% hObject    handle to EditPotSteer1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of EditPotSteer1 as text
%        str2double(get(hObject,'String')) returns contents of EditPotSteer1 as a double
end

% --- Executes during object creation, after setting all properties.
function EditPotSteer1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to EditPotSteer1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end


function EditPotSteer2_Callback(hObject, eventdata, handles)
% hObject    handle to EditPotSteer2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of EditPotSteer2 as text
%        str2double(get(hObject,'String')) returns contents of EditPotSteer2 as a double
end

% --- Executes during object creation, after setting all properties.
function EditPotSteer2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to EditPotSteer2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end


function edit6_Callback(hObject, eventdata, handles)
% hObject    handle to edit6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit6 as text
%        str2double(get(hObject,'String')) returns contents of edit6 as a double
end

% --- Executes during object creation, after setting all properties.
function edit6_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end