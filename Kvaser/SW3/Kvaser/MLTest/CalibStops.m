function varargout = CalibStops(varargin)
% CALIBSTOPS MATLAB code for CalibStops.fig
%      CALIBSTOPS, by itself, creates a new CALIBSTOPS or raises the existing
%      singleton*.
%
%      H = CALIBSTOPS returns the handle to a new CALIBSTOPS or the handle to
%      the existing singleton*.
%
%      CALIBSTOPS('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in CALIBSTOPS.M with the given input arguments.
%
%      CALIBSTOPS('Property','Value',...) creates a new CALIBSTOPS or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before CalibStops_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to CalibStops_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help CalibStops

% Last Modified by GUIDE v2.5 16-Jun-2017 07:42:59

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @CalibStops_OpeningFcn, ...
                   'gui_OutputFcn',  @CalibStops_OutputFcn, ...
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
    SendObj( [hex2dec('2103'),40] , 0 , DataType.long , 'Set left shelf motor off' ) ;
    SendObj( [hex2dec('2103'),50] , 0 , DataType.long , 'Set left right motor off' ) ;

function SetStopMotorsOn( ) 
global DataType 
    SendObj( [hex2dec('2103'),40] , 1 , DataType.long , 'Set left shelf motor on' ) ;
    SendObj( [hex2dec('2103'),50] , 1 , DataType.long , 'Set left right motor on' ) ;
   
function KillLpResponse( ) 
global DataType 
    SendObj( [hex2dec('2103'),201] , 1 , DataType.long , 'Disable response to LP commands' ) ;

function stat = GetMushroomState ( )
    global DataType
    val =  FetchObj( [hex2dec('2104'),1] , DataType.long , 'BIT status' ) ;
    stat =  bitget( val ,3  ) ; 

   
    
% --- Executes just before CalibStops is made visible.
function CalibStops_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to CalibStops (see VARARGIN)

% Choose default command line output for CalibStops
handles.output = hObject;
global DataType
global TargetCanId

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

% Set the motors to off 
SetStopMotorsOff (  )  ;

% Bring the flashed calibration 
handles.CalibFieldNames = {'RDoorCenter' , 'RDoorGainFac' , 'LDoorCenter' , 'LDoorGainFac' ,'ShoulderCenter' , 'ElbowCenter' , 'WristCenter' ,...
    'V36Gain','V36Offset', ...
     'Spare10' , 'Spare11' , 'Spare12' , 'Spare13','Spare14','Spare15','Spare16','Spare17','Spare18'} ;
handles.CalibInit = SaveCalibPD ( [], [] , handles.CalibFieldNames ) ; 

update_screen(handles) ; 

handles.timer = timer(...
    'ExecutionMode', 'fixedSpacing', ...       % Run timer repeatedly.
    'StartDelay',0.4, ... %    'Period', 0.4, ...                        % Initial period is 1 sec.
    'TimerFcn', {@update_stopcalib_display,hObject}); % Specify callback function.% Update handles structure
guidata(hObject, handles);
start (handles.timer) ;


handles.NCalibPts = 4 ; 
set ( handles.EditNCalibPts , 'String' , num2str(handles.NCalibPts) ) ; 

set( handles.TextCalibDate,'String', num2str(handles.CalibInit.CalibDate ) ) ; 
set( handles.TextCalibrationID,'String', num2str(handles.CalibInit.CalibData)) ; 

% Update handles structure
guidata(hObject, handles);


% UIWAIT makes CalibStops wait for user response (see UIRESUME)
% uiwait(handles.figure1);
function update_stopcalib_display( varargin) 
    handles = guidata(varargin{3}) ; 
    try
    update_screen(handles) ; 
    catch 
    end
    %start (handles.timer) ;

function Edata = GetExtData() 
global DataType
    ShoulderCnt =  FetchObj( [hex2dec('2103'),12] , DataType.long , 'Shoulder encoder count' ) ;
    ElbowCnt =  FetchObj( [hex2dec('2103'),22] , DataType.long , 'Shoulder encoder count' ) ;
    WristCnt =  FetchObj( [hex2dec('2103'),32] , DataType.long , 'Shoulder encoder count' ) ;

    ShoulderRad =  FetchObj( [hex2dec('2103'),13] , DataType.long , 'Shoulder encoder rad' ) / 1000 ;
    ElbowRad =  FetchObj( [hex2dec('2103'),23] , DataType.long , 'Shoulder encoder rad' ) / 1000  ;
    WristRad =  FetchObj( [hex2dec('2103'),33] , DataType.long , 'Shoulder encoder rad' ) / 1000 ;

    LStopCnt =  FetchObj( [hex2dec('2103'),42] , DataType.long , 'Lstop cnt' ) ;
    LStopRad =  FetchObj( [hex2dec('2103'),43] , DataType.long , 'Lstop rad' ) / 1000 ;
            
    RStopCnt =  FetchObj( [hex2dec('2103'),52] , DataType.long , 'Rstop cnt' ) ;
    RStopRad =  FetchObj( [hex2dec('2103'),53] , DataType.long , 'Rstop rad' ) / 1000 ;
             

Edata = struct ( 'ShoulderCnt' , ShoulderCnt ,'ElbowCnt',ElbowCnt, 'WristCnt',WristCnt, ...
    'ShoulderRad' , ShoulderRad ,'ElbowRad',ElbowRad, 'WristRad',WristRad, ...
    'LStopCnt' , LStopCnt ,'LStopRad',LStopRad, ...
    'RStopCnt' , RStopCnt ,'RStopRad',RStopRad) ; 
    
  
    
function update_screen(handles)    
global DataType
    if  ~isfield(handles,'UpdateDisplayActive') || ~handles.UpdateDisplayActive 
        return ; 
    end 

    Edata = GetExtData() ; 
    Mstat = GetMushroomState() ; 
    set(handles.CheckMushroom,'Value', Mstat ) ; 
    if ( Mstat ) 
        set( handles.PushSaveFlash , 'Enable','on' ); 
    else
        set( handles.PushSaveFlash , 'Enable','off' ); 
    end 
    
    set(handles.TextRightStopDeg,'String',num2str(Edata.RStopRad* 180 / pi) ) ;
    set(handles.TextLeftStopDeg,'String',num2str(Edata.LStopRad* 180 / pi) ) ;
    set(handles.TextRightStopCnt,'String',num2str(Edata.RStopCnt ) ) ;
    set(handles.TextLeftStopCnt,'String',num2str(Edata.LStopCnt) ) ;

    if ( handles.Calibrating  )
        set( handles.PushForComplete,'Visible','On') ; 
        set( handles.TextPleaseDo,'Visible','On') ; 
        NextPt = handles.CalibratingState + 1 ; 
        
        switch ( NextPt ) 
            case 1
                set( handles.TextPleaseDo,'String',{'Get right door to the flat position';'Press Done'}) ; 
            case 2
                set( handles.TextPleaseDo,'String',{'Get right door to the 60deg up position';'Press Done'}) ; 
            case 3
                set( handles.TextPleaseDo,'String',{'Get left door to the flat position';'Press Done'}) ; 
            case 4
                set( handles.TextPleaseDo,'String',{'Get left door to the 60deg up position';'Press Done'}) ; 
        end
        
        if handles.PushActionDone
            handles.CalibratingState = NextPt ; 
            switch ( NextPt ) 
                case 1
                    handles.ROpen = [ Edata.RStopRad , Edata.RStopCnt] ; 
                case 2
                    handles.RClose = [ Edata.RStopRad , Edata.RStopCnt] ; 
                case 3
                    handles.LOpen = [ Edata.LStopRad , Edata.LStopCnt] ; 
                case 4
                    handles.LClose = [ Edata.LStopRad , Edata.LStopCnt] ; 
            end 
            handles.PushActionDone = 0 ; 

             if ( NextPt == handles.NCalibPts) 
                CalibRaw = struct ( 'ROpen' ,handles.ROpen , 'RClose' , handles.RClose , 'LOpen' ,handles.LOpen , 'LClose' ,handles.LClose  ) ; 
                save DoorCalibRslt.mat CalibRaw

                handles.CalibRaw = CalibRaw ; 
                handles.Calibrating = 0 ;
                handles.CalibratingState = 0 ; 
                set( handles.PushForComplete,'Visible','Off') ; 
                % set( handles.TextPleaseDo,'Visible','Off') ; 
                set( handles.TextPleaseDo,'String',{'Your results are ready';'Press Mushroom and';'Use Save Calib button';'To approve and save'}) ; 
                % save('NeckCalibRslt.mat' ,'PotSummary' ) ;  
                set( handles.PushSaveFlash,'Visible','On') ;
            end
            guidata(handles.hObject, handles);
        end 
    else
        set( handles.PushForComplete,'Visible','Off') ; 
        %set( handles.TextPleaseDo,'Visible','Off') ; 
    end 

    
    
function SetNeckRef(handles, inc) 
global DataType
global TargetCanId
ref = str2num( get(handles.TextSteerRef,'String') ) ; %#ok<*ST2NM>
ref = ref + inc ; 

stat = KvaserCom( 7 , [1536+TargetCanId ,1408+TargetCanId ,hex2dec('2206') ,5,DataType.long,0,100], ref ); % Command speed to steer right
if stat , error ('Sdo failure') ; end 

set(handles.TextSteerRef,'String', num2str(ref) ) ; 
    


% --- Outputs from this function are returned to the command line.
function varargout = CalibStops_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in PushUp100K.
function PushUp100K_Callback(hObject, eventdata, handles)
% hObject    handle to PushUp100K (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
SetNeckRef(handles, 1e5) ; 



% --- Executes on button press in PushUp10K.
function PushUp10K_Callback(hObject, eventdata, handles)
% hObject    handle to PushUp10K (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
SetNeckRef(handles, 1e4) ; 


% --- Executes on button press in PushUp1K.
function PushUp1K_Callback(hObject, eventdata, handles)
% hObject    handle to PushUp1K (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
SetNeckRef(handles, 1e3) ; 


% --- Executes on button press in PushDn100K.
function PushDn100K_Callback(hObject, eventdata, handles)
% hObject    handle to PushDn100K (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
SetNeckRef(handles, -1e5) ; 


% --- Executes on button press in PushDn10K.
function PushDn10K_Callback(hObject, eventdata, handles)
% hObject    handle to PushDn10K (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
SetNeckRef(handles, -1e4) ; 


% --- Executes on button press in PushDn1K.
function PushDn1K_Callback(hObject, eventdata, handles)
% hObject    handle to PushDn1K (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
SetNeckRef(handles, -1e3) ; 


% --- Executes on button press in PushCalibrate.
function PushCalibrate_Callback(hObject, eventdata, handles)
% hObject    handle to PushCalibrate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.Calibrating = 1 ; 
handles.CalibratingState = 0 ; 
handles.CalibRaw = [] ; 
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


% --- Executes on button press in PushUp45deg.
function PushUp45deg_Callback(hObject, eventdata, handles)
% hObject    handle to PushUp45deg (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
SetNeckRef(handles, 121000) ; 

% --- Executes on button press in PushDn45deg.
function PushDn45deg_Callback(hObject, eventdata, handles)
% hObject    handle to PushDn45deg (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
SetNeckRef(handles, -121000) ; 


function  [good,handles] = ApproveCalib(handles)  
    % End of the game 
global DataType
    CalibRaw = handles.CalibRaw ; 
    save('DoorCalibRslt.mat' ,'CalibRaw' ) ;  
    disp('Calibration history is logged at the file DoorCalibRslt.mat') ; 
    [calibRslt,pr,pl] = CalcCalibDoors ( CalibRaw ) ; 
    good = 0 ;
    
    strFuck = {} ; 
    if ( abs(calibRslt.RDoorCenter) > 4000 ) 
        strFuck = [strFuck ; 'RDoorCenter  should not be out of [-4000 4000], in fact it was [',num2str(calibRslt.RDoorCenter) ,']']  ; 
    end 
    
    
    gaintol = 3e-4 ; 
    if ( abs(calibRslt.RDoorGainFac) > gaintol ) 
        strFuck = [strFuck ; 'RDoorGainFac  should not be out of +/-',num2str(gaintol),', in fact it was [',num2str(calibRslt.RDoorGainFac) ,']']  ; 
    end 
    if ( abs(calibRslt.LDoorCenter) > 4000 ) 
        strFuck = [strFuck ; 'LDoorCenter  should not be out of [-4000 4000], in fact it was [',num2str(calibRslt.LDoorCenter) ,']']  ; 
    end 
    if ( abs(calibRslt.LDoorGainFac) > gaintol ) 
        strFuck = [strFuck ; 'LDoorGainFac  should not be out of [-3e-4,3e-4], in fact it was [',num2str(calibRslt.LDoorGainFac) ,']']  ; 
    end
    
    cntr = [CalibRaw.ROpen(2),CalibRaw.RClose(2)] ; 
    degr = [0,60 * pi / 180 ] ; % [CalibRaw.ROpen(1),CalibRaw.RClose(1)] ; 
    
    cntl = [CalibRaw.LOpen(2),CalibRaw.LClose(2)] ; 
    degl = [0,60 * pi / 180 ] ; % [CalibRaw.LOpen(1),CalibRaw.LClose(1)] ; 
    
    figure(1) ; clf ;
    subplot(2,1,1) ; 
    dxr = abs( diff(cntr)) ; 
    dxl = abs( diff(cntl)) ; 
    dx = max([dxr,dxl] ) ; 
        
    plot( cntr , degr * 180 / pi ,'-+' ,cntr , polyval( pr, cntr)* 180 / pi , 'd' ) ; 
    set(gca,'Xlim',[min(cntr),min(cntr+dx)]) ; 
    xlabel('Motor encoder count (Right)') ; ylabel('degrees') ; legend('Deg','Fitted') ; 
    subplot(2,1,2) ; 
    plot( cntl , degl * 180 / pi ,'-+',cntl , polyval( pl, cntl)* 180 / pi , 'd' ) ; 
    set(gca,'XLim',[min(cntl),min(cntl+dx)]) ; 
    xlabel('Motor encoder count (Left)') ; ylabel('degrees') ; legend('Deg','Fitted') ; 
    drawnow ; 
    if ~isempty(strFuck) 
        strFuck = [strFuck ; 'Please look at fig #1'] ; 
        uiwait( msgbox(strFuck , 'Calibration failed') ) ;  
    else
        dcd = questdlg( {'Please tell if the two lines';'have similar slopes and straight'}, ...
            'Approve linearity?', 'Yes', 'No' , 'No');  
        if isequal(dcd , 'Yes')                    
            handles.CalibInit = MergeStruct (handles.CalibInit,calibRslt ) ; 
            % RNeckPotCenter = 6 , LNeckPotCenter = 7 ,
            % RNeckPotGainFac = 8 , LNeckPotGainFac = 9 ; 
            SendObj( [hex2dec('2302'),1] ,hex2dec('12345678') , DataType.long , 'Password for calib') ;
            SendObj( [hex2dec('2302'),2] ,calibRslt.RDoorCenter , DataType.float , 'RDoorCenter calib') ;
            SendObj( [hex2dec('2302'),3] ,calibRslt.RDoorGainFac , DataType.float , 'RDoorGainFac calib') ;
            SendObj( [hex2dec('2302'),4] ,calibRslt.LDoorCenter , DataType.float , 'LDoorCenter calib') ;
            SendObj( [hex2dec('2302'),5] ,calibRslt.LDoorGainFac , DataType.float , 'LDoorGainFac calib') ;
            % apply calibration 
            SendObj( [hex2dec('2302'),29] ,0 , DataType.float , 'Apply calibration') ;
            good = 1 ;
        else
            uiwait( msgbox(strFuck , 'Aborted by user') ) ;  
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

[good,handles] = ApproveCalib(handles) ; 

handles.UpdateDisplayActive = 1 ;
guidata(hObject, handles);

if ~good
    return ; 
end 

[fname,PathName] = uiputfile('*.jsn','Select the calibration JSON file');
SaveCalibPD( handles.CalibInit,[PathName,fname] ) ;
dcd = questdlg('Save to flash?', ...
                         'Please specify', ...
                         'Yes', 'No' , 'No');  
                     
if isequal( dcd , 'Yes' )                 
    ProgCalibPD(fname, 1 , handles.CalibFieldNames ); 
end 

msgbox( {'You have to shut the robot'; 'release the mushroom' ; 'and restart'; 'in order to apply the calibration'} ,'Attention') ; 



% global DataType
% global TargetCanId
% stat = KvaserCom( 7 , [1536+TargetCanId ,1408+TargetCanId ,hex2dec('2302'), 1,DataType.long,0,100], hex2dec('12345678') );  
% if stat , error ('Sdo failure') ; end 
% stat = KvaserCom( 7 , [1536+TargetCanId ,1408+TargetCanId ,hex2dec('2302') ,31,DataType.long,0,100],handles.CalibInit.CalibData );  
% if stat , error ('Sdo failure') ; end 



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


% --- Executes on button press in CheckMotorOn.
function CheckMotorOn_Callback(hObject, eventdata, handles)
% hObject    handle to CheckMotorOn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of CheckMotorOn
val = get( handles.CheckMotorOn,'Value');
if ( val ) 
    SetStopMotorsOn(); 
else
    SetStopMotorsOff(); 
end


% --- Executes on button press in pushbutton14.
function pushbutton14_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton14 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% --- Executes on button press in PushStart12V.
global DataType 
global TargetCanId
KvaserCom( 7 , [1536+TargetCanId ,1408+TargetCanId ,hex2dec('2004'),1,DataType.short,0,100], 1 ); % Set 12V on  
pause(2) ; 
KvaserCom( 7 , [1536+TargetCanId ,1408+TargetCanId ,hex2dec('2004'),2,DataType.short,0,100], 1 ); % Set 24V on  


% --- Executes on button press in CheckMushroom.
function CheckMushroom_Callback(hObject, eventdata, handles)
% hObject    handle to CheckMushroom (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of CheckMushroom
