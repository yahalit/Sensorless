function varargout = CalibFlex(varargin)
% CALIBFLEX MATLAB code for CalibFlex.fig
%      CALIBFLEX, by itself, creates a new CALIBFLEX or raises the existing
%      singleton*.
%
%      H = CALIBFLEX returns the handle to a new CALIBFLEX or the handle to
%      the existing singleton*.
%
%      CALIBFLEX('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in CALIBFLEX.M with the given input arguments.
%
%      CALIBFLEX('Property','Value',...) creates a new CALIBFLEX or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before CalibFlex_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to CalibFlex_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help CalibFlex

% Last Modified by GUIDE v2.5 26-Apr-2023 11:03:13

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @CalibFlex_OpeningFcn, ...
                   'gui_OutputFcn',  @CalibFlex_OutputFcn, ...
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

function SetMotorsOff( handles,mask) 
global DataType 
global TargetCanId2
if nargin < 2
    mask = hex2dec('1234') ; 
end 
SendObj( [hex2dec('2103'),7,TargetCanId2] , mask , DataType.long , 'Set manipulator to individual motoר mode: motor off ' ) ;
set( handles.ButtonMotorOn ,'String' , 'Motor On' )  ;  
   
function SetMotorsOn( handles  , mask  ) 
global DataType 
global TargetCanId2
if nargin < 2
    mask = hex2dec('1234') ; 
end 

SendObj( [hex2dec('2103'),6,TargetCanId2] , mask , DataType.long , 'Set manipulator on' ) ;
set( handles.ButtonMotorOn ,'String' , 'Motor Off' )  ;  
    
% --- Executes just before CalibFlex is made visible.
function CalibFlex_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to CalibFlex (see VARARGIN)

% Choose default command line output for CalibFlex
handles.output = hObject;
global DataType %#ok<NUSED>
global TargetCanId %#ok<NUSED>
global PdCalibFields  %#ok<NUSED>
global CalibTable2 

AtpStart ; 

[~,handles.FlexPlateRatio] = GetSignal( 'FlexPlateRatio' , '2' );
[~,handles.RotaryPotAngle] = GetSignal( 'RotaryPotAngle' , '2' );


handles.UpdateDisplayActive = 1 ; 
handles.CalibratingPlate = 0 ; 
handles.CalibratingDoor = 0 ; 
handles.PushActionDone = 0 ; 
handles.FlexHome = 0 ; 
handles.RotaryHomeDeg = 0 ; 
handles.FlexHomeDeg = 0 ; 

handles.CreateStruct =  struct('Interpreter','tex','WindowStyle' , 'modal') ; 

% set ( handles.editRotaryHome ,'String' ,num2str(handles.RotaryHomeDeg) ) ; 
set ( handles.editFlexHome ,'String' ,num2str(handles.FlexHomeDeg) ) ; 

handles.FlexNominalOffsetCnt =  FetchObj( [hex2dec('2103'),17,TargetCanId2] , DataType.long , 'FlexNominalOffsetCnt' ) ;
handles.DoorNominalOffsetCnt =  FetchObj( [hex2dec('2103'),47,TargetCanId2] , DataType.long , 'DoorNominalOffsetCnt' ) ;
handles.RotaryNominalOffsetCnt =  FetchObj( [hex2dec('2103'),57,TargetCanId2] , DataType.long , 'RotaryNominalOffsetCnt' ) ;
handles.FlexPosScale =  FetchObj( [hex2dec('2103'),18,TargetCanId2] , DataType.float , 'FlexPosScale' ) ;
handles.DoorPosScale =  FetchObj( [hex2dec('2103'),48,TargetCanId2] , DataType.float , 'DoorPosScale' ) ;
handles.RotaryPosScale =  FetchObj( [hex2dec('2103'),58,TargetCanId2] , DataType.float , 'RotaryPosScale' ) ;
handles.EdataOnZero = [] ; 

handles.hObject = hObject ; 
guidata(hObject, handles);

set( handles.PushForComplete,'Visible','Off') ; 
set( handles.TextPleaseDo,'Visible','Off') ;
set( handles.PushSaveFlash,'Visible','Off') ;

% Set the motors to off 
SetMotorsOff (  handles)  ;

% Bring the flashed calibration 
% handles.CalibInit = SaveCalibManCpu2 ( []  ) ; 
CalibNames = cell(1,length(CalibTable2) ) ; 
nCalibPars = length(CalibNames); 
for cnt = 1:nCalibPars
    next = CalibTable2{cnt} ; 
    CalibNames{cnt} = next{2}; 
end 
handles.CalibNames = CalibNames ; 

handles.InitPosTarget = 1 ;
guidata(hObject, handles);
update_screen(handles) ; 

global DispT
if ~exist('DispT','var') || ~isa(DispT,'DlgTimerObj')
    evalin('base','AtpStart') ; 
end 
handles.EvtObj = DlgUserObj(@update_flex_display,hObject);
handles.EvtObj.listenToTimer(DispT) ;   


% handles.timer = timer(...
%     'ExecutionMode', 'fixedSpacing', ...       % Run timer repeatedly.
%     'StartDelay',0.4, ... %    'Period', 0.4, ...                        % Initial period is 1 sec.
%     'TimerFcn', {@update_flex_display,hObject}); % Specify callback function.% Update handles structure
guidata(hObject, handles);
% start (handles.timer) ;

handles.CalibInit = SaveCalibManCpu2([]);
set( handles.TextCalibDate,'String', num2str(handles.CalibInit.CalibDate ) ) ; 
set( handles.TextCalibrationID,'String', num2str(handles.CalibInit.CalibData)) ; 

% Update handles structure
guidata(hObject, handles);


function pword = GetSFPass() 
    global CalibTable2
    nCalibPars = length(CalibTable2); 
    pword = hex2dec('12345600') + nCalibPars ; 


function ind = GetCalibIndex(table,name) 
    ind = find( strcmp(name,table),1 ) ;  
 

% UIWAIT makes CalibFlex wait for user response (see UIRESUME)
% uiwait(handles.figure1);
function update_flex_display( hobj) 
    global TmMgrT
    handles = guidata(hobj) ; 

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

% 
% 
%     handles = guidata(varargin{3}) ; 
%     try
%     update_screen(handles) ; 
%     catch 
%     end
    %start (handles.timer) ;

function Edata = GetExtData() 
global DataType
global TargetCanId2 

    FlexCnt =  FetchObj( [hex2dec('2103'),12,TargetCanId2] , DataType.long , 'Flex cnt' ) ;
    FlexMeter =  FetchObj( [hex2dec('2103'),13,TargetCanId2] , DataType.long , 'Flex rad' ) / 1000 ;
    
    DoorCnt =  FetchObj( [hex2dec('2103'),42,TargetCanId2] , DataType.long , 'Door cnt' ) ;
    DoorRad =  FetchObj( [hex2dec('2103'),43,TargetCanId2] , DataType.long , 'Door rad' ) / 1000 ;
            
    RotaryCnt =  FetchObj( [hex2dec('2103'),52,TargetCanId2] , DataType.long , 'Rotary cnt' ) ;
    RotaryRad =  FetchObj( [hex2dec('2103'),53,TargetCanId2] , DataType.long , 'Rotary rad' ) / 1000 ;

    MotorOnInfo =  FetchObj( [hex2dec('2103'),5,TargetCanId2] , DataType.long , 'Motor On Info' )  ;
             

Edata = struct ( 'FlexCnt' , FlexCnt ,'FlexMeter',FlexMeter, ...
    'RotaryCnt' , RotaryCnt ,'RotaryRad',RotaryRad , ... 
    'DoorCnt' , DoorCnt ,'DoorRad',DoorRad ,'MotorOnInfo' , MotorOnInfo ) ; 
     
    
function update_screen(handles)    
    if  ~isfield(handles,'UpdateDisplayActive') || ~handles.UpdateDisplayActive 
        return ; 
    end 
    

    Edata = GetExtData() ; 
    
    set(handles.TextFlexDeg,'String',num2str(Edata.FlexMeter) ) ;
    set(handles.TextRotaryDeg,'String',num2str(Edata.RotaryRad * 180 / pi) ) ;
    set(handles.TextDoorDeg,'String',num2str(Edata.DoorRad * 180 / pi) ) ;
    
    set(handles.TextFlexCnt,'String',num2str(Edata.FlexCnt ) ) ;
    set(handles.TextRotaryCnt,'String',num2str(Edata.RotaryCnt) ) ;
    set(handles.TextDoorCnt,'String',num2str(Edata.DoorCnt) ) ;

    Edata.FlexPlateRatio = GetSignal( handles.FlexPlateRatio , '2' );
    set(handles.TextPotRatio,'String',num2str(Edata.FlexPlateRatio) ) ; 

    if ( handles.InitPosTarget ) 
        handles.FlexTarget = Edata.FlexMeter; 
        handles.DoorTargetDeg = Edata.DoorRad  * 180 / pi ; 
        handles.RotaryTargetDeg = Edata.RotaryRad * 180 / pi ; 
        set(handles.EditFlexTarget,'String',num2str(handles.FlexTarget ) ) ;
        set(handles.EditDoorTarget,'String',num2str(handles.DoorTargetDeg ) ) ;
        set(handles.EditRotaryTarget,'String',num2str(handles.RotaryTargetDeg ) ) ;
        set(handles.CheckFlexRelative,'Value',0) ; 
        set(handles.CheckRotaryRelative,'Value',0) ; 
        handles.InitPosTarget = 0 ; 
    end 
    
    % Decide by motor ON if GO buttons are visible 
    handles.FlexMotorOn = bitand( Edata.MotorOnInfo, 1) ;     
    handles.DoorMotorOn = bitand( Edata.MotorOnInfo , 2^16) / 2^16  ; 
    handles.RotaryMotorOn = bitand( Edata.MotorOnInfo, 2^17 ) / 2^17 ; 
    
    if ( handles.FlexMotorOn ) 
        set(handles.ButtonMotorOn,'String','Set Motor Off','BackgroundColor',[0,1,0],'ForegroundColor',[0,0,0]) ; 
        set(handles.ButtonFlexGo,'Visible','on') ; 
    else
        set(handles.ButtonMotorOn,'String','Set Motor On','BackgroundColor',[0,0,1],'ForegroundColor',[1,1,1]) ; 
        set(handles.ButtonFlexGo,'Visible','off') ; 
    end 
    if ( handles.DoorMotorOn ) 
        set(handles.ToggleDoorMotorOn,'String','Set Motor Off','BackgroundColor',[0,1,0],'ForegroundColor',[0,0,0]) ; 
        set(handles.ButtonDoorGo,'Visible','on') ; 
    else
        set(handles.ToggleDoorMotorOn,'String','Set Motor On','BackgroundColor',[0,0,1],'ForegroundColor',[1,1,1]) ; 
        set(handles.ButtonDoorGo,'Visible','off') ; 
    end 
    if ( handles.RotaryMotorOn ) 
        set(handles.ButtonRotaryGo,'Visible','on') ; 
        set(handles.PushPlateMotorOn,'String','Set Motor Off','BackgroundColor',[0,1,0],'ForegroundColor',[0,0,0]) ; 
    else
        set(handles.ButtonRotaryGo,'Visible','off') ; 
        set(handles.PushPlateMotorOn,'String','Set Motor On','BackgroundColor',[0,0,1],'ForegroundColor',[1,1,1]) ; 
    end 
    
    handles.Edata = Edata ; 

    if ( handles.CalibratingDoor )
        handles = CalibDoorManager(handles); 
    end
    if ( handles.CalibratingPlate )
        handles = CalibPlateManager(handles); 
    end

    guidata(handles.hObject, handles);


function out = AvgSignalCpu2(handles,name,n)
    if nargin < 3 
        n = 5 ; 
    end 

    n = fix(n) ; 
    n = min( max( n ,1 ) , 1000 ); 
    sum = 0 ; 
    for cnt = 1:n 
        set( handles.TextPleaseDo, 'String' ,{'Averaging signal:',['name : ',num2str(cnt)]} ) ; 
        sum = sum + GetSignal(name,'2'); 
    end 
    out = sum / n ; 


function handles = CalibDoorManager(handles)
    global DataType %#ok<*GVMIS> 
    global RecStruct
    global TargetCanId2 
    if handles.PushActionDone
        switch ( handles.CalibratingDoor  )
            case 1
                % Calibration starts, nothing yet done. 1st stage is to
                % motor the door up 
                    SendObj( [hex2dec('2103'),98,TargetCanId2] , hex2dec('1231') , DataType.long , 'Prep torque mode' ) ;                    
                    handles.CalibratingDoor = 100 ; 
                    set( handles.PushForComplete,'Visible','Off','String','Next') ;
%             case 2   
%                     handles.CalibratingDoor = 3 ; 
                    % Set the manipulator motors to off 
                    
            case 3
                %   User pressed next confirming an up door , ask to go down 
                    handles.CalibratingDoor = 4 ; 
                    handles.FlexDoorTopLimit = round(AvgSignalCpu2(handles,'Dyn12PosCnt0')) ;
                    set( handles.TextPleaseDo, 'String' ,{'Press Next for bottom limit','Door will jump down'} ) ; 
                    set( handles.PushForComplete,'Visible','On','String','Next') ;
            case 4 
                    handles.CalibratingDoor = 5 ; 
                    SendObj( [hex2dec('2103'),99,TargetCanId2] , -0.8 , DataType.float , 'Set motor torque' ) ;                    

                    set( handles.TextPleaseDo, 'String' ,{'Verify door in bottom limit','Press Next to confirm'} ) ; 
                    set( handles.PushForComplete,'Visible','On','String','Next') ;
            case 5 
                    handles.CalibratingDoor = 6 ;
                    handles.FlexDoorBottomLimit = round(AvgSignalCpu2(handles,'Dyn12PosCnt0')) ;
                    SetMotorsOff(handles) ; 
                    SendObj( [hex2dec('2103'),98,TargetCanId2] , hex2dec('1232') , DataType.long , 'Prep position mode' ) ;                    

                    set( handles.TextPleaseDo, 'String' ,{'Motor is now off','Bring the door manually to ZERO','Press Next to confirm'} ) ; 
                    set( handles.PushForComplete,'Visible','On','String','Next') ;
            case 6
               
                    handles.FlexDoorZero  = round(AvgSignalCpu2(handles,'Dyn12PosCnt0')) ;

                    x = struct('FlexDoorZero',handles.FlexDoorZero,'FlexDoorTopLimit',handles.FlexDoorTopLimit,'FlexDoorBottomLimit',handles.FlexDoorBottomLimit) ; 
                    save CalibDoorRslts.mat x 
                    thtOffset = fix( 78.24 / 360 * 4096) ; 

                    [good,errstr] = AnaFlexDoorCalib(x) ; 

                    if good 
                        ButtonName = questdlg('Do you want to update/flash the result:?','Question','Yes', 'No', 'No');
                        if isequal(ButtonName,'Yes') 
                            SendObj( [hex2dec('2303'),1,TargetCanId2] ,GetSFPass() , DataType.long  , 'Set parameters password' ) ;
                            SendObj( [hex2dec('2303'),251,TargetCanId2] ,0 , DataType.long  , 'Update calibration parameters from flash' ) ;
                            SendObj( [hex2dec('2303'),GetCalibIndex('FlexDoorCenter',handles.CalibNames),TargetCanId2] , handles.FlexDoorZero + thtOffset , DataType.long  , 'Set FlexRotaryCenter' ) ;
                            % 45 counts is approximately 4 motor degrees 
                            SendObj( [hex2dec('2303'),GetCalibIndex('FlexDoorTopEndTravel',handles.CalibNames),TargetCanId2] , handles.FlexDoorTopLimit  - 45 , DataType.long  , 'Set FlexRotaryCenter' ) ;
                            SendObj( [hex2dec('2303'),GetCalibIndex('FlexDoorBotEndTravel',handles.CalibNames),TargetCanId2] , handles.FlexDoorBottomLimit +  45 , DataType.long  , 'Set FlexRotaryCenter' ) ;
                            CalibData = FetchObj( [hex2dec('2303'),GetCalibIndex('CalibData',handles.CalibNames),TargetCanId2] , DataType.long  , 'Fetch CalibData' ) ;
                            SendObj( [hex2dec('2303'),253,TargetCanId2] , CalibData , DataType.long  , 'Save in flash' ) ;
                        end
                        set( handles.TextPleaseDo, 'String' ,{'Flex door calibration done','See you','In celebrations'} ) ; 
                    else
                        msgbox({'\fontsize(14)Flex door calibration failed',errstr,'So sorry'} ,handles.CreateStruct ) ; 
                        set( handles.TextPleaseDo, 'String' ,{'Flex door calibration failed',errstr,'So sorry'} ) ; 
                    end 
                    handles.CalibratingDoor = 0 ; 
                    set( handles.PushForComplete,'Visible','Off','String','Next') ;

            otherwise
                handles.CalibratingDoor = 0 ; 
                set( handles.PushForComplete,'Visible','Off','String','Done') ; 
        end
        handles.PushActionDone = 0 ; 
        guidata(handles.hObject, handles);
    else
        switch handles.CalibratingDoor
            case 1
                    set( handles.TextPleaseDo, 'Visible','On','String' ,{'Rotate rotary plate','so door has free motion','Press Next to set motor on','Door will jump up'} ) ; 
                    set( handles.PushForComplete,'Visible','On','String','Next') ;
            case 100
                ProgState =  FetchObj( [hex2dec('2103'),98,TargetCanId2] , DataType.long , 'ProgState' ) ;
                if ProgState==0 
                    SetMotorsOn ( handles , 2^5 ); 
                    handles.CalibratingDoor = 101 ; 
                    set( handles.TextPleaseDo, 'String' ,{'Starting the motors'} ) ;                     
                else
                    set( handles.PushForComplete,'Visible','Off','String','Next') ;
                end 
                set( handles.TextPleaseDo, 'String' ,{'Programming door motor','For torque mode'} ) ; 
            case 101
                MotorOnInfo =  FetchObj( [hex2dec('2103'),5,TargetCanId2] , DataType.long , 'Motor On Info' )  ;
                mask = 257 ; 
                if bitand( mask *2^16 , MotorOnInfo) /2^16 == mask 
                    %set( handles.PushForComplete,'Visible','On','String','Next') ;
                    SendObj( [hex2dec('2103'),99,TargetCanId2] , 0.8 , DataType.float , 'Set motor torque' ) ;                    
                    set( handles.TextPleaseDo, 'String' ,{'Verify door in upper limit','Press Next to confirm'} ) ; 
                    set( handles.PushForComplete,'Visible','On','String','Next') ;
                    handles.CalibratingDoor = 3 ; 

                    % set( handles.TextPleaseDo, 'String' ,{'Press Next to set motor on','Door will jump up'} ) ;                 
                end
        end
    end 

function handles = CalibPlateManager(handles)
    global DataType %#ok<*GVMIS> 
    global RecStruct
    global TargetCanId2 
    switch ( handles.CalibratingPlate  )
        case 1
            
        
            if handles.PushActionDone
                handles.CalibratingPlate = 11 ; 
                set(handles.PushForComplete,'String','Start'); 
                handles.RecTime = 12; 
                RecInitAction = struct( 'InitRec' , 0 , 'BringRec' , 0 ,'ProgRec' , 1 ,'Struct' , 1 ,'T' , handles.RecTime ,'MaxLen', 1000 ) ; 
                handles.RecBringAction = struct( 'InitRec' , 0 , 'BringRec' , 1 ,'ProgRec' , 0 ,'Struct' , 1 ,'BlockUpLoad', 1  ) ; 
                handles.RecNames = {'AxisReadout_6','FlexPlateRatio'} ; 
                L_RecStruct = RecStruct ;
                L_RecStruct.Sync2C = 1 ; 

                L_RecStruct.BlockUpLoad = 0 ; 
                [~,L_RecStruct] = Recorder(handles.RecNames , L_RecStruct , RecInitAction   );
                handles.L_RecStruct = L_RecStruct ;
                handles.EdataOnStart = handles.Edata ; 
                sum = 0 ; 
                for cnt = 1:5
                    sum = sum + GetSignal('FlexPlateRatio'); 
                end 
                handles.FlexRotaryCenter = sum / 5 ; 
                set( handles.TextPleaseDo,'String',{'Set the tapearm to -90g (90 deg CCW)';' and press Ready'}); 
                set(handles.PushForComplete,'String','Ready'); 
                handles.PushActionDone = 0 ; 
            end
        case 11
            if handles.PushActionDone
                handles.CalibratingPlate = 2 ; 
                set(handles.PushForComplete,'String','Start'); 
                set( handles.TextPleaseDo,'String',{'After you push Start';['You have ',num2str(handles.RecTime) ,' seconds'];...
                    'to pause 1 second';'then SLOWLY rotate tapearm 90 degrees clockwise'}) ; 
                handles.PushActionDone = 0 ; 
            end

        case 2
            if handles.PushActionDone
                handles.PushActionDone = 0 ; 
                SendObj( [hex2dec('2000'),100] , 1 , DataType.short  , 'Set the recorder on' ) ;
                
                % InitRec set zero , recorder shall start automatically
                handles.CalibratingPlate = 3 ; 
                handles.tic = tic ; 
                set(handles.PushForComplete,'String',num2str(handles.RecTime)); 
            end

        case 3
            tremain = handles.RecTime - toc(handles.tic) ; 
            if tremain > 0 
                set(handles.PushForComplete,'String',num2str(tremain) ); 
            else
                set(handles.PushForComplete,'String','Uploading' ); 
                drawnow ; 
                [~,~,r] = Recorder(handles.RecNames , handles.L_RecStruct , handles.RecBringAction   );
                nomgain = GetFloatPar('ManGeo.FlexPlatePot2Rad','2') ; 
                EdataOnStart = handles.EdataOnStart ; 
                PotCenter    = handles.FlexRotaryCenter ;
                save CalibFlexPlatePot.mat r nomgain EdataOnStart PotCenter 
                [corr, estr] = AnaCalibFlexPlate() ; 
                if isempty(estr) 
                    set( handles.TextPleaseDo,'String',{'Your results are ready'}) ;

                    ButtonName = questdlg('Do you want to update/flash the result:?','Question','Yes', 'No', 'No');
                    if isequal(ButtonName,'Yes') 
                        SendObj( [hex2dec('2303'),1,TargetCanId2] ,GetSFPass() , DataType.long  , 'Set parameters password' ) ;
                        SendObj( [hex2dec('2303'),251,TargetCanId2] ,0 , DataType.long  , 'Update calibration parameters from flash' ) ;
                        SendObj( [hex2dec('2303'),GetCalibIndex('FlexRotaryCenter',handles.CalibNames),TargetCanId2] , handles.FlexRotaryCenter , DataType.float  , 'Set FlexRotaryCenter' ) ;
                        SendObj( [hex2dec('2303'),GetCalibIndex('FlexRotaryPotGain',handles.CalibNames),TargetCanId2] , corr , DataType.float  , 'Set FlexRotaryPotGain' ) ;
                        CalibData = FetchObj( [hex2dec('2303'),GetCalibIndex('CalibData',handles.CalibNames),TargetCanId2] , DataType.long  , 'Fetch CalibData' ) ;
                        SendObj( [hex2dec('2303'),253,TargetCanId2] , CalibData , DataType.long  , 'Save in flash' ) ;
                    end

                else
                    set( handles.TextPleaseDo,'String',{'Your results are rejected';estr}) ;
                end
                handles.CalibratingPlate = 0 ;
                set( handles.PushForComplete,'Visible','Off','String','Done') ; 
            end 
        otherwise
            handles.CalibratingPlate = 0 ; 
            set( handles.PushForComplete,'Visible','Off','String','Done') ; 
%             set( handles.TextPleaseDo,'String',{'Have a good day'}) ; 
       %set( handles.TextPleaseDo,'Visible','Off') ; 
    end 


% --- Outputs from this function are returned to the command line.
function varargout = CalibFlex_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

function KillAllCalibrations(handles) 
handles.CalibratingDoor = 0  ; 
handles.CalibratingPlate = 0 ; 
handles.PushActionDone = 0 ;  
set(handles.PushForComplete,'String','Done','Visible','Off'); 
set( handles.TextPleaseDo,'String',{'Calibration killed'}) ; 
guidata(handles.hObject, handles);

% --- Executes on button press in PushCalibrate.
function PushCalibrate_Callback(hObject, eventdata, handles)
% hObject    handle to PushCalibrate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if (  any(handles.CalibratingPlate == [3,4]))
    return ;
end 
KillAllCalibrations(handles) ; 
handles.CalibratingPlate = 1 ; 
set( handles.TextPleaseDo,'String',{'Set manipulator to 0,0  position';'manipulator straight';'gripper points backwards';'Press Done'}) ; 
set( handles.PushForComplete,'Visible','On') ; 
set( handles.TextPleaseDo,'Visible','On') ; 
set(handles.PushForComplete,'String','Done','Visible','On') ; 
guidata(hObject, handles);


% --- Executes on button press in PushActionDone.
function PushActionDone_Callback(hObject, eventdata, handles)
% hObject    handle to PushActionDone (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.PushActionDone = 1 ; 

SendObj( [hex2dec('2303'),1,TargetCanId2] ,hex2dec('12345678') , DataType.long , 'Password for calib') ;
SendObj( [hex2dec('2303'),9,TargetCanId2] ,calibRslt.DoorCenter , DataType.float , 'DoorCenter calib') ;
SendObj( [hex2dec('2303'),10,TargetCanId2] ,calibRslt.RotaryCenter , DataType.float , 'RotaryCenter calib') ;
SendObj( [hex2dec('2303'),11,TargetCanId2] ,calibRslt.FlexCenter , DataType.float , 'FlexCenter calib') ;
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
    if isempty(strFuck) && ( handles.FlexPosScale * handles.RotaryPosScale * handles.DoorPosScale == 0 ) 
        strFuck = 'Position scale is zero '; 
    end 
    if isempty(strFuck)
        
        tol = 0.5 ; 
        FlexDev1 = handles.EdataOnZero.FlexCnt - handles.FlexNominalOffsetCnt ; 
        RotaryDev1    = handles.EdataOnZero.RotaryCnt - handles.RotaryNominalOffsetCnt ; 
        DoorDev1    = handles.EdataOnZero.DoorCnt - handles.DoorNominalOffsetCnt ; 
        
        FlexDev = mod2piS ( FlexDev1 * handles.FlexPosScale ) /handles.FlexPosScale ;
        RotaryDev = mod2piS ( RotaryDev1 * handles.RotaryPosScale ) /handles.RotaryPosScale ;
        DoorDev = mod2piS ( DoorDev1 *  handles.DoorPosScale) /handles.DoorPosScale ;
                
        if  abs(FlexDev * handles.FlexPosScale) > tol 
            strFuck = 'Flex correction out of range '; 
        end 
            
        if  abs(RotaryDev * handles.RotaryPosScale) > tol 
            strFuck = 'Rotary correction out of range '; 
        end
        
        if  abs( DoorDev * handles.DoorPosScale ) > tol
            strFuck = 'Door correction out of range '; 
        end 
    end 
    
    if ~isempty(strFuck) 
        strFuck = [ string(strFuck) ; "Sorry...Calibration failed"] ; 
        uiwait( msgbox(strFuck , 'Calibration failed') ) ;  
    else
        calibRslt.FlexCenter = FlexDev ; 
		calibRslt.RotaryCenter = RotaryDev ; 
		calibRslt.DoorCenter = DoorDev ;

        handles.CalibInit = MergeStruct (handles.CalibInit,calibRslt ) ; 
        % RNeckPotCenter = 6 , LNeckPotCenter = 7 ,
        % RNeckPotGainFac = 8 , LNeckPotGainFac = 9 ; 
        
        try
            SendObj( [hex2dec('2303'),1,TargetCanId2] ,hex2dec('12345678') , DataType.long , 'Password for calib') ;
            SendObj( [hex2dec('2303'),9,TargetCanId2] ,calibRslt.DoorCenter , DataType.float , 'DoorCenter calib') ;
            SendObj( [hex2dec('2303'),10,TargetCanId2] ,calibRslt.RotaryCenter , DataType.float , 'RotaryCenter calib') ;
            SendObj( [hex2dec('2303'),11,TargetCanId2] ,calibRslt.FlexCenter , DataType.float , 'FlexCenter calib') ;
            % apply calibration 
            SendObj( [hex2dec('2303'),253,TargetCanId2] ,0 , DataType.float , 'Save and Apply calibration') ;
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
if ( npts > 1 && npts < 100 && handles.CalibratingPlate == 0 ) 
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
    delete( handles.EvtObj) ;
%     if isequal(class( handles.timer),'timer')  
%         stop(handles.timer) ; 
%         delete(handles.timer) ; 
%     end
catch 
end
% Hint: delete(hObject) closes the figure
delete(hObject);

function value = ValidateEdit( control, defval , minval , maxval  ) 
try
    value = str2num( get(control,'String') ) ; 
    if value >= minval && value <= maxval 
        return ; 
    end
    value = defval ; 
catch 
    value = defval ; 
end
set(control,'String', num2str(value) ) ;  


function EditFlexTarget_Callback(hObject, eventdata, handles)
% hObject    handle to EditFlexTarget (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of EditFlexTarget as text
%        str2double(get(hObject,'String')) returns contents of EditFlexTarget as a double
    handles.FlexTarget = ValidateEdit( handles.EditFlexTarget , handles.FlexTarget , -1.5 , 1.5  );  
    guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function EditFlexTarget_CreateFcn(hObject, eventdata, handles)
% hObject    handle to EditFlexTarget (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function EditRotaryTarget_Callback(hObject, eventdata, handles)
% hObject    handle to EditRotaryTarget (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of EditRotaryTarget as text
%        str2double(get(hObject,'String')) returns contents of EditRotaryTarget as a double
    handles.RotaryTargetDeg = ValidateEdit( handles.EditRotaryTarget , handles.RotaryTargetDeg , -160 , 160  );  
    guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function EditRotaryTarget_CreateFcn(hObject, eventdata, handles)
% hObject    handle to EditRotaryTarget (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function EditDoorTarget_Callback(hObject, eventdata, handles)
% hObject    handle to EditDoorTarget (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of EditDoorTarget as text
%        str2double(get(hObject,'String')) returns contents of EditDoorTarget as a double
    handles.DoorTargetDeg = ValidateEdit( handles.EditDoorTarget , handles.DoorTargetDeg , -10 , 80  );  
    guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function EditDoorTarget_CreateFcn(hObject, eventdata, handles)
% hObject    handle to EditDoorTarget (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in checkbox4.
function checkbox4_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox4


% --- Executes on button press in ButtonMotorOn.
function ButtonMotorOn_Callback(hObject, eventdata, handles)
% hObject    handle to ButtonMotorOn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of ButtonMotorOn
global DataType ;
global TargetCanId2
% Hint: get(hObject,'Value') returns toggle state of CheckRotaryRelative
if get( handles.ButtonMotorOn ,'Value' ) 
    SetMotorsOn(handles,1) ; 
else
    SetMotorsOff(handles,1) ; 
end

% --- Executes on button press in CheckFlexRelative.
function CheckFlexRelative_Callback(hObject, eventdata, handles)
% hObject    handle to CheckFlexRelative (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of CheckFlexRelative


% --- Executes on button press in CheckDoorRelative.
function CheckDoorRelative_Callback(hObject, eventdata, handles)
% hObject    handle to CheckDoorRelative (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of CheckDoorRelative


% --- Executes on button press in CheckRotaryRelative.
function CheckRotaryRelative_Callback(hObject, eventdata, handles)
% hObject    handle to CheckRotaryRelative (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

 

% --- Executes on button press in ButtonFlexGo.
function ButtonFlexGo_Callback(hObject, eventdata, handles)
% hObject    handle to ButtonFlexGo (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global DataType 
global TargetCanId2 
% Hint: get(hObject,'Value') returns toggle state of CheckRotaryRelative
pref = str2num( get(handles.EditFlexTarget,'String' ) ) ;  %#ok<*ST2NM>
if ( get(handles.CheckFlexRelative,'Value') ) 
    pref = pref + handles.Edata.FlexMeter ;
end
SendObj( [hex2dec('2103'),11,TargetCanId2] , pref * 1000 , DataType.long , 'Flex pos cmd' ) ;



% --- Executes on button press in ButtonRotaryGo.
function ButtonRotaryGo_Callback(hObject, eventdata, handles)
% hObject    handle to ButtonRotaryGo (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global DataType ;
global TargetCanId2 
% Hint: get(hObject,'Value') returns toggle state of CheckRotaryRelative
pref = str2num( get(handles.EditRotaryTarget,'String' ) ) * pi / 180 ; 
if (get( handles.CheckRotaryRelative ,'Value')) 
    pref = pref + handles.Edata.RotaryRad ;
end
SendObj( [hex2dec('2103'),51,TargetCanId2] , pref * 1000 , DataType.long , 'Rotary pos cmd' ) ;



% --- Executes on button press in ButtonDoorGo.
function ButtonDoorGo_Callback(hObject, eventdata, handles)
% hObject    handle to ButtonDoorGo (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global DataType ;
global TargetCanId2 
% Hint: get(hObject,'Value') returns toggle state of CheckRotaryRelative
pref = str2num( get(handles.EditDoorTarget,'String' ) ) * pi / 180 ; 
SendObj( [hex2dec('2103'),41,TargetCanId2] , pref * 1000 , DataType.long , 'Rotary pos cmd' ) ;


% --- Executes on button press in checkFlexMm.
function checkFlexMm_Callback(hObject, eventdata, handles)
% hObject    handle to checkFlexMm (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkFlexMm


% --- Executes on button press in buttonFlexHome.
function buttonFlexHome_Callback(hObject, eventdata, handles)
% hObject    handle to buttonFlexHome (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global DataType ;
global TargetCanId2 
% Hint: get(hObject,'Value') returns toggle state of CheckRotaryRelative
pref = handles.FlexHome ; 
SendObj( [hex2dec('2103'),16,TargetCanId2] , pref  , DataType.float, 'Flex home' ) ;
handles.FlexTarget = handles.FlexHome ; 
set( handles.EditFlexTarget,'String',num2str(handles.FlexTarget)) ; 
guidata(hObject, handles);


% --- Executes on button press in ButtonRotaryHome.
function ButtonRotaryHome_Callback(hObject, eventdata, handles)
% hObject    handle to ButtonRotaryHome (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global TargetCanId2 
global DataType
pref = handles.RotaryHomeDeg * pi / 180  ; 
SendObj( [hex2dec('2103'),56,TargetCanId2] , pref  , DataType.float, 'Rotary home' ) ;
handles.RotaryTargetDeg = handles.RotaryHomeDeg ; 
set( handles.EditRotaryTarget,'String',num2str(handles.RotaryTargetDeg)) ; 
guidata(hObject, handles);


function editFlexHome_Callback(hObject, eventdata, handles)
% hObject    handle to editFlexHome (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editFlexHome as text
%        str2double(get(hObject,'String')) returns contents of editFlexHome as a double
    handles.FlexHome = ValidateEdit( handles.editFlexHome , handles.FlexHome , 0 , 1.5  );  
    guidata(hObject, handles);


    
% --- Executes during object creation, after setting all properties.
function editFlexHome_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editFlexHome (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function editRotaryHome_Callback(hObject, eventdata, handles)
% hObject    handle to editRotaryHome (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editRotaryHome as text
%        str2double(get(hObject,'String')) returns contents of editRotaryHome as a double
%     handles.RotaryHomeDeg = ValidateEdit( handles.editRotaryHome , handles.RotaryHomeDeg , -160 , 160 );  
    guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function editRotaryHome_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editRotaryHome (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in PushCalibrateDoor.
function PushCalibrateDoor_Callback(hObject, eventdata, handles)
% hObject    handle to PushCalibrateDoor (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
KillAllCalibrations(handles) ; 

handles.CalibratingDoor = 1 ; 
% Wait ceremonial start 
set( handles.TextPleaseDo,'String',{'Starting door calibration';'Wait...'}) ; 
set( handles.PushForComplete ,'Visible','Off'); 
SetMotorsOff(handles) ; 
guidata(hObject, handles);


% --- Executes on button press in PushHomingProc.
function PushHomingProc_Callback(hObject, eventdata, handles)
% hObject    handle to PushHomingProc (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global TargetCanId 
global DataType
SendObj( [hex2dec('2207'),64,TargetCanId ] , 1 , DataType.long , 'Set Homing procedure' ) ;


% --- Executes on button press in PushKillHoming.
function PushKillHoming_Callback(hObject, eventdata, handles)
% hObject    handle to PushKillHoming (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global TargetCanId
global DataType
SendObj( [hex2dec('2207'),65,TargetCanId ] , 1 , DataType.long , 'Kill Homing procedure' ) ;


% --- Executes on button press in PushKillCalibration.
function PushKillCalibration_Callback(hObject, eventdata, handles)
% hObject    handle to PushKillCalibration (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
KillAllCalibrations(handles) ; 


% --- Executes on button press in ToggleDoorMotorOn.
function ToggleDoorMotorOn_Callback(hObject, eventdata, handles)
% hObject    handle to ToggleDoorMotorOn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of ToggleDoorMotorOn
global DataType ;
global TargetCanId2
% Hint: get(hObject,'Value') returns toggle state of CheckRotaryRelative
if handles.DoorMotorOn == 0  
    SetMotorsOn(handles,2^5) ; 
else
    SetMotorsOff(handles,2^5) ; 
end


% --- Executes on button press in PushPlateMotorOn.
function PushPlateMotorOn_Callback(hObject, eventdata, handles)
% hObject    handle to PushPlateMotorOn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global DataType ;
global TargetCanId2
% Hint: get(hObject,'Value') returns toggle state of CheckRotaryRelative
if handles.RotaryMotorOn == 0  
    SetMotorsOn(handles,2^6) ; 
else
    SetMotorsOff(handles,2^6) ; 
end


% --- Executes on button press in pushbutton30.
function pushbutton30_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton30 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
