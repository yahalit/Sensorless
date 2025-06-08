function varargout = CalibSteer(varargin)
% CALIBSTEER MATLAB code for CalibSteer.fig
%      CALIBSTEER, by itself, creates a new CALIBSTEER or raises the existing
%      singleton*.
%
%      H = CALIBSTEER returns the handle to a new CALIBSTEER or the handle to
%      the existing singleton*.
%
%      CALIBSTEER('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in CALIBSTEER.M with the given input arguments.
%
%      CALIBSTEER('Property','Value',...) creates a new CALIBSTEER or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before CalibSteer_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to CalibSteer_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help CalibSteer

% Last Modified by GUIDE v2.5 17-May-2019 09:41:01

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @CalibSteer_OpeningFcn, ...
                   'gui_OutputFcn',  @CalibSteer_OutputFcn, ...
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


% --- Executes just before CalibSteer is made visible.
function CalibSteer_OpeningFcn(hObject, ~, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to CalibSteer (see VARARGIN)

% Choose default command line output for CalibSteer
handles.output = hObject;
global DataType

% AtpStart ; 

handles.UpdateDisplayActive = 1 ; 
handles.Calibrating = 0 ; 
handles.CalibratingState = 0 ;
handles.PushActionDone = 0 ; 
handles.hObject = hObject ; 
guidata(hObject, handles);




set( handles.RadioLeftSteer,'Value',0); 
set( handles.RadioRightSteer,'Value',1); 

set( handles.PushForComplete,'Visible','Off') ; 
set( handles.TextPleaseDo,'Visible','Off') ; 

handles.RSteerMotCntRad = GetFloatPar('Geom.RSteerMotCntRad') ; 
handles.LSteerMotCntRad = GetFloatPar('Geom.LSteerMotCntRad') ; 
guidata(hObject, handles);

update_screen(handles) ; 


global DispT
if ~exist('DispT','var') || ~isa(DispT,'DlgTimerObj')
    evalin('base','AtpStart') ; 
end 
handles.EvtObj = DlgUserObj(@update_sw_display,hObject);
handles.EvtObj.listenToTimer(DispT) ;   
handles.Colors = struct( 'Grey', rgb('DarkGray'),'Green',rgb('Lime'),'Cyan' , rgb('Cyan') ,'Red' , rgb('Red')); 

% handles.timer = timer(...
%     'ExecutionMode', 'fixedSpacing', ...       % Run timer repeatedly.
%     'Period', 0.3, ...                        % Initial period is 1 sec.
%     'TimerFcn', {@update_steercalib_display,hObject}); % Specify callback function.% Update handles structure
guidata(hObject, handles);
% start (handles.timer) ;

% Just go to the manual mode 
ErrCode = SendObj( [hex2dec('2206'),0] , 10000 , DataType.long , 'Set manual mode' ) ;
if ( ErrCode == hex2dec('8FFFF38') ) 
    uiwait( errordlg('Robot must be in the operational mode') ) ; 
    Stack = dbstack ; 
    Stack = Stack(1) ; 
    
    errstruct  = struct ('message','Could not load CalibSteer','identifier','CalibNeck:InitConditions','stack',Stack) ; 

    error(errstruct);
end


% Bring the flashed calibration 
handles.CalibInit = SaveCalib ( [] ) ; 

set( handles.TextCalibDate,'String', num2str(handles.CalibInit.CalibDate ) ) ; 
set( handles.TextCalibrationID,'String', num2str(handles.CalibInit.CalibData)) ; 

% Update handles structure
guidata(hObject, handles);



function update_sw_display( hobj) 
    global TmMgrT
    handles = guidata(hobj) ; 

    try
    cnt = TmMgrT.GetCounter('CAL_STEER') ; 

    if cnt < -1e5 
        delete( hobj) ; 
    else
        update_screen(handles) ; 
        TmMgrT.IncrementCounter('CAL_STEER',2) ; 
    end     
        
    catch 
    end


% % UIWAIT makes CalibSteer wait for user response (see UIRESUME)
% % uiwait(handles.figure1);
% function update_steercalib_display( varargin) 
%     handles = guidata(varargin{3}) ; 
%     try
%     update_screen(handles) ; 
%     catch 
%     end
    
    
    
function update_screen(handles)    
global DataType

CreateStruct =  struct('Interpreter','tex','WindowStyle' , 'modal') ; 

    if  ~isfield(handles,'UpdateDisplayActive') || ~handles.UpdateDisplayActive 
        return ; 
    end 
    IsRight = get( handles.RadioRightSteer,'Value') ;
    fac = -180 / ( pi * GetSteerMotCntRad(handles))  ; 
    
    [pot,enc,ref,ang,otherpot] = GetSteerData( IsRight) ; 
    set(handles.TextSteerRef,'String',num2str(ref)) ; 
    set(handles.TextSteerRefDeg,'String',num2str(ref*fac)) ; 
    set(handles.TextEncoder,'String',num2str(enc))  ;
    set(handles.TextSteerActDeg,'String',num2str(enc*fac))  ;
    set(handles.TextSteerPot,'String',num2str(pot)) ;
    set(handles.TextSteerAngle,'String',num2str(ang* 180 / pi) ) ;
    set(handles.TextOtherPot,'String',num2str(otherpot) ) ;
    
    if ( handles.Calibrating  )
        set( handles.PushForComplete,'Visible','On') ; 
        set( handles.TextPleaseDo,'Visible','On') ; 
        nSamp = 10; 
        PotSamp = zeros(nSamp,1) ; 
        EncSamp = zeros(nSamp,1) ; 
        RefSamp = zeros(nSamp,1) ; 
        switch (handles.CalibratingState) 
            case 0 
                
                set( handles.TextPleaseDo,'String',{'Bring the axis to 90deg right';'Press Done'}) ; 
                if handles.PushActionDone
                    for cnt = 1:nSamp 
                        [PotSamp(cnt),EncSamp(cnt),RefSamp(cnt)] = GetSteerData( IsRight) ;     
                    end 
                    handles.PotRight = [mean(PotSamp) , mean(EncSamp) , mean(RefSamp) ] ;
                    handles.PushActionDone = 0 ; 
                    handles.CalibratingState = 1 ; 
                    guidata(handles.hObject, handles);
                end 
            case 1 
                set( handles.TextPleaseDo,'String',{'Bring the axis to center';'Press Done'}) ; 
                if handles.PushActionDone
                    for cnt = 1:nSamp 
                        [PotSamp(cnt),EncSamp(cnt),RefSamp(cnt)] = GetSteerData( IsRight) ;     
                    end 
                    handles.PotCenter = [mean(PotSamp) , mean(EncSamp) , mean(RefSamp) ] ;
                    handles.PushActionDone = 0 ; 
                    handles.CalibratingState = 2 ; 
                    guidata(handles.hObject, handles);
                end 
            case 2 
                set( handles.TextPleaseDo,'String',{'Bring the axis to 90deg left';'Press Done'}) ; 
                if handles.PushActionDone
                    for cnt = 1:nSamp 
                        [PotSamp(cnt),EncSamp(cnt),RefSamp(cnt)] = GetSteerData( IsRight) ;     
                    end 
                    handles.PotLeft = [mean(PotSamp) , mean(EncSamp) , mean(RefSamp) ] ;
                    
                    pots = [handles.PotRight(1),handles.PotCenter(1),handles.PotLeft(1)] ; 
                    encs = [handles.PotRight(2),handles.PotCenter(2),handles.PotLeft(2)] ; 
                    refs = [handles.PotRight(3),handles.PotCenter(3),handles.PotLeft(3)] ; 
                    save SteerCalibRslt pots encs refs 
                    [centercalib,gaincalib] = CalcCalibSteer ( pots, encs ,refs ) ;                    
                    if ( abs(centercalib) > 0.15 ||  abs(gaincalib) > 0.15 ) 
                        [centercalibR,gaincalibR] = CalcCalibSteer ( pots(end:-1:1), encs(end:-1:1) ,refs(end:-1:1) ) ;
                        if ( abs(centercalibR) < 0.15 &&  abs(gaincalibR) < 0.15 ) 
                            uiwait( msgbox( {'Calibration failed: ','Probably you confused the right-left directions?',...
                                [' out of range center [',num2str(gaincalib),'] , bias [',num2str(centercalib),']']}) ) ;  
                        else
                            uiwait( msgbox( ['Calibration failed - out of range center [',num2str(gaincalib),'] , bias [',num2str(centercalib),']']) ) ;  
                        end
                    else
                        if ( IsRight)     
                            handles.CalibInit.RSteerPotCenter = centercalib ; 
                            handles.CalibInit.RSteerPotGainFac = gaincalib ;

							SendObj( [hex2dec('2302'),2] , handles.CalibInit.RSteerPotCenter , DataType.float , 'Set Calib RSteerPotCenter' );
                          
							SendObj( [hex2dec('2302'),4] , handles.CalibInit.RSteerPotGainFac , DataType.float , 'Set Calib RSteerPotGainFac' );
                        else
                            handles.CalibInit.LSteerPotCenter = centercalib ; 
                            handles.CalibInit.LSteerPotGainFac = gaincalib ; 

							SendObj( [hex2dec('2302'),3] , handles.CalibInit.LSteerPotCenter , DataType.float , 'Set Calib LSteerPotCenter' );
							SendObj( [hex2dec('2302'),5] , handles.CalibInit.LSteerPotGainFac , DataType.float , 'Set Calib LSteerPotGainFac' );

                        end
                        
%                         motorOn(0) ; % apply calibration 
						SendObj( [hex2dec('2302'),249] , 0 , DataType.long , 'Apply Calib' );
                        msgbox( {'\fontsize{14}Calibration applied to potentiiometers: ','But will affect motion',...
                             'Only after the saving to flash,','Then after next power up or RESET' },'Information',CreateStruct)   ;  
%                         pause(0.5) ; 
% 						SendObj( [hex2dec('2204'),40] , 1 , DataType.long , 'Home sensors' );
%                         motorOn(1) ; % Restart motors  
                        
                        
                    end
                    
                    handles.Calibrating = 0 ;
                    handles.PushActionDone = 0 ; 
                    handles.CalibratingState = 0 ; 
                    guidata(handles.hObject, handles);
                end 
        end 
    else
        set( handles.PushForComplete,'Visible','Off') ; 
        set( handles.TextPleaseDo,'Visible','Off') ; 
    end 
 
    
function SetSteerRef(handles, inc) 
global DataType
 
ref = str2num( get(handles.TextSteerRef,'String') ) ; %#ok<*ST2NM>
ref = ref + inc ; 
IsRight = get( handles.RadioRightSteer,'Value') ;
if IsRight
	SendObj( [hex2dec('2206'),3] , ref , DataType.long , 'Command steer R') ; 
else
	SendObj( [hex2dec('2206'),4] , ref , DataType.long , 'Command steer L') ; 
end     
set(handles.TextSteerRef,'String', num2str(ref) ) ; 
    


% --- Outputs from this function are returned to the command line.
function varargout = CalibSteer_OutputFcn(~, ~, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in PushUp100K.
function PushUp100K_Callback(~, ~, handles)
% hObject    handle to PushUp100K (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
SetSteerRef(handles, 1e5) ; 



% --- Executes on button press in PushUp10K.
function PushUp10K_Callback(hObject, eventdata, handles)
% hObject    handle to PushUp10K (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
SetSteerRef(handles, 1e4) ; 


% --- Executes on button press in PushUp1K.
function PushUp1K_Callback(hObject, eventdata, handles)
% hObject    handle to PushUp1K (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
SetSteerRef(handles, 1e3) ; 


% --- Executes on button press in PushDn100K.
function PushDn100K_Callback(hObject, eventdata, handles)
% hObject    handle to PushDn100K (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
SetSteerRef(handles, -1e5) ; 


% --- Executes on button press in PushDn10K.
function PushDn10K_Callback(hObject, eventdata, handles)
% hObject    handle to PushDn10K (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
SetSteerRef(handles, -1e4) ; 


% --- Executes on button press in PushDn1K.
function PushDn1K_Callback(hObject, eventdata, handles)
% hObject    handle to PushDn1K (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
SetSteerRef(handles, -1e3) ; 


% --- Executes on button press in RadioRightSteer.
function RadioRightSteer_Callback(hObject, eventdata, handles)
% hObject    handle to RadioRightSteer (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of RadioRightSteer
set( handles.RadioLeftSteer,'Value',0); 
set( handles.RadioRightSteer,'Value',1); 


% --- Executes on button press in RadioLeftSteer.
function RadioLeftSteer_Callback(hObject, eventdata, handles)
% hObject    handle to RadioLeftSteer (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of RadioLeftSteer
set( handles.RadioLeftSteer,'Value',1); 
set( handles.RadioRightSteer,'Value',0); 

% --- Executes on button press in PushCalibrate.
function PushCalibrate_Callback(hObject, eventdata, handles)
% hObject    handle to PushCalibrate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.Calibrating = 1 ; 
handles.CalibratingState = 0 ; 
guidata(hObject, handles);


% --- Executes on button press in PushActionDone.
function PushActionDone_Callback(hObject, eventdata, handles)
% hObject    handle to PushActionDone (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.PushActionDone = 1 ; 
guidata(hObject, handles);


% --- Executes on button press in PushForComplete.
function PushForComplete_Callback(hObject, eventdata, handles)
% hObject    handle to PushForComplete (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.PushActionDone = 1 ; 
guidata(hObject, handles);


function a = GetSteerMotCntRad(handles) 
if get(handles.RadioRightSteer,'Value')==1 
 a = handles.RSteerMotCntRad; 
else
 a = handles.LSteerMotCntRad; 
end

% --- Executes on button press in PushUp45deg.
function PushUp45deg_Callback(hObject, eventdata, handles)
% hObject    handle to PushUp45deg (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

mov = GetSteerMotCntRad(handles) * pi / 4 ; 
SetSteerRef(handles, mov ) ; % 291500) ; 


% --- Executes on button press in PushDn45deg.
function PushDn45deg_Callback(hObject, eventdata, handles)
% hObject    handle to PushDn45deg (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
mov = GetSteerMotCntRad(handles) * pi / 4 ; 
SetSteerRef(handles, -mov) ; %291500) ; 


function SetMasterBlaster() 
global DataType
SendObj( [hex2dec('2220'),5] , hex2dec('1234') , DataType.short , 'Set Master Blaster' ) ;

% --- Executes on button press in PushSaveFlash.
function PushSaveFlash_Callback(hObject, eventdata, handles)
% hObject    handle to PushSaveFlash (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[fname,PathName] = uiputfile('*.jsn','Select the calibration JSON file');
SaveCalib( handles.CalibInit,[PathName,fname] ) ;
dcd = questdlg('Save to flash?', ...
                         'Please specify', ...
                         'Yes', 'No', 'No' );  
if isequal( dcd , 'Yes' )                 
    ProgCalib(fname, 1 ); 
    msgbox(' Succesfully saved to flash ','Info');    
end 

function motorOn(InVal)
% mon = [mon1, mon2 ,mon3 ,mon4 ,mon5, 1] ; 
global DataType 
if InVal
    mon = ones(1,5) ; 
else
    mon = zeros(1,5) ; 
end
mon = [mon 1]; 
vec  = 2.^(0:15) ; 
qs = [0,1] ; 
rsfail = [1 , 1] ; 
reserved = [0,0,0,0];
brr = [0,1] ; 
value = sum( [ mon , reserved , brr,  rsfail , qs] .* vec ) ;  
SetMasterBlaster() ; 
SendObj( [hex2dec('2220'),6] , value , DataType.short ,'Reset motors cmd') ;


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
% hObject    handle to PushUpdateDate (see GCBO)% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
s = datestr(now,'ddmmyyyy');
handles.CalibInit.CalibDate = str2num(s) ; 
set( handles.TextCalibDate,'String', s )  ; 
guidata(hObject, handles);


% --- Executes during object deletion, before destroying properties.
function figure1_DeleteFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
delete( handles.EvtObj) ;
