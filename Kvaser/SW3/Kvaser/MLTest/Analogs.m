function varargout = Analogs(varargin)
% ANALOGS MATLAB code for Analogs.fig
%      ANALOGS, by itself, creates a new ANALOGS or raises the existing
%      singleton*.
%
%      H = ANALOGS returns the handle to a new ANALOGS or the handle to
%      the existing singleton*.
%
%      ANALOGS('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in ANALOGS.M with the given input arguments.
%
%      ANALOGS('Property','Value',...) creates a new ANALOGS or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Analogs_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Analogs_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Analogs

% Last Modified by GUIDE v2.5 11-Nov-2022 07:20:01
global ObjectIndex
global ObjectSubindex
global Color_OnPending
global Color_On
global SimFlags
Color_On = [0 1 0];
Color_OnPending = [0 0.5 0.5];

ObjectIndex=struct(...
    'SetGetManipulatorAction' , hex2dec('2103')...
    ,'ControlWord', hex2dec('2210') ) ; 
ObjectSubindex=struct(...
    'SetGetManipulatorAction_workMode' , 1 ...
    ,'SetGetManipulatorAction_expectedXmm' , 102 ...
    ,'SetGetManipulatorAction_expectedYmm' , 103 ...
    ,'SetGetManipulatorAction_simMode' , 200 ...
    );
SimFlags=struct(...
	'Manipulator',1 ...
	,'Laser',2 ...
	);

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Analogs_OpeningFcn, ...
                   'gui_OutputFcn',  @Analogs_OutputFcn, ...
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


% --- Executes just before Analogs is made visible.
function Analogs_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Analogs (see VARARGIN)

AtpStart; % Start CAN services 

uiwait(msgbox('Make sure your Kvaser is connected to CAN#2') ) ;

% Initial choice of manipulator commanding mode 
set( handles.RadioManAuto, 'Value' , 1  ) ; 
set( handles.PushManManual, 'Value' , 0  ) ; 
set( handles.PushArmStandby,'Enable','off') ; 
set( handles.PushDynSend,'Enable','off') ; 
set( handles.PushArmStandby,'Enable','off') ; 
set( handles.PushGoPackage,'Enable','off') ; 
set( handles.PushPutPackage,'Enable','off') ; 


% Choose default command line output for Analogs
handles.output = hObject;
handles.DynStat = struct('DynRef',zeros(1,5));

guidata(hObject, handles);

handles.timer = timer(...
    'ExecutionMode', 'fixedRate', ...       % Run timer repeatedly.
    'Period', 0.65, ...                        % Initial period is 1 sec.
    'TimerFcn', {@update_display,hObject}); % Specify callback function.% Update handles structure
start (handles.timer) ;
% Update handles structure
guidata(hObject, handles);

% UIWAIT makes Analogs wait for user response (see UIRESUME)
% uiwait(handles.figure1);

function update_display( varargin) 

global TargetCanId
global DataType 
    handles = guidata(varargin{3}) ; 
    
    if ( get( handles.CheckCCSDebug,'Value') == 1 ) 
        % If inside the debugger, dont address with CAN
        return;
    end 
    
    s = PDGetAnalogs() ; 
    set( handles.Txt5V,'String' , num2str( s.Volts5 )  ) ;
    set( handles.Txt36V,'String' , num2str( s.V36 )  ) ;
    set( handles.Txt54V,'String' , num2str( (s.VBat54_1 +  s.VBat54_2) * 0.5)  ) ;
    set( handles.Txt12V,'String' , num2str( (s.Volts12_1+s.Volts12_2)*0.5 )  ) ;
    set( handles.Txt5VCur,'String' , num2str( s.CurServo )  ) ;
    set( handles.Txt12VCur,'String' , num2str( s.Cur12 )  ) ;
    set( handles.Txt24VCur,'String' , num2str( s.Cur24 )  ) ;
    set( handles.Txt24V,'String' , num2str( s.Volts24 )  ) ;
    set( handles.TxtVServo,'String' , num2str( s.VServo )  ) ;
    set( handles.TextCurPump1,'String' , num2str( s.CurAirPump1 )  ) ;
    set( handles.TextCurPump2,'String' , num2str( s.CurAirPump2 )  ) ;
    set( handles.TextCurPump3,'String' , num2str( s.CurAirPump3 )  ) ;
    set( handles.TextShuntCur,'String' , num2str( s.IShunt )  ) ;

    set( handles.TextSuckState1, 'String' , num2str(s.PumpC1) ) ; 
    set( handles.TextSuckState2, 'String' , num2str(s.PumpC2) ) ; 

    
    % d = GetDigitals() ; 
    ss = GetBitStatus() ;
    handles.ss = ss ; 
    
    LpControl = get(handles.RadioManAuto , 'Value') ; 

    
    if isequal( ss.MushrumState, 'Released') 
        set( handles.CheckMushroom,'Value' , 1  ) ;
    else
        set( handles.CheckMushroom,'Value' , 0  ) ;
    end 
   set( handles.TextV12Status,'String', ss.str12  ) ;
   set( handles.TextV24Status,'String', ss.str24  ) ;
   set( handles.Text54VStat,'String', ss.str54  ) ;
   
   if isequal( ss.MushrumState, 'Released') 
       if ( ss.V12On  )
           set( handles.PushStart12V ,'String', 'Shut 12V','BackgroundColor',[0 1 0]) ; 
           if ( ss.V24On  )
               set( handles.PushStart24V ,'String', 'Shut 24V','BackgroundColor',[0 1 0]) ; 
           else
               set( handles.PushStart24V ,'String', 'Set 24V','BackgroundColor',[0 0.5 1]) ; 
           end 
       else
           set( handles.PushStart12V ,'String', 'Set 12V','BackgroundColor',[0 0.5 1]) ; 
           set( handles.PushStart24V ,'String', 'Disabled by 12V off','BackgroundColor',[1 1 1] * 0.9) ; 
       end 
   else
        set( handles.PushStart12V ,'String', 'Disabled by mushroom','BackgroundColor',[1 1 1] * 0.9) ; 
        set( handles.PushStart24V ,'String', 'Disabled by mushroom','BackgroundColor',[1 1 1] * 0.9) ; 
   end

   if ( ss.ServoPwrOn == 0 ) 
       set( handles.PushServoVoltage ,'String', 'Set ServoVoltage','BackgroundColor',[0 0.5 1]) ; 
   else
       set( handles.PushServoVoltage ,'String', 'Cut ServoVoltage','BackgroundColor',[0 1 0]) ; 
   end 
  
   if( ss.PumpOn(1) == 0 ) 
       set( handles.PushPump1 ,'String', 'Laser PS ON','BackgroundColor',[0 0.5 1]) ; 
   else
       set( handles.PushPump1 ,'String', 'Laser PS Off','BackgroundColor',[0 1 0]) ; 
   end 
   if( ss.PumpOn(2) == 0 ) 
       set( handles.PushPump2 ,'String', 'Set Pump 2','BackgroundColor',[0 0.5 1]) ; 
   else
       set( handles.PushPump2 ,'String', 'Cut Pump 2','BackgroundColor',[0 1 0]) ; 
   end 
   if( ss.PumpOn(3) == 0 ) 
       set( handles.PushPump3 ,'String', 'Set Pump 3','BackgroundColor',[0 0.5 1]) ; 
   else
       set( handles.PushPump3 ,'String', 'Cut Pump 3','BackgroundColor',[0 1 0]) ; 
   end 
   if( ss.Chakalaka == 0) 
       set( handles.PushChakalaka ,'String', 'Set Chakalaka','BackgroundColor',[0 0.5 1]) ; 
   else
       set( handles.PushChakalaka ,'String', 'Cut Chakalaka','BackgroundColor',[0 1 0]) ; 
   end
   
   if( ss.StopBrake == 0) 
       set( handles.PushStopBrake ,'String', 'Set StopBrake','BackgroundColor',[0 0.5 1]) ; 
   else
       set( handles.PushStopBrake ,'String', 'Cut StopBrake','BackgroundColor',[0 1 0]) ; 
   end
   
   if( ss.StopRelay == 0)
       set( handles.PushStopRelay ,'String', 'Set StopRelay','BackgroundColor',[0 0.5 1]) ; 
   else
       set( handles.PushStopRelay ,'String', 'Cut StopRelay','BackgroundColor',[0 1 0]) ; 
   end 

   if( ss.SteerBrake == 0)
       set( handles.PushSteerBrake ,'String', 'Set SteerBrake','BackgroundColor',[0 0.5 1]) ; 
   else
       set( handles.PushSteerBrake ,'String', 'Cut SteerBrake','BackgroundColor',[0 1 0]) ; 
   end 
   
   if( ss.WheelBrake == 0)
       set( handles.PushWheelBrake ,'String', 'Set WheelBrake','BackgroundColor',[0 0.5 1]) ; 
   else
       set( handles.PushWheelBrake ,'String', 'Cut WheelBrake','BackgroundColor',[0 1 0]) ; 
   end 
   
   if( ss.NeckBrake == 0)
       set( handles.PushNeckBrake ,'String', 'Set NeckBrake','BackgroundColor',[0 0.5 1]) ; 
   else
       set( handles.PushNeckBrake ,'String', 'Cut NeckBrake','BackgroundColor',[0 1 0]) ; 
   end 
   
   if( ss.Fan == 0)
       set( handles.PushFan ,'String', 'Set Fan','BackgroundColor',[0 0.5 1]) ; 
   else
       set( handles.PushFan ,'String', 'Cut Fan','BackgroundColor',[0 1 0]) ; 
   end
   
   if( ss.TailLamp == 0)
       set( handles.PushTailLamp ,'String', 'Set TailLamp','BackgroundColor',[0 0.5 1]) ; 
   else
       set( handles.PushTailLamp ,'String', 'Cut TailLamp','BackgroundColor',[0 1 0]) ; 
   end 

   if( ss.Shunt == 0)
       set( handles.PushShunt ,'String', 'Set Shunt','BackgroundColor',[0 0.5 1]) ; 
   else
       set( handles.PushShunt ,'String', 'Cut Shunt','BackgroundColor',[0 1 0]) ; 
   end 
   
   EncInCounts = get( handles.CheckEncoderCounts, 'Value' ) ;
 
   if ( get( handles.PushManManual, 'Value') == 1 && ss.Dynamixel24On && ss.MONShoulder && ss.MONElbow && ss.MONWrist && ...
           ss.Dynamixel12On && ss.MONLeft && ss.MONRight ) 
      set( handles.PushDynSend,'Enable','on') ; 
   else
      set( handles.PushDynSend,'Enable','off') ; 
   end

   
   if ( ss.Dynamixel24On ) 
       if ( ss.InitState24 == 0  ) 
            set( handles.PushStartMan ,'String', 'Man Net On','BackgroundColor',[0 0.5 0.5]) ; 
       else
            set( handles.PushStartMan ,'String', 'Man Ready','BackgroundColor',[0 1 0]) ; 
            if ( EncInCounts ) 
                Olist = [12,22,32] ; 
            else
                Olist = [13,23,33] ; 
            end 
            val1 = KvaserCom( 8 , [1536+TargetCanId ,1408+TargetCanId ,hex2dec('2103') ,Olist(1),DataType.long,0,100] ); % Get records
            val2 = KvaserCom( 8 , [1536+TargetCanId ,1408+TargetCanId ,hex2dec('2103') ,Olist(2),DataType.long,0,100] ); % Get records
            val3 = KvaserCom( 8 , [1536+TargetCanId ,1408+TargetCanId ,hex2dec('2103') ,Olist(3),DataType.long,0,100] ); % Get records
            if ( EncInCounts == 0 ) 
                val1 = val1 * 0.057295779513082 ; 
                val2 = val2 * 0.057295779513082 ; 
                val3 = val3 * 0.057295779513082 ; 
            end 
            set ( handles.TextShoulderAngle ,'String', num2str(val1) ) ; 
            set ( handles.TextElbowAngle ,'String', num2str(val2) ) ; 
            set ( handles.TextWristAngle ,'String', num2str(val3) ) ; 
            
            if ( ss.MONShoulder ) 
                set ( handles.TextShoulderOn,'BackgroundColor',[0,1,0]) ; 
            else
                set( handles.TextShoulderOn,'BackgroundColor',[0,0,1]) ; 
            end 
            
            if ( LpControl  || ss.MONShoulder == 0 )
                val = KvaserCom( 8 , [1536+TargetCanId ,1408+TargetCanId ,hex2dec('2103') ,11,DataType.long,0,100] );  
                if ~isempty(val) 
                    handles.DynStat.DynRef(1)= val * 0.001 ;  
                    set ( handles.EditShoulderAngle , 'String' , num2str( handles.DynStat.DynRef(1) * 57.295779513082323) ) ; 
                end
            end 
            
            if ( ss.MONElbow ) 
                set( handles.TextElbowOn,'BackgroundColor',[0,1,0]) ; 
            else
                set( handles.TextElbowOn,'BackgroundColor',[0,0,1]) ; 
            end
            
            if ( LpControl  || ss.MONElbow == 0 )
                 val = KvaserCom( 8 , [1536+TargetCanId ,1408+TargetCanId ,hex2dec('2103') ,21,DataType.long,0,100] );  
                if ~isempty(val) 
                    handles.DynStat.DynRef(2) = val * 0.001 ; 
                    set ( handles.EditElbowAngle , 'String' , num2str( handles.DynStat.DynRef(2) * 57.295779513082323) ) ; 
                end
            end
            
            if ( ss.MONWrist )
                set( handles.TextWristOn,'BackgroundColor',[0,1,0]) ; 
            else
                set( handles.TextWristOn,'BackgroundColor',[0,0,1]) ; 
            end 
            
            if ( LpControl  || ss.MONWrist == 0 )
                val = KvaserCom( 8 , [1536+TargetCanId ,1408+TargetCanId ,hex2dec('2103') ,31,DataType.long,0,100] );  
                if ~isempty(val) 
                    handles.DynStat.DynRef(3) = val * 0.001 ; 
                    set ( handles.EditWristAngle , 'String' , num2str( handles.DynStat.DynRef(3) * 57.295779513082323) ) ; 
                end
            end
            
       end 
   end 
   
   if ( ss.Dynamixel12On ) 
       if ( ss.InitState12 == 0 ) 
            set( handles.PushStartStop ,'String', 'Stop Net On','BackgroundColor',[0 0.5 0.5]) ; 
       else
            set( handles.PushStartStop ,'String', 'Stop Tready','BackgroundColor',[0 1 0]) ; 
            if ( EncInCounts ) 
                Olist = [42,52 ] ; 
            else
                Olist = [43,53 ] ; 
            end 
            val1 = KvaserCom( 8 , [1536+TargetCanId ,1408+TargetCanId ,hex2dec('2103') ,Olist(1),DataType.long,0,100] ); % Get records
            val2 = KvaserCom( 8 , [1536+TargetCanId ,1408+TargetCanId ,hex2dec('2103') ,Olist(2),DataType.long,0,100] ); % Get records
            if ( EncInCounts == 0 ) 
                val1 = val1 * 0.057295779513082 ; 
                val2 = val2 * 0.057295779513082 ; 
            end 
            set ( handles.TextLeftActual ,'String', num2str(val1) ) ; 
            set ( handles.TextRightActual ,'String', num2str(val2) ) ; 

            if ( ss.MONLeft ) 
                set( handles.TextLeftOn,'BackgroundColor',[0,1,0]) ; 
            else
                set( handles.TextLeftOn,'BackgroundColor',[0,0,1]) ; 
            end          
            if ( LpControl  || ss.MONLeft == 0 )
                val = KvaserCom( 8 , [1536+TargetCanId ,1408+TargetCanId ,hex2dec('2103') ,41,DataType.long,0,100] );  
                if ~isempty(val) 
                    handles.DynStat.DynRef(4) = val * 0.001 ; 
                    set ( handles.EditLeftTarget , 'String' , num2str( handles.DynStat.DynRef(4) * 57.295779513082323) ) ; 
                end
            end 
            
            if ( ss.MONRight ) 
                set( handles.TextRightOn,'BackgroundColor',[0,1,0]) ; 
            else
                set( handles.TextRightOn,'BackgroundColor',[0,0,1]) ; 
            end          
            if ( LpControl  || ss.MONRight == 0 )
                val = KvaserCom( 8 , [1536+TargetCanId ,1408+TargetCanId ,hex2dec('2103') ,51,DataType.long,0,100] );  
                if ~isempty(val) 
                    handles.DynStat.DynRef(5) = val * 0.001 ; 
                    set ( handles.EditRightTarget , 'String' , num2str( handles.DynStat.DynRef(5) * 57.295779513082323) ) ; 
                end
            end
       
       end 
   end 
 
   set( handles.CheckManSw1 ,'Value', ss.ManSw1 ) ;
   set( handles.CheckManSw2 ,'Value', ss.ManSw2 ) ; 
   set( handles.CheckStopSw1 ,'Value', ss.StopSw1 ) ; 
   set( handles.CheckStopSw2 ,'Value', ss.StopSw2 ) ; 
   
   
   
   handles.ss = ss ;
    % Update handles structure
   guidata(varargin{3}, handles);
   
% --- Outputs from this function are returned to the command line.
function varargout = Analogs_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in CheckMushroom.
function CheckMushroom_Callback(hObject, eventdata, handles)
% hObject    handle to CheckMushroom (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of CheckMushroom


% --- Executes on button press in PushStart12V.
function PushStart12V_Callback(hObject, eventdata, handles)
% hObject    handle to PushStart12V (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global DataType 
global TargetCanId
if isequal( get( handles.PushStart12V ,'String'), 'Set 12V')  
    KvaserCom( 7 , [1536+TargetCanId ,1408+TargetCanId ,hex2dec('2004'),1,DataType.short,0,100], 1 ); % Set 12V on  
end
if isequal( get( handles.PushStart12V ,'String'), 'Shut 12V')  
    KvaserCom( 7 , [1536+TargetCanId ,1408+TargetCanId ,hex2dec('2004'),1,DataType.short,0,100], 0 ); % Set 12V off
end 


% --- Executes on button press in PushStart24V.
function PushStart24V_Callback(hObject, eventdata, handles)
% hObject    handle to PushStart24V (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global DataType 
global TargetCanId
if isequal( get( handles.PushStart24V ,'String'), 'Set 24V')  
    KvaserCom( 7 , [1536+TargetCanId ,1408+TargetCanId ,hex2dec('2004'),2,DataType.short,0,100], 1 ); % Set 12V on  
end
if isequal( get( handles.PushStart24V ,'String'), 'Shut 24V')  
    KvaserCom( 7 , [1536+TargetCanId ,1408+TargetCanId ,hex2dec('2004'),2,DataType.short,0,100], 0 ); % Set 12V off
end 


% --- Executes on button press in PushPump1.
function PushPump1_Callback(hObject, eventdata, handles)
% hObject    handle to PushPump1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global DataType
global TargetCanId
if isequal( get( handles.PushPump1 ,'String'), 'Laser PS ON')  
    KvaserCom( 7 , [1536+TargetCanId ,1408+TargetCanId ,hex2dec('2003'),4,DataType.short,0,100], 1 ); % Set on  
else
    KvaserCom( 7 , [1536+TargetCanId ,1408+TargetCanId ,hex2dec('2003'),4,DataType.short,0,100], 0 ); % Set off
end 


% --- Executes on button press in PushPump2.
function PushPump2_Callback(hObject, eventdata, handles)
% hObject    handle to PushPump2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global DataType
global TargetCanId
if isequal( get( handles.PushPump2 ,'String'), 'Set Pump 2')  
    KvaserCom( 7 , [1536+TargetCanId ,1408+TargetCanId ,hex2dec('2003'),5,DataType.short,0,100], 1 ); % Set on  
else
    KvaserCom( 7 , [1536+TargetCanId ,1408+TargetCanId ,hex2dec('2003'),5,DataType.short,0,100], 0 ); % Set off
end 


% --- Executes on button press in PushPump3.
function PushPump3_Callback(hObject, eventdata, handles) %#ok<*DEFNU>
% hObject    handle to PushPump3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global DataType
global TargetCanId
if isequal( get( handles.PushPump3 ,'String'), 'Set Pump 3')  
    KvaserCom( 7 , [1536+TargetCanId ,1408+TargetCanId ,hex2dec('2003'),6,DataType.short,0,100], 1 ); % Set on  
else
    KvaserCom( 7 , [1536+TargetCanId ,1408+TargetCanId ,hex2dec('2003'),6,DataType.short,0,100], 0 ); % Set off
end 


% --- Executes on button press in PushChakalaka.
function PushChakalaka_Callback(hObject, eventdata, handles)
% hObject    handle to PushChakalaka (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global DataType
global TargetCanId
if isequal( get( handles.PushChakalaka ,'String'), 'Set Chakalaka')  
    KvaserCom( 7 , [1536+TargetCanId ,1408+TargetCanId ,hex2dec('2003'),7,DataType.short,0,100], 1 ); % Set on  
else
    KvaserCom( 7 , [1536+TargetCanId ,1408+TargetCanId ,hex2dec('2003'),7,DataType.short,0,100], 0 ); % Set off
end 


% --- Executes on button press in CheckManSw1.
function CheckManSw1_Callback(hObject, eventdata, handles) %#ok<*INUSD>
% hObject    handle to CheckManSw1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of CheckManSw1


% --- Executes on button press in CheckManSw2.
function CheckManSw2_Callback(hObject, eventdata, handles)
% hObject    handle to CheckManSw2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of CheckManSw2


% --- Executes on button press in CheckStopSw1.
function CheckStopSw1_Callback(hObject, eventdata, handles)
% hObject    handle to CheckStopSw1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of CheckStopSw1


% --- Executes on button press in CheckStopSw2.
function CheckStopSw2_Callback(hObject, eventdata, handles)
% hObject    handle to CheckStopSw2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of CheckStopSw2


% --- Executes on button press in PushStopBrake.
function PushStopBrake_Callback(hObject, eventdata, handles)
% hObject    handle to PushStopBrake (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global DataType
global TargetCanId
if isequal( get( handles.PushStopBrake ,'String'), 'Set StopBrake')  
    KvaserCom( 7 , [1536+TargetCanId ,1408+TargetCanId ,hex2dec('2003'),8,DataType.short,0,100], 1 ); % Set on  
else
    KvaserCom( 7 , [1536+TargetCanId ,1408+TargetCanId ,hex2dec('2003'),8,DataType.short,0,100], 0 ); % Set off
end 


% --- Executes on button press in PushStopRelay.
function PushStopRelay_Callback(hObject, eventdata, handles) %#ok<*INUSL>
% hObject    handle to PushStopRelay (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global DataType
global TargetCanId
if isequal( get( handles.PushStopRelay ,'String'), 'Set StopRelay')  
    KvaserCom( 7 , [1536+TargetCanId ,1408+TargetCanId ,hex2dec('2003'),9,DataType.short,0,100], 1 ); % Set on  
else
    KvaserCom( 7 , [1536+TargetCanId ,1408+TargetCanId ,hex2dec('2003'),9,DataType.short,0,100], 0 ); % Set off
end 


% --- Executes on button press in PushSteerBrake.
function PushSteerBrake_Callback(hObject, eventdata, handles)
% hObject    handle to PushSteerBrake (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global DataType
global TargetCanId
if isequal( get( handles.PushSteerBrake ,'String'), 'Set SteerBrake')  
    KvaserCom( 7 , [1536+TargetCanId ,1408+TargetCanId ,hex2dec('2003'),10,DataType.short,0,100], 1 ); % Set on  
else
    KvaserCom( 7 , [1536+TargetCanId ,1408+TargetCanId ,hex2dec('2003'),10,DataType.short,0,100], 0 ); % Set off
end 


% --- Executes on button press in PushWheelBrake.
function PushWheelBrake_Callback(hObject, eventdata, handles)
% hObject    handle to PushWheelBrake (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global DataType
global TargetCanId
if isequal( get( handles.PushWheelBrake ,'String'), 'Set WheelBrake')  
    KvaserCom( 7 , [1536+TargetCanId ,1408+TargetCanId ,hex2dec('2003'),11,DataType.short,0,100], 1 ); % Set on  
else
    KvaserCom( 7 , [1536+TargetCanId ,1408+TargetCanId ,hex2dec('2003'),11,DataType.short,0,100], 0 ); % Set off
end 


% --- Executes on button press in PushNeckBrake.
function PushNeckBrake_Callback(hObject, eventdata, handles)
% hObject    handle to PushNeckBrake (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global DataType
global TargetCanId
if isequal( get( handles.PushNeckBrake ,'String'), 'Set NeckBrake')  
    KvaserCom( 7 , [1536+TargetCanId ,1408+TargetCanId ,hex2dec('2003'),12,DataType.short,0,100], 1 ); % Set on  
else
    KvaserCom( 7 , [1536+TargetCanId ,1408+TargetCanId ,hex2dec('2003'),12,DataType.short,0,100], 0 ); % Set off
end 


% --- Executes on button press in PushFan.
function PushFan_Callback(hObject, eventdata, handles)
% hObject    handle to PushFan (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global DataType
global TargetCanId
if isequal( get( handles.PushFan ,'String'), 'Set Fan')  
    KvaserCom( 7 , [1536+TargetCanId ,1408+TargetCanId ,hex2dec('2003'),13,DataType.short,0,100], 1 ); % Set on  
else
    KvaserCom( 7 , [1536+TargetCanId ,1408+TargetCanId ,hex2dec('2003'),13,DataType.short,0,100], 0 ); % Set off
end 


% --- Executes on button press in PushTailLamp.
function PushTailLamp_Callback(hObject, eventdata, handles)
% hObject    handle to PushTailLamp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global DataType
global TargetCanId
if isequal( get( handles.PushTailLamp ,'String'), 'Set TailLamp')  
    KvaserCom( 7 , [1536+TargetCanId ,1408+TargetCanId ,hex2dec('2003'),14,DataType.short,0,100], 1 ); % Set on  
else
    KvaserCom( 7 , [1536+TargetCanId ,1408+TargetCanId ,hex2dec('2003'),14,DataType.short,0,100], 0 ); % Set off
end 


% --- Executes on button press in PushServoVoltage.
function PushServoVoltage_Callback(hObject, eventdata, handles)
% hObject    handle to PushServoVoltage (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global DataType
global TargetCanId

if isequal( get( handles.PushServoVoltage ,'String'), 'Set ServoVoltage')  
    KvaserCom( 7 , [1536+TargetCanId ,1408+TargetCanId ,hex2dec('2004'),3,DataType.short,0,100], 1 ); % Set on  
else
    KvaserCom( 7 , [1536+TargetCanId ,1408+TargetCanId ,hex2dec('2004'),3,DataType.short,0,100], 0 ); % Set off
end


% --- Executes on button press in PushShunt.
function PushShunt_Callback(hObject, eventdata, handles)
% hObject    handle to PushShunt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global DataType
global TargetCanId
if isequal( get( handles.PushShunt ,'String'), 'Set Shunt')  
    KvaserCom( 7 , [1536+TargetCanId ,1408+TargetCanId ,hex2dec('2003'),16,DataType.short,0,100], 1 ); % Set on  
else
    KvaserCom( 7 , [1536+TargetCanId ,1408+TargetCanId ,hex2dec('2003'),16,DataType.short,0,100], 0 ); % Set off
end



function EditWristAngle_Callback(hObject, eventdata, handles)
% hObject    handle to EditWristAngle (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of EditWristAngle as text
%        str2double(get(hObject,'String')) returns contents of EditWristAngle as a double
    refs = get ( handles.EditWristAngle , 'String' ) ; 
    try 
        refs = str2num( refs ) ; 
        if ( isempty(refs) || refs < -170 || refs > 170 ) 
            refs = handles.DynStat.DynRef(3) ; 
        end 
    catch 
        refs = handles.DynStat.DynRef(3) ; 
    end 
    handles.DynStat.DynRef(3) = refs ; 
    set ( handles.EditWristAngle , 'String' , num2str( handles.DynStat.DynRef(3)) ) ; 
    guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function EditWristAngle_CreateFcn(hObject, eventdata, handles)
% hObject    handle to EditWristAngle (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function EditElbowAngle_Callback(hObject, eventdata, handles)
% hObject    handle to EditElbowAngle (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of EditElbowAngle as text
%        str2double(get(hObject,'String')) returns contents of EditElbowAngle as a double
    refs = get ( handles.EditElbowAngle , 'String' ) ; 
    try 
        refs = str2num( refs ) ;  %#ok<*ST2NM>
        if ( isempty(refs) || refs < -170 || refs > 170 ) 
            refs = handles.DynStat.DynRef(2) ; 
        end 
    catch 
        refs = handles.DynStat.DynRef(2) ; 
    end 
    handles.DynStat.DynRef(2) = refs ; 
    set ( handles.EditElbowAngle , 'String' , num2str( handles.DynStat.DynRef(2) ) ) ; 
    guidata(hObject, handles);
    


% --- Executes during object creation, after setting all properties.
function EditElbowAngle_CreateFcn(hObject, eventdata, handles)
% hObject    handle to EditElbowAngle (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function EditShoulderAngle_Callback(hObject, eventdata, handles)
% hObject    handle to EditShoulderAngle (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of EditShoulderAngle as text
%        str2double(get(hObject,'String')) returns contents of EditShoulderAngle as a double
    refs = get ( handles.EditShoulderAngle , 'String' ) ; 
    try 
        refs = str2num( refs ) ; 
        if ( isempty(refs) || refs < -170 || refs > 170 ) 
            refs = handles.DynStat.DynRef(1) ; 
        end 
    catch 
        refs = handles.DynStat.DynRef(1) ; 
    end 
    handles.DynStat.DynRef(1) = refs ; 
    set ( handles.EditShoulderAngle , 'String' , num2str( handles.DynStat.DynRef(1) ) ) ; 
    
    guidata(hObject, handles);
   


% --- Executes during object creation, after setting all properties.
function EditShoulderAngle_CreateFcn(hObject, eventdata, handles)
% hObject    handle to EditShoulderAngle (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in PushDynSend.
function PushDynSend_Callback(hObject, eventdata, handles)
% hObject    handle to PushDynSend (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global DataType ; 
global TargetCanId ;
try 
    shoulderref = str2num( get ( handles.EditShoulderAngle , 'String' ) ) ;
    elbowref = str2num( get ( handles.EditElbowAngle , 'String' ) ) ;
    wristref = str2num( get ( handles.EditWristAngle , 'String' ) ) ;
    leftref = str2num( get ( handles.EditLeftTarget , 'String' ) ) ;
    rightref = str2num( get ( handles.EditRightTarget , 'String' ) ) ;

    KvaserCom( 7 , [1536+TargetCanId ,1408+TargetCanId ,hex2dec('2103'),9,DataType.long,0,100], 0  ); % Set ref to non-cartese          
    
    KvaserCom( 7 , [1536+TargetCanId ,1408+TargetCanId ,hex2dec('2103'),11,DataType.long,0,100], fix(shoulderref * 17.453292519943)  ); % Set ref           
    KvaserCom( 7 , [1536+TargetCanId ,1408+TargetCanId ,hex2dec('2103'),21,DataType.long,0,100], fix(elbowref * 17.453292519943)  ); % Set ref           
    KvaserCom( 7 , [1536+TargetCanId ,1408+TargetCanId ,hex2dec('2103'),31,DataType.long,0,100], fix(wristref * 17.453292519943)  ); % Set ref           
    KvaserCom( 7 , [1536+TargetCanId ,1408+TargetCanId ,hex2dec('2103'),41,DataType.long,0,100], fix(leftref * 17.453292519943)  ); % Set ref           
    KvaserCom( 7 , [1536+TargetCanId ,1408+TargetCanId ,hex2dec('2103'),51,DataType.long,0,100], fix(rightref * 17.453292519943)  ); % Set ref           
catch 
end 


% --- Executes on button press in PushManManual.
function PushManManual_Callback(hObject, eventdata, handles)
% hObject    handle to PushManManual (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global TargetCanId 
global DataType

set( handles.RadioManAuto, 'Value' , 0  ) ; 
set( handles.PushManManual, 'Value' , 1  ) ; 
set( handles.PushDynSend,'Enable','on') ; 
set( handles.PushStandBy,'Enable','on') ; 
set( handles.PushMotorOff,'Enable','on') ; 
KvaserCom( 7 , [1536+TargetCanId ,1408+TargetCanId ,hex2dec('2103'),201,DataType.long,0,100], 1  ); % Disable PDO listen        





% Hint: get(hObject,'Value') returns toggle state of PushManManual
global DataType 
global TargetCanId
global ObjectIndex
KvaserCom( 7 , [1536+TargetCanId ,1408+TargetCanId ,ObjectIndex.ControlWord, 0 ,DataType.long,0,100], PdIcdHelper.buildControlWordManualMode());         


% --- Executes on button press in RadioManAuto.
function RadioManAuto_Callback(hObject, eventdata, handles)
% hObject    handle to RadioManAuto (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global TargetCanId 
global DataType

set( handles.RadioManAuto, 'Value' , 1  ) ; 
set( handles.PushManManual, 'Value' , 0  ) ; 
set( handles.PushStandBy,'Enable','off') ; 
set( handles.PushMotorOff,'Enable','off') ; 
set( handles.PushDynSend,'Enable','off') ; 
KvaserCom( 7 , [1536+TargetCanId ,1408+TargetCanId ,hex2dec('2103'),201,DataType.long,0,100], 0  ); % Enable PDO ilstening           




% Hint: get(hObject,'Value') returns toggle state of RadioManAuto


% --- Executes on button press in CheckManInit.
function CheckManInit_Callback(hObject, eventdata, handles)
% hObject    handle to CheckManInit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of CheckManInit


% --- Executes on button press in PushStartMan.
function PushStartMan_Callback(hObject, eventdata, handles)
% hObject    handle to PushStartMan (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global DataType 
global TargetCanId
KvaserCom( 7 , [1536+TargetCanId ,1408+TargetCanId ,hex2dec('2004'),5,DataType.short,0,100], 1 ); % Set Manipulator network on  



function EditTargetX_Callback(hObject, eventdata, handles)
% hObject    handle to EditTargetX (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of EditTargetX as text
%        str2double(get(hObject,'String')) returns contents of EditTargetX as a double


% --- Executes during object creation, after setting all properties.
function EditTargetX_CreateFcn(hObject, eventdata, handles)
% hObject    handle to EditTargetX (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function EditTargetY_Callback(hObject, eventdata, handles)
% hObject    handle to EditTargetY (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of EditTargetY as text
%        str2double(get(hObject,'String')) returns contents of EditTargetY as a double


% --- Executes during object creation, after setting all properties.
function EditTargetY_CreateFcn(hObject, eventdata, handles)
% hObject    handle to EditTargetY (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in PushStandBy.
function PushStandBy_Callback(hObject, eventdata, handles)
% hObject    handle to PushStandBy (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global TargetCanId
global DataType 
    KvaserCom( 7 , [1536+TargetCanId ,1408+TargetCanId ,hex2dec('2103'),9,DataType.short,0,100], 0  ); % Set ref           

if handles.ss.InitState24
    KvaserCom( 7 , [1536+TargetCanId ,1408+TargetCanId ,hex2dec('2103'),10,DataType.long,0,100], 1 ); % shoulder Set motor on 
    KvaserCom( 7 , [1536+TargetCanId ,1408+TargetCanId ,hex2dec('2103'),20,DataType.long,0,100], 1 ); % elbow Set motor on 
    KvaserCom( 7 , [1536+TargetCanId ,1408+TargetCanId ,hex2dec('2103'),30,DataType.long,0,100], 1 ); % Set motor on wrist 
end 
if handles.ss.InitState12
    KvaserCom( 7 , [1536+TargetCanId ,1408+TargetCanId ,hex2dec('2103'),40,DataType.long,0,100], 1 ); % Set motor on Left 
    KvaserCom( 7 , [1536+TargetCanId ,1408+TargetCanId ,hex2dec('2103'),50,DataType.long,0,100], 1 ); % Set motor on Right 
end 

% --- Executes on button press in PushPretestMan.
function PushPretestMan_Callback(hObject, eventdata, handles)
% hObject    handle to PushPretestMan (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Verify model number  
Model = 38152 ;
try 
    DxId = 3; 
    str = ['Dynamixel ',num2str(DxId),'MAN ok']; 
    [Rslt,stat] = ReadDxl(DxId , 2 , 0 , 24  );
    if ( stat ) 
        str = 'CAN Com fail' ; 
    end 
    if ~(Rslt==Model) 
        str = ['ID ',num2str(DxId),' model verification failed , should be ',num2str(Model),' Found: ',num2str(Rslt) ]  ; 
    end 
catch 
    str = ['ID ',num2str(DxId),'  Dynamixel did not answer'] ; 
end    
str1 = str ; 

try 
    DxId = 4; 
    str = ['Dynamixel ',num2str(DxId),'MAN ok']; 
    [Rslt,stat] = ReadDxl(DxId , 2 , 0 , 24  );
    if ( stat ) 
        str = 'CAN Com fail' ; 
    end 
    if ~(Rslt==Model) 
        str = ['ID ',num2str(DxId),' model verification failed , should be ',num2str(Model),' Found: ',num2str(Rslt) ]  ; 
    end 
catch 
    str = ['ID ',num2str(DxId),'  Dynamixel did not answer'] ; 
end    
str2 = str ; 

try 
    DxId = 5; 
    str = ['Dynamixel ',num2str(DxId),'MAN ok']; 
    [Rslt,stat] = ReadDxl(DxId , 2 , 0 , 24  );
    if ( stat ) 
        str = 'CAN Com fail' ; 
    end 
    if ~(Rslt==Model) 
        str = ['ID ',num2str(DxId),' model verification failed , should be ',num2str(Model),' Found: ',num2str(Rslt) ]  ; 
    end 
catch 
    str = ['ID ',num2str(DxId),'  Dynamixel did not answer'] ; 
end    
str3 = str ; 

Model = 1020 ;
try 
    DxId = 1; 
    str = ['Dynamixel ',num2str(DxId),'Stop ok']; 
    [Rslt,stat] = ReadDxl(DxId , 2 , 0 , 12  );
    if ( stat ) 
        str = 'CAN Com fail' ; 
    end 
    if ~(Rslt==Model) 
        str = ['ID ',num2str(DxId),' model verification failed , should be ',num2str(Model),' Found: ',num2str(Rslt) ]  ; 
    end 
catch 
    str = ['ID ',num2str(DxId),'  Dynamixel did not answer'] ; 
end    
str4 = str ; 

try 
    DxId = 2; 
    str = ['Dynamixel ',num2str(DxId),'Stop ok']; 
    [Rslt,stat] = ReadDxl(DxId , 2 , 0 , 12  );
    if ( stat ) 
        str = 'CAN Com fail' ; 
    end 
    if ~(Rslt==Model) 
        str = ['ID ',num2str(DxId),' model verification failed , should be ',num2str(Model),' Found: ',num2str(Rslt) ]  ; 
    end 
catch 
    str = ['ID ',num2str(DxId),'  Dynamixel did not answer'] ; 
end    
str5 = str ; 

uiwait(msgbox({str1;str2;str3;str4 ;str5} ,'Dynamixel stat !','modal'));    


% --- Executes on button press in PushStartStop.
function PushStartStop_Callback(hObject, eventdata, handles)
% hObject    handle to PushStartStop (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global DataType 
global TargetCanId
KvaserCom( 7 , [1536+TargetCanId ,1408+TargetCanId ,hex2dec('2004'),4,DataType.short,0,100], 1 ); % Set 12V stop network on  


% --- Executes on button press in CheckBypassMan.
function CheckBypassMan_Callback(hObject, eventdata, handles)
% hObject    handle to CheckBypassMan (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of CheckBypassMan
global DataType 
global TargetCanId
us = get( handles.CheckBypassMan ,'Value');
KvaserCom( 7 , [1536+TargetCanId ,1408+TargetCanId ,hex2dec('2004'),109,DataType.short,0,100], us ); 


% --- Executes on button press in CheckBypassStop.
function CheckBypassStop_Callback(hObject, eventdata, handles)
% hObject    handle to CheckBypassStop (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of CheckBypassStop
global DataType 
global TargetCanId
us = get( handles.CheckBypassStop ,'Value');
KvaserCom( 7 , [1536+TargetCanId ,1408+TargetCanId ,hex2dec('2004'),108,DataType.short,0,100], us ); 


% --- Executes on button press in CheckExternVDyn.
function CheckExternVDyn_Callback(hObject, eventdata, handles)
% hObject    handle to CheckExternVDyn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of CheckExternVDyn
global DataType 
global TargetCanId
us = get( handles.CheckExternVDyn ,'Value');
KvaserCom( 7 , [1536+TargetCanId ,1408+TargetCanId ,hex2dec('2004'),106,DataType.short,0,100], us ); 
KvaserCom( 7 , [1536+TargetCanId ,1408+TargetCanId ,hex2dec('2004'),107,DataType.short,0,100], us ); 


% --- Executes on button press in CheckCCSDebug.
function CheckCCSDebug_Callback(hObject, eventdata, handles)
% hObject    handle to CheckCCSDebug (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of CheckCCSDebug


% --- Executes on button press in CheckEncoderCounts.
function CheckEncoderCounts_Callback(hObject, eventdata, handles)
% hObject    handle to CheckEncoderCounts (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of CheckEncoderCounts


% --- Executes on button press in PushRecorder.
function PushRecorder_Callback(hObject, eventdata, handles)
% hObject    handle to PushRecorder (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
stop (handles.timer) ;
uiwait ( SigRec );
start (handles.timer) ;


% --- Executes on button press in PushMotorOff.
function PushMotorOff_Callback(hObject, eventdata, handles)
% hObject    handle to PushMotorOff (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global DataType 
global TargetCanId
KvaserCom( 7 , [1536+TargetCanId ,1408+TargetCanId ,hex2dec('2103'),10,DataType.long,0,100], 0); % shoulder  
KvaserCom( 7 , [1536+TargetCanId ,1408+TargetCanId ,hex2dec('2103'),20,DataType.long,0,100], 0 ); % elbow 
KvaserCom( 7 , [1536+TargetCanId ,1408+TargetCanId ,hex2dec('2103'),30,DataType.long,0,100], 0 ); % wrist
KvaserCom( 7 , [1536+TargetCanId ,1408+TargetCanId ,hex2dec('2103'),40,DataType.long,0,100], 0 ); % left 
KvaserCom( 7 , [1536+TargetCanId ,1408+TargetCanId ,hex2dec('2103'),50,DataType.long,0,100], 0 ); % right



function EditLeftTarget_Callback(hObject, eventdata, handles)
% hObject    handle to EditLeftTarget (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of EditLeftTarget as text
%        str2double(get(hObject,'String')) returns contents of EditLeftTarget as a double
    refs = get ( handles.EditLeftTarget , 'String' ) ; 
    try 
        refs = str2num( refs ) ; 
        if ( isempty(refs) || refs < -25 || refs > 100 ) 
            refs = handles.DynStat.DynRef(4) ; 
        end 
    catch 
        refs = handles.DynStat.DynRef(4) ; 
    end 
    handles.DynStat.DynRef(4) = refs ; 
    set ( handles.EditLeftTarget , 'String' , num2str( handles.DynStat.DynRef(4)) ) ; 
    guidata(hObject, handles);

    
    


% --- Executes during object creation, after setting all properties.
function EditLeftTarget_CreateFcn(hObject, eventdata, handles)
% hObject    handle to EditLeftTarget (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function EditRightTarget_Callback(hObject, eventdata, handles)
% hObject    handle to EditRightTarget (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of EditRightTarget as text
%        str2double(get(hObject,'String')) returns contents of EditRightTarget as a double
    refs = get ( handles.EditRightTarget , 'String' ) ; 
    try 
        refs = str2num( refs ) ; 
        if ( isempty(refs) || refs < -25 || refs > 100 ) 
            refs = handles.DynStat.DynRef(5) ; 
        end 
    catch 
        refs = handles.DynStat.DynRef(5) ; 
    end 
    handles.DynStat.DynRef(5) = refs ; 
    set ( handles.EditRightTarget , 'String' , num2str( handles.DynStat.DynRef(5)) ) ; 
    guidata(hObject, handles);
   


% --- Executes during object creation, after setting all properties.
function EditRightTarget_CreateFcn(hObject, eventdata, handles)
% hObject    handle to EditRightTarget (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function out = GetPackageLocation(handles)
	out = struct('X', -474, 'Y', 20);
	refs = get ( handles.EditTargetX , 'String' ) ;
	try 
		refs = str2num( refs ) ; 
		if ( ~isempty(refs) && refs >= (-124-450) && refs <= (-124-250) ) 
			out.X = refs;
		end 
	catch 
	end 
	refs = get ( handles.EditTargetY , 'String' ) ;
	try 
		refs = str2num( refs ) ; 
		if ( ~isempty(refs) && refs >= 0 && refs <= 200 ) 
			out.Y = refs;
		end 
	catch 
	end 


% --- Executes on button press in PushGoPackage.
function PushGoPackage_Callback(hObject, eventdata, handles)
% hObject    handle to PushGoPackage (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global DataType 
global TargetCanId
global ObjectIndex
global ObjectSubindex
packageLocation = GetPackageLocation(handles);
%must add -124mm because of Xdistance between wheel origin and shoulder axis
KvaserCom( 7 , [1536+TargetCanId ,1408+TargetCanId ,ObjectIndex.SetGetManipulatorAction, ObjectSubindex.SetGetManipulatorAction_expectedXmm ,DataType.long,0,100], packageLocation.X);
KvaserCom( 7 , [1536+TargetCanId ,1408+TargetCanId ,ObjectIndex.SetGetManipulatorAction, ObjectSubindex.SetGetManipulatorAction_expectedYmm ,DataType.long,0,100], packageLocation.Y);
KvaserCom( 7 , [1536+TargetCanId ,1408+TargetCanId ,ObjectIndex.ControlWord, 0 ,DataType.long,0,100], PdIcdHelper.buildControlWord(1,1,'right'));

% --- Executes on button press in PushPutPackage.
function PushPutPackage_Callback(hObject, eventdata, handles)
% hObject    handle to PushPutPackage (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global DataType 
global TargetCanId
global ObjectIndex
global ObjectSubindex
packageLocation = GetPackageLocation(handles);
%must add -124mm because of Xdistance between wheel origin and shoulder axis
KvaserCom( 7 , [1536+TargetCanId ,1408+TargetCanId ,ObjectIndex.SetGetManipulatorAction, ObjectSubindex.SetGetManipulatorAction_expectedXmm ,DataType.long,0,100], packageLocation.X);
KvaserCom( 7 , [1536+TargetCanId ,1408+TargetCanId ,ObjectIndex.SetGetManipulatorAction, ObjectSubindex.SetGetManipulatorAction_expectedYmm ,DataType.long,0,100], packageLocation.Y);
KvaserCom( 7 , [1536+TargetCanId ,1408+TargetCanId ,ObjectIndex.ControlWord, 0 ,DataType.long,0,100], PdIcdHelper.buildControlWord(1,0,'right'));

% --- Executes on button press in PushArmStandby.
function PushArmStandby_Callback(hObject, eventdata, handles)
% hObject    handle to PushArmStandby (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global DataType 
global TargetCanId
global ObjectIndex
KvaserCom( 7 , [1536+TargetCanId ,1408+TargetCanId ,ObjectIndex.ControlWord, 0 ,DataType.long,0,100], PdIcdHelper.buildControlWord(0,0,'right'));


% --- Executes on button press in PushSimMode.
function PushSimMode_Callback(hObject, eventdata, handles)
% hObject    handle to PushSimMode (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global DataType 
global TargetCanId
global ObjectIndex
global ObjectSubindex
global Color_On
global SimFlags
simMode = 0;
if (get( handles.CheckSimulateManipulator,'Value') == 1)
	simMode = simMode + SimFlags.Manipulator;
end
if (get( handles.CheckSimulateLaser,'Value') == 1)
	simMode = simMode + SimFlags.Laser;
end
simMode = simMode + hex2dec('12345670');
KvaserCom( 7 , [1536+TargetCanId ,1408+TargetCanId ,ObjectIndex.SetGetManipulatorAction, ObjectSubindex.SetGetManipulatorAction_simMode ,DataType.long,0,100], simMode);
set( hObject ,'BackgroundColor', Color_On);
set( handles.CheckSimulateManipulator,'Enable','off');
set( handles.CheckSimulateLaser,'Enable','off');


% --- Executes during object deletion, before destroying properties.
function figure1_DeleteFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if isfield(handles,'timer') && isa(handles.timer,'timer') 
    stop(handles.timer) ;
    delete(handles.timer) ; 
end
% delete( handles.EvtObj) ; 
