function varargout = Rescue(varargin)
% RESCUE MATLAB code for Rescue.fig
%      RESCUE, by itself, creates a new RESCUE or raises the existing
%      singleton*.
%
%      H = RESCUE returns the handle to a new RESCUE or the handle to
%      the existing singleton*.
%
%      RESCUE('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in RESCUE.M with the given input arguments.
%
%      RESCUE('Property','Value',...) creates a new RESCUE or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Rescue_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Rescue_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Rescue

% Last Modified by GUIDE v2.5 09-Jan-2023 17:47:26

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Rescue_OpeningFcn, ...
                   'gui_OutputFcn',  @Rescue_OutputFcn, ...
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

function x = IsNearAngle(theta,ref,tol) 
junk = mod(theta-ref, 2 * pi ) ; 
if junk >= pi 
    junk = junk -2 * pi ; 
else
    if junk < -pi 
        junk = junk + 2 * pi ; 
    end
end
if abs(junk) < tol 
    x = 1 ; 
else
    x = 0 ; 
end 

function [x,s] = IsRobotOk (handles) 

global AtpCfg ; 
if nargin >= 1 && handles.SimMode
    x = 1 ; 
    return ; 
end

x = 0 ; s = []  ; 
try 
    AtpCfg.Suspend = 1 ;
    s = GetState() ; 
    if  s.Bit.MotorOnRw && s.Bit.MotorOnLw && s.Bit.MotorOnRSteer && s.Bit.MotorOnLSteer && s.Bit.MotorOnNeck
        x = 1 ;
    end 
catch 
end 
AtpCfg.Suspend = 0 ;  

function val = AcceptInRange( txt , valmin, valmax , oldval ) 
    val = inf ; 
    try 
        val = str2num( get( txt , 'String') ) ;  %#ok<ST2NM>
    catch 
    end 
       
    if isa(val,'numeric') && (length(val) == 1 ) && val >= valmin && val <= valmax 
    else
        val = oldval ; 
    end 
    set( txt , 'String' , num2str(val)) ; 
   
function HardShutUpOlivier()
global DataType 
    SendObj( [hex2dec('2220'),17] , 1234 , DataType.long , 'Shut up Olivier' ) ;    
    SetFloatPar('AutomaticRunPars.PoleSpeed',0.15) ; 
    SetFloatPar('AutomaticRunPars.ArcSpeed',0.15) ; 
    SetFloatPar('Geom.StopAfterLeaderEncountersSwM',0.20) ; 
    
function [handles,good,msg] = GetRobotState( handles)
global DataType 
global RecStruct 
    msg = [] ; 
    if handles.SimMode 
        Rsteer = pi/2 ; 
        Lsteer = pi/2 ; 
        NeckAngle = pi/2 ;
    else
% Get the robot state: neck position , steering position 
        Rsteer = -FetchObj( [hex2dec('2204'),30] , DataType.float ,'Right steer angle') ;
        Lsteer = -FetchObj( [hex2dec('2204'),31] , DataType.float ,'Left steer angle') ;
        NeckAngle = FetchObj( [hex2dec('2204'),32] , DataType.float ,'NeckAngle') ;
    end
    
    RobotStatField = FetchObj( [hex2dec('220b'),1], DataType.long ,'RobotStatField') + 2^32 ;
    WheelArmStatField = FetchObj( [hex2dec('220b'),23], DataType.long ,'WheelArmStatField') ;
    handles.RsteerRad = Rsteer ;
    handles.LsteerRad = Lsteer ;
    handles.NeckAngleRad = NeckAngle; 

    handles.OnShelf = IsNearAngle( Rsteer , 0 , pi/8 )   ;  
    handles.OnPole  = IsNearAngle( abs(Rsteer) , pi/2 , pi/8 ) ; 
    handles.IsRight = IsNearAngle( NeckAngle , pi / 2 , pi/4 )  ;
    
    handles.WheelArmState = bitand( WheelArmStatField, 15*2^6 ) / 2^6 ;
    handles.WakeupState   = bitand(RobotStatField,7*2^29)/2^29 ; 
    handles.MotionMode    = bitand(RobotStatField,15) ; 
    handles.CrabState     = bitand( WheelArmStatField, 3) ;

    good = 1 ; 
    
    if ( ~IsNearAngle( Rsteer , Lsteer , pi/8 ) && ~IsNearAngle( abs(Rsteer-Lsteer),pi , pi/8 )) || ~IsNearAngle( abs(NeckAngle) , pi / 2 , pi/4 )  
        msg = 'Bad steering angle' ;
        good = 0 ; 
    end
    
    if (handles.WakeupState==handles.WakeUpStates.E_CAN_WAKEUP_OPERATIONAL) 
        if handles.MotionMode > handles.MotionModes.E_SysMotionModeManualTravel
            try
               SendObj( [hex2dec('220b '),1] , 0 , DataType.long , 'Set yo manual travel' ) ;
            catch
            end
        end 
        if ( handles.MotionMode < handles.MotionModes.E_SysMotionModeStay ) 
            if isempty(msg) ,msg = 'Motion mode can be E_SysMotionModeStay,E_SysMotionModePerAxis, or E_SysMotionModeManualTravel' ; end
            good = 0 ; 
        end
    else
        if isempty(msg) ,msg = 'Robot not in E_CAN_WAKEUP_OPERATIONAL' ; end
        good = 0 ; 
    end
    
    
    if good
        if handles.OnPole && (handles.CrabState==0)
            % Set the correct crabbed state
            if handles.OnPole
                try 
                    if ( handles.IsRight ) 
                        SendObj( [hex2dec('2222'),28] , 0.07 , DataType.float , 'Set crawl' ) ;
                    else
                        SendObj( [hex2dec('2222'),29] , 0.07 , DataType.float , 'Set crawl' ) ;
                    end
                catch 
                    if isempty(msg) ,msg = 'Could not put crawl setting' ; end
                    good = 0 ;
                end
            end
            WheelArmStatField = FetchObj( [hex2dec('220b'),23], DataType.long ,'WheelArmStatField') ;
            handles.CrabState = bitand( WheelArmStatField, 3) ;    
        end
        switch handles.CrabState
            case 0
                if handles.OnPole
                    if isempty(msg) ,msg = 'Uncrabbed on the pole' ; end
                    good = 0 ; 
                end
            case 1
                if ~IsNearAngle( Rsteer , pi/2 , pi/32 ) || ~handles.IsRight
                    if isempty(msg) ,msg = 'Bad steer angle or steering does not match neck angle' ; end
                    good = 0 ; 
                end
            case 3
                if ~IsNearAngle( abs(Rsteer) , pi/2 , pi/32 ) || handles.IsRight
                    if isempty(msg) ,msg = 'Bad steer angle or steering does not match neck angle' ; end
                    good = 0 ; 
                end
                handles.CrabState= -1 ; 
            otherwise
                if isempty(msg) ,msg = 'Bad crabbing state' ; end
                good = 0 ;
        end
        
    end
    if (handles.WheelArmState==RecStruct.Enums.WheelArmStates.E_RExtendActive) || ...
            (handles.WheelArmState==RecStruct.Enums.WheelArmStates.E_LExtendActive) ...
            || (handles.WheelArmState==RecStruct.Enums.WheelArmStates.E_BothExtendActiveError)
        if isempty(msg) ,msg = 'Wheelarm not locked or unknown' ; end
        good = 0 ;
    end


function StopMotors()
    global DataType 
    SendObj( [hex2dec('2220'),6] , 32 , DataType.long , 'Shut motors' ) ;    

% --- Executes just before Rescue is made visible.
function Rescue_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Rescue (see VARARGIN)
global DataType
global RecStruct 


global DispT
if ~exist('DispT','var') || ~isa(DispT,'DlgTimerObj')
    evalin('base','AtpStart') ; 
end
handles.SimMode  = 0 ; 
handles.EvtObj = DlgUserObj(@update_sw_display,hObject);
handles.EvtObj.listenToTimer(DispT) ;   
handles.Colors = struct( 'Grey', rgb('DarkGray'),'Green',rgb('Lime'),'Cyan' , rgb('Cyan') ,'Red' , rgb('Red')); 
handles.WheelArmStates = RecStruct.Enums.WheelArmStates ;
handles.WakeUpStates = RecStruct.Enums.WakeUpStates ; 
handles.MotionModes  = RecStruct.Enums.MotionModes; 
handles.CreateStruct =  struct('Interpreter','tex','WindowStyle' , 'modal') ; 


[cfg,~,errstr] = GetRobotCfg(0); 
if ~isempty(errstr) 
    uiwait(errordlg(["Robot is not configured correctly","User RobotCfg dialog to fix that"] ) ) ; 
    return ; 
end
handles.RobotCfg = cfg ; 

% Choose default command line output for Rescue
handles.output = hObject;
guidata(hObject, handles);

[handles,good,msg] = GetRobotState( handles) ;
if ~good
    uiwait( errordlg({'Robot state does not permit rescue',msg,'Use BIT or WheelArm dialog','to correct the issue','hint: use [Reset LP Only]'}) ) ; 
    error('So sorry') ; 
end

if ( handles.OnPole && ~((handles.WheelArmState==handles.WheelArmStates.E_GroundGood2Go) ||(handles.WheelArmState==handles.WheelArmStates.E_RExtendGood2Go) ||(handles.WheelArmState==handles.WheelArmStates.E_LExtendGood2Go) )  ) 
    uiwait( errordlg({'Wheel arm not in the retracted state','use WheelArm dialog','to correct the issue'}) ) ; 
    error('So sorry') ; 
end
    
% Get protocol 
try 
handles.ComProtocol = FetchObj( [hex2dec('2224'),1] , DataType.long ,'Comm Protocol') ;
handles.RetractedWidth = FetchObj( [hex2dec('2224'),2] , DataType.float ,'RetractedWidth');
handles.ExtendedWidth = FetchObj( [hex2dec('2224'),3] , DataType.float ,'ExtendedWidth');
catch 
handles.ComProtocol = 2^24 ; 
handles.RetractedWidth = 0.502 ; 
handles.ExtendedWidth = 0.722 ; 
end

if handles.ComProtocol >= (2^24 + 2^16)
    handles.IsTrackWidthProtocol = 1  ;
else
    handles.IsTrackWidthProtocol = 0  ;
end

% See manipulator type 
CalibStr = SaveCalib ( [] , 'SetManipTypeParamsBackup.jsn' ); 

WheelArmType = bitand( bitshift(CalibStr.RobotConfig,-4) , 3) ;
switch WheelArmType 
    case RecStruct.Enums.WheelArmType.Rigid 
        set(handles.TextWheelArm,'String','Rigid: No wheelarm') 
        handles.ExtendedWidth = handles.RetractedWidth ; 
        handles.IsWheelArm = 0 ; 
    case RecStruct.Enums.WheelArmType.Wheel_Arm28 
        set(handles.TextWheelArm,'String','Wheel arm installed') 
        handles.IsWheelArm = 1 ; 
    case RecStruct.Enums.WheelArmType.Wheel_Arm24
        set(handles.TextWheelArm,'String','Wheel arm installed') 
        handles.IsWheelArm = 1 ; 
    otherwise
        error("Unidentified wheel arm configuration") ;                 
end

% Geometry - see that height is big enough to start 
handles.Geom = struct() ; 
handles.Geom.ClimbArcRadi = GetFloatPar('Geom.ClimbArcRadi') ; 
handles.Geom.DistanceFromShoulderJoint2Slidewheel = GetFloatPar('Geom.DistanceFromShoulderJoint2Slidewheel') ; 
handles.Geom.Center2WheelDist  = GetFloatPar('Geom.Center2WheelDist') ; 
handles.Geom.LimitSw2DistPosOnArc  = GetFloatPar('Geom.LimitSw2DistPosOnArc') ; 
handles.Geom.ClimbArcOverFloor = GetFloatPar('Geom.ClimbArcOverFloor') ; 

handles.MinStartHeight = handles.Geom.ClimbArcRadi + handles.Geom.DistanceFromShoulderJoint2Slidewheel ...
    + handles.Geom.Center2WheelDist ...
    + handles.Geom.LimitSw2DistPosOnArc + handles.Geom.ClimbArcOverFloor + 0.08 ; 

% handles.Geom.ClimbArcRadi + 2 * handles.Geom.DistanceFromShoulderJoint2Slidewheel + ...
%     handles.ExtendedWidth + 0.05 ;
set( handles.TextMinHeight,'String',num2str(handles.MinStartHeight)) ; 

REncSpeedCmd = FetchObj( [hex2dec('2207'),38] , DataType.float ,'Right speed cmd') ;
LEncSpeedCmd = FetchObj( [hex2dec('2207'),39] , DataType.float ,'Left speed cmd') ;
handles.WheelEncoder2Meter = FetchObj( [hex2dec('2207'),40] , DataType.float ,'WheelEncoder2Meter') ;
handles.GoodToGo = 1 ; 
%handles.OnTheJog = 0 ; 

handles.TravelSpeed = GetFloatPar('ControlPars.ShelfRescueSpeed') ; 
set(handles.EditTravelSpeed,'String',num2str(handles.TravelSpeed));

% Test general sanity 
if ~good 
    ButtonName = questdlg('Dont see a good to go robot. Continue as debug sim?', ...
                         'Yes only as Dev aid', ...
                         'Yes', 'No', 'No') ;    
    if ~isequal(ButtonName,'Yes') 
        set( handles.TextMain , 'String' , 'Cant help you, poor thing') ;
        set( handles.TextAlways , 'String' , 'Dont identify robot position') ;
        handles.GoodToGo = 0 ; 
    else 
        handles.SimMode = 1 ; 
        [handles,~] = GetRobotState( handles) ;     
    end 
end

if  REncSpeedCmd || LEncSpeedCmd
    set( handles.TextMain , 'String' , 'Cant help you, poor thing') ;
    set( handles.TextAlways , 'String' , 'The robot is on the move') ;
    handles.GoodToGo = 0 ; 
end  

if ~handles.SimMode && ~IsRobotOk(handles) 
    set( handles.TextMain , 'String' , 'Cant help you, poor thing') ;
    set( handles.TextAlways , 'String' , 'Set all the motors ON') ;
    handles.GoodToGo = 0 ; 
end 

handles.RobotHeight = inf ;
handles.HeightTol   = 0.15 ;
% handles.MaxJogSpeed = 0.3  ; 
% handles.JogSpeed = 0 ; 
  
if ~handles.OnShelf && ~handles.OnPole
    set( handles.TextMain , 'String' , 'Cant help you, poor thing') ;
    set( handles.TextAlways , 'String' , 'The robot is neither on shelf nor on pole') ;
    handles.GoodToGo = 0 ; 
end 

if handles.GoodToGo
    if handles.IsRight
        dirstr = 'Right' ;
        handles.ManualNeckCmd = pi/2 ; 
    else
        dirstr = 'Left' ; 
        handles.ManualNeckCmd = -pi/2 ; 
    end 
    if handles.OnShelf
        shelfstr ='On the shelf' ; 
        set(handles.CheckGoForward,'Visible','On','Value',1) ;  
        handles.ManualSteerCmd = 0 ; 
    else
        shelfstr ='On the pole' ; 
        set(handles.CheckGoForward,'Visible','Off') ;  
        handles.ManualSteerCmd = handles.ManualNeckCmd ;  
    end 
    
    set( handles.TextMain , 'String' , ['At your service: Unloading ',dirstr,' climb']) ;
    set( handles.TextAlways , 'String' , ['Initially ', shelfstr]) ;

    handles.GoDistance = 0 ; 
    if ( handles.OnShelf ) 
        set(handles.PushGo,'Visible','On') ;                                                                                                                                   
        set(handles.EditGoDist,'String',num2str(handles.GoDistance)) ; 
        set(handles.PushJog,'Visible','On') ; 
    else
        set(handles.PushJog,'Visible','Off') ;                                                                                                                                   
        set(handles.EditGoDist,'Visible','Off') ; 
    end 
    
    set(handles.PushGoDown,'Visible','On') ; 
%     set(handles.SliderJog,'Visible','Off') ;
%     set(handles.EditTravelSpeed,'Visible','Off') ;
    %set(handles.TextBw,'Visible','Off') ;
    
    
    set( handles.EditRobotHeight,'String','Need spec','ForegroundColor',[1,0,0],'BackgroundColor',[0,1,1] ,'Style','edit') ; 
    set( handles.EditHeightTol,'String',num2str(handles.HeightTol),'ForegroundColor',[1,0,0],'BackgroundColor',[0,1,1] ,'Style','edit') ; 
    
    % Reset the robot
    SendObj( [hex2dec('2301'),1] , hex2dec('12345678') , DataType.long , 'FW access rights' ) ;
    try 
    %SendObj( [hex2dec('2301'),244] , 0 , DataType.long , 'Reset FW' ) ;
    catch 
    end 
else
    set(handles.CheckGoForward,'Value',1,'Visible','Off') ;  
    set(handles.PushGo,'Visible','Off') ; 
    set(handles.PushGoDown,'Visible','Off') ; 
    set(handles.PushJog,'Visible','Off') ; 
%     set(handles.SliderJog,'Visible','Off') ;    
%     set(handles.EditTravelSpeed,'Visible','Off') ;
    %set(handles.TextBw,'Visible','Off') ;
    set( handles.EditRobotHeight,'String','NA','ForegroundColor',[0,0,0],'BackgroundColor',[1,0,0] ,'Style','text') ; 
    set( handles.EditHeightTol,'String','NA','ForegroundColor',[0,0,0],'BackgroundColor',[1,0,0] ,'Style','text') ; 
end

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes Rescue wait for user response (see UIRESUME)
% uiwait(handles.figure1);


function update_sw_display( hobj) 
    global TmMgrT
    handles = guidata(hobj) ; 

    try
    cnt = TmMgrT.GetCounter('RESCUE') ; 

    if cnt < -1e5 
        delete( hobj) ; 
    else
        update_screen(handles) ; 
        TmMgrT.IncrementCounter('RESCUE',2) ; 
    end     
        
    catch 
    end
    
function  x = update_screen(handles)
    x = 1 ; 
    

% --- Outputs from this function are returned to the command line.
function varargout = Rescue_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



function EditRobotHeight_Callback(hObject, eventdata, handles)
% hObject    handle to EditRobotHeight (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of EditRobotHeight as text
%        str2double(get(hObject,'String')) returns contents of EditRobotHeight as a double
handles.RobotHeight = AcceptInRange( handles.EditRobotHeight , handles.MinStartHeight , 12 , handles.RobotHeight ) ;

[handles,good] = GetRobotState( handles); 

if  isfinite( handles.RobotHeight ) && handles.GoodToGo && good 
    if ( handles.OnShelf ) 
        set( handles.PushGo ,'Enable', 'on') ; 
        set ( handles.CheckGoForward ,'Visible', 'on' ); 
    end
    set( handles.PushGoDown ,'Enable', 'on') ; 
else
    set( handles.EditRobotHeight,'String','Failed-rewrite','ForegroundColor',[1,0,0],'BackgroundColor',[0,1,1] ,'Style','edit') ; 
end 
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function EditRobotHeight_CreateFcn(hObject, eventdata, handles)
% hObject    handle to EditRobotHeight (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function EditHeightTol_Callback(hObject, eventdata, handles)
% hObject    handle to EditHeightTol (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of EditHeightTol as text
%        str2double(get(hObject,'String')) returns contents of EditHeightTol as a double
handles.HeightTol = AcceptInRange( handles.EditHeightTol , 0.01 , 1.0 , handles.RobotHeight ) ; 
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function EditHeightTol_CreateFcn(hObject, eventdata, handles)
% hObject    handle to EditHeightTol (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.



if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in CheckGoForward.
function CheckGoForward_Callback(hObject, eventdata, handles)
% hObject    handle to CheckGoForward (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of CheckGoForward


% --- Executes on button press in CheckResetAfter.
function CheckResetAfter_Callback(hObject, eventdata, handles)
% hObject    handle to CheckResetAfter (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of CheckResetAfter


% --- Executes on button press in PushGo.
function PushGo_Callback(hObject, eventdata, handles)
% hObject    handle to PushGo (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global DataType
global AtpCfg 
global BitKillTime 
second = [0 0 0 0 0 1];


BitKillTime =  datevec(datenum(clock + 2* second)); 
HardShutUpOlivier(); 

if ~IsRobotOk (handles)
    uiwait( msgbox('Robot is not clear to go:','Communication error or','Refer the BIT dialog','Error') ) ;
    BitKillTime =  datevec(datenum(clock)) ; 
    return ; 
end 
if ~isfinite(handles.RobotHeight) 
    uiwait( msgbox('You must define Robot Height before','Error') ) ;
    BitKillTime =  datevec(datenum(clock)) ; 
    return ; 
end 

[handles,good] = GetRobotState( handles) ;
if ~good
    uiwait( msgbox('Robot is not good to go: Refer the BIT dialog','Error') ) ;
    BitKillTime =  datevec(datenum(clock)) ; 
    return ; 
end 

if  handles.OnShelf  
    SetFloatPar('ControlPars.ShelfRescueSpeed',handles.TravelSpeed)
    Qindex = 1 ; 
    SpiDoTx = 2 ; 
    Dir = get(handles.CheckGoForward ,'Value') ; 
    if ~(Dir==1)
        Dir = -1 ; 
    end 

    SendObj( [hex2dec('2220'),120] , 1 , DataType.long ,'Disable overload detection') ;    

    SendObj( [hex2dec('2203'),100] , 1 , DataType.short ,'Chakalaka 0n') ;
  
    % Set a queue destination 
    SpiClearQueue( Qindex , SpiDoTx); 

    % Set a go home travel 
    NextPt = 0 ; 
    [~,~] = SpiSetSpecials( 'Lassie' , struct('Dir',Dir,'Height',handles.RobotHeight)  , SpiDoTx ) ; 
    
    NextPt = NextPt + 1 ; 
    [~,~] = SpiSetPathWait( Qindex , NextPt , inf , SpiDoTx ) ;
    
    % Set recorder on 
    if ~AtpCfg.Udp.On 
        AnaShelfRescueRecord() ; 
    end 
    
    % and execute it 
    [~,~] = SpiQueueExec( Qindex , 0 , 1 , SpiDoTx ) ; 
    BitKillTime =  datevec(datenum(clock)) ; 
else
    BitKillTime =  datevec(datenum(clock)) ; 
    msgbox('Robot need be ready on the shelf to do that','Error') ; 
end


% --- Executes on button press in PushJog.(hObject, eventdata, handles)
function PushJog_Callback(hObject, ~, handles)
% hObject    handle to PushJog (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global DataType 
HardShutUpOlivier(); 


% if handles.OnTheJog
%     set(handles.PushJog,'String','Jog') ; 
% %     set(handles.SliderJog,'Visible','Off','Value',0) ;    
%     set(handles.EditTravelSpeed,'Visible','Off') ;
%     %set(handles.TextBw,'Visible','Off') ;
%     if ( handles.OnShelf ) 
%         set(handles.PushGo,'Enable','On') ;
%     end
%     set(handles.PushGoDown,'Enable','On') ;
% 
%     SendObj( [hex2dec('2206'),11] , 0  , DataType.float , 'Speed command RWheel' ) ;
%     SendObj( [hex2dec('2206'),12] , 0  , DataType.float , 'Speed command LWheel' ) ;
%     handles.OnTheJog = 0 ; 
% else
    if ~IsRobotOk (handles)
        uiwait( msgbox('Robot is not ready to go:','Communication error or', 'Refer the BIT dialog','Error') ) ;
        return ; 
    end 
    
    if ( ~handles.OnShelf ) 
        uiwait( errordlg('This mode is only available horizontally on the shelf ') ) ;
        return ; 
    end
    % Kill auto recorder trigger, so we dont destroy previous problems
    % records
    SendObj( [hex2dec('2222'),16] , 0 , DataType.long , 'Debug mode = bRecorder4ShelfRun' ) ;

    SetFloatPar('AutomaticRunPars.ShelfSpeed',handles.TravelSpeed) ; 
    
    if ( SendObj( [hex2dec('220b'),2] , 4  , DataType.long , 'Set mode to manual travel' ) ) 
        uiwait( errordlg('Cannot start the motors in manual mode (servo fault?)') ) ;
        return ;         
    end 
    
    SendObj( [hex2dec('2220'),98] , 5  , DataType.long , 'Set mode to shelf' ) ;
    
    SendObj( [hex2dec('2207'),62] , handles.GoDistance  , DataType.float , 'send as fine position' ) ;
%     set(handles.PushJog,'String','Stop') ; 
%     set(handles.SliderJog,'Visible','On','Value',0) ; 


    [handles,good] = GetRobotState( handles); 
    if ~good
        set( handles.TextMain , 'String' , 'Cant help you, poor thing') ;
        set( handles.TextAlways , 'String' , 'Robot is not ok to move') ;
        StopMotors() ; 
        if handles.OnShelf
            set(handles.PushGo,'Enable','On') 
        end
        set(handles.PushGoDown,'Enable','On') 
%         handles.OnTheJog = 0  ; 
    else 
        set( handles.TextMain , 'String'   , 'At your service') ;
        set( handles.TextAlways , 'String' , 'Jogging') ; 
%         SendObj( [hex2dec('2206'),13] , handles.ManualSteerCmd  , DataType.float , 'Pos command RSteer' ) ;
%         SendObj( [hex2dec('2206'),14] , handles.ManualSteerCmd  , DataType.float , 'Pos command LSteer' ) ;
%         SendObj( [hex2dec('2206'),15] , handles.ManualNeckCmd   , DataType.float , 'Pos command Neck' ) ;
%         set(handles.PushGo,'Enable','Off') 
%         set(handles.PushGoDown,'Enable','Off') 
%         handles.OnTheJog = 1 ; 
    end 
% end 
% handles.JogSpeed = 0 ; 
guidata(hObject, handles);


% --- Executes on slider movement.
function SliderJog_Callback(hObject, eventdata, handles)
% hObject    handle to SliderJog (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
% global DataType 
% 
% [handles,good] = GetRobotState( handles); 
% if good
%     if ~IsRobotOk (handles)
%         uiwait( msgbox('Robot is not ready to go: Refer the BIT dialog','Error') ) ;
%         set( handles.SliderJog ,'Value', 0 ) ; 
%         return ; 
%     end     
%     
%     val = get(handles.SliderJog,'Value') ; 
%     handles.JogSpeed = handles.MaxJogSpeed * val ; 
%     SendObj( [hex2dec('2206'),11] , handles.JogSpeed  , DataType.float , 'Speed command RWheel' ) ;
%     SendObj( [hex2dec('2206'),12] , handles.JogSpeed   , DataType.float , 'Speed command LWheel' ) ;
%     guidata(hObject, handles);
% else
%     set( handles.TextMain , 'String' , 'Cant help you, poor thing') ;
%     set( handles.TextAlways , 'String' , 'Robot is not ok to move') ;
%     StopMotors() ; 
%     handles.OnTheJog = 0  ; 
% end

% --- Executes during object creation, after setting all properties.
% function SliderJog_CreateFcn(hObject, ~, handles)
% hObject    handle to SliderJog (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
% if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
%     set(hObject,'BackgroundColor',[.9 .9 .9]);   
% end
% set( hObject , 'Min', -1 , 'Max' , 1 , 'Value', 0 , 'SliderStep', [1/8 1/2] ) ; 


% --- Executes on button press in PushStopAll.
function PushStopAll_Callback(hObject, eventdata, handles)
% hObject    handle to PushStopAll (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global DataType 
% First kill the wheels 
SendObj( [hex2dec('2206'),11] , 0  , DataType.float , 'Speed command RWheel' ) ;
SendObj( [hex2dec('2206'),12] , 0   , DataType.float , 'Speed command LWheel' ) ;

% Get axis commands for R,L, Neck 
% cmdrsteer = FetchObj( [hex2dec('2206'),13] , DataType.float ,'Right steer cmd') * 180 / pi; 
% cmdlsteer = FetchObj( [hex2dec('2206'),14] , DataType.float ,'Left steer cmd') * 180 / pi; 
% cmdneck =  FetchObj( [hex2dec('2206'),15] , DataType.float ,'Left steer cmd') * 180 / pi; 


% Get axis actuals for R,L, Neck 
% actrsteer = -FetchObj( [hex2dec('2204'),30] , DataType.float ,'Right steer angle') * 180 / pi;
% actlsteer = -FetchObj( [hex2dec('2204'),31] , DataType.float ,'Left steer angle') * 180 / pi; 
% actneck   = FetchObj( [hex2dec('2204'),32] , DataType.float ,'NeckAngle')* 180 / pi ;
% 
% % Take actual value just id difference is too large
% if abs(cmdrsteer-actrsteer) > 8 
%     cmdrsteer = actrsteer ; 
% end
% if abs(cmdlsteer-actlsteer) > 8 
%     cmdlsteer = aclsteer ; 
% end
% if abs(cmdneck-actneck) > 8 
%     cmdneck = actneck ; 
% end

% SendObj( [hex2dec('2206'),13] , cmdrsteer  , DataType.float , 'Speed command RWheel' ) ;
% SendObj( [hex2dec('2206'),14] , cmdlsteer   , DataType.float , 'Speed command LWheel' ) ;
% SendObj( [hex2dec('2206'),15] , cmdneck   , DataType.float , 'Speed command LWheel' ) ;
% 
% handles.ManualRSteerCmd = cmdrsteer ;
% handles.ManualLSteerCmd = cmdlsteer ; 
% handles.ManualNeckCmd = cmdneck ;
% handles.ManualRSpeedCmd = 0  ; 
% handles.ManualLSpeedCmd = 0  ; 


% handles.OnTheJog = 0 ; 
% set(handles.PushJog,'String','Jog') ; 
% set(handles.SliderJog,'Visible','Off','Value',0) ;    
% set(handles.EditTravelSpeed,'Visible','Off') ;
%set(handles.TextBw,'Visible','Off') ;
if handles.OnShelf
    set(handles.PushGo,'Enable','On') ; 
end
set(handles.PushGoDown,'Enable','On') ; 

guidata(hObject, handles); % Store command


% --- Executes on button press in PushGoDown.
function PushGoDown_Callback(hObject, eventdata, handles)
% hObject    handle to PushGoDown (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global DataType
global BitKillTime 
second = [0 0 0 0 0 1];

BitKillTime =  datevec(datenum(clock + 2* second)); 

HardShutUpOlivier();

[good,s] = IsRobotOk (handles);
if ~good
    uiwait( msgbox('Robot is not clear to go:','Communication error or','Refer the BIT dialog','Error') ) ;
    BitKillTime =  datevec(datenum(clock)) ; 
    return ; 
end 
if ~isfinite(handles.RobotHeight) 
    uiwait( msgbox('You must define Robot Height before','Error') ) ;
    BitKillTime =  datevec(datenum(clock)) ; 
    return ; 
end 

[handles,good] = GetRobotState( handles) ;
if ~good ()
    uiwait( msgbox('Robot is not good to go: Refer the BIT dialog','Error') ) ;
    BitKillTime =  datevec(datenum(clock)) ; 
    return ; 
end 


DoRotate = 0 ;
if  ~handles.OnPole
    ButtonName = questdlg('Yo need to rotate junction. Do it?', ...
                     'Decision', ...
                     'Yes', 'No', 'No');    
    if isequal(ButtonName,'No') 
        uiwait( msgbox('Action aborted by user','Abort') ) ; 
        BitKillTime =  datevec(datenum(clock)) ; 
        return ;
    end 
    DoRotate = 1 ; 
else
    if ( s.base.NOuterPos < -1.4)
        ClimbDir = -1 ; 
    elseif ( s.base.NOuterPos > 1.4)
        ClimbDir =  1 ; 
    else
        msgbox({'\fontsize{14}Bad neck angle','Cannot decide direction'},'Abort',handles.CreateStruct) ; 
        BitKillTime =  datevec(datenum(clock)) ; 
        return ; 
    end

    if ClimbDir >= 0 
        stat = SendObj( [hex2dec('2222'),28] , 0.05 , DataType.float , 'Set crawl right' ) ;
    else
        stat = SendObj( [hex2dec('2222'),29] , 0.05 , DataType.float , 'Set crawl left' ) ;
    end
    if stat 
        msgbox({'\fontsize{14}Bad steering angle','Cannot define crabbed mode'},'Abort',handles.CreateStruct) ; 
        BitKillTime =  datevec(datenum(clock)) ; 
        return ; 
    end 
end 

SendObj( [hex2dec('2220'),120] , 1 , DataType.long ,'Disable overload detection') ;    

SendObj( [hex2dec('2203'),100] , 1 , DataType.short ,'Chakalaka 0n') ;

SetFloatPar('ControlPars.DownTolForArcSwitchLoc',handles.HeightTol) ; 
Qindex = 1 ; 
SpiDoTx = 2 ; 
yDist = 0.35 ; 

% Set a queue destination 
SpiClearQueue( Qindex , SpiDoTx); 

% Set a go home travel 
NextPt = 0 ; 

if handles.IsRight
    Yew = pi/2 ; 
else
    Yew = -pi/2 ; 
end

if ( DoRotate ) 
% Unrotate the disc 
    [~,~] = SpiSetSpecials( 'SetHeightRot' , struct('Dir',0,'Height',handles.RobotHeight)  , SpiDoTx ) ; 
    RotateCmd = -1 ; IsClimb = 1 ; 
    NextPt = NextPt + 1 ; 
    [~,~] = SpiChangeMode( Qindex , NextPt , [Yew,RotateCmd,IsClimb] , SpiDoTx ); 
else
    [~,~] = SpiSetSpecials( 'SetHeight' , struct('Dir',0,'Height',handles.RobotHeight)  , SpiDoTx ) ; 
end

% Unclimb 
NextPt = NextPt + 1 ; 
xTarget = 0 ; yTarget = 0 ; 
[~,~] = SpiSetPathPt( Qindex , NextPt , struct('X',[xTarget,yTarget,handles.RobotHeight] ,'cx', [1 , 0, 0],'TrackWidth',handles.RetractedWidth) , [],SpiDoTx );

NextPt = NextPt + 1 ; 
[~,~] = SpiSetPathPt( Qindex , NextPt , struct('X',[xTarget,yTarget,0] ,'cx' , [1 , 0, 0],'TrackWidth',handles.RetractedWidth),[] , SpiDoTx );

% Change the mode to unclimbed 
NextPt = NextPt + 1 ; 
RotateCmd = 0 ; IsClimb = 0 ; 
[~,~] = SpiChangeMode( Qindex , NextPt , [Yew,RotateCmd,IsClimb] , SpiDoTx );

% Return to course 
NextPt = NextPt + 1 ; 
[~,~] = SpiSetPathPt( Qindex , NextPt , struct('X',[xTarget,yTarget,0] ,'cx', [1 , 0, 0],'TrackWidth',handles.RetractedWidth) ,[], SpiDoTx );

NextPt = NextPt + 1 ; 
[~,~] = SpiSetPathPt( Qindex , NextPt , struct('X',[xTarget,yTarget-yDist,0],'cx', [1 , 0, 0],'TrackWidth',handles.RetractedWidth),[] , SpiDoTx );

% Uncrab 
NextPt = NextPt + 1 ; 
Yew = 0 ; RotateCmd = 0 ; IsClimb = 0 ; 
[~,~] = SpiChangeMode( Qindex , NextPt , [Yew,RotateCmd,IsClimb] , SpiDoTx );

% End the queue
NextPt = NextPt + 1 ; 
[~,~] = SpiSetPathWait( Qindex , NextPt , inf , SpiDoTx ) ;

% and execute it 
[~,~] = SpiQueueExec( Qindex , 0 , 1 , SpiDoTx ) ;      
BitKillTime =  datevec(datenum(clock)); 


% --- Executes during object deletion, before destroying properties.
function figure1_DeleteFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
delete( handles.EvtObj) ;



function EditTravelSpeed_Callback(hObject, eventdata, handles)
% hObject    handle to EditTravelSpeed (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of EditTravelSpeed as text
%        str2double(get(hObject,'String')) returns contents of EditTravelSpeed as a double
handles.TravelSpeed = AcceptInRange( handles.EditTravelSpeed , 0.02 , 0.4 , handles.TravelSpeed ) ;
set(handles.EditTravelSpeed,'String',num2str(handles.TravelSpeed)); 
SetFloatPar('ControlPars.ShelfRescueSpeed',handles.TravelSpeed) ; 
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function EditTravelSpeed_CreateFcn(hObject, eventdata, handles)
% hObject    handle to EditTravelSpeed (see GCBO)
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

% Hint: delete(hObject) closes the figure
delete(hObject);



function TextAlways_Callback(hObject, eventdata, handles)
% hObject    handle to TextAlways (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of TextAlways as text
%        str2double(get(hObject,'String')) returns contents of TextAlways as a double


% --- Executes during object creation, after setting all properties.
function TextAlways_CreateFcn(hObject, eventdata, handles)
% hObject    handle to TextAlways (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function EditGoDist_Callback(hObject, eventdata,  handles)
% hObject    handle to EditGoDist (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of EditGoDist as text
%        str2double(get(hObject,'String')) returns contents of EditGoDist as a double
handles.GoDistance = AcceptInRange( handles.EditGoDist , -20 , 20 , handles.GoDistance ) ;
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function EditGoDist_CreateFcn(hObject, eventdata, handles)
% hObject    handle to EditGoDist (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in PushAlignRobot.
function PushAlignRobot_Callback(hObject, eventdata, handles)
% hObject    handle to PushAlignRobot (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Cause the robot to align 
global DataType
[~,RetStr] = SendObj( [hex2dec('2207'),63] , 1 , DataType.long , 'Set automatic shelf alignment to IMU ' ) ;
if ~isempty(RetStr)  
    uiwait(errordlg({'Cant align now, reason',RetStr})) ; 
end
