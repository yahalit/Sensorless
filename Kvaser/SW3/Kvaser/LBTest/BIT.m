function varargout = BIT(varargin)
% BIT MATLAB code for BIT.fig
%      BIT, by itself, creates a new BIT or raises the existing
%      singleton*.
%
%      H = BIT returns the handle to a new BIT or the handle to
%      the existing singleton*.
%
%      BIT('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in BIT.M with the given input arguments.
%
%      BIT('Property','Value',...) creates a new BIT or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before BIT_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to BIT_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help BIT

% Last Modified by GUIDE v2.5 31-Oct-2024 12:03:26

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @BIT_OpeningFcn, ...
                   'gui_OutputFcn',  @BIT_OutputFcn, ...
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



function code = GetCode( num , shift , mask ) 
code = bitand (2^32 +  num , 2^shift * mask ) / 2^shift ; 
        
         
        
    

% --- Executes just before BIT is made visible.
function BIT_OpeningFcn(hObject, ~, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to BIT (see VARARGIN)

% Choose default command line output for BIT
global AtpCfg
global UdpStr 

try 
     handles.CreateStruct =  struct('Interpreter','tex','WindowStyle' , 'modal') ; 
     guidata(hObject, handles);
     

     BIT_OpeningFcnBody(hObject, handles, varargin); 
catch 
    handles = guidata(hObject) ; 
    if isfield( handles,'EvtObj') 
        delete( handles.EvtObj) ;
        if ( AtpCfg.Udp.On  )
            msgbox({'\fontsize{12}Cant start BIT (Communication disconnected?)',['Own IP is : ',UdpStr.LocalHost],'Probably using the global LAN ',...
                'You should use the local LAN','Or a PING from the robot side is required'},'Error',handles.CreateStruct) ; 
        else
            msgbox({'\fontsize{12}Cant start BIT for CAN','Use CommSetup if you want UDP' },'Error',handles.CreateStruct) ; 
        end
    else
        uiwait(errordlg({'Cant start BIT - Timer missing ','(Wrong work directory in Matlab?)'},'Error') ); 
    end
    handles.output = hObject ; 
    %guidata(hObject, handles);
    delete( hObject ) ; 
end 


function BIT_OpeningFcnBody(hObject, handles, varargin)
global DataType 
global DispT
global TargetCanId
global RecStruct
% global TmMgrT


handles.output = hObject;
I = imread('SQUID-Logo1.jpg');
axes(handles.Logo) ; 
image(I);
set(handles.Logo ,'Visible','off','XTick',[],'YTick',[]) ;

handles.MotRefInit = 0 ; 
handles.CommInactive = 0 ; 
handles.TmrFunctionActive = 0 ;
set (handles.CheckCrab,'Visible','off') ; 
set (handles.CheckCrab,'Visible','off') ; 
guidata(hObject, handles);


evalin('base','AtpStart') ; 
handles.EvtObj = DlgUserObj(@update_bitrix_display,hObject);
handles.EvtObj.MylistenToTimer(DispT) ; 
guidata(hObject, handles);
handles.bCheckFaultDetail = 0 ; 

s =  GetState() ; 
handles.s = s; 
handles.ManDesc = GetDrive( [], 1 );

% Test manipulator style 
[cfg,~,errstr] = GetRobotCfg(0); 
if ~isempty(errstr) 
    uiwait(errordlg(["Robot is not configured correctly","User RobotCfg dialog to fix that"] ) ) ; 
    return ; 
end
handles.RobotCfg = cfg ; 
handles.ManipStyleList = struct( 'None_Manipulator' , 0,'SCARA_Manipulator' , 1,'Flex_Manipulator' , 2 ) ; 
handles.ManipStyle     = FetchObj( [hex2dec('2220'),53] , DataType.long , 'ManipStyle' ) ; 

set(handles.TagManType,'String',cfg.ManipTypeName) ; 

switch handles.ManipStyle
    case handles.ManipStyleList.Flex_Manipulator 
        set(handles.TegtGripAngleLabel,'String','Plate angle') ;   
        set(handles.TextXPOS,'String','') ;
        set(handles.TextYPos,'String','Tape pos.') ;
        set(handles.text315,'String','Door angle') ; 
        set(handles.text314,'String','Plate angle') ; 
end

% switch handles.ManipStyle
%     case handles.ManipStyleList.SCARA_Manipulator
%         set(handles.TagManType,'String','Scara' ); 
%     case handles.ManipStyleList.Flex_Manipulator
%         set(handles.TagManType,'String','Flex' ); 
%     case handles.ManipStyleList.None_Manipulator
%         set(handles.TagManType,'String','None' ); 
%     otherwise     
%         set(handles.TagManType,'String','Unknown' ); 
% end

handles.hObject = hObject ; 
handles.UpdateDisplayActive = 1 ; 
guidata(hObject, handles);


handles.BitSetup = ini2struct('BIT.ini') ; 

handles.ModeCmd = struct('ShelfMode', s.Bit.ShelfMode ) ; % Assure life will start with a complete stop 
handles.NeckMode =  s.Bit.NeckMode ;


handles.WakeStates = struct('Code' ,{0,1,2,3,4,5,6,7,15,2000},'Label',...
	{'E_CAN_WAKEUP_INIT_OR_FAIL', 'E_CAN_WAKEUP_SEND_NMT_RESET','E_CAN_WAKEUP_SEND_CONFIG_SDO', ...
    'E_CAN_WAKEUP_SEND_NMT_OPER' ,'E_CAN_WAKEUP_PROG_SPECIFIC_SDO','E_CAN_WAKEUP_PRE_OPERATIONAL' ,...
   	'E_CAN_WAKEUP_OPERATIONAL' ,'E_CAN_WAKEUP_SLEEP','E_CAN_WAKEUP_FAILURE','E_CAN_WAKEUP_FAILURE'} ) ; 

handles.AutoOpCodes = struct ( 'Code' ,{0,1,2,3,4,5} ,'Label',...
    {'QE_ENTRY_UNUSED','QE_ENTRY_PATH_PT','QE_SPECIAL_CMD_RESCUE','QE_ENTRY_CHANGE_MODE','QE_ENTRY_HANDLE_PACK','QE_ENTRY_WAIT'})  ;
handles.MotModes  = struct ( 'Code' , {15,14,0,2,3,4,5,6,10},'Label',...
    {'E_SysMotionModeFault','E_SysMotionModeSafeFault','E_SysMotionModeMotorOff','E_SysMotionModeStay','E_SysMotionModePerAxis',...
    'E_SysMotionModeManualTravel','E_SysMotionModeTestPack','E_SysMotionModeHostSpeedControl','E_SysMotionModeAutomatic'} ) ; 
handles.ShelfModes  = struct ( 'Code' , {0,1,2,3,4,5,10,15},'Label',...
    {'E_Shelf_Nothing','E_ShelfArc','E_TwistToShelf','E_TwistFromShelf','E_ShelfRunRescue','E_ShelfRunAuto','E_DealPack','E_ShelfFailure'} ) ; 
handles.PackStates  = struct ( 'Code' , {0,1,2,3,4,5,14,15},'Label',...
    {'EPackState_Init','EPackState_WaitTailIncidence','EPackState_ManipulatorAction','EPackState_ManipulatorWaitMon',...
    'EPackState_Success','PackSt_TailIncidenceRetract','EPackState_MayUnclimb_Failure','EPackState_Failure'} ) ; 
handles.ManPackStates = struct ( 'Code' , {0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,20,21,22,23,24,255},'Label',...
    {'MAN_ST_INIT','MAN_ST_WAIT_STOP_1','MAN_ST_GO_ROUGH_POSITION','MAN_ST_GO_ROUGH_POSITION_A','MAN_ST_WAIT_LASER_POS',...
    'MAN_ST_GO_PRECISE_POSITION','MAN_ST_DO_SUCTION','MAN_ST_FOLDBACK','MAN_ST_RETREAT',...
    'MAN_ST_DO_EDGE_STOP','MAN_ST_RETRACT_TO_STANDBY',...
    'MAN_ST_RELEASE_PUT','MAN_ST_RELEASE_WAIT_STOP','MAN_ST_PUSH_PACK','MAN_ST_RELEASE_RET_HOME','MAN_ST_DONE',...
    'MAN_ST_EMCSTOP','MAN_ST_RVS_STANDBY','MAN_ST_STDBY','MAN_ST_PUSH_PACK_ROUGH','MAN_ST_RETREAT_RELEASE',...
    'MAN_ST_PREPARE','MAN_ST_WAIT_DOOR_OPEN','MAN_ST_FAILURE'} ) ; 
handles.ArcSubModes = struct ( 'Code' , {0,1,2,3,4,5,6,7,8,9,10,12,13,14,15,16,18,19,20,24,25,26 },'Label',...
    {'Nothing','Wait_1st_Sensor','Wait_2nd_Sensor','PoleCruise','ShoulderAdjust',...
    'PreInterPoleCruise','InterPoleCruise',...
    'ClimbDone','ClimbError','TrackWidthAdjust','WaitStam','UnclimbWaitSwitch','UnclimbFinalApproach','UnclimbFinalWait','RescueDone'...
    'UnclimbWaitSwitch2','WaitCrab','TwistToShelf_WaitWhPosAdjust','TwistToShelf_Done',...
    'TwistFromShelf_WaitCrab','E_TwistFromShelf_WaitWhPosAdjust','E_TwistFromShelf_Done' } ) ;

handles.WheelArmStates = MakeTableFromEnum(RecStruct.Enums.WheelArmStates) ; 
handles.PsWakeUpStates = MakeTableFromEnum(RecStruct.Enums.PsWakeUpStates) ; 

    
handles.CommInactive = 0 ; 
guidata(hObject, handles);

handles = DisplayFirmVersion(handles) ; 

update_screen(handles) ; 
 


% handles.timer = timer(...
%     'ExecutionMode', 'fixedSpacing', ...       % Run timer repeatedly.
%     'Period', AtpCfg.GuiTimerPeriod , ...                        % Initial period is 1 sec.
%     'TimerFcn', {@update_manroute_display,hObject}); % Specify callback function.% Update handles structure
guidata(hObject, handles);
% start (handles.timer) ;

set(handles.CheckboxLeftBrakeRelease,'Value',0);
% set(handles.RadioBrakeAutomatic,'Value',1);

% s = GetState() ; 
Rsteer = -s.base.ROuterPos ;
Lsteer = -s.base.LOuterPos ;
NeckAngle = s.base.NOuterPos ;

handles.ManualRSteerCmd = Rsteer ;
handles.ManualLSteerCmd = Lsteer ;
handles.ManualNeckCmd = NeckAngle; 

handles.ManualRSpeedCmd = 0  ; 
set(handles.EditRWheelSpeed,'String',num2str(handles.ManualRSpeedCmd) ) ; 
handles.ManualLSpeedCmd = 0  ; 
set(handles.EditLWheelSpeed,'String',num2str(handles.ManualLSpeedCmd) ) ; 
handles.ManualBCmd = Rsteer * 180 / pi  ; 
set(handles.EditRSteerSetPoint,'String',num2str(handles.ManualRSteerCmd) ) ;
handles.ManualLSteerCmd = Lsteer * 180 / pi  ; 
set(handles.EditLSteerSetPoint,'String',num2str(handles.ManualLSteerCmd) ) ;
handles.ManualNeckCmd = NeckAngle * 180 / pi  ; 
set(handles.EditNeckSetPoint,'String',num2str(handles.ManualNeckCmd) ) ;


% Update handles structure
handles.TmrFunctionActive = 1 ; 
guidata(hObject, handles);




function [handles,verok] = DisplayFirmVersion(handles)
global DataType ;
global TargetCanId 
global TargetCanId2 

YearLP = 0 ; 
YearPD = 0 ; 
verok = 0 ; 

try 
    % LpFirmVer = FetchObj( [hex2dec('2301'),4] , DataType.long ,'LP firmware version') ;
    LpFirmVer = FetchObj( [hex2dec('2301'),9] , DataType.long ,'LP firmware version') ;

    CoreId    = FetchObj( [hex2dec('2301'),8] , DataType.long ,'Core ID') ;
    handles.RobotType = bitand(CoreId,15) ; 
    RobotTypeNames = cell(1,16)  ; RobotTypeNames{2} = 'Gen2.5' ;RobotTypeNames{3} = 'Gen3' ;
    set(handles.TextRobotType , 'String' , RobotTypeNames{handles.RobotType} ) ; 

    LpCpu2FirmVer = FetchObj( [hex2dec('2301'),4,TargetCanId2] , DataType.long ,'LP CPU2 firmware version') ;
    ProjType2 = FetchObj( [hex2dec('2301'),5,TargetCanId2] , DataType.long ,'LP CPU2 firmware type') ;
    
%LpVerSubverPatch (( (long unsigned)LP_VER << 24 ) + ((long unsigned)LP_SUBVER<<16) + ((long unsigned)LP_PATCH <<8) + (long unsigned) LP_XX )

    VerLP = GetBitField(LpFirmVer,25:32);
    %YearLP = GetBitField(LpFirmVer,21:31);
    YearLPCpu2 = GetBitField(LpCpu2FirmVer,21:31);
    PdFirmVer = FetchObj( [hex2dec('2301'),15] , DataType.long ,'LP firmware version') ; % Com2PdThroughLp( 8 , [1536+TargetCanId ,1408+TargetCanId ,hex2dec('2301'),4,DataType.long,0,200] ); 
    if handles.RobotType >= 3 
        YearPD = GetBitField(PdFirmVer,25:31)+2000;
    else
        YearPD = 2023 ;
    end

catch  
end

%if (YearLP > 2000 && YearLP < 2050 ) 
if (VerLP > 1 && VerLP < 100 ) 
    switch  ProjType2
        case hex2dec('8500') 
            Proj2Name = 'Boot' ; 
        case hex2dec('8580') 
            Proj2Name = 'Operational' ; 
        otherwise
            Proj2Name = 'Unknown' ; 
    end
    
    if (YearLPCpu2 > 2000 && YearLPCpu2 < 2050 ) 
        handles.LpCpu2FirmVerString = [Proj2Name,': Year:',num2str(YearLPCpu2),' Month:',GetBitField(LpCpu2FirmVer,17:20,'d'),...
            ' Day:',GetBitField(LpCpu2FirmVer,9:16,'d'),' SubVer:',GetBitField(LpCpu2FirmVer,1:8,'d') ] ; 
        set( handles.TextLpCpu2Ver,'String',handles.LpCpu2FirmVerString ) ; 
    else
        set( handles.TextLpCpu2Ver,'String','Unknown' ) ; 
    end
        
    % handles.LpFirmVerString = ['Year:',num2str(YearLP),' Month:',GetBitField(LpFirmVer,17:20,'d'),...
    %     ' Day:',GetBitField(LpFirmVer,9:16,'d'),' SubVer:',GetBitField(LpFirmVer,1:8,'d') ] ; 
    handles.LpFirmVerString = ['Ver:',num2str(VerLP),' Sub:',GetBitField(LpFirmVer,17:24,'d'),...
        ' Patch:',GetBitField(LpFirmVer,9:16,'d'),' XX:',GetBitField(LpFirmVer,1:8,'d') ] ; 
    
    set( handles.TextLpVer,'String',handles.LpFirmVerString ) ; 
    verok = verok + 1 ; 
else
    set( handles.TextLpVer,'String','Unknown' ) ; 
end

if (YearPD > 2000 && YearPD < 2050 ) 
    if handles.RobotType <= 2
        handles.PdFirmVerString = ['Year:',num2str(YearPD) ,' Month:',GetBitField(PdFirmVer,17:20,'d'),...
            ' Day:',GetBitField(PdFirmVer,9:16,'d'),' SubVer:',GetBitField(PdFirmVer,1:8,'d') ] ; 
    else
        handles.PdFirmVerString = ['Year:',num2str(YearPD) ,' Month:',GetBitField(PdFirmVer,21:24,'d'),...
            ' Day:',GetBitField(PdFirmVer,16:20,'d'),' Ver:',GetBitField(PdFirmVer,9:15,'d'),':',...
            GetBitField(PdFirmVer,5:8,'d'),':',GetBitField(PdFirmVer,1:4,'d')] ; 
    end 
    set( handles.TextPdVer,'String',handles.PdFirmVerString ) ; 
    verok = verok + 2 ; 
else
    set( handles.TextPdVer,'String','Unknown' ) ; 
end

if handles.RobotType >= 3 
    set(handles.Text36VBat,'String','18V supply')
end

function n = ReadNum( str ) 
    if length(str) > 2 && ( isequal( str(1:2) , '0x' ) || isequal( str(1:2) , '0X' )) 
        n = hex2dec(str(3:end)) ; 
    else
        n = str2num( str ) ;  
    end 
   
   

function  [str,bgc,fgc] = MotorStatAtr( mon , flt , qstop , cur , detail )
global RecStruct 
global  DataType ; 
    if nargin < 5  
        detail = 0 ; 
    end 

    if mon
        if qstop 
            str = 'On:Stopped' ; 
            bgc = [0.9294    0.6941    0.1255];
            fgc = [0.0784    0.1686    0.5490] ; 
        else
            str = 'On:Ok' ; 
            bgc = [0 , 1 , 0 ];
            fgc = [ 0 , 0 , 0 ] ; 
        end 
        if nargin >= 4 , str = [str,' : ',num2str(fix(cur*10)/10),'A']; end
    else
        if ~flt 
            str = 'Off' ; 
            bgc = [0,0,1 ];
            fgc = [ 1 , 1 , 1 ] ; 
        else
            if ( detail ) 
                try 
                    n = FetchObj([hex2dec('2227'),detail],DataType.long,'Get Axis fault code')  ;
                    nn = find( n == RecStruct.BHErrCodes.Code  , 1 ) ; 
                    str = ['[0x',dec2hex(n),']',RecStruct.BHErrCodes.Formal{nn} ] ; 
                catch 
                    str = 'Axis don''t answer'; 
                end 
            else
                str = 'Fault' ; 
            end 
            bgc = [1 , 0 , 0 ];
            fgc = [ 1 , 1 , 1 ] ; 
        end 
    end
    
function    MarkHealth( h , inactive ,fail)
if nargin < 3 
    fail = logical(inactive) ;
end

    if fail 
        set(h,'String','Fail','BackgroundColor',[1 , 0 , 0 ],'ForegroundColor',[ 1 , 1 , 1 ]) ;
    else
        if inactive 
            set(h,'String','OK','BackgroundColor',[0,0,1 ],'ForegroundColor',[ 1,1,1 ]) ;
        else
            set(h,'String','OK','BackgroundColor',[0,1,0 ],'ForegroundColor',[ 0,0,0 ]) ;
        end 
    end

    
function  update_bitrix_display( hobj) 
    global TmMgrT
    global AtpCfg 
    handles = guidata(hobj) ; 
    
    if ( handles.TmrFunctionActive == 0 || AtpCfg.Suspend) 
       set( handles.TextBanner,'String', 'BIT & SqUID Panel-suspended', 'BackgroundColor',[1 1 1]*0.8) ; 
       return ; 
    end 
    
    try
        TmMgrT.IncrementCounter('BIT',2) ; 

        switch AtpCfg.CommType
            case 'CAN'
                set(handles.TextCommType,'String','CAN, any robot'); 
            case 'UDP'
                set(handles.TextCommType,'String',['UDP, Robot#',num2str(AtpCfg.Udp.RobotNumber) ]); 
            otherwise
                set(handles.TextCommType,'String','Unidentified comm.'); 
        end 
        

        lpfirm = get( handles.TextLpVer,'String' ) ; 
        pdfirm = get( handles.TextPdVer,'String' ) ; 
        if isequal(lpfirm,'Unknown') || isequal(pdfirm,'Unknown') || handles.CommInactive
            handles = DisplayFirmVersion(handles) ; 
        end

        if (handles.CommInactive ) 
            handles.CommInactive = handles.CommInactive - 1 ; 
            guidata(handles.hObject, handles);
        else
            update_screen(handles) ;
            set( handles.TextBanner,'String', 'BIT & SqUID Panel', 'BackgroundColor',[0 0 0]) ; 
        end
    catch 
        handles.CommInactive = 3 ; 
        handles.MotRefInit = 0 ; 
        set( handles.TextBanner,'String', 'BIT & SqUID-not connected', 'BackgroundColor',[1 1 1]) ; 
        set( handles.TextLpVer,'String','Unknown' ) ; 
        set( handles.TextPdVer,'String','Unknown' ) ; 
        guidata(handles.hObject, handles);
       % update_screen(handles) ;
    end
 
% UIWAIT makes BIT wait for user response (see UIRESUME)
% uiwait(handles.figure1);
% function update_manroute_display( varargin) 
%     handles = guidata(varargin{3}) ; 
%     try
%     update_screen(handles) ; 
%     catch 
%     end
 



function str = GetManMotErr(Name,num,stat) % 'SH',s.Net24MovState(1))
    str = [] ; 
    if nargin > 2
        if( stat == 28679) 
            str = '  No manipulator installed' ; 
        end
        return ;
    end
    if num == 0 
        return ; 
    end
    if num == 128 
        str = 'Comm 2 srv fail' ; 
    elseif num == 64 
        str = 'Drive alert' ; 
    else
        if bitand(num,1)
            str = [str,' Volt '] ; 
        end
        if bitand(num,2)
            str = [str,' Hall '] ; 
        end
        if bitand(num,4)
            str = [str,' OHeat '] ; 
        end
        if bitand(num,8)
            str = [str,' Enc. '] ; 
        end
        if bitand(num,16)
            str = [str,' Eshock '] ; 
        end
        if bitand(num,32)
            str = [str,' Oload '] ; 
        end
    end
    str = [ ':' ,Name,':', str] ; 

function c = GetPumpRequestColor(r,act)
if r && act
    c = [0 ,1 ,0] ; 
    return ; 
end
if ~r && ~act
    c = [1 ,1 ,1] * 0.7 ; 
    return ; 
end
if r && ~act
    c = [1 , 0 ,0] ; 
    return ;
else
    c = [1 ,0.647 ,0] ; 
end
    
function update_screen(handles) 
    global DataType 
    global BitKillTime 
    global TmMgrT 
    global RecStruct
    tnow = clock ; 
    if etime ( tnow , BitKillTime  )  < 0 
        return ; 
    end
    

    if  ~isfield(handles,'UpdateDisplayActive') || ~handles.UpdateDisplayActive 
        return ; 
    end 
    

    % Set the application button value per actual app open state 
    cnt = TmMgrT.GetCounter('TESTSW') ; 
    if cnt > 0 
        set( handles.PushSensorTest , 'String','Close sensor ind.') ; 
        set( handles.PushSensorTest,'Value',1) ;
    else
        set( handles.PushSensorTest , 'String','Open sensor ind.') ; 
        set( handles.PushSensorTest, 'Value',0) ;
    end
    cnt = TmMgrT.GetCounter('RESCUE') ; 
    if cnt > 0 
        set( handles.PushRescueDlg , 'String','Close Rescue Dialog') ; 
        set( handles.PushRescueDlg,'Value',1) ;
    else
        set( handles.PushRescueDlg , 'String','Open Rescue Dialog') ; 
        set( handles.PushRescueDlg, 'Value',0) ;
    end
    
    cnt = TmMgrT.GetCounter('PACKAGE') ; 
    if cnt > 0 
        set( handles.PushPackDlg , 'String','Close Package Dialog') ; 
        set( handles.PushPackDlg,'Value',1) ;
    else
        set( handles.PushPackDlg , 'String','Open Package Dialog') ; 
        set( handles.PushPackDlg, 'Value',0) ;
    end
    
    cnt = TmMgrT.GetCounter('BRAKES') ; 
    if cnt > 0 
        set( handles.PushBrakeDlg , 'String','Close Brake Dialog') ; 
        set( handles.PushBrakeDlg,'Value',1) ;
    else
        set( handles.PushBrakeDlg , 'String','Open Brake Dialog') ; 
        set( handles.PushBrakeDlg, 'Value',0) ;
    end

    cnt = TmMgrT.GetCounter('CAL_LASER') ; 
    if cnt > 0 
        set( handles.toggleCalibLaser , 'String','Close Calib Laser') ; 
        set( handles.toggleCalibLaser,'Value',1) ;
    else
        set( handles.toggleCalibLaser , 'String','Open  Calib Laser') ; 
        set( handles.toggleCalibLaser, 'Value',0) ;
    end
 
    
    cnt = TmMgrT.GetCounter('GND_TRAVEL') ; 
    if cnt > 0 
        set( handles.PushGndTravel , 'String','Close Ground Nav Dlg') ; 
        set( handles.PushGndTravel,'Value',1) ;
    else
        set( handles.PushGndTravel , 'String','Open Ground Nav Dlg') ; 
        set( handles.PushGndTravel, 'Value',0) ;
    end 

    
    cnt = TmMgrT.GetCounter('TEST_WARM') ; 
    if cnt > 0 
        set( handles.ButtonWheelArm , 'String','Close wheel arm') ; 
        set( handles.ButtonWheelArm,'Value',1) ;
    else
        set( handles.ButtonWheelArm , 'String','Open wheel arm') ; 
        set( handles.ButtonWheelArm, 'Value',0) ;
    end 
    
    if ~get( handles.checkboxSeparateWheels, 'Value')
        set( handles.EditLWheelSpeed,'Enable','off') ;
    else
        set( handles.EditLWheelSpeed,'Enable','on') ;
    end
    
    % Update status
    % ManDesc = GetDrive([],1); 
    s = GetState() ; 
    ms = s.Manip ; %  = GetManPos(handles.ManipStyle );
    
    NavDesc = s.NavDesc ; % GetNavDesc( );


    Rsteer = -s.base.ROuterPos * 180 / pi ;
    Lsteer = -s.base.LOuterPos * 180 / pi  ;
    NeckPos = s.base.NOuterPos * 180 / pi ; 
    tolDeg = 12 ; 
    if ( (abs( Rsteer + Lsteer) < tolDeg) || (abs(NeckPos) > 1)) &&  (abs( Rsteer - 90) < tolDeg) && (abs( Lsteer + 90) < tolDeg) 
        if ( abs(s.Bit.CrabCrawl) < 0.5)
            set( handles.CheckCrab ,'Visible','On','Value',0) ;
            set( handles.checkboxBalanceLoads ,'Visible','Off','Value',0) ;
        else
            set( handles.checkboxBalanceLoads ,'Visible','On' ) ;
            if (s.Bit.CrabCrawl > 0 ) 
                set( handles.CheckCrab ,'Visible','On','Value',1,'String','Crab right') ;
                set( handles.checkboxBalanceLoads ,'Visible','On','Value',s.Bit.bBalanceWheelLoadsOnManual) ;
            else
                set( handles.CheckCrab ,'Visible','On','Value',1,'String','Crab left') ;
                set( handles.checkboxBalanceLoads ,'Visible','On','Value',s.Bit.bBalanceWheelLoadsOnManual) ;
            end
        end
        set( handles.CheckCrab ,'Visible','On') ;
    else
        if ( abs(NeckPos) > 1)  &&  (abs( Rsteer  ) < tolDeg) && (abs( Lsteer  ) < tolDeg && s.Bit.CrabCrawl ) 
            if (s.Bit.CrabCrawl > 0 ) 
                set( handles.CheckCrab ,'Visible','On','Value',1,'String','Crab right') ;
            else
                set( handles.CheckCrab ,'Visible','On','Value',1,'String','Crab left') ;
            end
        else
            set( handles.CheckCrab ,'Visible','Off','Value',0,'String','Crab') ;
        end
    end

    SeparateWheels = get( handles.checkboxSeparateWheels,'Value'); 
    BalanceWheels  = get( handles.checkboxBalanceLoads,'Value');
    if BalanceWheels
        set( handles.checkboxSeparateWheels,'Value',0,'Enable','off');
    else
        set( handles.checkboxSeparateWheels,'Enable','on');
    end

    if ( get( handles.CheckCrab,'Value') == 0 ) || SeparateWheels  
        if ( BalanceWheels ) 
            set( handles.checkboxBalanceLoads ,'Visible','Off','Value',0) ;
            checkboxBalanceLoads_Callback(hObject, [], handles);
        end
    end

    set(handles.EditHoldState,'String',num2str(s.Bit.OnDebugWait) ) ; 
    handles.s = s ; 
    if handles.s.Bit.DebugHoldEnabled
        set(handles.PushHoldEnable,'String','Disable') ; 
        set(handles.PushHoldEnable,'BackGroundColor',[0,1,0]) ;
    else
        set(handles.PushHoldEnable,'String','Enable') ; 
        set(handles.PushHoldEnable,'BackGroundColor',[1,1,1]*0.8) ;
    end 
    
    LedsOn = s.BitDialog.LedsOn ;
    if ( bitand( LedsOn , 4 ) ) 
        CamLightOn = 1 ; 
    else
        CamLightOn = 0 ; 
    end
    
    set( handles.TextElapsedTime,'String',  TimeString ( s.base.TimeElapseMsec ) ) ; 
    switch handles.ManipStyle
        case handles.ManipStyleList.Flex_Manipulator 
           set(handles.TEXT_MANX,'String',num2str(ms.X)) ; % WTF ms.Tape) ) ;
           set(handles.TEXT_MANY,'String',num2str(ms.Y)); % WTF ms.Plate)) ;
           set( handles.TextMANDR,'String', num2str(ms.RD * 180 / pi)) ; 
           set( handles.TextMANDL,'String', num2str(ms.LD * 180 / pi)) ; 
        case handles.ManipStyleList.SCARA_Manipulator
            set( handles.TEXT_MANX,'String', num2str(ms.X  , '%3.3f')  ) ; 
            set( handles.TEXT_MANY,'String', num2str(ms.Y , '%3.3f')  ) ; 
            set( handles.TEXT_MANT,'String', num2str(ms.Tht * 180 / pi , '%3.2f' )  ) ; 
            set( handles.TextMANDR,'String', num2str(ms.RD * 180 / pi , '%3.2f' )  ) ; 
            set( handles.TextMANDL,'String', num2str(ms.LD * 180 / pi , '%3.2f' )  ) ; 
    end

    set( handles.CheckCamLight ,'Value' ,CamLightOn) ;  

    set( handles.CheckRLimit ,'Value' ,s.Bit.RSwValue ) ;  
    set( handles.CheckLLimit ,'Value' ,s.Bit.LSwValue ) ;  
    set( handles.EditRValidCnt ,'String' ,num2str(s.Bit.RSwDetectCnt) ) ;  
    set( handles.EditLValidCnt ,'String' ,num2str(s.Bit.LSwDetectCnt) ) ;  

    set( handles.CheckLeftBrake ,'Value' ,1-s.Bit.SteerBrakeRelease ) ;  
    set( handles.CheckRightBrake ,'Value' ,1-s.Bit.WheelBrakeRelease ) ;  
    
    set ( handles.RadioStandBy,'Value',ms.stdby) ;  
    set ( handles.RadiManMon,'Value',ms.MotorOn) ;  
    set ( handles.RadioManErrorBad,'Value',ms.Error) ;  
    set ( handles.RadioRecoverable,'Value',ms.ErrorRecoverable) ;  
    
%    Vandal  set ( handles.TextPump1On ,'BackGroundColor' , GetPumpRequestColor(s.Bit.PumpRequest,s.Bit.Pump1SwOn)) ; 
%    Vandal   set ( handles.TextPump2On ,'BackGroundColor' , GetPumpRequestColor(s.Bit.PumpRequest,s.Bit.Pump2SwOn)) ; 

    fac = 180 / pi;  % Rad to degrees
    cgr = [0, 1 ,0]; % Green color 
    crd = [ 1 ,0,0]; % Red color 
    if ~s.Bit.IMUFail
        set( handles.TextPitch,'String',num2str(fac * NavDesc.Pitch, '%2.2f'),'BackgroundColor',cgr) ;
        set( handles.TextRoll,'String',num2str(fac * NavDesc.Roll, '%2.2f'),'BackgroundColor',cgr) ;
    else
        set( handles.TextPitch,'String','','BackgroundColor',crd) ;
        set( handles.TextRoll,'String','','BackgroundColor',crd) ;
    end
    
    % Set nav state 
    if (  s.Bit.NavInitialized) 
        set( handles.CheckNavInitialized,'Value',1,'BackgroundColor',cgr) ;
        set( handles.TextPosX,'String',num2str(NavDesc.PosX),'BackgroundColor',cgr) ;
        set( handles.TextPosY,'String',num2str(NavDesc.PosY),'BackgroundColor',cgr) ;
        set( handles.TextPosZ,'String',num2str(NavDesc.PosZ),'BackgroundColor',cgr) ;

        set( handles.TextYew,'String',num2str(fac * NavDesc.Heading, '%2.2f'),'BackgroundColor',cgr) ;
    else
        set( handles.CheckNavInitialized,'Value',0,'BackgroundColor',crd) ;
        set( handles.TextPosX,'String','','BackgroundColor',crd) ;
        set( handles.TextPosY,'String','','BackgroundColor',crd) ;
        set( handles.TextPosZ,'String','','BackgroundColor',crd) ;
        if ~s.Bit.IMUFail
            set( handles.TextYew,'String',num2str(fac * NavDesc.Heading, '%2.2f'),'BackgroundColor',[0,0,1]) ;
        else
            set( handles.TextYew,'String','','BackgroundColor',crd) ;
        end
   
    end 
% str = struct('X',ManX,'Y',ManY,'Tht',ManTht,'RD',ManRD,'LD', ManLD) ; 

    
    
%     s.base.UsSamp1 =  FetchObj( [hex2dec('2204'),10] , DataType.float , 'UsSamp1') ;

%     handles.ManDesc = ManDesc ; 
    [str,bgc,fgc] = MotorStatAtr( s.Bit.MotorOnRw,s.Bit.FaultRw , s.Bit.QuickStop , s.base.Current1 , handles.bCheckFaultDetail * 1 ); 
    set( handles.TextMotorFault1,'String',str,'BackgroundColor',bgc,'ForegroundColor',fgc)  ; 
    [str,bgc,fgc] = MotorStatAtr( s.Bit.MotorOnLw,s.Bit.FaultLw , s.Bit.QuickStop , s.base.Current2 , handles.bCheckFaultDetail *  2 ); 
    set( handles.TextMotorFault2,'String',str,'BackgroundColor',bgc,'ForegroundColor',fgc)  ; 
    [str,bgc,fgc] = MotorStatAtr( s.Bit.MotorOnRSteer,s.Bit.FaultRSteer , s.Bit.QuickStop , s.base.Current3 ,handles.bCheckFaultDetail * 3); 
    set( handles.TextMotorFault3,'String',str,'BackgroundColor',bgc,'ForegroundColor',fgc)  ; 
    [str,bgc,fgc] = MotorStatAtr( s.Bit.MotorOnLSteer,s.Bit.FaultLSteer , s.Bit.QuickStop , s.base.Current4 ,handles.bCheckFaultDetail * 4 ); 
    set( handles.TextMotorFault4,'String',str,'BackgroundColor',bgc,'ForegroundColor',fgc)  ; 
    [str,bgc,fgc] = MotorStatAtr( s.Bit.MotorOnNeck,s.Bit.FaultNeck , s.Bit.QuickStop , s.base.Current5 , handles.bCheckFaultDetail * 5  ); 
    set( handles.TextMotorFault5,'String',str,'BackgroundColor',bgc,'ForegroundColor',fgc  )  ; 
   
    ManMotFail = 0 ;
    
    ManMotorOnArray = zeros(1,5) ; 
    if s.Bit.Dyn24InitDone
        
        mon   = s.Bit.MotorOnMan ; 
        ManMotorOnArray(1:3) = mon ; 
        
        mfail = -2 * s.Bit.ManFail ; 
        
        str = 'Net On' ; % : Sh, El, Wr:', num2str(mon+mfail) ] ;
        if any(mfail)
            ManMotFail = 1 ; 
        end 
        fgc = [0 0 0 ] ; 
        
        if any( s.Bit.Net24BootState == [7,8]) 
                str = 'Reboot' ; % : Sh, El, Wr:', num2str(mon+mfail) ] ;
                bgc = [1 1 1] ; 
        else
            if all(mon) 
                str = 'Mot On' ; % : Sh, El, Wr:', num2str(mon+mfail) ] ;
                % bgc = [0 0 1 ] ;
            else
                if any(mfail) 
                    str = ['Fail:', num2str(mfail) ] ;
                    bgc = [1 0 0] ; 
                else
                    bgc = [0 1 0 ] ; 
                end 
            end
        end
        % [~,bgc,fgc] = MotorStatAtr( all(mon) , any(mfail) , 0 );
    else
        str ='Net off';
        if handles.RobotType == 3 
            bgc = [0 0 1 ] ;
            fgc = [1 1 1 ] ; 
        else
        % [~,bgc,fgc] = MotorStatAtr( 0 , 1 , 0 );
            bgc = [1 0 0 ] ;
            fgc = [0 0 0 ] ; 
            ManMotFail = 1 ; 
        end
    end 
    
    set ( handles.EditDyn24Stat,'String' , str ,'BackgroundColor',bgc,'ForegroundColor',fgc) ; 
    
    if s.Bit.Dyn12InitDone
        mon   = s.Bit.MotorOnStop ; 
        ManMotorOnArray(4:5) = mon ; 
        mfail = -2 * s.Bit.StopFail ; 
        str = 'Net On' ; % : Ls, Rs:', num2str(mon+mfail) ] ;
        if any(mfail)
            ManMotFail = 1 ; 
        end 
        fgc = [0 0 0 ] ; 
        
        if any( s.Bit.Net12BootState == [7,8]) 
            str = 'Reboot' ; % : Sh, El, Wr:', num2str(mon+mfail) ] ;
            bgc = [1 1 1] ; 
        else
            if all(mon) 
                str = ['Mot On'] ; %
                % bgc = [0 0 1 ] ;
            else
                if any(mfail) 
                    str = ['Fail:', num2str(mfail) ] ;
                    bgc = [1 0 0] ; 
                else
                    bgc = [0 1 0 ] ; 
                end 
            end
        end
        % [~,bgc,fgc] = MotorStatAtr( all(mon) , any(mfail) , 0 );
    else
        str ='Net off'; 
%         [~,bgc,fgc] = MotorStatAtr( 0 , 1 , 0 );
        bgc = [1 0 0 ] ;
        fgc = [0 0 0 ] ; 
        ManMotFail = 1 ; 
    end 
    
    set ( handles.RadioShOn, 'Value' , ManMotorOnArray (1) ) ;
    set ( handles.RadioElOn, 'Value' , ManMotorOnArray (2) ) ;
    set ( handles.RadioWrOn, 'Value' , ManMotorOnArray (3) ) ;
    set ( handles.RadioRON, 'Value' , ManMotorOnArray (4) ) ;
    set ( handles.RadioLOn, 'Value' , ManMotorOnArray (5) ) ;
    
    set ( handles.EditDyn12Stat,'String' , str ,'BackgroundColor',bgc,'ForegroundColor',fgc) ; 
    
    fgc = [0 0 0 ] ; 
    if ( s.Bit.MotorOnRw || s.Bit.MotorOnLw ) 
        if ( s.Bit.BrakeReleaseCmd ) 
            str = 'Released' ; 
            bgc = [0 , 1 , 0 ];
        else  
            str = 'Engaged' ; 
            bgc = [0 , 0 , 1 ];
        end
    else 
        if ( ~s.Bit.BrakeReleaseCmd ) 
            str = 'Engaged' ; 
            fgc = [1 1 1 ] ; 
            bgc = [0 , 0 , 1 ];
        else  
            str = 'Released' ; 
            bgc = [0 , 1 , 0 ];
        end
    end 
    set( handles.TextBrakeState,'String',str,'BackgroundColor',bgc,'ForegroundColor',fgc)  ; 
    
    MarkHealth( handles.TexPotRefOk , s.Bit.PotRefFail) ; 
    
    MarkHealth( handles.TextNeckOK , s.Bit.OverNeckStretch ) 
    if ( s.Bit.GyroOffsetCalibrating && ~s.Bit.IMUFail) 
        set(handles.TextIMUOK,'String','Calib','BackgroundColor',[0.85 , 0.33 , 0.1 ],'ForegroundColor',[ 0 , 1 , 1 ]) ;   
    else
        MarkHealth( handles.TextIMUOK , s.Bit.IMUFail) ; 
    end 
    MarkHealth( handles.TextCalibOK , s.Bit.CalibReadFail) ; 

    MarkHealth( handles.Text54VOk , ~s.Bit.Active54V,s.Bit.V54Fail) ; 
    MarkHealth( handles.Text24VOK , ~s.Bit.Active24V,s.Bit.V24Fail) ; 
    MarkHealth( handles.Text12VOK , ~s.Bit.Active12V,s.Bit.V12Fail) ; 
    MarkHealth( handles.Text18VOK , ~s.Bit.Active18V,s.Bit.V18Fail) ; 
 
    if ( s.Bit.Active12V ) 
        set( handles.PushStart12,'String','Shut 12V','BackgroundColor',[0,1,0] ) ; 
    else
        set( handles.PushStart12,'String','Start 12V','BackgroundColor',[1,0,0] ) ; 
    end
    
    if ( s.Bit.Active24V ) 
        set( handles.PushStart24,'String','Shut 24V','BackgroundColor',[0,1,0] ) ; 
    else
        set( handles.PushStart24,'String','Start 24V','BackgroundColor',[0,0,1] ) ; 
    end
    
    if ( s.Bit.Active54V ) 
        set( handles.PushStartServoVoltage,'String','Shut 54V','BackgroundColor',[0,1,0] ) ; 
    else
        set( handles.PushStartServoVoltage,'String','Start 54V','BackgroundColor',[1,0,0] ) ; 
    end
     
%     RsteerReached = bitget ( ManDesc.GenStat, 1 ) ; 
%     LsteerReached = bitget ( ManDesc.GenStat, 2 ) ; 
%     RWStop = bitget ( ManDesc.GenStat, 3 ) ; 
%     LWStop = bitget ( ManDesc.GenStat, 4 ) ; 
%     NewCrabFlag  = bitget ( ManDesc.GenStat, 5 ) ; 
    % CrabCrawl = sum( bitget ( ManDesc.GenStat, (6:7) ) .* [2,1] )  ; 
%     InductiveR = bitget ( ManDesc.GenStat, 8 ) ; 
%     InductiveL = bitget ( ManDesc.GenStat, 9 ) ; 

%     set( handles.CheckTransition,'Value',NewCrabFlag ) ; 
%     set( handles.CheckStopped,'Value',RWStop * LWStop ) ; 
%     set( handles.CheckConverged,'Value',RsteerReached * LsteerReached ) ; 
    
%     set( handles.CheckInductiveL,'Value',InductiveL) ; 
%     set( handles.CheckInductiveR,'Value',InductiveR) ; 

    Rsteer = -s.base.ROuterPos ;
    [bg,fg] =  SetSeverityColor(abs(Rsteer* 180 / pi) ,handles.BitSetup.SteerLimitsBgColor  ) ; 
    set( handles.TextRightSteer,'String', num2str(Rsteer * 180 / pi ), 'BackgroundColor' ,bg,'ForegroundColor' , fg  ) ; 

    Lsteer = -s.base.LOuterPos ;
    [bg,fg] =  SetSeverityColor(abs(Lsteer* 180 / pi) ,handles.BitSetup.SteerLimitsBgColor  ) ; 
    
    set( handles.TextLeftSteer,'String', num2str(Lsteer * 180 / pi ), 'BackgroundColor' ,bg,'ForegroundColor' , fg  ) ; 
    
    NeckAngle = s.base.NOuterPos ;
    set( handles.TextNeckAngle,'String', num2str(NeckAngle * 180 / pi )  ) ; 

    TorqueDiff = s.base.TorqueDiff ;
    
    [bg,fg] =  SetSeverityColor(abs(TorqueDiff * 180 / pi) ,handles.BitSetup.NeckLimitsBgColor ) ; 
    set( handles.TextNeckDiff,'String', num2str(TorqueDiff * 180 / pi ) , 'BackgroundColor' ,bg,'ForegroundColor' , fg) ;   
    
    Tilt = s.BitDialog.Tilt ; %  FetchObj( [hex2dec('2204'),53] , DataType.float ,'Tilt') ;
    set( handles.TextAccTilt,'String', num2str(Tilt * 180 / pi )  ) ; 
    
    if s.Bit.RobotType < 3
        v36 = s.base.V36 ; 
        if ( v36 > 40.0 ) 
            bcolor = [0 1 1 ] ; 
            fcolor = [ 1 0 0 ] ; 
        elseif ( v36 > 38.0 ) 
            bcolor = [1 1 0 ] ; 
            fcolor = [ 1 0 0 ] ; 
        else
            bcolor = [1 0 0  ] ; 
            fcolor = [1 1 1 ] ; 
        end
        set( handles.TextBattary36,'String', num2str(v36 ) ,'BackgroundColor' ,bcolor,'ForegroundColor',fcolor) ; 
    else
        v18 = s.base.Volts18 ; 
        if ( v18 > 20.0 ) 
            bcolor = [1 0 0  ] ; 
            fcolor = [1 1 1 ] ; 
        elseif ( v18 > 15.0 ) 
            bcolor = [0 1 1 ] ; 
            fcolor = [ 1 0 0 ] ; 
        else
            bcolor = [1 0 0  ] ; 
            fcolor = [1 1 1 ] ; 
        end
        set( handles.TextBattary36,'String', num2str(v18 ) ,'BackgroundColor' ,bcolor,'ForegroundColor',fcolor) ; 
    end

    set( handles.TextBattary54,'String', num2str(s.base.VBat54 )  ) ; 
    set( handles.TextPS24,'String', num2str(s.base.Volts24 )  ) ; 
    set( handles.Text12VPS,'String', num2str(s.base.Volts12 )  ) ; 

    
    % num = FetchObj( [hex2dec('220b'),1] , DataType.long ,'Mode status') ;
    
    [strMotMode,mm] = GetDictEntry( handles.MotModes , s.Bit.Mode , 0 , 15 ) ; 
    
    % In auto mode, automatic update of angles
    if ( mm == 10 && s.Bit.ExecutingQueue )
        PushLoadActSetPoint_Callback(handles.hObject, [], handles);
    end 
    
    q   = s.Bit.ExecutingQueue ; 
    IndInQ = s.Bit.nGet ; 
    WakeStateStr = GetDictEntry( handles.WakeStates , s.Bit.WakeupState , 0 , 15 ) ; 
    strOpCode = GetDictEntry( handles.AutoOpCodes , s.Bit.OpCode , 0 , 31 ) ; 
    %PrevStrOpCode = GetDictEntryByCode( handles.AutoOpCodes , max([ccode-1,0]) );
    GndNav = s.Bit.InGroundNav ; 
    InPack = s.Bit.InPack  ; 
    if ( mm == 5 ) 
        InPack = 1 ; 
    end 
    
    Manip = s.Manip ; 
    
    % NumManPackState = FetchObj( [hex2dec('220b'),11] , DataType.long ,'Manipulator package status') ; % Low byte is manipulator state, high byte is error 
    ShelfCode = GetDictEntry( handles.ShelfModes , s.Bit.ShelfMode , 0 , 15 ) ; 
    if ( isequal('E_ShelfArc',ShelfCode)  )
        % Arc climb 
        handles.ssubmode = s.Bit.ShelfSubMode ; % FetchObj( [hex2dec('2207'),199] , DataType.float ,'Get Shelf mode') ;
        ShelfSubCode = GetDictEntry( handles.ArcSubModes , handles.ssubmode , 0 , 15 ) ; 
        ShelfCode = [ShelfCode,':',ShelfSubCode];
    end 
    PackState = GetDictEntry( handles.PackStates , s.Bit.PackState , 0 , 15 ) ; 
    [PackStateMan,manstatecode] = GetDictEntry( handles.ManPackStates , Manip.ManState , 0 , 255 ) ; 
        
    % [~,code] = GetDictEntry( handles.ManFailures , Manip.ManStopErr , 0 , 255 ) ;
    if Manip.ManStopErr == 0 
        ManLastFail = 'Manipulator ok' ; 
        etext = ManLastFail ;
        elabtext = '' ; 
        if ManMotFail 
            ManLastFail = 'Fault in manipulator: ' ;
        end
    else
        code = Manip.ManStopErr + 8192 ; 
        [etext,elabtext] = Errtext(code); 
        ManLastFail = [ etext,':  ',elabtext ] ; 
    end
    if ( manstatecode == 255 )
        [PackStateMan] =  ManLastFail;
    end 


    
    InSleep = 0 ; 
    if  isequal ( WakeStateStr, 'E_CAN_WAKEUP_OPERATIONAL') 
        
        if handles.MotRefInit == 0 
            handles.MotRefInit = 1; 
            PushLoadActSetPoint_Callback(handles.hObject, [], handles); 
        end

        StatStr = ['Mot mode:[',strMotMode,']'] ; 
        if ( mm == 10 ) % Automatic 
            if ( q == 0 )
                StatStr = [StatStr,'Waiting indefinite in null queue '] ; 
            else    
                StatStr = [StatStr,' Queue[ind]:',num2str(q) ,' Next fetch[',num2str(IndInQ) ,']:',strOpCode] ; 
            end
        end 
        if GndNav 
            ShelfStr = 'Ground nav: ' ; 
        else
            ShelfStr = ['Shelf mode:[',ShelfCode,']'] ; 
        end 
        if ( InPack ) 
            ShelfStr = [ShelfStr , 'PackState:',PackState,' Man:',PackStateMan]; 
        end

        expnum_2 = s.BitDialog.expnum_2; %   FetchObj( [hex2dec('220b'),2] , DataType.long ,'Captured exceptions') ;
        expnow = GetCode( expnum_2 , 0 , 65535  ) ; 
        expold = GetCode( expnum_2 , 16 , 65535  ) ; 

        expnum_3 = s.BitDialog.expnum_3 ; % FetchObj( [hex2dec('220b'),3] , DataType.long ,'Mode status') ;
        expold2 = GetCode( expnum_3 , 0 , 65535  ) ; 
        expold3 = GetCode( expnum_3 , 16 , 65535  ) ; 

        if s.Bit.InPause
            StatStr = [StatStr ,': In mission Pause'];
        end
        
        set ( handles.TextStatStr, 'String' , StatStr ) ; 
        if ( mm >= 14 ) 
            set (handles.TextStatStr,'BackgroundColor',[1 , 0 , 0 ],'ForegroundColor',[ 0 , 1 , 1 ]) ;
        else
            set(handles.TextStatStr,'BackgroundColor',[0 , 1 , 1 ],'ForegroundColor',[ 1 , 0 , 0 ]); 
        end 
        
        
        set(handles.TextShelfStr,'BackgroundColor',[0 , 1 , 1 ],'ForegroundColor',[ 1 , 0 , 0 ]); 
        set ( handles.TextShelfStr, 'String' , ShelfStr ) ; 
        [etext,elabtext] = Errtext(expnow); 
        set ( handles.TextErrCode, 'String' , ['1: 0x',dec2hex(expnow),' : ',etext ,' : ',elabtext] ) ; 
            [etext,elabtext] = Errtext(expold); 
        set ( handles.TextErrCode2, 'String' , ['2: 0x',dec2hex(expold),' : ',etext ,' : ',elabtext] ) ; 
            [etext,elabtext] = Errtext(expold2); 
        set ( handles.TextErrCode3, 'String' , ['3: 0x',dec2hex(expold2),' : ',etext ,' : ',elabtext] ) ; 
            [etext,elabtext] = Errtext(expold3); 
        set ( handles.TextErrCode4, 'String' , ['4: 0x',dec2hex(expold3),' : ',etext ,' : ',elabtext] ) ;  

        mf = ManLastFail ; 
        ManLastFail = [mf , GetManMotErr('D1',s.Bit.Net12MovState(1)),GetManMotErr('D2',s.Bit.Net12MovState(2)),...
            GetManMotErr('SH',s.Bit.Net24MovState(1)),GetManMotErr('EL',s.Bit.Net24MovState(2)),GetManMotErr('WR',s.Bit.Net24MovState(3)),GetManMotErr('','',ms.Stat)] ;
        
        set ( handles.TextErrCodeMan,'String',['Last man err=',ManLastFail]) ; 
    else
        handles.MotRefInit = 0 ; 
        
        set (handles.TextStatStr,'BackgroundColor',[1 , 0 , 0 ],'ForegroundColor',[ 0 , 1 , 1 ]) ;
        StatStr = ['Wakeup state:[',WakeStateStr,']'] ; 
        if isequal ( WakeStateStr,'E_CAN_WAKEUP_SLEEP') 
            set(handles.TextShelfStr,'BackgroundColor',[0 , 1 , 1 ],'ForegroundColor',[ 1 , 0 , 0 ]); 
            InSleep = 1 ; 
            set ( handles.TextStatStr, 'String' , ['Robot is set to sleep (power save), Wakeup submode : ',StatStr] ) ; 
            set ( handles.TextShelfStr, 'String' , 'Shelf state : NA' ) ; 
            set ( handles.TextErrCode, 'String' , '' ) ; 
            set ( handles.TextErrCode2, 'String' , '' ) ; 
            set ( handles.TextErrCode3, 'String' , '' ) ; 
            set ( handles.TextErrCode4, 'String' , '' ) ;  
            set ( handles.TextErrCodeMan,'String','Manipulator state : NA') ; 
        else
            expnum_2 = s.BitDialog.expnum_2; % FetchObj( [hex2dec('220b'),2] , DataType.long ,'Captured exceptions') ;
            expnow = GetCode( expnum_2 , 0 , 65535  ) ; 
            expold = GetCode( expnum_2 , 16 , 65535  ) ; 

            expnum_3 = s.BitDialog.expnum_3; % FetchObj( [hex2dec('220b'),3] , DataType.long ,'Mode status') ;
            expold2 = GetCode( expnum_3 , 0 , 65535  ) ; 
            expold3 = GetCode( expnum_3 , 16 , 65535  ) ; 
            set ( handles.TextStatStr, 'String' , ['Robot not operational, Wakeup submode : ',StatStr] ) ; 

            strps = GetDictEntry( handles.PsWakeUpStates , s.Bit.Status_WakeUp , 0 , 15 );
            set ( handles.TextShelfStr, 'String', ['Power supply wakeup state : ' , strps] ) ; 
            if  ( s.Bit.Status_WakeUp == RecStruct.Enums.PsWakeUpStates.SYSSTAT_WAKE_WAIT_OPER ) 
                set(handles.TextShelfStr,'BackgroundColor',[0 , 1 , 1 ],'ForegroundColor',[ 1 , 0 , 0 ]); 
            else
                set (handles.TextShelfStr,'BackgroundColor',[1 , 0 , 0 ],'ForegroundColor',[ 0 , 1 , 1 ]) ;
            end
            [etext,elabtext] = Errtext(expnow); 
            set ( handles.TextErrCode, 'String' , ['1: 0x',dec2hex(expnow),' : ',etext ,' : ',elabtext] ) ; 
                [etext,elabtext] = Errtext(expold); 
            set ( handles.TextErrCode2, 'String' , ['2: 0x',dec2hex(expold),' : ',etext ,' : ',elabtext] ) ; 
                [etext,elabtext] = Errtext(expold2); 
            set ( handles.TextErrCode3, 'String' , ['3: 0x',dec2hex(expold2),' : ',etext ,' : ',elabtext] ) ; 
                [etext,elabtext] = Errtext(expold3); 
            set ( handles.TextErrCode4, 'String' , ['4: 0x',dec2hex(expold3),' : ',etext ,' : ',elabtext] ) ;  
            set ( handles.TextErrCodeMan,'String','Manipulator state : NA') ; 
        end
    end
    
    if InSleep
        set( handles.PushGotoSleep ,'String','Wakeup') ; 
    else
        set( handles.PushGotoSleep ,'String','Sleep') ; 
    end
    
    set( handles.CheckMushroomPressed ,'Value',s.Bit.MushroomDepressed) ; 
    if s.Bit.MushroomDepressed
        set( handles.CheckMushroomPressed ,'BackgroundColor',[1,0,0],'String','Depressed') ; 
    else
        set( handles.CheckMushroomPressed ,'BackgroundColor',[0,1,0],'String','Released') ; 
    end
    
    
    
    LaserDist = s.BitDialog.LaserDist    ; % FetchObj( [hex2dec('2204'),10] , DataType.float ,'Laser distance') ;
    if (LaserDist > -2 && LaserDist < 265  ) 
        set( handles.TextLaserDist , 'String' , num2str(LaserDist) , 'BackgroundColor', [0,1,1] ) ; 
    else
        set( handles.TextLaserDist , 'String' , 'Invalid' , 'BackgroundColor', [1,1,0]) ; 
    end
        
    set ( handles.TextLineDevCounter , 'String' , num2str(NavDesc.DevCnt ) ) ; 
    set ( handles.TextLineAge , 'String' , num2str(NavDesc.DevAge ) ) ; 
    set ( handles.TextLineTheta , 'String' , num2str(NavDesc.DevAz ) ) ; 
    set ( handles.TextLineOffset , 'String' , num2str(NavDesc.DevOffset ) ) ; 
    set ( handles.TextQrCounter , 'String' , num2str(NavDesc.QrCnt ) ) ; 
    set ( handles.TextQrTheta , 'String' , num2str(NavDesc.QrAz ) ) ; 
    set ( handles.TextQrX , 'String' , num2str(NavDesc.QrX ) ) ; 
    set ( handles.TextQrY , 'String' , num2str(NavDesc.QrY ) ) ; 
    
    
    switch handles.RobotCfg.WheelArmType 
        case RecStruct.Enums.WheelArmType.Rigid
            set(handles.textwheelarmtype,'String','No wheel arm') ; 
        otherwise % case RecStruct.Enums.WheelArmType.Wheel_Arm28
             WarmState = s.Bit.WarmSummary ;
             WarmState = bitand(WarmState , 15*2^6)  / 2^6 ;
             WarmLabelString = GetDictEntry( handles.WheelArmStates , WarmState , 0 , 15 ) ; 
             switch WarmLabelString
                 case 'E_GroundGood2Go'
                     labelcolor = [1,1,1] * 0.5 ; 
                 case 'E_RExtendGood2Go'
                     labelcolor = [253,218,13]/500; 
                 case 'E_LExtendGood2Go'
                     labelcolor = [253,218,13]/500; 
                 otherwise
                     labelcolor = [1,0,0]; 
             end
                     
             set(handles.TextWheelArmState,'String',WarmLabelString,'BackgroundColor',labelcolor) ; 
             if ( handles.RobotCfg.WheelArmType == RecStruct.Enums.WheelArmType.Wheel_Arm28) 
                 set( handles.textwheelarmtype,'String','Wheel arm 28" state') ; 
             end 
             if ( handles.RobotCfg.WheelArmType == RecStruct.Enums.WheelArmType.Wheel_Arm24) 
                 set( handles.textwheelarmtype,'String','Wheel arm 24" state') ; 
             end 
    end
    
% if ~isempty(sbase.TemperatureRW) 
% end
%     base.TemperatureRW = TemperatureRW ; 
%     base.TemperatureLW = TemperatureLW ; 


    handles.CommInactive = 0 ; 

    
    guidata(handles.hObject, handles);


% --- Outputs from this function are returned to the command line.
function varargout = BIT_OutputFcn(~, ~, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = [] ; %handles.output;


% --- Executes on button press in CheckMotorOn1.
function CheckMotorOn1_Callback(hObject, eventdata, handles)
% hObject    handle to CheckMotorOn1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of CheckMotorOn1


% --- Executes on button press in CheckMotorOn2.
function CheckMotorOn2_Callback(hObject, eventdata, handles)
% hObject    handle to CheckMotorOn2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of CheckMotorOn2


% --- Executes on button press in CheckMotorOn3.
function CheckMotorOn3_Callback(hObject, eventdata, handles)
% hObject    handle to CheckMotorOn3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of CheckMotorOn3


% --- Executes on button press in CheckMotorOn4.
function CheckMotorOn4_Callback(hObject, eventdata, handles)
% hObject    handle to CheckMotorOn4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of CheckMotorOn4


% --- Executes on button press in CheckMotorOn5.
function CheckMotorOn5_Callback(hObject, eventdata, handles)
% hObject    handle to CheckMotorOn5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of CheckMotorOn5


% --- Executes on button press in RadioBrakeAuto.
function RadioBrakeAuto_Callback(hObject, eventdata, handles)
% hObject    handle to RadioBrakeAuto (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of RadioBrakeAuto


% --- Executes on button press in RadioBrakeEngage.
function RadioBrakeEngage_Callback(hObject, eventdata, handles)
% hObject    handle to RadioBrakeEngage (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of RadioBrakeEngage


% --- Executes on button press in CheckboxLeftBrakeRelease.
function CheckboxLeftBrakeRelease_Callback(hObject, eventdata, handles)
% hObject    handle to CheckboxLeftBrakeRelease (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of CheckboxLeftBrakeRelease
% set(handles.CheckboxLeftBrakeRelease,'Value',1);
% set(handles.RadioBrakeAutomatic,'Value',0);



% --- Executes on button press in CheckIndividualControl.
function CheckIndividualControl_Callback(hObject, eventdata, handles)
% hObject    handle to CheckIndividualControl (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in PushResetWork.
function PushResetWork_Callback(hObject, ~, handles)
% hObject    handle to PushResetWork (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global DataType 

vec  = 2.^[0:15] ; 
mon1 = get( handles.CheckMotorOn1,'Value') ; 
mon2 = get( handles.CheckMotorOn2,'Value') ; 
mon3 = get( handles.CheckMotorOn3,'Value') ; 
mon4 = get( handles.CheckMotorOn4,'Value') ; 
mon5 = get( handles.CheckMotorOn5,'Value') ; 

% allow_WADisengaged = get( handles.CheckAllowWheelArm,'Value') ; 
% 
% if allow_WADisengaged
%     SendObj( [hex2dec('2220'),17] , 1 , DataType.long , 'ShutUpOlivier' ) ;
%     SendObj( [hex2dec('2222'),20] , 0 , DataType.long , 'Kill use flag' ) ;
%     SendObj( [hex2dec('2222'),9] , 1 , DataType.long , 'Set wheelarm cheat ' ) ;
%     SendObj( [hex2dec('2222'),7] , 1 , DataType.long , 'Allow manual wheelarm ' ) ;
%     SendObj( [hex2dec('2222'),6] , 1 , DataType.long , 'Allow debubg wheelarm (stretch arm in manual mode)' ) ;
% end

mon = [mon1, mon2 ,mon3 ,mon4 ,mon5, 1] ; 
qs = [0,1] ; % [get( handles.CheckQuickBox,'Value'), 1] ;
rsfail = [1 , 1] ; 
reserved = [0,0,0];
if get(handles.checkboxManualBrakeControl,'Value')
    brr = [0 0 1] ;  
    if get(handles.checkboxRReleaseBrake,'Value')
        brr(2) = 1 ; 
    end
    if get(handles.CheckboxLeftBrakeRelease,'Value')
        brr(1) = 1 ; 
    end
else
    brr = [0,0,0] ; 
end 
value = sum( [ mon , reserved , brr,  rsfail , qs] .* vec ) ;  
SetMasterBlaster() ; 
SendObj( [hex2dec('2220'),6] , value , DataType.short ,'Reset motors cmd') ;

% After setting, refresh position display 
PushLoadActSetPoint_Callback(hObject, [], handles);

% % --- Executes on button press in RadioBrakeAutomatic.
% function RadioBrakeAutomatic_Callback(hObject, eventdata, handles)
% % hObject    handle to RadioBrakeAutomatic (see GCBO)
% % eventdata  reserved - to be defined in a future version of MATLAB
% % handles    structure with handles and user data (see GUIDATA)
% 
% % Hint: get(hObject,'Value') returns toggle state of RadioBrakeAutomatic
% set(handles.CheckboxLeftBrakeRelease,'Value',0);
% set(handles.RadioBrakeAutomatic,'Value',1);

% --- Executes on button press in PushStart12.
function PushStart12_Callback(hObject, eventdata, handles)
% hObject    handle to PushStart12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global DataType 
global TargetCanId
SetMasterBlaster() ; 
if isequal( get( handles.PushStart12 ,'String'), 'Start 12V')  
    SendObj( [hex2dec('2220'),9] , 1 , DataType.short , 'Start 12V' ) ;
    set( handles.PushStart12,'String','Start 12V','BackgroundColor',[1,0,0] ) ; 
else
    SendObj( [hex2dec('2220'),9] , 0 , DataType.short , 'Shut 12V' ) ;
    set( handles.PushStart12,'String','Shut 24V','BackgroundColor',[1,0,0] ) ; 
end 


% --- Executes on button press in PushStart24.
function PushStart24_Callback(hObject, eventdata, handles)
% hObject    handle to PushStart24 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global DataType 
global TargetCanId
SetMasterBlaster() ; 
if isequal( get( handles.PushStart24 ,'String'), 'Start 24V')  
    set( handles.PushStart24,'String','Start 24V','BackgroundColor',[1,0,0] ) ; 
    SendObj( [hex2dec('2220'),10] , 1 , DataType.short , 'Start 24V' ) ;
else
    SendObj( [hex2dec('2220'),10] , 0 , DataType.short , 'Shut 24V' ) ;
    set( handles.PushStart24,'String','Shut 24V','BackgroundColor',[1,0,0] ) ; 
end 


function SetMasterBlaster() 
global DataType
SendObj( [hex2dec('2220'),5] , hex2dec('1234') , DataType.short , 'Set Master Blaster' ) ;


% --- Executes on button press in PushStartServoVoltage.
function PushStartServoVoltage_Callback(hObject, eventdata, handles)
% hObject    handle to PushStartServoVoltage (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global DataType
SetMasterBlaster() ; 
if isequal( get( handles.PushStartServoVoltage ,'String'), 'Start 54V')  
    SendObj( [hex2dec('2220'),11] , 1 , DataType.short , 'Set servo voltage' ) ;
    set( handles.PushStartServoVoltage,'String','Start 54V','BackgroundColor',[1,0,0] ) ; 
else
    SendObj( [hex2dec('2220'),11] , 0 , DataType.short , 'Shut servo voltage' ) ;
    set( handles.PushStartServoVoltage,'String','Shut 54V','BackgroundColor',[1,0,0] ) ; 
end






% --- Executes on button press in PushDloadLP.
function PushDloadLP_Callback(hObject, eventdata, handles)
% hObject    handle to PushDloadLP (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set ( handles.EvtObj,'active', 0 ) ; 
% stop (handles.timer) ;
DownFW ; 

% --- Executes on button press in PushDLoadPD.
function PushDLoadPD_Callback(hObject, eventdata, handles)
% hObject    handle to PushDLoadPD (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global PdProjectRoot
global PDHexName 
global DataType
% stop (handles.timer) ;
set ( handles.EvtObj,'active', 0 ) ; 
fname = [PdProjectRoot,'Debug\',PDHexName] ; 

ButtonName = questdlg({'Is this FW file correct?';fname}, ...
                         'Please approve', ...
                         'Approve', 'Reject', 'Reject');
if ~isequal(ButtonName,'Approve')
    disp( ['Downloading FW from file [',fname,'] has been rejected'] ) ; 
    return ; 
end

SendObj( [hex2dec('2220'),12] ,1 , DataType.long , 'Stop periodic int to PD ' ) ;
DownFWFunc( fname , @Com2PdThroughLp , 40 )

% --- Executes on button press in PushResetLPOnly.
function PushResetLPOnly_Callback(hObject, eventdata, handles)
% hObject    handle to PushResetLPOnly (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global DataType
act = handles.TmrFunctionActive  ;
handles.TmrFunctionActive = 0 ; 
guidata(hObject, handles);

%%% Comment the next line 
% SendObj( [hex2dec('2301'),1] , hex2dec('12345678') , DataType.long , 'FW access rights' ) ;
try 
SendObj( [hex2dec('2301'),244] , 0 , DataType.long , 'Reset FW' ,[] , 10, 0) ;
catch 
end 
handles.TmrFunctionActive = act ; 
guidata(hObject, handles);





% --- Executes on button press in CheckMushroomPressed.
function CheckMushroomPressed_Callback(hObject, eventdata, handles)
% hObject    handle to CheckMushroomPressed (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of CheckMushroomPressed


% --- Executes on button press in CheckFaultDetail.
function CheckFaultDetail_Callback(hObject, eventdata, handles)
% hObject    handle to CheckFaultDetail (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of CheckFaultDetail
handles.bCheckFaultDetail = get( handles.CheckFaultDetail,'Value') ; 
guidata(handles.hObject, handles);


% --- Executes on button press in PushLoadActSetPoint.
function PushLoadActSetPoint_Callback(hObject, ~, handles)
% hObject    handle to PushLoadActSetPoint (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global DataType
s = handles.s ; 
Rsteer = -s.base.ROuterPos ;
Lsteer = -s.base.LOuterPos ; 
NeckAngle = s.base.NOuterPos ;
% FetchObj( [hex2dec('2204'),34] , DataType.long ,'Right Wheel Speed');
%RWSpeed = RWSpeed * 0.0198999997 / 11678.9736; 
%LWSpeed = FetchObj( [hex2dec('2204'),35] , DataType.long ,'Left Wheel Speed')  ; 
%LWSpeed = LWSpeed * 0.0198999997 / 11678.9736 ;

%handles.ManualRSpeedCmd = 0  ; 
handles.ManualRSpeedCmd = 0 ; % RWSpeed ;
set(handles.EditRWheelSpeed,'String',num2str(handles.ManualRSpeedCmd) ) ; 
%handles.ManualLSpeedCmd = 0  ; 
handles.ManualLSpeedCmd = 0 ; % LWSpeed ; 
set(handles.EditLWheelSpeed,'String',num2str(handles.ManualLSpeedCmd) ) ; 
handles.ManualRSteerCmd = Rsteer  * 180 / pi ; 
set(handles.EditRSteerSetPoint,'String',num2str(handles.ManualRSteerCmd) ) ;
handles.ManualLSteerCmd = Lsteer  * 180 / pi  ; 
set(handles.EditLSteerSetPoint,'String',num2str(handles.ManualLSteerCmd) ) ;
handles.ManualNeckCmd = NeckAngle * 180 / pi  ; 
set(handles.EditNeckSetPoint,'String',num2str(handles.ManualNeckCmd) ) ;
guidata(hObject, handles);


% --- Executes on button press in PushApplySetPoint.
function PushApplySetPoint_Callback(hObject, eventdata, handles)
% hObject    handle to PushApplySetPoint (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Steering tracking management
set(handles.CheckSteeringTracking,'value',0)
SendObj( [hex2dec('2220'),130] ,0  , GetDataType('long') , 'Wheel untrack steering' ) ;

PushApplySetPoint_Body(hObject, eventdata, handles,0) % Dont ask here anything 

function PushApplySetPoint_Body(hObject, eventdata, handles,askCrab)

global DataType %#ok<GVMIS> 

if nargin < 4 
    askCrab = 0 ; 
end 

s = handles.s ; 
Rsteer = -s.base.ROuterPos * 180 / pi ;
Lsteer = -s.base.LOuterPos * 180 / pi  ;
NeckPos = s.base.NOuterPos * 180 / pi ; 
% NeckAngle = s.base.NOuterPos * 180 / pi  ;
tolDeg = 12 ; 
if askCrab
    if ( abs(NeckPos) > 1 &&  abs( Rsteer - 90) < tolDeg) && (abs( Lsteer + 90) < tolDeg) && ( abs(s.Bit.CrabCrawl) < 0.5)
        pref = questdlg({'Steering angles are crabbed','But logical state is NOT.','Do you want to set crabbed state?'}, ...
                             'Decision for wheel speed direction', ...
                             'Yes', 'No','Abort', 'Abort');
        if isequal(pref,'Abort') 
            return ; 
        end 

        if ~isequal(pref,'No') 
            if isequal(pref,'Yes') 
                pref = questdlg('Set crab direction', ...
                                     'Decision for wheel speed direction', ...
                                     'Left','Right', 'Abort', 'Abort');
            end 
            
            if isequal(pref,'Abort') 
                return ; 
            end 
    
            if isequal(pref,'Right') 
                if NeckPos < 0 
                    pref = questdlg({'By neck angle you should crab left','Are you sure?'}, ...
                                 'Decision for wheel speed direction', ...
                                 'Yes', 'Abort', 'Abort');
                    if isequal(pref,'Abort') 
                        return ; 
                    end 
                end
                try
                    SendObj( [hex2dec('2222'),28] , 15 * pi / 180  , DataType.float , 'Set to CRAB' ) ;
                catch
                    return
                end
            else
                if NeckPos > 0 
                    pref = questdlg({'By neck angle you should crab Right','Are you sure?'}, ...
                                 'Decision for wheel speed direction', ...
                                 'Yes', 'Abort', 'Abort');
                    if isequal(pref,'Abort') 
                        return ; 
                    end 
                end
                try
                    SendObj( [hex2dec('2222'),29] , 15 * pi / 180  , DataType.float , 'Set to CRAB' ) ;
                catch
                    return 
                end
            end
        end
    else


        if ( abs(NeckPos) > 1 &&  (abs( Rsteer  ) < tolDeg) && (abs( Lsteer  ) < tolDeg) &&  s.Bit.CrabCrawl )
            pref = questdlg({'Steering angles are not crabbed','But logical state is CRABBED.','Do you want to set un-crabbed state?'}, ...
                                 'Decision for wheel speed direction', ...
                                 'Yes', 'No','Abort', 'Abort');
            if isequal(pref,'Abort') 
                return ; 
            end
            if ~isequal(pref,'No') 
                if isequal(pref,'Yes') 
                    try
                        SendObj( [hex2dec('2222'),27] , 15 * pi / 180  , DataType.float , 'Unset CRAB' ) ;
                    catch
                        return ; 
                    end
                end 
            end
        end
    end

end
tolDeg = 65 ; 
if (abs(Rsteer) < tolDeg) && (abs( Lsteer) < tolDeg) && ( abs(s.Bit.CrabCrawl) > 0.5) && askCrab
    pref = questdlg({'Steering angles are NOT crabbed','But logical state is CRABBED.','Do you want to set uncrabbed state?'}, ...
                         'Decision for wheel speed direction', ...
                         'Yes', 'No','Abort', 'Yes');
    if isequal(pref,'Abort') 
        return ; 
    end 
    if isequal(pref,'Yes') 
        SendObj( [hex2dec('2222'),27] , 70 * pi / 180  , DataType.float , 'Set ro UNCRAB' ) ;
    end 
end


SendObj( [hex2dec('2206'),11] , handles.ManualRSpeedCmd  , DataType.float , 'Speed command RWheel' ) ;
SendObj( [hex2dec('2206'),12] , handles.ManualLSpeedCmd   , DataType.float , 'Speed command LWheel' ) ;
SendObj( [hex2dec('2206'),13] , handles.ManualRSteerCmd * pi / 180  , DataType.float , 'Pos command RSteer' ) ;
SendObj( [hex2dec('2206'),14] , handles.ManualLSteerCmd * pi / 180  , DataType.float , 'Pos command LSteer' ) ;
SendObj( [hex2dec('2206'),15] , handles.ManualNeckCmd * pi / 180  , DataType.float , 'Pos command Neck' ) ;
SendObj( [hex2dec('2228'),17] , double(get(handles.checkboxBalanceLoads,'Value'))  , DataType.long , 'SysState.Debug.bBalanceWheelLoadsOnManual' ) ;


% --- Executes on button press in PushStopAll.
function PushStopAll_Callback(hObject, eventdata, handles)
% hObject    handle to PushStopAll (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global DataType 
s = handles.s ; 
% First kill the wheels 
SendObj( [hex2dec('2206'),11] , 0  , DataType.float , 'Speed command RWheel' ) ;
SendObj( [hex2dec('2206'),12] , 0   , DataType.float , 'Speed command LWheel' ) ;

% Get axis commands for R,L, Neck 
cmdrsteer = s.base.cmdrsteerRadSec * 180 / pi; 
cmdlsteer = s.base.cmdlsteerRadSec * 180 / pi; 
cmdneck =  s.base.cmdneckRadSec * 180 / pi; 


% Get axis actuals for R,L, Neck 
actrsteer = -s.base.ROuterPos * 180 / pi;
actlsteer = -s.base.LOuterPos * 180 / pi; 
actneck   = s.base.NOuterPos  * 180 / pi ;

% Take actual value just if difference is too large
if abs(cmdrsteer-actrsteer) > 8 
    cmdrsteer = actrsteer ; 
end
if abs(cmdlsteer-actlsteer) > 8 
    cmdlsteer = actlsteer ; 
end
if abs(cmdneck-actneck) > 8 
    cmdneck = actneck ; 
end


handles.ManualRSteerCmd = cmdrsteer ;
handles.ManualLSteerCmd = cmdlsteer ; 
handles.ManualNeckCmd = cmdneck ;
handles.ManualRSpeedCmd = 0 ; 
handles.ManualLSpeedCmd = 0  ; 

guidata(hObject, handles); % Store command


% PushApplySetPoint_Callback(hObject, eventdata, handles);
% When pressing stop one should not deal with ant stupid questions
PushApplySetPoint_Body(hObject, eventdata, handles,0); 
set(handles.EditRWheelSpeed,'String',num2str(handles.ManualRSpeedCmd) ) ; 
set(handles.EditLWheelSpeed,'String',num2str(handles.ManualLSpeedCmd) ) ; 
set(handles.EditRSteerSetPoint,'String',num2str(handles.ManualRSteerCmd) ) ;
set(handles.EditLSteerSetPoint,'String',num2str(handles.ManualLSteerCmd) ) ;
set(handles.EditNeckSetPoint,'String',num2str(handles.ManualNeckCmd) ) ;



function EditRSteerSetPoint_Callback(hObject, eventdata, handles)
% hObject    handle to EditRSteerSetPoint (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of EditRSteerSetPoint as text
%        str2double(get(hObject,'String')) returns contents of EditRSteerSetPoint as a double
global DataType
try 
    pos = str2num(get(handles.EditRSteerSetPoint,'String')) ;  %#ok<*LTARG>
    if ( abs( pos  * pi / 180) <= 2 ) 
        handles.ManualRSteerCmd = pos ; 
        guidata(hObject, handles);
    end
catch 
end 
set( handles.EditRSteerSetPoint, 'String' , num2str(handles.ManualRSteerCmd) );  

% --- Executes during object creation, after setting all properties.
function EditRSteerSetPoint_CreateFcn(hObject, eventdata, handles)
% hObject    handle to EditRSteerSetPoint (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function EditLSteerSetPoint_Callback(hObject, eventdata, handles)
% hObject    handle to EditLSteerSetPoint (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of EditLSteerSetPoint as text
%        str2double(get(hObject,'String')) returns contents of EditLSteerSetPoint as a double
global DataType
try 
    pos = str2num(get(handles.EditLSteerSetPoint,'String'))  ;  %#ok<*LTARG>
    if ( abs( pos * pi / 180) <= 2 ) 
        handles.ManualLSteerCmd = pos ; 
        guidata(hObject, handles);
    end
catch 
end 
set( handles.EditLSteerSetPoint, 'String' , num2str(handles.ManualLSteerCmd) );  

% --- Executes during object creation, after setting all properties.
function EditLSteerSetPoint_CreateFcn(hObject, eventdata, handles)
% hObject    handle to EditLSteerSetPoint (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function EditRWheelSpeed_Callback(hObject, eventdata, handles)
% hObject    handle to EditRWheelSpeed (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of EditRWheelSpeed as text
%        str2double(get(hObject,'String')) returns contents of EditRWheelSpeed as a double
global DataType
try 
    speed = str2num(get(handles.EditRWheelSpeed,'String')) ;  %#ok<*LTARG>
    if ( abs( speed ) <= 2 ) 
        handles.ManualRSpeedCmd = speed ; 
        if ~get( handles.checkboxSeparateWheels, 'Value')
            handles.ManualLSpeedCmd = speed ; 
        end
        guidata(hObject, handles);
    end
catch 
end 
set( handles.EditRWheelSpeed, 'String' , num2str(handles.ManualRSpeedCmd) );  
if ~get( handles.checkboxSeparateWheels, 'Value')
    set( handles.EditLWheelSpeed, 'String' , num2str(handles.ManualLSpeedCmd) );  
end



% --- Executes during object creation, after setting all properties.
function EditRWheelSpeed_CreateFcn(hObject, eventdata, handles)
% hObject    handle to EditRWheelSpeed (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function EditLWheelSpeed_Callback(hObject, eventdata, handles)
% hObject    handle to EditLWheelSpeed (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of EditLWheelSpeed as text
%        str2double(get(hObject,'String')) returns contents of EditLWheelSpeed as a double
global DataType
try 
    speed = str2num(get(handles.EditLWheelSpeed,'String')) ;  %#ok<*LTARG>
    if ( abs( speed ) <= 2 ) 
        handles.ManualLSpeedCmd = speed ; 
        guidata(hObject, handles);
    end   
catch 
end 
set( handles.EditLWheelSpeed, 'String' , num2str(handles.ManualLSpeedCmd) );  

 
% --- Executes during object creation, after setting all properties.
function EditLWheelSpeed_CreateFcn(hObject, eventdata, handles)
% hObject    handle to EditLWheelSpeed (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in CheckCanTxOn.
function CheckCanTxOn_Callback(hObject, eventdata, handles)
% hObject    handle to CheckCanTxOn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of CheckCanTxOn



function EditNeckSetPoint_Callback(hObject, eventdata, handles)
% hObject    handle to EditNeckSetPoint (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of EditNeckSetPoint as text
%        str2double(get(hObject,'String')) returns contents of EditNeckSetPoint as a double
global DataType
try 
    pos = str2num( get(handles.EditNeckSetPoint,'String') )  ;  %#ok<*ST2NM,*LTARG>
    if ( abs( pos * pi / 180) <= 1.7 ) 
        handles.ManualNeckCmd = pos ; 
        guidata(hObject, handles);
    end
catch 
end 
set( handles.EditNeckSetPoint, 'String' , num2str(handles.ManualNeckCmd) );  


% --- Executes on button press in CheckForceLaser.
function CheckForceLaser_Callback(hObject, eventdata, handles)
% hObject    handle to CheckForceLaser (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of CheckForceLaser
global DataType
val= get( handles.CheckForceLaser , 'Value' ) ;
SendObj( [hex2dec('2220'),15] , val  , DataType.short , 'SetLaserOn' ) ;




% --- Executes on button press in CheckManualPump.
function CheckManualPump_Callback(hObject, eventdata, handles)
% hObject    handle to CheckManualPump (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of CheckManualPump
global DataType
val= get( handles.CheckManualPump , 'Value' ) ;
SendObj( [hex2dec('2220'),16] , val  , DataType.short , 'Set Pump On' ) ;


% --- Executes on button press in RadioStandBy.
function RadioStandBy_Callback(hObject, eventdata, handles)
% hObject    handle to RadioStandBy (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of RadioStandBy


% --- Executes on button press in RadiManMon.
function RadiManMon_Callback(hObject, eventdata, handles)
% hObject    handle to RadiManMon (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of RadiManMon


% --- Executes on button press in RadioManErrorBad.
function RadioManErrorBad_Callback(hObject, eventdata, handles)
% hObject    handle to RadioManErrorBad (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of RadioManErrorBad


% --- Executes on button press in RadioRecoverable.
function RadioRecoverable_Callback(hObject, eventdata, handles)
% hObject    handle to RadioRecoverable (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of RadioRecoverable


% --- Executes on button press in CheckForceLaser.
function checkbox26_Callback(hObject, eventdata, handles)
% hObject    handle to CheckForceLaser (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of CheckForceLaser


% --- Executes on button press in CheckManualPump.
function checkbox27_Callback(hObject, eventdata, handles)
% hObject    handle to CheckManualPump (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of CheckManualPump


% --- Executes on button press in RadioStandBy.
function radiobutton25_Callback(hObject, eventdata, handles)
% hObject    handle to RadioStandBy (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of RadioStandBy


% --- Executes on button press in RadiManMon.
function radiobutton26_Callback(hObject, eventdata, handles)
% hObject    handle to RadiManMon (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of RadiManMon


% --- Executes on button press in RadioManErrorBad.
function radiobutton27_Callback(hObject, eventdata, handles)
% hObject    handle to RadioManErrorBad (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of RadioManErrorBad


% --- Executes on button press in RadioRecoverable.
function radiobutton28_Callback(hObject, eventdata, handles)
% hObject    handle to RadioRecoverable (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of RadioRecoverable


% --- Executes on button press in CheckNavInitialized.
function CheckNavInitialized_Callback(hObject, eventdata, handles)
% hObject    handle to CheckNavInitialized (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of CheckNavInitialized


% --- Executes on button press in CheckCamLight.
function CheckCamLight_Callback(hObject, eventdata, handles)
% hObject    handle to CheckCamLight (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global DataType 
val = get(handles.CheckCamLight , 'Value' ) ;
if val 
    val = 1 ; % WTF was 4 
end 
SendObj( [hex2dec('2203'),100] , val , DataType.short ,'Chakalaka value') ;

% Hint: get(hObject,'Value') returns toggle state of CheckCamLight


% --- Executes on button press in PushGotoSleep.
function PushGotoSleep_Callback(hObject, eventdata, handles)
% hObject    handle to PushGotoSleep (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global DataType 
InSleep = ~isequal(lower(get(handles.PushGotoSleep,'String')),'sleep') ; 
if InSleep 
    
    [~,RetStr]  = SendObj( [hex2dec('2220'),72] , 1234 , DataType.long ,'Wakeup') ;
    if ( ~isempty(RetStr ) ) 
        uiwait(errordlg(RetStr, 'Error in wakeup')) ; 
    end
else
    SendObj( [hex2dec('2220'),73] , 1234 , DataType.long ,'goto sleep') ;
end



% --- Executes on button press in PushSensorTest.
function PushSensorTest_Callback(hObject, eventdata, handles)
% hObject    handle to PushSensorTest (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global TmMgrT 
cnt = get( handles.PushSensorTest,'Value') ; 
if cnt 
    TmMgrT.SetCounter('TESTSW',500 ) ; 
    bup = handles.TmrFunctionActive ; 
    handles.TmrFunctionActive = 0 ; 
    guidata(hObject, handles);
    evalin('base','TestSw') ; 
    handles.TmrFunctionActive = bup ; 
    guidata(hObject, handles);
    set( handles.PushSensorTest , 'String','Close sensor ind.') ; 
else
    TmMgrT.SetCounter('TESTSW',-1e6) ; 
    set( handles.PushSensorTest , 'String','Open sensor ind.') ; 
end 




% --- Executes on button press in PushRescueDlg.
function PushRescueDlg_Callback(hObject, eventdata, handles)
% hObject    handle to PushRescueDlg (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global TmMgrT 
cnt = get( handles.PushRescueDlg,'Value') ; 
if cnt 
    TmMgrT.SetCounter('RESCUE',500 ) ; 
    bup = handles.TmrFunctionActive ; 
    handles.TmrFunctionActive = 0 ;
    guidata(hObject, handles);

    try 
    evalin('base','Rescue') ; 
    catch 
    end 

    handles.TmrFunctionActive = bup ;
    guidata(hObject, handles);

    set( handles.PushRescueDlg , 'String','Close Rescue Dialog') ; 
else
    TmMgrT.SetCounter('RESCUE',-1e6) ; 
    set( handles.PushRescueDlg , 'String','Open Rescue Dialog') ; 
end 


% --- Executes on button press in PushPackDlg.
function PushPackDlg_Callback(hObject, eventdata, handles)
% hObject    handle to PushPackDlg (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global TmMgrT 
global DataType 
global RecStruct
cnt = get( handles.PushPackDlg,'Value') ; 

if (handles.ManipStyle == handles.ManipStyleList.Flex_Manipulator) 
    uiwait( msgbox('Flex Manipulator is not yet supported')) ; 
    return ; 
end

if ~(handles.ManipStyle == handles.ManipStyleList.SCARA_Manipulator)
    uiwait( msgbox('Manipulator is not configured; use RobotCfg to configure Scara')) ; 
    return ; 
end

if  ~( handles.RobotCfg.WheelArmType == RecStruct.Enums.WheelArmType.Rigid) 
    WarmState = handles.s.Bit.WarmState ;%  FetchObj( [hex2dec('220b'),23] , DataType.long ,'Wheel arm state') ;
    good = 0 ; 
    switch WarmState
        case RecStruct.Enums.WheelArmStates.E_GroundGood2Go
            good = 1 ; 
        case RecStruct.Enums.WheelArmStates.E_RExtendGood2Go
            good = 1 ; 
        case RecStruct.Enums.WheelArmStates.E_LExtendGood2Go
            good = 1 ; 
    end
    if ~good
        uiwait( msgbox({'Wheelarm must be secured to place', 'for package actions to work'})) ; 
        return ; 
    end
end 

if cnt 
    TmMgrT.SetCounter('PACKAGE',500 ) ; 
    bup = handles.TmrFunctionActive ; 
    handles.TmrFunctionActive = 0 ; 
    guidata(hObject, handles);
    evalin('base','Package') ; 

    handles.TmrFunctionActive = bup ; 
    guidata(hObject, handles);
    set( handles.PushPackDlg , 'String','Close Package Dialog') ; 
else
    TmMgrT.SetCounter('PACKAGE',-1e6) ; 
    set( handles.PushPackDlg , 'String','Open Package Dialog') ; 
end 

% --- Executes on button press in PushCalibNeck.
function PushCalibNeck_Callback(hObject, eventdata, handles)
% hObject    handle to PushCalibNeck (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global TmMgrT 
cnt = get( handles.PushCalibNeck,'Value') ; 
if cnt 
    TmMgrT.SetCounter('CAL_NECK',500 ) ; 
    bup = handles.TmrFunctionActive ; 
    handles.TmrFunctionActive = 0 ; 
    guidata(hObject, handles);

    evalin('base','CalibNeck') ; 

    handles.TmrFunctionActive = bup ; 
    guidata(hObject, handles);
    
    set( handles.PushCalibNeck , 'String','Close Calib Neck_IMU Dlg') ; 
else
    TmMgrT.SetCounter('CAL_NECK',-1e6) ; 
    set( handles.PushCalibNeck , 'String','Open Calib Neck_IMU Dlg') ; 
end 


% --- Executes on button press in PushCalibSteer.
function PushCalibSteer_Callback(hObject, eventdata, handles)
% hObject    handle to PushCalibSteer (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global TmMgrT 
cnt = get( handles.PushCalibSteer,'Value') ; 
if cnt 
    TmMgrT.SetCounter('CAL_STEER',500 ) ; 
    bup = handles.TmrFunctionActive ; 
    handles.TmrFunctionActive = 0 ; 
    guidata(hObject, handles);

    evalin('base','CalibSteer') ; 
    handles.TmrFunctionActive = bup ; 
    guidata(hObject, handles);
    
    set( handles.PushCalibSteer , 'String','Close Calib Steer Dlg') ; 
else
    TmMgrT.SetCounter('CAL_STEER',-1e6) ; 
    set( handles.PushCalibSteer , 'String','Open Calib Steer Dlg') ; 
end 


% --- Executes on button press in PushGndTravel.
function PushGndTravel_Callback(hObject, eventdata, handles)
% hObject    handle to PushGndTravel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of PushGndTravel
global TmMgrT 
cnt = get( handles.PushGndTravel,'Value') ; 
if cnt 
    TmMgrT.SetCounter('GND_TRAVEL',500 ) ; 
    bup = handles.TmrFunctionActive ; 
    handles.TmrFunctionActive = 0 ; 
    guidata(hObject, handles);

    evalin('base','GoRoute') ; 

    handles.TmrFunctionActive = bup ; 
    guidata(hObject, handles);

    set( handles.PushGndTravel , 'String','Close Ground Nav Dlg') ; 
else
    TmMgrT.SetCounter('GND_TRAVEL',-1e6) ; 
    set( handles.PushGndTravel , 'String','Open Ground Nav Dlg') ; 
end 

% --- Executes during object deletion, before destroying properties.
function figure1_DeleteFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
try
delete( handles.EvtObj) ;
catch
end

% --- Executes during object deletion, before destroying properties.
function uipanel22_DeleteFcn(hObject, eventdata, handles)
% hObject    handle to uipanel22 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in togglePackageErrLog.
function togglePackageErrLog_Callback(hObject, eventdata, handles)
% hObject    handle to togglePackageErrLog (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of togglePackageErrLog
PackErrHistory



% --- Executes on button press in RadioShOn.
function RadioShOn_Callback(hObject, eventdata, handles)
% hObject    handle to RadioShOn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of RadioShOn


% --- Executes on button press in RadioElOn.
function RadioElOn_Callback(hObject, eventdata, handles)
% hObject    handle to RadioElOn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of RadioElOn


% --- Executes on button press in RadioWrOn.
function RadioWrOn_Callback(hObject, eventdata, handles)
% hObject    handle to RadioWrOn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of RadioWrOn


% --- Executes on button press in RadioRON.
function RadioRON_Callback(hObject, eventdata, handles)
% hObject    handle to RadioRON (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of RadioRON


% --- Executes on button press in RadioLOn.
function RadioLOn_Callback(hObject, eventdata, handles)
% hObject    handle to RadioLOn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of RadioLOn


% --- Executes during object creation, after setting all properties.
function CheckboxLeftBrakeRelease_CreateFcn(hObject, eventdata, handles)
% hObject    handle to CheckboxLeftBrakeRelease (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes during object creation, after setting all properties.
function PushApplySetPoint_CreateFcn(hObject, eventdata, handles)
% hObject    handle to PushApplySetPoint (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes during object creation, after setting all properties.
function PushResetLPOnly_CreateFcn(hObject, eventdata, handles)
% hObject    handle to PushResetLPOnly (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- If Enable == 'on', executes on mouse press in 5 pixel border.
% --- Otherwise, executes on mouse press in 5 pixel border or over EditDyn24Stat.
function EditDyn24Stat_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to EditDyn24Stat (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in toggleCalibLaser.
function toggleCalibLaser_Callback(hObject, eventdata, handles)
% hObject    handle to toggleCalibLaser (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global TmMgrT 
cnt = get( handles.toggleCalibLaser,'Value') ; 
if cnt 
    TmMgrT.SetCounter('CAL_LASER',500 ) ; 

    bup = handles.TmrFunctionActive ; 
    handles.TmrFunctionActive = 0 ; 
    guidata(hObject, handles);


    evalin('base','CalibLaser') ; 

    handles.TmrFunctionActive = bup ; 
    guidata(hObject, handles);

    set( handles.toggleCalibLaser , 'String','Close Calib Laser') ; 
else
    TmMgrT.SetCounter('CAL_LASER',-1e6) ; 
    set( handles.toggleCalibLaser , 'String','Open Calib Laser') ; 
end 


% --- Executes on button press in toggleCalibTray.
function toggleCalibTray_Callback(hObject, eventdata, handles)
% hObject    handle to toggleCalibTray (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global TmMgrT 
if ( handles.ManipStyle ~= 1 ) 
    uiwait( errordlg({'Manipulator type should beconfigured ','to SCARA for tray calib to work'}) ) ; 
    set( handles.toggleCalibTray,'Value',0) ; 
    return ; 
end
cnt = get( handles.toggleCalibTray,'Value') ; 
if cnt 
    TmMgrT.SetCounter('CAL_TRAY',500 ) ; 

    bup = handles.TmrFunctionActive ; 
    handles.TmrFunctionActive = 0 ; 
    guidata(hObject, handles);
    
    evalin('base','CalibTray') ; 

    handles.TmrFunctionActive = bup ; 
    guidata(hObject, handles);
    
    set( handles.toggleCalibTray , 'String','Close Calib Tray') ; 
else
    TmMgrT.SetCounter('CAL_TRAY',-1e6) ; 
    set( handles.toggleCalibTray , 'String','Open Calib Tray') ; 
end 


% --- Executes on button press in PushCalibMan.
function PushCalibMan_Callback(hObject, eventdata, handles)
% hObject    handle to PushCalibMan (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of PushCalibMan
global TmMgrT 
cnt = get( handles.PushCalibMan,'Value') ; 


if cnt 
    TmMgrT.SetCounter('CAL_MAN',500 ) ;

    bup = handles.TmrFunctionActive ; 
    handles.TmrFunctionActive = 0 ; 
    guidata(hObject, handles);
    
    switch handles.ManipStyle
        case handles.ManipStyleList.SCARA_Manipulator 
            evalin('base','CalibMan') ; 
        case handles.ManipStyleList.Flex_Manipulator 
            evalin('base','FlexDash') ;   
        otherwise 
            evalin('base','CalibMan') ; 
    end

    handles.TmrFunctionActive = bup ; 
    guidata(hObject, handles);
    
    set( handles.PushCalibMan , 'String','Close Calib Man') ; 
else
    TmMgrT.SetCounter('CAL_MAN',-1e6) ; 
    set( handles.PushCalibMan , 'String','Open Calib Man') ; 
end 


% --- Executes on button press in ButtonWheelArm.
function ButtonWheelArm_Callback(hObject, eventdata, handles)
% hObject    handle to ButtonWheelArm (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global TmMgrT 
global RecStruct
 
if isequal(handles.RobotCfg.WheelArmType,RecStruct.Enums.WheelArmType.Rigid) 
    set( handles.ButtonWheelArm,'Value',0) ; 
    uiwait( msgbox({'\fontsize{12} This robot has no wheelarm','If it has, go to RobotCfg to configure '},'Error',handles.CreateStruct) ) ; 
    
end 

cnt = get( handles.ButtonWheelArm,'Value') ; 
if cnt 
    TmMgrT.SetCounter('TEST_WARM',500 ) ; 
    bup = handles.TmrFunctionActive ; 
    handles.TmrFunctionActive = 0 ; 
    guidata(hObject, handles);
    
    evalin('base','WheelArm') ;

    handles.TmrFunctionActive = bup ;
    guidata(hObject, handles);
    
    set( handles.ButtonWheelArm , 'String','Close wheel arm') ; 
else
    TmMgrT.SetCounter('TEST_WARM',-1e6) ; 
    set( handles.ButtonWheelArm , 'String','Open wheel arm') ; 
end 


% --- Executes on button press in PushReleaseHold.
function PushReleaseHold_Callback(hObject, eventdata, handles)
% hObject    handle to PushReleaseHold (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global DataType ; 
SendObj( [hex2dec('2222'),20] , 0 , DataType.long , 'Go On to the next state ') ; 



function EditHoldState_Callback(hObject, eventdata, handles)
% hObject    handle to EditHoldState (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of EditHoldState as text
%        str2double(get(hObject,'String')) returns contents of EditHoldState as a double


% --- Executes during object creation, after setting all properties.
function EditHoldState_CreateFcn(hObject, eventdata, handles)
% hObject    handle to EditHoldState (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in PushHoldEnable.
function PushHoldEnable_Callback(~, ~, handles)
% hObject    handle to PushHoldEnable (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global DataType ; 
if ( handles.s.Bit.DebugHoldEnabled ) 
SendObj( [hex2dec('2222'),23] , 0, DataType.long , 'Go On to the next state ') ; 
else
SendObj( [hex2dec('2222'),23] , 1, DataType.long , 'Go On to the next state ') ; 
end    



% --- Executes on button press in CheckCrab.
function CheckCrab_Callback(hObject, eventdata, handles)
% hObject    handle to CheckCrab (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of CheckCrab
global DataType %#ok<GVMIS> 
val = get( handles.CheckCrab,'Value') ; 
s = handles.s ; 
NeckPos = s.base.NOuterPos * 180 / pi ; 

if ( val )
    pref = questdlg('Set crab direction', ...
                             'Decision for wheel speed direction', ...
                             'Right', 'Left','Abort', 'Abort');    
    if isequal(pref,'Abort') 
        return ; 
    end 

    if isequal(pref,'Right') 
        if NeckPos < 0 
            pref = questdlg({'By neck angle you should crab left','Are you sure?'}, ...
                         'Decision for wheel speed direction', ...
                         'Yes', 'Abort', 'Abort');
            if isequal(pref,'Abort') 
                return ; 
            end 
        end
        SendObj( [hex2dec('2222'),28] , 15 * pi / 180  , DataType.float , 'Set to CRAB' ) ;
    else
        if NeckPos > 0 
            pref = questdlg({'By neck angle you should crab Right','Are you sure?'}, ...
                         'Decision for wheel speed direction', ...
                         'Yes', 'Abort', 'Abort');
            if isequal(pref,'Abort') 
                return ; 
            end 
        end
        SendObj( [hex2dec('2222'),29] , 15 * pi / 180  , DataType.float , 'Set to CRAB' ) ;
    end
else
    SendObj( [hex2dec('2222'),27] , 200 * pi / 180  , DataType.float , 'Undo CRAB' ) ;
end 


% --- Executes on button press in CheckRLimit.
function CheckRLimit_Callback(hObject, eventdata, handles)
% hObject    handle to CheckRLimit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of CheckRLimit


% --- Executes on button press in CheckLLimit.
function CheckLLimit_Callback(hObject, eventdata, handles)
% hObject    handle to CheckLLimit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of CheckLLimit



function EditRValidCnt_Callback(hObject, eventdata, handles)
% hObject    handle to EditRValidCnt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of EditRValidCnt as text
%        str2double(get(hObject,'String')) returns contents of EditRValidCnt as a double


% --- Executes during object creation, after setting all properties.
function EditRValidCnt_CreateFcn(hObject, eventdata, handles)
% hObject    handle to EditRValidCnt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function EditLValidCnt_Callback(hObject, eventdata, handles)
% hObject    handle to EditLValidCnt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of EditLValidCnt as text
%        str2double(get(hObject,'String')) returns contents of EditLValidCnt as a double


% --- Executes during object creation, after setting all properties.
function EditLValidCnt_CreateFcn(hObject, eventdata, handles)
% hObject    handle to EditLValidCnt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in PushCommSetup.
function PushCommSetup_Callback(hObject, eventdata, handles)
% hObject    handle to PushCommSetup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
bup = handles.TmrFunctionActive ; 
handles.TmrFunctionActive = 0 ; 
guidata(hObject, handles);
try 
    CommSetup() ; 
catch 
end 
handles.TmrFunctionActive = bup ; 
guidata(hObject, handles);




% --- Executes on button press in PushApplyGnd.
function PushApplyGnd_Callback(~, ~, handles)
% hObject    handle to PushApplyGnd (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global DataType %#ok<GVMIS> 

% Steering tracking management
if get(handles.CheckSteeringTracking,'value')
    SendObj( [hex2dec('2220'),130] , 1  , DataType.long , 'Wheel track steering' ) ;
else
    SendObj( [hex2dec('2220'),130] ,0  , DataType.long , 'Wheel untrack steering' ) ;
end

SendObj( [hex2dec('2206'),21] , handles.ManualRSpeedCmd  , DataType.float , 'Speed command RWheel' ) ;
SendObj( [hex2dec('2206'),22] , handles.ManualLSpeedCmd   , DataType.float , 'Speed command LWheel' ) ;
SendObj( [hex2dec('2206'),13] , handles.ManualRSteerCmd * pi / 180  , DataType.float , 'Pos command RSteer' ) ;
SendObj( [hex2dec('2206'),14] , handles.ManualLSteerCmd * pi / 180  , DataType.float , 'Pos command LSteer' ) ;
SendObj( [hex2dec('2206'),15] , handles.ManualNeckCmd * pi / 180  , DataType.float , 'Pos command Neck' ) ;
SendObj( [hex2dec('2228'),17] , double(get(handles.checkboxBalanceLoads,'Value'))  , DataType.long , 'SysState.Debug.bBalanceWheelLoadsOnManual' ) ;


% --- Executes on button press in PushResetError.
function PushResetError_Callback(hObject, eventdata, handles)
% hObject    handle to PushResetError (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global DataType %#ok<GVMIS> 
SendObj( [hex2dec('220b'),3] , 1 , DataType.long , 'Reset drives' ) ;


% --- Executes on button press in ToggleReleaseNK.
function ToggleReleaseNK_Callback(hObject, eventdata, handles)
% hObject    handle to ToggleReleaseNK (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of ToggleReleaseNK


% --- Executes on button press in togglebutton9.
function togglebutton9_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of togglebutton9


% --- Executes on button press in ToggleReleaseRW.
function ToggleReleaseRW_Callback(hObject, eventdata, handles)
% hObject    handle to ToggleReleaseRW (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of ToggleReleaseRW


% --- Executes on button press in ToggleReleaseLW.
function ToggleReleaseLW_Callback(hObject, eventdata, handles)
% hObject    handle to ToggleReleaseLW (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of ToggleReleaseLW


% --- Executes on button press in ToggleReleaseTA.
function ToggleReleaseTA_Callback(hObject, eventdata, handles)
% hObject    handle to ToggleReleaseTA (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of ToggleReleaseTA


% --- Executes on button press in PushBrakeDlg.
function PushBrakeDlg_Callback(hObject, eventdata, handles)
% hObject    handle to PushBrakeDlg (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of PushBrakeDlg
global TmMgrT 
cnt = get( handles.PushBrakeDlg,'Value') ; 
if cnt 
    TmMgrT.SetCounter('BRAKES',500 ) ; 
    bup = handles.TmrFunctionActive ; 
    handles.TmrFunctionActive = 0 ; 
    guidata(hObject, handles);

    try 
    evalin('base','Brakes') ; 
    catch 
    end 

    handles.TmrFunctionActive = bup ; 
    guidata(hObject, handles);
    
    set( handles.PushBrakeDlg , 'String','Close Brake Dlg') ; 
else
    TmMgrT.SetCounter('BRAKES',-1e6) ; 
    set( handles.PushBrakeDlg , 'String','Open Brake Dlg') ; 
end 


% --- Executes on button press in CheckSteeringTracking.
function CheckSteeringTracking_Callback(hObject, eventdata, handles)
% hObject    handle to CheckSteeringTracking (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of CheckSteeringTracking


% --- Executes on button press in checkboxSeparateWheels.
function checkboxSeparateWheels_Callback(hObject, eventdata, handles)
% hObject    handle to checkboxSeparateWheels (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkboxSeparateWheels


% --- Executes on button press in checkboxBalanceLoads.
function checkboxBalanceLoads_Callback(hObject, eventdata, handles)
% hObject    handle to checkboxBalanceLoads (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkboxBalanceLoads

DataType = GetDataType(); 
checkOn = double( get(hObject,'Value')) ; 
if ( checkOn ) 
    % Set the motion mode to per-axis 
    PushLoadActSetPoint_Callback(hObject, [] , handles);
    PushApplyGnd_Callback([], [], handles);
    set( handles.checkboxSeparateWheels,'Value',0)  ; % If load is balanced, wheel separation is not an option
end
% Then set to compensation mode
SendObj( [hex2dec('2228'),17] , checkOn , DataType.short  ,'set torque correction') ;


% --- Executes on button press in pushbutton73.
function pushbutton73_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton73 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton74.
function pushbutton74_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton74 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton75.
function pushbutton75_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton75 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton76.
function pushbutton76_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton76 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton77.
function pushbutton77_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton77 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in checkboxRReleaseBrake.
function checkboxRReleaseBrake_Callback(hObject, eventdata, handles)
% hObject    handle to checkboxRReleaseBrake (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkboxRReleaseBrake



function edit22_Callback(hObject, eventdata, handles)
% hObject    handle to edit22 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit22 as text
%        str2double(get(hObject,'String')) returns contents of edit22 as a double


% --- Executes during object creation, after setting all properties.
function edit22_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit22 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit23_Callback(hObject, eventdata, handles)
% hObject    handle to edit23 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit23 as text
%        str2double(get(hObject,'String')) returns contents of edit23 as a double


% --- Executes during object creation, after setting all properties.
function edit23_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit23 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit24_Callback(hObject, eventdata, handles)
% hObject    handle to edit24 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit24 as text
%        str2double(get(hObject,'String')) returns contents of edit24 as a double


% --- Executes during object creation, after setting all properties.
function edit24_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit24 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in checkbox61.
function checkbox61_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox61 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox61


% --- Executes on button press in pushbutton78.
function pushbutton78_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton78 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in checkbox62.
function checkbox62_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox62 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox62


% --- Executes on button press in checkbox63.
function checkbox63_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox63 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox63


% --- Executes on button press in checkbox64.
function checkbox64_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox64 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox64



function edit25_Callback(hObject, eventdata, handles)
% hObject    handle to edit25 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit25 as text
%        str2double(get(hObject,'String')) returns contents of edit25 as a double


% --- Executes during object creation, after setting all properties.
function edit25_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit25 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit26_Callback(hObject, eventdata, handles)
% hObject    handle to edit26 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit26 as text
%        str2double(get(hObject,'String')) returns contents of edit26 as a double


% --- Executes during object creation, after setting all properties.
function edit26_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit26 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in checkboxManualBrakeControl.
function checkboxManualBrakeControl_Callback(hObject, eventdata, handles)
% hObject    handle to checkboxManualBrakeControl (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkboxManualBrakeControl
