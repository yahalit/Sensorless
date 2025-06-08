function varargout = CalibLaser(varargin)
% CALIBLASER MATLAB code for CalibLaser.fig
%      CALIBLASER, by itself, creates a new CALIBLASER or raises the existing
%      singleton*.
%
%      H = CALIBLASER returns the handle to a new CALIBLASER or the handle to
%      the existing singleton*.
%
%      CALIBLASER('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in CALIBLASER.M with the given input arguments.
%
%      CALIBLASER('Property','Value',...) creates a new CALIBLASER or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before CalibLaser_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to CalibLaser_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help CalibLaser

% Last Modified by GUIDE v2.5 31-Mar-2022 22:46:01

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @CalibLaser_OpeningFcn, ...
                   'gui_OutputFcn',  @CalibLaser_OutputFcn, ...
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


% --- Executes just before CalibLaser is made visible.
function CalibLaser_OpeningFcn(hObject, ~, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to CalibLaser (see VARARGIN)

% Choose default command line output for CalibLaser
handles.output = hObject;
global DataType


AtpStart ; 

handles.UpdateDisplayActive = 1 ; 
handles.Calibrating = 0 ; 
handles.CalibratingState = 0 ;
handles.PushActionDone = 0 ; 
handles.hObject = hObject ; 
guidata(hObject, handles);

set( handles.PushForComplete,'Visible','Off') ; 
set( handles.TextPleaseDo,'Visible','Off') ;
set( handles.PushSaveFlash,'Visible','Off') ;
set( handles.EditActDistance,'String',num2str(0.0)) ; 

update_screen(handles) ; 

% handles.timer = timer(...
%     'ExecutionMode', 'fixedSpacing', ...       % Run timer repeatedly.
%     'StartDelay',0.5, ... %    'Period', 0.4, ...                        % Initial period is 1 sec.
%     'TimerFcn', {@update_steercalib_display,hObject}); % Specify callback function.% Update handles structure



global DispT
if ~exist('DispT','var') || ~isa(DispT,'DlgTimerObj')
    evalin('base','AtpStart') ; 
end 
handles.EvtObj = DlgUserObj(@update_sw_display,hObject);
handles.EvtObj.listenToTimer(DispT) ;   
handles.Colors = struct( 'Grey', rgb('DarkGray'),'Green',rgb('Lime'),'Cyan' , rgb('Cyan') ,'Red' , rgb('Red')); 


guidata(hObject, handles);
% start (handles.timer) ;

handles.LaserGainNom    = 133.5863 ; 
handles.LaserOffsetNom  = 39.2175  ; 

% Set laser to manual mode 
SendObj( [hex2dec('2220'),15] , 1 , DataType.long , 'Go manual laser ON mode' ); 

% Bring the flashed calibration 
handles.CalibInit = SaveCalib ( [] ) ; 

handles.NCalibPts = 3 ; 
set ( handles.EditNCalibPts , 'String' , num2str(handles.NCalibPts) ) ; 

set( handles.TextCalibDate,'String', num2str(handles.CalibInit.CalibDate ) ) ; 
set( handles.TextCalibrationID,'String', num2str(handles.CalibInit.CalibData)) ; 

% Update handles structure
guidata(hObject, handles);



function update_sw_display( hobj) 
    global TmMgrT
    handles = guidata(hobj) ; 

    try
    cnt = TmMgrT.GetCounter('CAL_LASER') ; 

    if cnt < -1e5 
        delete( hobj) ; 
    else
        update_screen(handles) ; 
        TmMgrT.IncrementCounter('CAL_LASER',2) ; 
    end     
        
    catch 
    end
    
% UIWAIT makes CalibLaser wait for user response (see UIRESUME)
% uiwait(handles.figure1);
% function update_steercalib_display( varargin) 
%     handles = guidata(varargin{3}) ; 
%     try
%     update_screen(handles) ; 
%     catch 
%     end
%     %start (handles.timer) ;

function [LaserDist,LaserVolts]  = GetLaserData() 
global DataType
 	LaserVolts =  FetchObj( [hex2dec('2204'),22] , DataType.float , 'Get distance volts' ) ;  
    LaserDist =  FetchObj( [hex2dec('2204'),10] , DataType.float , 'Get distance mm' ) ;  
    LaserVolts = (round(LaserVolts*10000)) / 10000 ; 
    LaserDist  = (round(LaserDist*10)) / 10 ; 
    
function update_screen(handles)    

    if  ~isfield(handles,'UpdateDisplayActive') || ~handles.UpdateDisplayActive 
        return ; 
    end 

    [LaserDist,LaserVolts]  = GetLaserData() ;  %#ok<ASGLU>
    set(handles.TextVerticalDeg,'String',num2str(LaserDist) ) ;
    set(handles.TextGyroRoll,'String',num2str( LaserVolts ))  ; 
   
    if ( handles.Calibrating  )
        set( handles.PushForComplete,'Visible','On') ; 
        set( handles.TextPleaseDo,'Visible','On') ; 
        NextPt = handles.CalibratingState + 1 ; 
        
        if ( NextPt <= handles.NCalibPts) 
            set( handles.TextPleaseDo,'String',{['Bring the target to pt#[',num2str(NextPt),'] of [',num2str(handles.NCalibPts),']'];...
                'Log the distance as ACT distance';'Press Done'}) ; 
        end

        if handles.PushActionDone
            nSamp = 10; 
            LaserSamp = zeros(nSamp,1) ; 
            LaserAdcSamp = zeros(nSamp,1) ; 
            LaserUser    = str2num ( get(handles.EditActDistance,'String') )  ;  %#ok<ST2NM>
            if ~ (isempty(LaserUser) || LaserUser < 0 || LaserUser > 400 )
                for cnt = 1:nSamp 
                    [LaserSamp(cnt),LaserAdcSamp(cnt)] =  GetLaserData( ) ; 
                end 

                if ( NextPt <= handles.NCalibPts)                 
                    handles.LaserSummary(NextPt,:)  = [mean(LaserSamp), mean(LaserAdcSamp) , LaserUser ] ;
                    handles.PushActionDone = 0 ; 
                end
                handles.CalibratingState = NextPt ; 
                if ( NextPt == handles.NCalibPts)                 
                    set( handles.TextPleaseDo,'String',{'Remove any target from the laser';'and press Done'}) ; 
                elseif ( NextPt == handles.NCalibPts+1) 
                    handles.Calibrating = 0 ;
                    handles.PushActionDone = 0 ; 
                    handles.CalibratingState = 0 ; 
                    %uiwait( msgbox({'Remove any target from the laser','and press ok'}) ) ;
                    handles.VoltageAtNoTarget =  mean(LaserAdcSamp(cnt)) ; 
                    set( handles.PushForComplete,'Visible','Off') ; 
                    set( handles.TextPleaseDo,'String',{'Your results are ready';'Use Save Calib button';'To approve and save'}) ; 
                    set( handles.PushSaveFlash,'Visible','On') ;
                end
                guidata(handles.hObject, handles);
            else
                set( handles.TextPleaseDo,'String',{'Try again:'; 'measure data is in [0 to 400]mm';['Bring the target to pt#[',num2str(NextPt),'] of [',num2str(handles.NCalibPts),']'];...
                    'Log the distance as ACT distance';'Press Done'}) ; 
            end
            
        end 
    else
        set( handles.PushForComplete,'Visible','Off') ; 
        %set( handles.TextPleaseDo,'Visible','Off') ; 
    end 

function  [good,handles] = ApproveCalib(handles)  
    % End of the game 
global DataType
%     ODItems = struct( 'SetPass',[hex2dec('2302'),1],'ReadFlashStruct',[hex2dec('2302'),251]) ; 

    LaserSummary = handles.LaserSummary ; 
    
    GainNom = handles.LaserGainNom   ; 
    OffsetNom = handles.LaserOffsetNom   ; 
    VoltageAtNoTarget  = handles.VoltageAtNoTarget;


    save('LaserCalibRslt.mat' ,'LaserSummary','GainNom','OffsetNom','VoltageAtNoTarget' ) ;  
    disp('Calibration history is logged at the file LaserCalibRslt.mat') ; 
    calibRslt = CalcCalibLaser ( LaserSummary,GainNom,OffsetNom,VoltageAtNoTarget ) ; 
    good = 0 ;
    
    strFuck = {} ; 
    
    if calibRslt.MinDist < -50 || calibRslt.MinDist > 5   
        strFuck = [strFuck ; 'Minimum distance  should not be out of [-50..5]mm, in fact it was [',num2str(calibRslt.MinDist) ,']']  ; 
    end

    if ( abs(calibRslt.LaserGainCorrection) > 0.3 ) 
        strFuck = [strFuck ; 'LaserGainCorrection  should not be out of [-0.3..0.3], in fact it was [',num2str(calibRslt.LaserGainCorrection) ,']']  ; 
    end 
    if ( abs(calibRslt.LaserOffsetCorrection) > 2  ) 
        strFuck = [strFuck ; 'LaserOffsetCorrection  should not be out of [-2 ..2 ], in fact it was [',num2str(calibRslt.LaserOffsetCorrection) ,']']  ; 
    end
    
    Volts = LaserSummary(:,2) ;
    User  = LaserSummary(:,3) ; 
    figure(10) ; clf 
    plot( Volts, User)  ; xlabel('Sensor output (volts)') ; legend('Dist: mm') ; 
    drawnow ; 
    if ~isempty(strFuck) 
        strFuck = [strFuck ; 'Please look at fig #1'] ; 
        uiwait( msgbox(strFuck , 'Calibration failed') ) ;  
    else
        dcd = questdlg( {'Please tell if the line';'Looks reasonable and straight'}, ...
            'Approve linearity?', 'Yes', 'No' , 'No');  
        if isequal(dcd , 'Yes')                    
            handles.CalibInit = MergeStruct (handles.CalibInit,calibRslt ) ; 
           
    
            SendObj( [hex2dec('2302'),20] ,calibRslt.LaserGainCorrection , DataType.float , 'LaserGainCorrection calib') ;
            SendObj( [hex2dec('2302'),21] ,calibRslt.LaserOffsetCorrection , DataType.float , 'LaserOffsetCorrection calib') ;
            SendObj( [hex2dec('2302'),22] ,calibRslt.LaserMinimumVolts , DataType.float , 'LaserMinimumVolts calib') ;
            % apply calibration 
            SendObj( [hex2dec('2302'),249] ,0 , DataType.float , 'Apply calibration') ;
            good = 1 ;
        else
            uiwait( msgbox(strFuck , 'Aborted by user') ) ;  
        end
    end 
    

% --- Outputs from this function are returned to the command line.
function varargout = CalibLaser_OutputFcn(~, ~, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



% --- Executes on button press in PushCalibrate.
function PushCalibrate_Callback(hObject, ~, handles)
% hObject    handle to PushCalibrate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.Calibrating = 1 ; 
handles.CalibratingState = 0 ; 
handles.LaserSummary = zeros(handles.NCalibPts,3 ) ; 
guidata(hObject, handles);


% --- Executes on button press in PushActionDone.
function PushActionDone_Callback(hObject, ~, handles)
% hObject    handle to PushActionDone (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.PushActionDone = 1 ; 
guidata(hObject, handles);


% --- Executes on button press in PushForComplete.
function PushForComplete_Callback(hObject, ~, handles)
% hObject    handle to PushForComplete (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.PushActionDone = 1 ; 
guidata(hObject, handles);

% --- Executes on button press in PushSaveFlash.
function PushSaveFlash_Callback(hObject, ~, handles)
% hObject    handle to PushSaveFlash (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
junk = handles.UpdateDisplayActive ;
handles.UpdateDisplayActive = 0 ;
guidata(hObject, handles);



[good,handles] = ApproveCalib(handles) ; 

handles.UpdateDisplayActive = junk ;
guidata(hObject, handles);


if ~good
    return ; 
end 

[fname,PathName] = uiputfile('*.jsn','Select the calibration JSON file');
SaveCalib( handles.CalibInit,[PathName,fname] ) ;
dcd = questdlg('Save to flash?', ...
                         'Please specify', ...
                         'Yes', 'No' , 'No');  
if isequal( dcd , 'Yes' )                 
    ProgCalib(fname, 1 ); 
    msgbox(' Succesfully saved to flash ','Info');
end 




function TextCalibrationID_Callback(hObject, ~, handles)
% hObject    handle to TextCalibrationID (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of TextCalibrationID as text
%        str2double(get(hObject,'String')) returns contents of TextCalibrationID as a double
str = get(handles.TextCalibrationID,'String') ;
try 
    num = str2num(str) ; 
    if ( num >=0 && num <= 2^31 ) 
        handles.CalibInit.CalibData = num ; 
        guidata(hObject, handles);
    else
        set( handles.TextCalibrationID,'String', handles.CalibInit.CalibData) ; 
    end
catch
    set( handles.TextCalibrationID,'String', handles.CalibInit.CalibData) ; 
end



% --- Executes on button press in PushUpdateDate.
function PushUpdateDate_Callback(hObject, ~, handles)
% hObject    handle to PushUpdateDate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
s = datestr(now,'ddmmyyyy');
handles.CalibInit.CalibDate = str2num(s) ; 
set( handles.TextCalibDate,'String', s )  ; 
guidata(hObject, handles);



function EditNCalibPts_Callback(hObject, ~, handles)
% hObject    handle to EditNCalibPts (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of EditNCalibPts as text
%        str2double(get(hObject,'String')) returns contents of EditNCalibPts as a double
try 
npts = str2num(get(handles.EditNCalibPts , 'String') );  
if ( npts > 1 && npts < 100 && handles.Calibrating == 0 ) 
    handles.NCalibPts = npts ; 
end 
catch 
end 
set( handles.EditNCalibPts , 'String' , num2str( handles.NCalibPts)) ; 
guidata(hObject, handles);



% --- Executes during object creation, after setting all properties.
function EditNCalibPts_CreateFcn(hObject, ~, ~)
% hObject    handle to EditNCalibPts (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% guidata(hObject, handles);


% --- Executes during object deletion, before destroying properties.
function figure1_DeleteFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global DataType
SendObj( [hex2dec('2220'),15] , 0 , DataType.long , 'Clear manual laser ON mode' ); 

delete( handles.EvtObj) ;



function EditActDistance_Callback(hObject, eventdata, handles)
% hObject    handle to EditActDistance (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of EditActDistance as text
%        str2double(get(hObject,'String')) returns contents of EditActDistance as a double


% --- Executes during object creation, after setting all properties.
function EditActDistance_CreateFcn(hObject, eventdata, handles)
% hObject    handle to EditActDistance (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- If Enable == 'on', executes on mouse press in 5 pixel border.
% --- Otherwise, executes on mouse press in 5 pixel border or over PushCalibrate.
function PushCalibrate_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to PushCalibrate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
