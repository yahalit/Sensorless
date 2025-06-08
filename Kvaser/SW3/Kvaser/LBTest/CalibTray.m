function varargout = CalibTray(varargin)
% CALIBTRAY MATLAB code for CalibTray.fig
%      CALIBTRAY, by itself, creates a new CALIBTRAY or raises the existing
%      singleton*.
%
%      H = CALIBTRAY returns the handle to a new CALIBTRAY or the handle to
%      the existing singleton*.
%
%      CALIBTRAY('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in CALIBTRAY.M with the given input arguments.
%
%      CALIBTRAY('Property','Value',...) creates a new CALIBTRAY or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before CalibTray_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to CalibTray_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help CalibTray

% Last Modified by GUIDE v2.5 01-Apr-2022 11:21:36

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @CalibTray_OpeningFcn, ...
                   'gui_OutputFcn',  @CalibTray_OutputFcn, ...
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
%     SendObj( [hex2dec('2103'),40,TargetCanId2] , 0 , DataType.long , 'Set left shelf motor off' ) ;
%     SendObj( [hex2dec('2103'),50,TargetCanId2] , 0 , DataType.long , 'Set left right motor off' ) ;
% 
% function SetStopMotorsOn( ) 
% global DataType 
% global TargetCanId2
%     SendObj( [hex2dec('2103'),40,TargetCanId2] , 1 , DataType.long , 'Set left shelf motor on' ) ;
%     SendObj( [hex2dec('2103'),50,TargetCanId2] , 1 , DataType.long , 'Set left right motor on' ) ;
%    
  
    
% --- Executes just before CalibTray is made visible.
function CalibTray_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to CalibTray (see VARARGIN)

% Choose default command line output for CalibTray
handles.output = hObject;
global DataType
global TargetCanId
global PdCalibFields 

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
handles.CalibInit = SaveCalibManCpu2 ( []  ) ; 

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


% UIWAIT makes CalibTray wait for user response (see UIRESUME)
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
global TargetCanId2 
%     ShoulderCnt =  FetchObj( [hex2dec('2103'),12,TargetCanId2] , DataType.long , 'Shoulder encoder count' ) ;
%     ElbowCnt =  FetchObj( [hex2dec('2103'),22,TargetCanId2] , DataType.long , 'Shoulder encoder count' ) ;
%     WristCnt =  FetchObj( [hex2dec('2103'),32,TargetCanId2] , DataType.long , 'Shoulder encoder count' ) ;
% 
%     ShoulderRad =  FetchObj( [hex2dec('2103'),13,TargetCanId2] , DataType.long , 'Shoulder encoder rad' ) / 1000 ;
%     ElbowRad =  FetchObj( [hex2dec('2103'),23,TargetCanId2] , DataType.long , 'Shoulder encoder rad' ) / 1000  ;
%     WristRad =  FetchObj( [hex2dec('2103'),33,TargetCanId2] , DataType.long , 'Shoulder encoder rad' ) / 1000 ;

    LStopCnt =  FetchObj( [hex2dec('2103'),42,TargetCanId2] , DataType.long , 'Lstop cnt' ) ;
    LStopRad =  FetchObj( [hex2dec('2103'),43,TargetCanId2] , DataType.long , 'Lstop rad' ) / 1000 ;
            
    RStopCnt =  FetchObj( [hex2dec('2103'),52,TargetCanId2] , DataType.long , 'Rstop cnt' ) ;
    RStopRad =  FetchObj( [hex2dec('2103'),53,TargetCanId2] , DataType.long , 'Rstop rad' ) / 1000 ;
             

Edata = struct ( 'LStopCnt' , LStopCnt ,'LStopRad',LStopRad, ...
    'RStopCnt' , RStopCnt ,'RStopRad',RStopRad) ; 
    
  
    
function update_screen(handles)    
global DataType
    if  ~isfield(handles,'UpdateDisplayActive') || ~handles.UpdateDisplayActive 
        return ; 
    end 
    

    Edata = GetExtData() ; 
    
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
                set( handles.TextPleaseDo,'String',{'Your results are ready';'Use Save Calib button';'To approve and save'}) ; 
                % save('NeckCalibRslt.mat' ,'PotSummary' ) ;  
                set( handles.PushSaveFlash,'Visible','On') ;
            end
            guidata(handles.hObject, handles);
        end 
    else
        set( handles.PushForComplete,'Visible','Off') ; 
        %set( handles.TextPleaseDo,'Visible','Off') ; 
    end 

    


% --- Outputs from this function are returned to the command line.
function varargout = CalibTray_OutputFcn(hObject, eventdata, handles) 
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



function  [good,handles] = ApproveCalib(handles)  
    % End of the game 
global DataType
global TargetCanId2 

    CalibRaw = handles.CalibRaw ; 
    save('DoorCalibRslt.mat' ,'CalibRaw' ) ;  
    disp('Calibration history is logged at the file DoorCalibRslt.mat') ; 
    [calibRslt,pr,pl] = CalcCalibDoorsCpu2 ( CalibRaw ) ; 
    good = 0 ;
    
    strFuck = {} ; 
    if ( abs(calibRslt.RDoorCenter) > 4000 ) 
        strFuck = [strFuck ; 'RDoorCenter  should not be out of [-4000 4000], in fact it was [',num2str(calibRslt.RDoorCenter) ,']']  ; 
    end 
    
    
    gaintol = 6e-4 ; 
    if ( abs(calibRslt.RDoorGainFac) > gaintol ) 
        strFuck = [strFuck ; 'RDoorGainFac  should not be out of +/-',num2str(gaintol),', in fact it was [',num2str(calibRslt.RDoorGainFac) ,']']  ; 
    end 
    if ( abs(calibRslt.LDoorCenter) > 4000 ) 
        strFuck = [strFuck ; 'LDoorCenter  should not be out of [-4000 4000], in fact it was [',num2str(calibRslt.LDoorCenter) ,']']  ; 
    end 
    if ( abs(calibRslt.LDoorGainFac) > gaintol ) 
        strFuck = [strFuck ; 'LDoorGainFac  should not be out of [-',num2str(gaintol),',',num2str(gaintol),'], in fact it was [',num2str(calibRslt.LDoorGainFac) ,']']  ; 
    end
    
    cntr = [CalibRaw.ROpen(2),CalibRaw.RClose(2)] ; 
    degr = [0,60 * pi / 180 ] ; % [CalibRaw.ROpen(1),CalibRaw.RClose(1)] ; 
    
    cntl = [CalibRaw.LOpen(2),CalibRaw.LClose(2)] ; 
    degl = [0,60 * pi / 180 ] ; % [CalibRaw.LOpen(1),CalibRaw.LClose(1)] ; 
    
    figure(10) ; clf ;
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
        strFuck = [string(strFuck) ; "Please look at fig #1"] ; 
        uiwait( msgbox(strFuck , 'Calibration failed') ) ;  
    else
        dcd = questdlg( {'Please tell if the two lines';'have similar slopes and straight'}, ...
            'Approve linearity?', 'Yes', 'No' , 'No');  
        if isequal(dcd , 'Yes')                    
            handles.CalibInit = MergeStruct (handles.CalibInit,calibRslt ) ; 
            % RNeckPotCenter = 6 , LNeckPotCenter = 7 ,
            % RNeckPotGainFac = 8 , LNeckPotGainFac = 9 ; 
            SendObj( [hex2dec('2303'),1,TargetCanId2] ,hex2dec('12345678') , DataType.long , 'Password for calib') ;
            SendObj( [hex2dec('2303'),2,TargetCanId2] ,calibRslt.RDoorCenter , DataType.float , 'RDoorCenter calib') ;
            SendObj( [hex2dec('2303'),3,TargetCanId2] ,calibRslt.RDoorGainFac , DataType.float , 'RDoorGainFac calib') ;
            SendObj( [hex2dec('2303'),4,TargetCanId2] ,calibRslt.LDoorCenter , DataType.float , 'LDoorCenter calib') ;
            SendObj( [hex2dec('2303'),5,TargetCanId2] ,calibRslt.LDoorGainFac , DataType.float , 'LDoorGainFac calib') ;
            % apply calibration 
            SendObj( [hex2dec('2303'),249,TargetCanId2] ,0 , DataType.float , 'Apply calibration') ;
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
SaveCalibManCpu2( handles.CalibInit,[PathName,fname] ) ;
dcd = questdlg('Save to flash?', ...
                         'Please specify', ...
                         'Yes', 'No' , 'No');  
                     
if isequal( dcd , 'Yes' )                 
    ProgCalibManCpu2(fname, 1   ); 
end 




function TextCalibrationID_Callback(hObject, eventdata, handles)
% hObject    handle to TextCalibrationID (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of TextCalibrationID as text
%        str2double(get(hObject,'String')) returns contents of TextCalibrationID as a double
str = get(handles.TextCalibrationID,'String') ;
try 
    num = str2num(str) ; %#ok<ST2NM> 
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
try
    if isequal(class( handles.timer),'timer')  
        stop(handles.timer) ; 
        delete(handles.timer) ; 
    end
catch 
end
% Hint: delete(hObject) closes the figure
delete(hObject);
