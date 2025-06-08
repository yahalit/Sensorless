function varargout = CalibMan(varargin)
% CALIBMAN MATLAB code for CalibMan.fig
%      CALIBMAN, by itself, creates a new CALIBMAN or raises the existing
%      singleton*.
%
%      H = CALIBMAN returns the handle to a new CALIBMAN or the handle to
%      the existing singleton*.
%
%      CALIBMAN('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in CALIBMAN.M with the given input arguments.
%
%      CALIBMAN('Property','Value',...) creates a new CALIBMAN or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before CalibMan_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to CalibMan_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help CalibMan

% Last Modified by GUIDE v2.5 14-Apr-2022 14:04:04

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @CalibMan_OpeningFcn, ...
                   'gui_OutputFcn',  @CalibMan_OutputFcn, ...
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

function SetStopMotorsOff( ) 
global DataType 
global TargetCanId2
    SendObj( [hex2dec('2103'),7,TargetCanId2] , hex2dec('1234') , DataType.long , 'Set manipulator to individual moto mode' ) ;

   
  
    
% --- Executes just before CalibMan is made visible.
function CalibMan_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to CalibMan (see VARARGIN)

% Choose default command line output for CalibMan
handles.output = hObject;
global DataType %#ok<NUSED>
global TargetCanId %#ok<NUSED>
global PdCalibFields  %#ok<NUSED>
global TargetCanId2 
global DispT
global TmMgrT

if ~exist('DispT','var') || ~isa(DispT,'DlgTimerObj')
    evalin('base','AtpStart') ; 
end 
handles.StartService = 0 ; 
guidata(hObject, handles);

handles.EvtObj = DlgUserObj(@update_sw_display,hObject);
handles.EvtObj.MylistenToTimer(DispT) ;
guidata(hObject, handles);

TmMgrT.SetCounter('CAL_MAN',2) ;     

% AtpStart ; 

handles.UpdateDisplayActive = 1 ; 
handles.Calibrating = 0 ; 
handles.CalibratingState = 0 ;
handles.PushActionDone = 0 ; 

handles.ShoulderNominalOffsetCnt =  FetchObj( [hex2dec('2103'),17,TargetCanId2] , DataType.long , 'ShoulderNominalOffsetCnt' ) ;
handles.ElbowNominalOffsetCnt =  FetchObj( [hex2dec('2103'),27,TargetCanId2] , DataType.long , 'ElbowNominalOffsetCnt' ) ;
handles.WristNominalOffsetCnt =  FetchObj( [hex2dec('2103'),37,TargetCanId2] , DataType.long , 'WristNominalOffsetCnt' ) ;
handles.ShoulderPosScale =  FetchObj( [hex2dec('2103'),18,TargetCanId2] , DataType.float , 'ShoulderPosScale' ) ;
handles.ElbowPosScale =  FetchObj( [hex2dec('2103'),28,TargetCanId2] , DataType.float , 'ElbowPosScale' ) ;
handles.WristPosScale =  FetchObj( [hex2dec('2103'),38,TargetCanId2] , DataType.float , 'WristPosScale' ) ;
handles.EdataOnZero = [] ; 
handles.CreateStruct =  struct('Interpreter','tex','WindowStyle' , 'modal') ; 


handles.hObject = hObject ; 
guidata(hObject, handles);

set( handles.PushForComplete,'Visible','Off') ; 
set( handles.TextPleaseDo,'Visible','Off') ;
set( handles.PushSaveFlash,'Visible','Off') ;

% Set the motors to off 
SetStopMotorsOff (  )  ;

% Bring the flashed calibration 
handles.CalibInit = SaveCalibManCpu2 ( []  ) ; 

update_screen(handles) ; 



% handles.timer = timer(...
%     'ExecutionMode', 'fixedSpacing', ...       % Run timer repeatedly.
%     'StartDelay',0.4, ... %    'Period', 0.4, ...                        % Initial period is 1 sec.
%     'TimerFcn', {@update_stopcalib_display,hObject}); % Specify callback function.% Update handles structure
% guidata(hObject, handles);
% start (handles.timer) ;


set( handles.TextCalibDate,'String', num2str(handles.CalibInit.CalibDate ) ) ; 
set( handles.TextCalibrationID,'String', num2str(handles.CalibInit.CalibData)) ; 
handles.StartService = 1 ; 

% Update handles structure
guidata(hObject, handles);


% UIWAIT makes CalibMan wait for user response (see UIRESUME)
% uiwait(handles.figure1);
function update_sw_display( hobj) 
    global TmMgrT
    handles = guidata(hobj) ; 

    if handles.StartService<1
        return ;
    end 
    
    try
    cnt = TmMgrT.GetCounter('CAL_MAN') ; 

    if cnt < -1e5 
        delete( hobj) ; 
    else
        update_screen(handles) ; 
        TmMgrT.IncrementCounter('CAL_MAN',2) ; 
    end     
        
    catch 
    end
    
    %start (handles.timer) ;

function Edata = GetExtData() 
global DataType
global TargetCanId2 
%     ShoulderCnt =  FetchObj( [hex2dec('2103'),12,TargetCanId2] , DataType.long , 'Shoulder encoder count' ) ;
%     ElbowCnt =  FetchObj( [hex2dec('2103'),22,TargetCanId2] , DataType.long , 'Shoulder encoder count' ) ;
%     WristCnt =  FetchObj( [hex2dec('2103'),32,TargetCanId2] , DataType.long , 'Shoulder encoder count' ) ;
% 
%     ShoulderRad =  FetchObj( [hex2dec('2103'),13,TargetCanId2] , DataType.long , 'Shoulder encoder rad' ) / 1000 ;
%     ElbowRad =  FetchObj( [hex2dec('2103'),23,TargetCanId2] , DataType.long , 'Shoulder encoder rad' ) / 1000  ;
%     WristRad =  FetchObj( [hex2dec('2103'),33,TargetCanId2] , DataType.long , 'Shoulder encoder rad' ) / 1000 ;

    ShoulderCnt =  FetchObj( [hex2dec('2103'),12,TargetCanId2] , DataType.long , 'Shoulder cnt' ) ;
    ShoulderRad =  FetchObj( [hex2dec('2103'),13,TargetCanId2] , DataType.long , 'Shoulder rad' ) / 1000 ;
            
    ElbowCnt =  FetchObj( [hex2dec('2103'),22,TargetCanId2] , DataType.long , 'Elbow cnt' ) ;
    ElbowRad =  FetchObj( [hex2dec('2103'),23,TargetCanId2] , DataType.long , 'Elbow rad' ) / 1000 ;

    WristCnt =  FetchObj( [hex2dec('2103'),32,TargetCanId2] , DataType.long , 'Wrist cnt' ) ;
    WristRad =  FetchObj( [hex2dec('2103'),33,TargetCanId2] , DataType.long , 'Wrist rad' ) / 1000 ;
             

Edata = struct ( 'ShoulderCnt' , ShoulderCnt ,'ShoulderRad',ShoulderRad, ...
    'ElbowCnt' , ElbowCnt ,'ElbowRad',ElbowRad , ... 
    'WristCnt' , WristCnt ,'WristRad',WristRad) ; 
    
  
    
function update_screen(handles)    
global DataType
    if  ~isfield(handles,'UpdateDisplayActive') || ~handles.UpdateDisplayActive 
        return ; 
    end 
    

    Edata = GetExtData() ; 
    
    set(handles.TextShoulderDeg,'String',num2str(Edata.ShoulderRad* 180 / pi) ) ;
    set(handles.TextElbowDeg,'String',num2str(Edata.ElbowRad * 180 / pi) ) ;
    set(handles.TextWristDeg,'String',num2str(Edata.WristRad* 180 / pi) ) ;
    
    set(handles.TextShoulderCnt,'String',num2str(Edata.ShoulderCnt ) ) ;
    set(handles.TextElbowCnt,'String',num2str(Edata.ElbowCnt) ) ;
    set(handles.TextWristCnt,'String',num2str(Edata.WristCnt) ) ;


    if ( handles.Calibrating  )
        set( handles.PushForComplete,'Visible','On') ; 
        set( handles.TextPleaseDo,'Visible','On') ; 
        
        set( handles.TextPleaseDo,'String',{'Set manipulator to 0,0,0 position';'manipulator straight';'gripper points backwards';'Press Done'}) ; 
        
        if handles.PushActionDone
            handles.PushActionDone = 0 ; 

            handles.EdataOnZero =  Edata ; 
            handles.Calibrating = 0 ;
            handles.CalibratingState = 0 ; 
            set( handles.PushForComplete,'Visible','Off') ; 
            % set( handles.TextPleaseDo,'Visible','Off') ; 
            set( handles.TextPleaseDo,'String',{'Your results are ready';'Use Save Calib button';'To approve and save'}) ; 
            % save('NeckCalibRslt.mat' ,'PotSummary' ) ;  
            set( handles.PushSaveFlash,'Visible','On') ;
            
            guidata(handles.hObject, handles);
        end 
    else
        set( handles.PushForComplete,'Visible','Off') ; 
        %set( handles.TextPleaseDo,'Visible','Off') ; 
    end 

    


% --- Outputs from this function are returned to the command line.
function varargout = CalibMan_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



% --- Executes on button press in PushCalibrate.
function PushCalibrate_Callback(hObject, eventdata, handles)
% hObject    handle to PushCalibrate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.Calibrating = 1 ; 
handles.PushActionDone = 0 ;  
handles.CalibratingState = 0 ; 
handles.CalibRaw = [] ; 
guidata(hObject, handles);


% --- Executes on button press in PushActionDone.
function PushActionDone_Callback(hObject, eventdata, handles)
% hObject    handle to PushActionDone (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.PushActionDone = 1 ; 

SendObj( [hex2dec('2303'),1,TargetCanId2] ,hex2dec('12345678') , DataType.long , 'Password for calib') ;
SendObj( [hex2dec('2303'),6,TargetCanId2] ,calibRslt.ShoulderCenter , DataType.float , 'ShoulderCenter calib') ;
SendObj( [hex2dec('2303'),7,TargetCanId2] ,calibRslt.ElbowCenter , DataType.float , 'ElbowCenter calib') ;
SendObj( [hex2dec('2303'),8,TargetCanId2] ,calibRslt.WristCenter , DataType.float , 'WristCenter calib') ;
% apply calibration 
SendObj( [hex2dec('2303'),249,TargetCanId2] ,0 , DataType.float , 'Apply calibration') ;

guidata(hObject, handles);


% --- Executes on button press in PushForComplete.
function PushForComplete_Callback(hObject, eventdata, handles)
% hObject    handle to PushForComplete (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.PushActionDone = 1 ; 
guidata(hObject, handles);



function  [good,handles] = ApproveCalib(handles)  
    % End of the game 
global DataType
global TargetCanId2 
  
    good = 0 ; 
    strFuck = [] ; 
    if isempty(handles.EdataOnZero) 
        strFuck = 'No recorded data for straight manipulator'; 
    end 
    if isempty(strFuck) && ( handles.ShoulderPosScale * handles.ElbowPosScale * handles.WristPosScale == 0 ) 
        strFuck = 'Position scale is zero '; 
    end 
    if isempty(strFuck)
        
        tol = 0.5 ; 
        ShoulderDev1 = handles.EdataOnZero.ShoulderCnt - handles.ShoulderNominalOffsetCnt ; 
        ElbowDev1    = handles.EdataOnZero.ElbowCnt - handles.ElbowNominalOffsetCnt ; 
        WristDev1    = handles.EdataOnZero.WristCnt - handles.WristNominalOffsetCnt ; 
        
        ShoulderDev = mod2piS ( ShoulderDev1 * handles.ShoulderPosScale ) /handles.ShoulderPosScale ;
        ElbowDev = mod2piS ( ElbowDev1 * handles.ElbowPosScale ) /handles.ElbowPosScale ;
        WristDev = mod2piS ( WristDev1 *  handles.WristPosScale) /handles.WristPosScale ;
                
        if  abs(ShoulderDev * handles.ShoulderPosScale) > tol 
            strFuck = 'Shoulder correction out of range '; 
        end 
            
        if  abs(ElbowDev * handles.ElbowPosScale) > tol 
            strFuck = 'Elbow correction out of range '; 
        end
        
        if  abs( WristDev * handles.WristPosScale ) > tol
            strFuck = 'Wrist correction out of range '; 
        end 
    end 
    
    if ~isempty(strFuck) 
        strFuck = [ string(strFuck) ; "Sorry...Calibration failed"] ; 
        uiwait( msgbox(strFuck , 'Calibration failed') ) ;  
    else
        calibRslt.ShoulderCenter = ShoulderDev ; 
		calibRslt.ElbowCenter = ElbowDev ; 
		calibRslt.WristCenter = WristDev ;

        handles.CalibInit = MergeStruct (handles.CalibInit,calibRslt ) ; 
        % RNeckPotCenter = 6 , LNeckPotCenter = 7 ,
        % RNeckPotGainFac = 8 , LNeckPotGainFac = 9 ; 
        
        try
            [fname,PathName] = uiputfile('*.jsn','Select the calibration JSON file');
            SaveCalibManCpu2( handles.CalibInit,[PathName,fname] ) ;
            ProgCalibManCpu2(fname, 1   ); 
            
%             SendObj( [hex2dec('2303'),1,TargetCanId2] ,hex2dec('12345600') + length(fieldnames(handles.CalibInit)) , DataType.long , 'Password for calib') ;
%             SendObj( [hex2dec('2303'),6,TargetCanId2] ,calibRslt.ShoulderCenter , DataType.float , 'ShoulderCenter calib') ;
%             SendObj( [hex2dec('2303'),7,TargetCanId2] ,calibRslt.ElbowCenter , DataType.float , 'ElbowCenter calib') ;
%             SendObj( [hex2dec('2303'),8,TargetCanId2] ,calibRslt.WristCenter , DataType.float , 'WristCenter calib') ;
%             % apply calibration 
%             SendObj( [hex2dec('2303'),253,TargetCanId2] ,0 , DataType.float , 'Save calibration in flash ') ;
            uiwait( msgbox({'\fontsize{14} Succesfully saved to flash'},handles.CreateStruct) ) ;
            good = 1 ; 
        catch
            msgbox('Failed programming flash in calibration') ; 
        end
    end 



% --- Executes on button press in PushSaveFlash.
function PushSaveFlash_Callback(hObject, eventdata, handles)
% hObject    handle to PushSaveFlash (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
junk = handles.UpdateDisplayActive ;
handles.UpdateDisplayActive = 0 ;
guidata(hObject, handles);

[~,handles] = ApproveCalib(handles) ; 

handles.UpdateDisplayActive = 1 ;
guidata(hObject, handles);

% if ~good
%     return ; 
% end 

% [fname,PathName] = uiputfile('*.jsn','Select the calibration JSON file');
% SaveCalibManCpu2( handles.CalibInit,[PathName,fname] ) ;
% dcd = questdlg('Save to flash?', ...
%                          'Please specify', ...
%                          'Yes', 'No' , 'No');  
%                      
% if isequal( dcd , 'Yes' )                 
%     ProgCalibManCpu2(fname, 1   ); 
% end 

% msgbox( {'You have to shut the robot'; 'release the mushroom' ; 'and restart'; 'in order to apply the calibration'} ,'Attention') ; 






function TextCalibrationID_Callback(hObject, eventdata, handles)
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
function PushUpdateDate_Callback(hObject, eventdata, handles)
% hObject    handle to PushUpdateDate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
s = datestr(now,'ddmmyyyy');
handles.CalibInit.CalibDate = str2num(s) ; 
set( handles.TextCalibDate,'String', s )  ; 
guidata(hObject, handles);



function EditNCalibPts_Callback(hObject, eventdata, handles)
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
function EditNCalibPts_CreateFcn(hObject, eventdata, handles)
% hObject    handle to EditNCalibPts (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end





% --- Executes when user attempts to close figure1.
function figure1_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    global TmMgrT
    try
        TmMgrT.SetCounter('CAL_MAN',-1000) ; 
        delete( handles.EvtObj) ;
    %delete( app.Timer ) ;
    catch 
    end
%             delete(app)
%     
%     if isequal(class( handles.timer),'timer')  
%         stop(handles.timer) ; 
%         delete(handles.timer) ; 
%     end
% catch 
% end
% Hint: delete(hObject) closes the figure
delete(hObject);
