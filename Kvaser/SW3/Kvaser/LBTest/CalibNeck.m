function varargout = CalibNeck(varargin)
% CALIBNECK MATLAB code for CalibNeck.fig
%      CALIBNECK, by itself, creates a new CALIBNECK or raises the existing
%      singleton*.
%
%      H = CALIBNECK returns the handle to a new CALIBNECK or the handle to
%      the existing singleton*.
%
%      CALIBNECK('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in CALIBNECK.M with the given input arguments.
%
%      CALIBNECK('Property','Value',...) creates a new CALIBNECK or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before CalibNeck_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to CalibNeck_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help CalibNeck

% Last Modified by GUIDE v2.5 27-Aug-2022 11:37:19

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @CalibNeck_OpeningFcn, ...
                   'gui_OutputFcn',  @CalibNeck_OutputFcn, ...
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


% --- Executes just before CalibNeck is made visible.
function CalibNeck_OpeningFcn(hObject, ~, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to CalibNeck (see VARARGIN)

% Choose default command line output for CalibNeck
handles.output = hObject;
global DataType


AtpStart ; 

handles.UpdateDisplayActive = 1 ; 
handles.Calibrating = 0 ; 
handles.CalibratingIMU = 0 ; 
handles.CalibratingState = 0 ;
handles.PushActionDone = 0 ; 
handles.hObject = hObject ; 
guidata(hObject, handles);

set( handles.PushForComplete,'Visible','Off') ; 
set( handles.TextPleaseDo,'Visible','Off') ;
set( handles.PushSaveFlash,'Visible','Off') ;


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

handles.EncoderBitPerRadian = evalin( 'base', 'GetFloatPar(''Geom.NeckMotCntRad'' )')  ;

% Just go to the manual mode 
ErrCode = SendObj( [hex2dec('2206'),0] , 10000 , DataType.long , 'Go manual mode' ); 
if ( ErrCode == hex2dec('8FFFF38') ) 
    uiwait( errordlg('Robot must be in the operational mode') ) ; 
    Stack = dbstack ; 
    Stack = Stack(1) ; 
    
    errstruct  = struct ('message','Could not load CalibNeck','identifier','CalibNeck:InitConditions','stack',Stack) ; 

    error(errstruct);
end

handles.AutoNeck =  FetchObj( [hex2dec('2207'),30] , DataType.float , 'AutoNeck' ) ;
set(handles.CheckAutoNeck,'Value',handles.AutoNeck) ; 


% Bring the flashed calibration 
handles.CalibInit = SaveCalib ( [] ) ; 
handles.quat0Rslt = [] ; 
handles.NCalibPts = 5 ; 
set ( handles.EditNCalibPts , 'String' , num2str(handles.NCalibPts) ) ; 

set( handles.TextCalibDate,'String', num2str(handles.CalibInit.CalibDate ) ) ; 
set( handles.TextCalibrationID,'String', num2str(handles.CalibInit.CalibData)) ; 

% Update handles structure
guidata(hObject, handles);



function update_sw_display( hobj) 
    global TmMgrT
    handles = guidata(hobj) ; 

    try
    cnt = TmMgrT.GetCounter('CAL_NECK') ; 

    if cnt < -1e5 
        delete( hobj) ; 
    else
        update_screen(handles) ; 
        TmMgrT.IncrementCounter('CAL_NECK',2) ; 
    end     
        
    catch 
    end
    
% UIWAIT makes CalibNeck wait for user response (see UIRESUME)
% uiwait(handles.figure1);
% function update_steercalib_display( varargin) 
%     handles = guidata(varargin{3}) ; 
%     try
%     update_screen(handles) ; 
%     catch 
%     end
%     %start (handles.timer) ;

function Edata = GetExtData() 
global DataType
GyroRoll =  FetchObj( [hex2dec('2204'),56] , DataType.float , 'Gyro roll' ) ;
GyroPitch =  FetchObj( [hex2dec('2204'),57] , DataType.float , 'Gyro pitch' ) ;
Heading =  FetchObj( [hex2dec('2204'),111] , DataType.float , 'Gyro pitch' ) ;
LPotCorrected =  FetchObj( [hex2dec('2204'),44] , DataType.float , 'LPotCorrected' ) ;
RPotCorrected =  FetchObj( [hex2dec('2204'),43] , DataType.float , 'RPotCorrected' ) ;
Edata = struct ( 'GyroRoll' , GyroRoll ,'GyroPitch',GyroPitch, 'LPotCorrected',LPotCorrected,'RPotCorrected',RPotCorrected,'Heading',Heading);  


function [pot1,pot2,enc,ref,roll,ang,dang] = GetNeckData( ) 
global DataType

	pot1 =  FetchObj( [hex2dec('2204'),1] , DataType.float , 'Get POT1' ) ;
	pot2 =  FetchObj( [hex2dec('2204'),2] , DataType.float , 'Get POT2' ) ;

	enc =  FetchObj( [hex2dec('2204'),42] , DataType.float , 'Get enc' ) ;  
	ref =  FetchObj( [hex2dec('2206'),5] , DataType.long , 'Get enc ref' ) ;
    
	roll = FetchObj( [hex2dec('2204'),56] , DataType.float , 'Gyro roll' ) ;%     FetchObj( [hex2dec('2204'),24] , DataType.float , 'Get roll' ) ;
	ang  =  FetchObj( [hex2dec('2204'),32] , DataType.float , 'Get ang' ) ;  
	dang  =  FetchObj( [hex2dec('2204'),33] , DataType.float , 'Get dang' ) ;
    
   
    
function update_screen(handles)    

    global RecStruct 
    global DataType 
    if  ~isfield(handles,'UpdateDisplayActive') || ~handles.UpdateDisplayActive 
        return ; 
    end 

    if handles.Calibrating || handles.CalibratingIMU 
        handles.PushCalibIMU.Enable = 'off' ; 
        handles.PushCalibrate.Enable = 'off' ; 
    else
        handles.PushCalibIMU.Enable = 'on' ; 
        handles.PushCalibrate.Enable = 'on' ; 
        set( handles.PushForComplete,'Visible','Off') ; 
        %set( handles.TextPleaseDo,'Visible','Off') ; 
    end 

    
    [pot1,pot2,enc,ref,roll,ang,dang] = GetNeckData( ) ; 
    Edata = GetExtData() ; 
    
    set(handles.TextSteerRef,'String',num2str(ref)) ; 
    set(handles.TextNeckPot1,'String',num2str(pot1)) ;
    set(handles.TextNeckPot2,'String',num2str(pot2)) ;
    set(handles.TextEncoder,'String',num2str(enc))  ;
 
    set(handles.TextSteerAngle,'String',num2str(ang* 180 / pi) ) ;
    set(handles.TextStrainDiff,'String',num2str(dang* 180 / pi) ) ;
    set(handles.TextVerticalDeg,'String',num2str(roll* 180 / pi) ) ;
    
    set(handles.TextGyroRoll,'String',num2str(Edata.GyroRoll * 180 / pi,'%.4g') ) ; 
    set(handles.TextGyroPitch,'String',num2str(Edata.GyroPitch * 180 / pi,'%.4g') ) ; 
    set(handles.TextHeading,'String',num2str(Edata.Heading * 180 / pi,'%.4g') ) ; 
   
    set(handles.TextCorrectR,'String',num2str(Edata.RPotCorrected * 180 / pi,'%.4g') ) ; 
    set(handles.TextCorrectL,'String',num2str(Edata.LPotCorrected * 180 / pi,'%.4g') ) ; 
   
    if ( handles.Calibrating  )
        set( handles.PushForComplete,'Visible','On') ; 
        set( handles.TextPleaseDo,'Visible','On') ; 
        NextPt = handles.CalibratingState + 1 ; 
        set( handles.TextPleaseDo,'String',{['Bring the axis to pt#[',num2str(NextPt),'] of [',num2str(handles.NCalibPts),']'];'Press Done'}) ; 

        if handles.PushActionDone
            nSamp = 10; 
            Pot1Samp = zeros(nSamp,1) ; 
            Pot2Samp = zeros(nSamp,1) ; 
            EncSamp = zeros(nSamp,1) ; 
            RefSamp = zeros(nSamp,1) ; 
            RollSamp = zeros(nSamp,1) ; 
            for cnt = 1:nSamp 
                [Pot1Samp(cnt),Pot2Samp(cnt),EncSamp(cnt),RefSamp(cnt),RollSamp(cnt)] =  GetNeckData( ) ; 
            end 
            handles.PotSummary(NextPt,:)  = [mean(Pot1Samp), mean(Pot2Samp) , mean(EncSamp) , mean(RefSamp) , mean(RollSamp) ] ;
            handles.PushActionDone = 0 ; 
            handles.CalibratingState = NextPt ; 
            if ( NextPt == handles.NCalibPts)                 
                handles.Calibrating = 0 ;
                handles.PushActionDone = 0 ; 
                handles.CalibratingState = 0 ; 
                set( handles.PushForComplete,'Visible','Off') ; 
                % set( handles.TextPleaseDo,'Visible','Off') ; 
                set( handles.TextPleaseDo,'String',{'Your results are ready';'Use Save Calib button';'To approve and save'}) ; 
                % save('NeckCalibRslt.mat' ,'PotSummary' ) ;  
                set( handles.PushSaveFlash,'Visible','On') ;
            end
            guidata(handles.hObject, handles);
        end 
    end 
    
    
    if ( handles.CalibratingIMU  )
        set( handles.TextPleaseDo,'Visible','On') ; 
        set( handles.TextPleaseDo,'String',{'Bring the neck to level';'Bring heading to zero';'Press Done'}) ; 

        if handles.PushActionDone

            set( handles.PushForComplete,'Visible','Off') ; 
            set( handles.TextPleaseDo,'String',{'Recording data';'and analyzing';'Please wait'}) ; 
            
            TrigSig   = 1 ; % find( strcmpi( SigNames ,'RawQuat0')) ;  
            TrigTypes = struct('Immediate', 0 , 'Rising' , 1 , 'Falling' , 2 ,'Equal' , 3) ; 
            RecNames = {'RawQuat0','RawQuat1','RawQuat2','RawQuat3'} ; 


            RecStructUser = struct('TrigSig',TrigSig,'TrigType',TrigTypes.Immediate ,'TrigVal',0,...
                'Sync2C', 1 , 'Gap' , 2 , 'Len' , 300 ) ; 
            RecStructUser.PreTrigCnt = RecStructUser.Len / 4;

            RecStructUser = MergeStruct ( RecStruct, RecStructUser)  ; 

            %Flags (set only one of them to 1) : 
            % ProgRec = 1 just programs the signals, recorder remains inactive waiting an activating event 
            % InitRec = 1 initates the recorder and makes it work 
            % BringRec = 1 Programs the recorder, waits completion, and brings the
            % results immediately
            options = struct( 'InitRec' , 1 , 'BringRec' , 1 ,'ProgRec' , 1 , 'BlockUpLoad', 1 ,'Struct' , 1  ); 

            [~,~,r]= Recorder(RecNames , RecStructUser , options ) ; 

            t = r.t ; 
            q0 = mean(r.RawQuat0) ; 
            q1 = mean(r.RawQuat1) ; 
            q2 = mean(r.RawQuat2) ; 
            q3 = mean(r.RawQuat3) ; 
            qsys = [0 1 1 0 ] / sqrt(2) ; 

            qq = [q0, q1, q2, q3] ; 
            if abs(norm(qq) - 1) > 0.05 
                uiwait( errordlg('Failed to narmalized quaternion') ) ; 
                handles.CalibratingIMU = 0 ; 
            end
            qq = qq / norm(qq) ; 
            [yy,pp,rr]= Quat2Euler( qq)  ;     % qq is q(g'->N
            QgTagToG_ENU = InvertQuat(euler2quat(0, pp,rr)) ; % Null the yew - This goes to calibration mat 
            handles.quat0Rslt =  QuatOnQuat(QuatOnQuat(qsys,QgTagToG_ENU),qsys);   


%             [yy,pp,rr]= Quat2Euler( QuatOnQuat(QuatOnQuat(qsys,[q0,-q1,-q2,-q3]),qsys))  ; 
%             quat0 = euler2quat(0, pp,rr) ; % This goes to calibration mat 
%             handles.quat0Rslt = quat0 ;

            handles.CalibratingIMU = 0 ;
            handles.PushActionDone = 0 ; 
            handles.CalibratingState = 0 ; 
            set( handles.PushForComplete,'Visible','Off') ; 
            guidata(handles.hObject, handles);
            
            
            handles.CalibInit.qImu2Body0 = handles.quat0Rslt (1) ;
            handles.CalibInit.qImu2Body1 = handles.quat0Rslt (2) ;
            handles.CalibInit.qImu2Body2 = handles.quat0Rslt (3) ;
            handles.CalibInit.qImu2Body3 = handles.quat0Rslt (4) ;
   
            SendObj( [hex2dec('2302'),16] ,handles.quat0Rslt (1) , DataType.float , 'qImu2Body0 calib') ;
            SendObj( [hex2dec('2302'),17] ,handles.quat0Rslt (2) , DataType.float , 'qImu2Body1 calib') ;
            SendObj( [hex2dec('2302'),18] ,handles.quat0Rslt (3) , DataType.float , 'qImu2Body2 calib') ;
            SendObj( [hex2dec('2302'),19] ,handles.quat0Rslt (4) , DataType.float , 'qImu2Body3 calib') ;

            % apply calibration 
            SendObj( [hex2dec('2302'),249] ,0 , DataType.float , 'Apply calibration') ;

            [fname,PathName] = uiputfile('*.jsn','Select the calibration JSON file');
            SaveCalib( handles.CalibInit,[PathName,fname] ) ;
            dcd = questdlg('Save to flash?', ...
                                     'Please specify', ...
                                     'Yes', 'No' , 'No');  
            if isequal( dcd , 'Yes' )                 
                guidata(handles.hObject, handles);
                ProgCalib([PathName,fname], 1 ); 
                msgbox(' Succesfully saved to flash ','Info');
            end 
            
            
            msgbox('IMU calibration done') ; 
        else
            set( handles.PushForComplete,'Visible','On') ; 
        end 

        %set( handles.TextPleaseDo,'Visible','Off') ; 
    end 
    

function  [good,handles] = ApproveCalib(handles)  
    % End of the game 
global DataType
%     ODItems = struct( 'SetPass',[hex2dec('2302'),1],'ReadFlashStruct',[hex2dec('2302'),251]) ; 

    PotSummary = handles.PotSummary ; 
    save('NeckCalibRslt.mat' ,'PotSummary' ) ;  
    disp('Calibration history is logged at the file NeckCalibRslt.mat') ; 
    calibRslt = CalcCalibNeck ( PotSummary ) ; 
    good = 0 ;
    
    strFuck = {} ; 
    if ( abs(calibRslt.RNeckPotCenter) > 0.7 ) 
        strFuck = [strFuck ; 'RNeckPotCenter  should not be out of [-0.7..0.7], in fact it was [',num2str(calibRslt.RNeckPotCenter) ,']']  ; 
    end 
    if ( abs(calibRslt.RNeckPotGainFac) > 2.4 ) 
        strFuck = [strFuck ; 'RNeckPotGainFac  should not be out of [-2.4..2.4], in fact it was [',num2str(calibRslt.RNeckPotGainFac) ,']']  ; 
    end 
    if ( abs(calibRslt.LNeckPotCenter) > 0.7 ) 
        strFuck = [strFuck ; 'LNeckPotCenter  should not be out of [-0.7..0.7], in fact it was [',num2str(calibRslt.LNeckPotCenter) ,']']  ; 
    end 
    if ( abs(calibRslt.LNeckPotGainFac) > 2.4 ) 
        strFuck = [strFuck ; 'LNeckPotGainFac  should not be out of [-2.4..2.4], in fact it was [',num2str(calibRslt.LNeckPotGainFac) ,']']  ; 
    end
    Pot1 = PotSummary(:,1) ; 
    Pot2 = PotSummary(:,2) ; 
    Acc = PotSummary(:,5) ; 
    fac = 180 / pi ; 
    figure(10) ; clf 
    plot( Acc * fac , Pot1 ,'-+' ,Acc * fac , Pot2 ,'-+') ; xlabel('Tilt sensor angle [deg]') ; legend('Pot1','Pot2') ; 
    drawnow ; 
    if ~isempty(strFuck) 
        strFuck = [strFuck ; 'Please look at fig #1'] ; 
        uiwait( msgbox(strFuck , 'Calibration failed') ) ;  
    else
        dcd = questdlg( {'Please tell if the two lines';'are parallel and straight'}, ...
            'Approve linearity?', 'Yes', 'No' , 'No');  
        if isequal(dcd , 'Yes')                    
            handles.CalibInit = MergeStruct (handles.CalibInit,calibRslt ) ; 
            % RNeckPotCenter = 6 , LNeckPotCenter = 7 ,
            % RNeckPotGainFac = 8 , LNeckPotGainFac = 9 ; 
            
%             stat = SendObj( ODItems.SetPass , hex2dec('12345620') , DataType.long ,'Set the password') ;  
%             if stat 
%                 error ( 'Cant set flash password') ; 
%             end 
%             stat = SendObj( ODItems.ReadFlashStruct , 0 , DataType.long ,'Load the calibration from the flash to the programming struct') ; 
%             if stat  
%                 ButtonName = questdlg({'The calibration flash may be unprogrammed';'Continue assuming no existing calibration?'}, ...
%                                  'Attention', ...
%                                  'Yes', 'No','Yes');
%                 if ~isequal(ButtonName,'Yes' ) 
%                    error ( 'Could not backup the existing calibration from the flash') ;  
%                 end
%             end
            
    
            SendObj( [hex2dec('2302'),6] ,calibRslt.RNeckPotCenter , DataType.float , 'RNeckPotCente calib') ;
            SendObj( [hex2dec('2302'),7] ,calibRslt.LNeckPotCenter , DataType.float , 'LNeckPotCenter calib') ;
            SendObj( [hex2dec('2302'),8] ,calibRslt.RNeckPotGainFac , DataType.float , 'RNeckPotGainFac calib') ;
            SendObj( [hex2dec('2302'),9] ,calibRslt.LNeckPotGainFac , DataType.float , 'LNeckPotGainFac calib') ;
            
            handles.quat0Rslt
            % apply calibration 
            SendObj( [hex2dec('2302'),249] ,0 , DataType.float , 'Apply calibration') ;
            good = 1 ;
        else
            uiwait( msgbox(strFuck , 'Aborted by user') ) ;  
        end
    end 
    
    
function SetNeckRef(handles, inc) 
global DataType

ref = str2num( get(handles.TextSteerRef,'String') ) ; %#ok<*ST2NM>
ref = ref + inc ; 

SendObj( [hex2dec('2206'),5] , ref , DataType.long , 'neck reference' ) ;

set(handles.TextSteerRef,'String', num2str(ref) ) ; 
    


% --- Outputs from this function are returned to the command line.
function varargout = CalibNeck_OutputFcn(~, ~, handles) 
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
SetNeckRef(handles, 1e5) ; 



% --- Executes on button press in PushUp10K.
function PushUp10K_Callback(~, ~, handles)
% hObject    handle to PushUp10K (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
SetNeckRef(handles, 1e4) ; 


% --- Executes on button press in PushUp1K.
function PushUp1K_Callback(~, ~, handles)
% hObject    handle to PushUp1K (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
SetNeckRef(handles, 1e3) ; 


% --- Executes on button press in PushDn100K.
function PushDn100K_Callback(~, ~, handles)
% hObject    handle to PushDn100K (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
SetNeckRef(handles, -1e5) ; 


% --- Executes on button press in PushDn10K.
function PushDn10K_Callback(~, ~, handles)
% hObject    handle to PushDn10K (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
SetNeckRef(handles, -1e4) ; 


% --- Executes on button press in PushDn1K.
function PushDn1K_Callback(~, ~, handles)
% hObject    handle to PushDn1K (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
SetNeckRef(handles, -1e3) ; 


% --- Executes on button press in PushCalibrate.
function PushCalibrate_Callback(hObject, ~, handles)
% hObject    handle to PushCalibrate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.Calibrating = 1 ; 
handles.CalibratingState = 0 ; 
handles.PotSummary = zeros(handles.NCalibPts,5 ) ; 
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


% --- Executes on button press in PushUp45deg.
function PushUp45deg_Callback(~, ~, handles)
% hObject    handle to PushUp45deg (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
SetNeckRef(handles, round( handles.EncoderBitPerRadian * pi / 4 ) ) ; 

% --- Executes on button press in PushDn45deg.
function PushDn45deg_Callback(~, ~, handles)
% hObject    handle to PushDn45deg (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
SetNeckRef(handles, -round(handles.EncoderBitPerRadian * pi / 4)) ; 

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


% --- Executes on button press in CheckAutoNeck.
function CheckAutoNeck_Callback(hObject, ~, handles)
% hObject    handle to CheckAutoNeck (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of CheckAutoNeck
global DataType
val = get(handles.CheckAutoNeck,'Value') ; 
SendObj( [hex2dec('2207'),30] ,val , DataType.float , 'Auto neck get') ;
handles.AutoNeck = val ; 
guidata(hObject, handles);


% --- Executes during object deletion, before destroying properties.
function figure1_DeleteFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
delete( handles.EvtObj) ;


% --- Executes on button press in PushCalibIMU.
function PushCalibIMU_Callback(hObject, eventdata, handles)
% hObject    handle to PushCalibIMU (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.CalibratingIMU = 1 ; 
handles.CalibratingState = 0 ; 
guidata(hObject, handles);


% --- Executes when user attempts to close figure1.
function figure1_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: delete(hObject) closes the figure
delete(hObject);
