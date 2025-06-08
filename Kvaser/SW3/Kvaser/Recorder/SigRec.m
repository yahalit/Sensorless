function varargout = SigRec(varargin)
% SIGREC MATLAB code for SigRec.fig
%      SIGREC, by itself, creates a new SIGREC or raises the existing
%      singleton*.
%
%      H = SIGREC returns the handle to a new SIGREC or the handle to
%      the existing singleton*.
%
%      SIGREC('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in SIGREC.M with the given input arguments.
%
%      SIGREC('Property','Value',...) creates a new SIGREC or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before SigRec_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to SigRec_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help SigRec

% Last Modified by GUIDE v2.5 25-Jan-2024 10:09:16

try %OBB section added to start AtpStart if deployed
    if isdeployed && ~exist('AtpCfg','var')
        AtpStart();
    end
catch
    uiwait(errordlg({'Cant run AtpStart'},'Error') ); 
	return
end

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @SigRec_OpeningFcn, ...
                   'gui_OutputFcn',  @SigRec_OutputFcn, ...
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

function [RecSetup,handles] = LoadRecSetup(fname,handles)
dfltSetup = 0 ; 
try 
    if isempty( fname) 
        [file,path] = uigetfile('*.mat');
        if isequal(file,0)
            dfltSetup = 1;
        else
            setup = load(fullfile(path,file)) ; % 'RecSavedSetup.mat' ) ; 
%            disp(['User selected ', fullfile(path,file)]);
        end
    else
        setup = load(fname) ; % 'RecSavedSetup.mat' ) ; 
    end 
    if max( setup.RecSelect)  > length(handles.RecNames)  
        dfltSetup = 1; 
    end 
    if length(setup.RecSelect) ~= length(setup.AxisSelect)
        dfltSetup = 1; 
    end 
catch 
    setup = [] ; 
end 
if dfltSetup || isempty(setup) || ~isstruct(setup) || any(isfield(setup,{'RecSelect','AxisSelect','DrawFig','SaveFile','Gap','Len','Sync2C' }) == 0 )  
    setup = [] ; 
end

if isempty( setup ) 
    handles.RecStruct.Sync2C = 1 ; 
    handles.RecSelect = [] ; 
    RecSetup = struct('AxisSelect',[]) ; 
    handles.DrawFig   = 1000 ; 
    handles.SaveFile = 'SigRecSave.mat' ; 
else  
    RecSetup = setup ;
    handles.RecSelect = RecSetup.RecSelect ;
    handles.AxisSelect = RecSetup.AxisSelect ;
    handles.DrawFig = RecSetup.DrawFig ; 
    handles.SaveFile = RecSetup.SaveFile ; 
    handles.RecStruct.Len  = RecSetup.Len ; 
    handles.RecStruct.Gap  = RecSetup.Gap ; 
    handles.RecStruct.Sync2C = RecSetup.Sync2C ;
end

set( handles.CheckSyncToC,'Value',handles.RecStruct.Sync2C) ; 
set( handles.EditNFigure , 'String' , num2str(handles.DrawFig ) ) ; 
set( handles.EditMatFile , 'String' , handles.SaveFile ) ; 
handles = GetRecrderTs(handles); 



% --- Executes just before SigRec is made visible.
function SigRec_OpeningFcn(hObject, eventdata, handles, varargin) %#ok<*INUSL>
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to SigRec (see VARARGIN)

% Choose default command line output for SigRec
global AtpCfg ; %#ok<GVMIS>
global RecStruct %#ok<GVMIS>

handles.output = hObject;
handles.ClickEna = 0 ;
handles.SelectTrigger = 0 ; 

set(handles.edit6,'String','Undefined') ;
set(handles.EditTriggerValue,'String','0') ;

try %OBB section added to start AtpStart if deployed
    if isdeployed && ~exist('AtpCfg','var')
        AtpStart();
    end
catch
    uiwait(errordlg({'Cant run AtpStart'},'Error') ); 
	return
end

handles.BlockSupport = 1 ; %AtpCfg.Support.BlockUpload ; 
guidata(hObject, handles);

if length(varargin) >= 1 
    strin = varargin{1} ;
    if ischar(strin)
        str = GetProjectAttributesByName(strin) ;
        EntName = [str.ShortHand,'Entity'] ;
        if isfield (RecStruct, EntName) 
            Ent = RecStruct.(EntName) ; 
        else
            Ent = str.Card ;
        end

        [~,handles.RecStruct] = SetCanComTarget(Ent,str.Side,strin,str.Proj,RecStruct);
        set( handles.TextTarget ,'String',['Target: ',str.Card,' Side: ',str.Side,'  Axis: ',str.Axis,' Proj: ',str.Proj])
        if isfield(handles.RecStruct,'SigList2') 
            handles.RecStruct = rmfield(handles.RecStruct,'SigList2') ;
        end
        handles.BlockSupport  = 1 ; % We dont speak directly, so we cant use it
    else
        error('First argument need be project name ') ; 
    end
else
    if ~isdeployed 
        AtpStart ;
    end
    handles.RecStruct = RecStruct ; 
    set( handles.TextTarget ,'String','Target: Default')
end 

firstRec = handles.RecStruct.SigList{1}; 
nFieldsInRec = length(firstRec) ;
puk=[handles.RecStruct.SigList{:}];

if isfield(handles.RecStruct,'SigList2') 
    Cpu2Exist = 1 ; 
else
    Cpu2Exist = 0; 
end

if Cpu2Exist
    firstRec2 = handles.RecStruct.SigList2{1}; 
    nFieldsInRec2 = length(firstRec2) ;
    puk2=[handles.RecStruct.SigList2{:}];
else
    nFieldsInRec2 = 0 ; 
    puk2=[]; 
end
handles.RecFlags = [puk(1:nFieldsInRec:end),puk2(1:nFieldsInRec2:end)];
handles.RecNames = [puk(2:nFieldsInRec:end),puk2(2:nFieldsInRec2:end)];


if Cpu2Exist
    gr2 = puk2(3:nFieldsInRec2:end) ; 
    for cnt = 1:length(gr2) 
        gr2{cnt} = [gr2{cnt},'_2'] ; 
    end 
    handles.RecGroups = [puk(3:nFieldsInRec:end),gr2 ] ; 
    handles.RecHelps = [puk(4:nFieldsInRec:end),puk2(4:nFieldsInRec2:end)];
    handles.RecCpu = [ones(1,fix(length(puk)/4) ),2 * ones(1,fix(length(puk2)/4) )] ;
else
    handles.RecGroups = puk(3:nFieldsInRec:end) ; 
    handles.RecHelps =  puk(4:nFieldsInRec:end) ; 
    handles.RecCpu = ones(1,fix(length(puk)/4) ) ; 
end



handles.ComboTrigType.String = {'Immediate','Up','Down','Equal','Triggered'} ;
handles.ComboTrigType.Value  = 1 ;
handles.PreTrigPercent = 0 ; 
set ( handles.EditTrigPercent, 'String' , num2str(handles.PreTrigPercent) ) ; 
set ( handles.CheckBlockUpload,'Value',handles.BlockSupport) ; 

set ( handles.CheckBlockUpload,'Visible','on') ; 

% Get the default setup 
% dfltSetup = 0 ; 
% try 
    [RecSetup,handles] = LoadRecSetup('RecSavedSetup.mat' ,handles ) ;
%     if isempty(RecSetup) 
%         dfltSetup = 1; 
%     end 
    
%     if max( RecSetup.RecSelect)  > length(handles.RecNames)  
%         dfltSetup = 1; 
%     end 
%     if length(RecSetup.RecSelect) ~= length(RecSetup.AxisSelect)
%         dfltSetup = 1; 
%     end 
%     handles.RecSelect = RecSetup.RecSelect ;
%     handles.AxisSelect = RecSetup.AxisSelect ;
%     handles.DrawFig = RecSetup.DrawFig ; 
%     handles.SaveFile = RecSetup.SaveFile ; 
%     handles.RecStruct.Len  = RecSetup.Len ; 
%     handles.RecStruct.Gap  = RecSetup.Gap ; 
%     handles.RecStruct.Sync2C = RecSetup.Sync2C ;
% catch 
%     dfltSetup = 1; 
% end 

% if ( dfltSetup ) 
%     handles.RecStruct.Sync2C = 1 ; 
%     handles.RecSelect = [] ; 
%     RecSetup.AxisSelect = [] ; 
%     handles.DrawFig   = 1000 ; 
%     handles.SaveFile = 'SigRecSave.mat' ; 
% end
% 
% Construct the signal tree

import uiextras.jTree.*
handles.t = CheckboxTree('Parent',handles.PanelSigTree);
handles.t.CheckboxClickedCallback = [] ; 

handles.UniqueGroups = unique(handles.RecGroups) ;
nGroups = length(handles.UniqueGroups);
nTotalSig = length(handles.RecFlags) ; 
handles.UniqueGroupNodes = cell( 1, nGroups ) ; 
handles.Sig2NodeMap = cell( 1 , nTotalSig ) ; 

for cnt = 1:nGroups   
    sind  = find ( strcmp( handles.RecGroups,handles.UniqueGroups{cnt})); 
    sname = handles.RecNames(sind) ; 
    shelp = handles.RecHelps(sind) ; 
    [sname,ssort]= sort(sname) ; 
    sind = sind( ssort) ; 
    shelp = shelp(ssort);
    Node1 = CheckboxTreeNode('Name',handles.UniqueGroups{cnt},'Parent',handles.t.Root ,'UserData', sind  );
    handles.UniqueGroupNodes{cnt} = Node1 ; 
    nSig = length(sind) ; 
    for ind = 1:nSig 
        handles.Sig2NodeMap{sind(ind)}  = CheckboxTreeNode('Name',sname{ind},'Parent',Node1,...
            'TooltipString',shelp{ind},'UserData',[sind(ind),1]) ; 
    end 
    handles.UniqueGroups{cnt} = { handles.UniqueGroups{cnt} , Node1 , sind , sname , shelp} ; 
end 
handles.t.SelectionType = 'discontiguous';
% t.SelectedNodes = [Node1_2 Node1];

% Drag and drop
handles.t.DndEnabled = false;

handles.t.Editable = false;

% Hide the root
handles.t.RootVisible = false;
handles.t.Enable = true;

% Clear all the checks 
% NumSig = length(handles.Sig2NodeMap) ;
% for cnt = 1:NumSig
%     handles.Sig2NodeMap{cnt}.UserData(2) = [] ; 
%     handles.Sig2NodeMap{cnt}.Checked = 0 ; 
% end 
handles.t.UserData = hObject ; 
% Update handles structure
handles.t.CheckboxClickedCallback = @(s,e)TreeClickCallBack(s,e);
handles.ClickEna = 1 ; 

handles = WriteRecTable(handles,RecSetup) ; 


guidata(hObject, handles);

function handles = WriteRecTable(handles,RecSetup) 
% If there are any selected signals, mark them as checked 
if ~isempty( handles.RecSelect) 
    nSelect = length(handles.RecSelect ) ;
    for cnt = 1:nSelect
        handles.Sig2NodeMap{ handles.RecSelect(cnt) }.UserData(2) = handles.AxisSelect(cnt) ; 
        handles.Sig2NodeMap{ handles.RecSelect(cnt) }.Checked = 1 ; 
    end 
end 

% set( handles.CheckSyncToC,'Value',handles.RecStruct.Sync2C) ; 
% set( handles.EditNFigure , 'String' , num2str(handles.DrawFig ) ) ; 
% set( handles.EditMatFile , 'String' , handles.SaveFile ) ; 
    
% set( handles.ListChosenRec, 'String' , handles.RecNames(handles.RecSelect)  ) ;
% handles = GetRecrderTs(handles); 

data = cell(16,2) ; 
strnames = handles.RecNames(handles.RecSelect) ; 
for cnt = 1:16 
    if cnt <= length(handles.RecSelect) 
        data(cnt,1) = {strnames{cnt}} ;  %#ok<*CCAT1>
        data(cnt,2) = {num2str(RecSetup.AxisSelect(cnt) )} ; 
    end 
end

handles = GetRecrderTs(handles); 

set( handles.TableSigs, 'Data' , data ) ; 


function handles = GetRecrderTs(handles)
global TargetCanId 
global AtpCfg

DataType = GetDataType() ; 


handles.FullRecLen = FetchObj( [hex2dec('2000'),60,handles.RecStruct.TargetCanId] , DataType.long , 'FullRecLen' ) ;
handles.MaxSigs    = FetchObj( [hex2dec('2000'),61,handles.RecStruct.TargetCanId] , DataType.long , 'MaxSigs' ) ;

handles.ShortTs    = FetchObj( [hex2dec('2000'),62,handles.RecStruct.TargetCanId] , DataType.long , 'ShortTs' ) ;
handles.CTs        = FetchObj( [hex2dec('2000'),63,handles.RecStruct.TargetCanId] , DataType.long , 'CTs' ) ;

if handles.RecStruct.Sync2C
    handles.ActTs = handles.CTs * 1e-6  ; 
else
    handles.ActTs = handles.ShortTs * 1e-6 ;
end 
set ( handles.TextSamplingTime,'String',['Ts(sec): ', num2str(handles.ActTs) ]) ;

set( handles.TextMaxPts , 'String', ['Total Pts: ',num2str(handles.FullRecLen)] ) ;
MaxPointsPerSig  = fix( max( handles.FullRecLen/max([1,length(handles.RecSelect) ]), 1) ) ; 
set( handles.TextNumPoints , 'String' , ['Max Pts/signal: ',num2str(MaxPointsPerSig) ] ) ; 
set( handles.TextNumSignals , 'String' , ['Max signals: ',num2str(handles.MaxSigs)] ) ; 

if ( handles.RecStruct.Len > MaxPointsPerSig ) 
     handles.RecStruct.Len = MaxPointsPerSig ; 
end 
    
set( handles.EditNPoint ,'String', num2str(handles.RecStruct.Len ) ) ;  
set( handles.EditNGap ,'String', num2str(handles.RecStruct.Gap ) ) ;  
set( handles.TextTotalTime ,'String', num2str(handles.RecStruct.Gap * handles.ActTs * handles.RecStruct.Len ) ) ; 




% UIWAIT makes SigRec wait for user response (see UIRESUME)
% uiwait(handles.figure1);
function TreeClickCallBack(s,e) %#ok<*INUSD>
hObject = s.UserData;
handles = guidata(hObject) ;
if ~handles.ClickEna
    return ; 
end 
bubu = s.CheckedNodes ; 

lbubu = length(bubu);
for cnt = 1:lbubu
    if ~isempty(bubu(cnt).Children) 
        nasem = bubu(cnt).Children ; 
        bubu(cnt) = nasem(1) ; 
        if length(nasem) > 1
            bubu = [bubu , nasem(2:end)] ;  %#ok<AGROW>
        end
    end
end 
% 
% if length(bubu) == 1 && 
%     % Group is full - this is a major node - take the children
%     bubu = bubu.Children ; 
% end 

RecSelect = [ ]; 
AxisSelect = [] ; 
for cnt = 1:length(bubu) 
    RecSelect = [RecSelect , bubu(cnt).UserData(1) ] ; %#ok<AGROW>
    AxisSelect = [AxisSelect , bubu(cnt).UserData(2) ] ;  %#ok<AGROW>
end

if ( length(RecSelect ) > handles.MaxSigs  ) 
    uiwait( msgbox({'Too many signals checked';'They will not be reflected';'To the recorder list'},'Error','Modal' ) ) ; 
    return ; 
end 

% Sort it by record index (no need to re-aarnge bubu, it is not used again ) 
[RecSelect,sortind] = sort(RecSelect) ; 
AxisSelect = AxisSelect(sortind) ; 


handles.RecSelect= RecSelect ; 
handles.AxisSelect = AxisSelect ; 

data = cell(16,2) ; 
strnames = handles.RecNames(handles.RecSelect) ; 
for cnt = 1:16
    if cnt <= length(handles.RecSelect) 
        data(cnt,1) = {strnames{cnt}} ;  
        data(cnt,2) = {num2str(handles.AxisSelect(cnt) )} ; 
    end 
end
set( handles.TableSigs, 'Data' , data ) ; 


% set( handles.ListChosenRec, 'Value', 1 ) ; 
% set( handles.ListChosenRec, 'String' , handles.RecNames(handles.RecSelect)  ) ;
set( handles.TextNumPoints , 'String' , ['Max Pts: ',num2str( fix( handles.FullRecLen/ max( [1,length(handles.RecSelect)]) ) )] ) ; 

handles = GetRecrderTs(handles); 
guidata(hObject, handles);

% --- Outputs from this function are returned to the command line.
function varargout = SigRec_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



guidata(hObject, handles);



% % --- Executes on selection change in ListChosenRec.
% function ListChosenRec_Callback(hObject, eventdata, handles)
% % hObject    handle to ListChosenRec (see GCBO)
% % eventdata  reserved - to be defined in a future version of MATLAB
% % handles    structure with handles and user data (see GUIDATA)
% 
% % Hints: contents = cellstr(get(hObject,'String')) returns ListChosenRec contents as cell array
% %        contents{get(hObject,'Value')} returns selected item from ListChosenRec
% sel =  get( handles.ListChosenRec, 'Value') ; 
% if isempty(sel) || sel == 0 
%     return ; 
% end 
% RemovedCheck = handles.RecSelect(sel) ; 
% handles.RecSelect(sel) = [] ; 
% if isempty(handles.RecSelect) 
%     set( handles.ListChosenRec, 'Value', 0 ) ; 
% else
%     set( handles.ListChosenRec, 'Value', 1 ) ; 
% end 
% set( handles.ListChosenRec, 'String' , handles.RecNames(handles.RecSelect)  ) ;
% set( handles.TextNumPoints , 'String' , ['Max Pts: ',num2str( fix( handles.FullRecLen/ max( [1,length(handles.RecSelect)]) ) )] ) ; 
% 
% % Kill the check 
% handles.Sig2NodeMap{ RemovedCheck }.Checked = 0 ; 
% 
% guidata(hObject, handles);



% % --- Executes during object creation, after setting all properties.
% function ListChosenRec_CreateFcn(hObject, eventdata, handles)
% % hObject    handle to ListChosenRec (see GCBO)
% % eventdata  reserved - to be defined in a future version of MATLAB
% % handles    empty - handles not created until after all CreateFcns called
% 
% % Hint: listbox controls usually have a white background on Windows.
% %       See ISPC and COMPUTER.
% if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
%     set(hObject,'BackgroundColor','white');
% end


% --- Executes on button press in PushRecStart.
function PushRecStart_Callback(hObject, eventdata, handles)
handles = GetRecrderTs(handles); 
guidata(hObject, handles);
    RecorderGeneric(hObject, eventdata, handles , struct( 'InitRec' , 1 , 'BringRec' , 1 ) ) ;

function RecorderGeneric(hObject, eventdata, handles, action , custom ) 
% hObject    handle to PushRecStart (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.RecStruct.Sync2C = get( handles.CheckSyncToC,'Value') ; 

if nargin < 5 
    custom = 0 ; 
end 

str = [] ; 
if ( isempty(handles.RecSelect)  ) 
    str = 'Recorder list is empty' ; 
end 
nsig = length(handles.RecSelect);
if ( nsig >= handles.MaxSigs  ) 
    str = 'Recorder list is too long ' ; 
end 
npoints = str2num(get( handles.EditNPoint ,'String' ) ) ;
ngap = str2num(get( handles.EditNGap ,'String' ) ) ; %#ok<*ST2NM>

if npoints > fix( handles.FullRecLen / nsig ) 
    str = 'Recorder vector length is too long ' ; 
end 

if ~isempty(str) 
    uiwait(msgbox({'Can''t record:';str},'Attention','modal'));
    return ;
end

nRec = length(handles.RecSelect);
olddata = get( handles.TableSigs,'Data' ) ;
axesdata = zeros( 1, nRec ) ; 
for cnt = 1:nRec  
    baba = olddata(cnt,2); 
    axesdata(cnt) = str2num( baba{1}  ) ;
end 
axesunique = sort(unique(axesdata ) );
naxes = length(axesunique) ;

olddata  = olddata( 1:nRec , 1) ; 
RecNames = olddata';
% ???? RecNames = get( handles.ListChosenRec, 'String' ) ;
action.Struct = 1; 

if ~custom
    handles.RecStruct.TrigType = handles.ComboTrigType.Value - 1 ;
    if (handles.RecStruct.TrigType ) 
        handles.RecStruct.PreTrigCnt = min( max( handles.PreTrigPercent / 100 * npoints , 1) , npoints-1) ; 
        handles.RecStruct.TrigVal = str2num( get(handles.EditTriggerValue,'String') ) ; 
        handles.RecStruct.TrigSig = handles.TrigSelect.Descriptor.NodeData(1) ; 
        handles.RecStruct.TrigSigName = handles.TrigSelect.Descriptor.Text ; 
    else
        handles.RecStruct.PreTrigCnt = 1 ; 
        handles.RecStruct.TrigVal = 0 ; 
        handles.RecStruct.TrigSig = 1 ; 
    end
%     switch 
%         case 1
%             handles.RecStruct.TrigType = 0  ; 
%         case 2  
%             handles.RecStruct.TrigType = 4  ; 
%     end
end


IsBlockUpload = get(handles.CheckBlockUpload,'Value' ) ; 
handles.RecStruct.BlockUpLoad = IsBlockUpload ; 

if isfield(handles.RecStruct,'TargetCanId') 
    IdStr = struct('Id',handles.RecStruct.TargetCanId,'Id2',handles.RecStruct.TargetCanId2) ; 
else
    IdStr = [] ; 
end

[RecVec,~,RecStr,errstr] = Recorder(RecNames , handles.RecStruct  , action ,[] , IdStr) ; 
% Decode complex fields 
if isfield( RecStr,'ControlWord' )
    RecStr = DecodeControlWord( RecStr , handles.RecStruct.TargetCanId); 
end

if isfield( RecStr,'CBit' )
    RecStr = DecodeAxisCbit( RecStr , handles.RecStruct.TargetCanId); 
end
if isfield( RecStr,'C2_RotatorCBit' )
    RecStr = DecodeAxisCbit( RecStr , handles.RecStruct.TargetCanId,'C2_RotatorCBit'); 
end
if isfield( RecStr,'C2_LinearCBit' )
    RecStr = DecodeAxisCbit( RecStr , handles.RecStruct.TargetCanId,'C2_LinearCBit'); 
end
if isfield( RecStr,'C2_TapeArmCBit' )
    RecStr = DecodeAxisCbit( RecStr , handles.RecStruct.TargetCanId,'C2_TapeArmCBit'); 
end

if isfield( RecStr,'LimitSwitchSummary' )
    RecStr = DecodeLimitSwitchSummary( RecStr , handles.RecStruct.TargetCanId); 
end

if isfield( RecStr,'RailSwitchStatus' )
    RecStr = DecodeRailSwitchStatus( RecStr , handles.RecStruct.TargetCanId); 
end

if isfield( RecStr,'RStatusAsPdo' )
    RecStr = DecodeSwStatus( RecStr , 'R' ); 
end


if isfield( RecStr,'LStatusAsPdo' )
    RecStr = DecodeSwStatus( RecStr , 'L' ); 
end

if isfield( RecStr,'SwitchStatus')
    RecStr = DecodeSwitchesStatus( RecStr   ); 
end

if ( errstr ) 
    MyErrDlg (errstr,'Recorder error') ; 
    return ; 
end 

if ( action.BringRec == 0  ) 
    return ; 
end 
 

figure(handles.DrawFig) ; clf 
set(handles.DrawFig, 'DefaultLegendInterpreter', 'none');
[~,n] = size(RecVec) ; 
t = handles.ActTs * ( 0: (n-1)) *  handles.RecStruct.Gap ; 

siglist = 1:nsig ; 

for cnt = 1:naxes
    nextlist = siglist( find(axesdata == axesunique(cnt) ) ) ;  %#ok<*FNDSB>
    subplot( naxes , 1 , cnt )   ;
    plot( t , RecVec(nextlist,:) ) ; 
    set(gca, 'TickLabelInterpreter', 'none');
    legend(RecNames{nextlist} ) ;  
end 
RecNames = setdiff(transpose(fieldnames(RecStr)) ,{'t','Ts'} ) ; 
save( handles.SaveFile, 'RecVec' , 't' ,'RecNames','RecStr') ;


function EditNPoint_Callback(hObject, eventdata, handles)
% hObject    handle to EditNPoint (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of EditNPoint as text
%        str2double(get(hObject,'String')) returns contents of EditNPoint as a double
try 
    npoints = str2num(get( handles.EditNPoint ,'String' ) ) ;
catch 
    npoints = handles.RecStruct.Len ; 
end 
if npoints < 3 || npoints > handles.FullRecLen  
    npoints = handles.RecStruct.Len ; 
end 
handles.RecStruct.Len = npoints ; 
set( handles.EditNPoint ,'String' , num2str(handles.RecStruct.Len)  ) ; 
set( handles.TextTotalTime ,'String', num2str(handles.RecStruct.Gap * handles.ActTs * handles.RecStruct.Len ) ) ; 
handles = GetRecrderTs(handles); 
guidata(hObject, handles);



% --- Executes during object creation, after setting all properties.
function EditNPoint_CreateFcn(hObject, eventdata, handles)
% hObject    handle to EditNPoint (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function EditNGap_Callback(hObject, eventdata, handles)
% hObject    handle to EditNGap (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of EditNGap as text
%        str2double(get(hObject,'String')) returns contents of EditNGap as a double

try 
    ngap = str2num(get( handles.EditNGap ,'String' ) ) ;
catch 
    ngap = handles.RecStruct.Gap ; 
end 
if ngap < 1 || ngap > 4096 
    ngap = handles.RecStruct.Gap ; 
end 
handles.RecStruct.Gap = ngap ; 
set( handles.EditNGap ,'String' , num2str(handles.RecStruct.Gap)  ) ; 

set( handles.TextTotalTime ,'String', num2str(handles.RecStruct.Gap * handles.ActTs * handles.RecStruct.Len ) ) ; 

guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function EditNGap_CreateFcn(hObject, eventdata, handles)
% hObject    handle to EditNGap (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in CheckSyncToC.
function CheckSyncToC_Callback(hObject, eventdata, handles)
% hObject    handle to CheckSyncToC (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of CheckSyncToC
handles.RecStruct.Sync2C = get(handles.CheckSyncToC,'Value' ) ;
if handles.RecStruct.Sync2C
    handles.ActTs = handles.CTs * 1e-6  ; 
else
    handles.ActTs = handles.ShortTs * 1e-6 ;
end 
set ( handles.TextSamplingTime,'String',['Ts(sec): ', num2str(handles.ActTs) ]) ;
set( handles.TextTotalTime ,'String', num2str(handles.RecStruct.Gap * handles.ActTs * handles.RecStruct.Len ) ) ; 
guidata(hObject, handles);



function EditNFigure_Callback(hObject, eventdata, handles)
% hObject    handle to EditNFigure (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of EditNFigure as text
%        str2double(get(hObject,'String')) returns contents of EditNFigure as a double
try 
    nfig = str2num(get( handles.EditNFigure ,'String' ) ) ;
catch 
    nfig = handles.DrawFig ; 
end 
if nfig < 1 || nfig > 4096 
    nfig = handles.DrawFig ; 
end 
handles.DrawFig = nfig ; 
set( handles.EditNFigure ,'String' , num2str(handles.DrawFig)  ) ; 
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function EditNFigure_CreateFcn(hObject, eventdata, handles)
% hObject    handle to EditNFigure (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function EditMatFile_Callback(hObject, eventdata, handles)
% hObject    handle to EditMatFile (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of EditMatFile as text
%        str2double(get(hObject,'String')) returns contents of EditMatFile as a double
mfile = get( handles.EditMatFile ,'String' )  ;
handles.SaveFile = mfile ;  
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function EditMatFile_CreateFcn(hObject, eventdata, handles)
% hObject    handle to EditMatFile (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in PushSaveSetup.
function PushSaveSetup_Callback(hObject, eventdata, handles)
% hObject    handle to PushSaveSetup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles = GetRecrderTs(handles); 
guidata(hObject, handles);
RecSelect = handles.RecSelect ;  %#ok<NASGU>
AxisSelect = handles.AxisSelect ;  %#ok<NASGU>
DrawFig = handles.DrawFig ;  %#ok<NASGU>
SaveFile = handles.SaveFile ;  %#ok<NASGU>
Len = handles.RecStruct.Len   ;  %#ok<NASGU>
Gap = handles.RecStruct.Gap   ;  %#ok<NASGU>
Sync2C = handles.RecStruct.Sync2C ;  %#ok<NASGU>
uisave({'RecSelect','AxisSelect','DrawFig','SaveFile','Gap','Len','Sync2C' },'RecSavedSetup')
% save ('RecSavedSetup.mat','RecSelect','AxisSelect','DrawFig','SaveFile','Gap','Len','Sync2C' ) ;


% --- Executes on button press in PushBringRec.
function PushBringRec_Callback(hObject, eventdata, handles)
% hObject    handle to PushBringRec (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles = GetRecrderTs(handles); 
guidata(hObject, handles);

RecorderGeneric(hObject, eventdata, handles , struct( 'InitRec' , 0 , 'BringRec' , 1 ,'ProgRec' , 0 ) ) ;


% --- Executes on button press in TagInitRec.
function TagInitRec_Callback(hObject, eventdata, handles)
% hObject    handle to TagInitRec (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles = GetRecrderTs(handles); 
guidata(hObject, handles);
RecorderGeneric(hObject, eventdata, handles , struct( 'InitRec' , 1 , 'BringRec' , 0  , 'ProgRec' , 1 ) ) ;


% --- Executes on button press in PushProgramRec.
function PushProgramRec_Callback(hObject, eventdata, handles)
% hObject    handle to PushProgramRec (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles = GetRecrderTs(handles); 
guidata(hObject, handles);
RecorderGeneric(hObject, eventdata, handles , struct( 'InitRec' , 0 , 'BringRec' , 0 ,'ProgRec' , 1 ) ) ;


% --- Executes when selected cell(s) is changed in TableSigs.
function TableSigs_CellSelectionCallback(hObject, eventdata, handles)
% hObject    handle to TableSigs (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.CONTROL.TABLE)
%	Indices: row and column indices of the cell(s) currently selecteds
% handles    structure with handles and user data (see GUIDATA)
if isempty( eventdata.Indices) 
    return 
end 

row = eventdata.Indices(1) ; 
col = eventdata.Indices(2) ; 

nRec = length(handles.RecSelect);
if ( row > nRec ) 
    % Selection of empty line 
    return 
end 
olddata = get( handles.TableSigs,'Data' ) ;
sel = row ; 

if ( col == 1 ) 
    % Signal select 
    RemovedCheck = handles.RecSelect(sel) ; 
    handles.RecSelect(sel) = [] ; 
    handles.AxisSelect(sel) = [] ; 

    data = cell(16,2) ; 
    olddata(sel,:) = [] ; 
    data(1:15,:) = olddata ; 
    set( handles.TableSigs, 'Data' , data ) ; 
  
    set( handles.TextNumPoints , 'String' , ['Max Pts: ',num2str( fix( handles.FullRecLen/ max( [1,length(handles.RecSelect)]) ) )] ) ; 

    % Kill the check 
    handles.Sig2NodeMap{ RemovedCheck }.Checked = 0 ; 
end 
if ( col == 2 ) 
    junk = cell ( 1 , nRec ) ; 
    for cnt = 1:nRec  
        junk{cnt} = num2str(cnt) ; 
    end 
    [SELECTION,OK] = listdlg('ListString',junk,'SelectionMode','single');
    if ~(OK == 1) || ~(length(SELECTION) == 1)  
        disp( 'Ilegal graph selection, rejected' ) ;
        return ;
    end
    handles.AxisSelect(sel) = SELECTION ; 
    olddata( row,2) = { num2str(SELECTION) } ; 
    set( handles.TableSigs, 'Data' , olddata ) ; 
end 

guidata(hObject, handles);


% --- Executes on button press in PushClearAll.
function PushClearAll_Callback(hObject, eventdata, handles)
% hObject    handle to PushClearAll (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if ~isempty( handles.RecSelect) 
    nSelect = length(handles.RecSelect ) ;
    for cnt = 1:nSelect
        handles.Sig2NodeMap{ handles.RecSelect(cnt) }.Checked = 0 ; 
    end 
end 
set( handles.TableSigs, 'Data' , [] ) ; 
guidata(hObject, handles);


% --- Executes on button press in PushEnumerateSIg.
function PushEnumerateSIg_Callback(hObject, eventdata, handles)
% hObject    handle to PushEnumerateSIg (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.AxisSelect = 1:length(handles.AxisSelect)  ;
nSelect = length(handles.RecSelect ) ;
for cnt = 1:nSelect 
    handles.Sig2NodeMap{ handles.RecSelect(cnt) }.UserData(2) = handles.AxisSelect(cnt) ; 
end
data = cell(16,2) ; 
strnames = handles.RecNames(handles.RecSelect) ; 
for cnt = 1:16
    if cnt <= length(handles.RecSelect) 
        data(cnt,1) = {strnames{cnt}} ;  
        data(cnt,2) = {num2str(handles.AxisSelect(cnt) )} ; 
    end 
end
set( handles.TableSigs, 'Data' , data ) ; 


guidata(hObject, handles);


% --- Executes on button press in PushProgUser.
function PushProgUser_Callback(hObject, eventdata, handles)
% hObject    handle to PushProgUser (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles = GetRecrderTs(handles); 
guidata(hObject, handles);

% Get the use file of instructions and evaluate it 
[FileName,PathName] = uigetfile('*.m','Select the recorder def m file');
% fname = [PathName,FileName]; 
try 
    [RecStructUser,options] = eval([FileName(1:end-2),'(handles);']) ; 
    handles.RecStruct = MergeStruct( handles.RecStruct , RecStructUser  );  
    RecorderGeneric(hObject, eventdata, handles , options , 1) ;
catch 
    disp( 'Failed fetching user file, rejected' ) ;
    return ;    
end 


% --- Executes on button press in pushbutton9.
function pushbutton9_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
DataType = GetDataType() ; 
SendObj( [hex2dec('2000'),100,handles.RecStruct.TargetCanId] , 1 , DataType.short  , 'Set the recorder on' ) ;
disp( 'Triggering (assumed programmed) recorder' ) ;



function EditTrigPercent_Callback(hObject, eventdata, handles)
% hObject    handle to EditTrigPercent (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of EditTrigPercent as text
%        str2double(get(hObject,'String')) returns contents of EditTrigPercent as a double
try 
    nperc = str2num(get( handles.EditTrigPercent ,'String' ) ) ;
catch 
    nperc = handles.PreTrigPercent ; 
end 
if nperc < 0 || nperc > 100  
    nperc = handles.PreTrigPercent ; 
end 
handles.PreTrigPercent = nperc ; 
set( handles.EditTrigPercent ,'String' , num2str(handles.PreTrigPercent)  ) ; 
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function EditTrigPercent_CreateFcn(hObject, eventdata, handles)
% hObject    handle to EditTrigPercent (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in ComboTrigType.
function ComboTrigType_Callback(hObject, eventdata, handles)
% hObject    handle to ComboTrigType (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns ComboTrigType contents as cell array
%        contents{get(hObject,'Value')} returns selected item from ComboTrigType


% --- Executes during object creation, after setting all properties.
function ComboTrigType_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ComboTrigType (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in PushTriggerFlag.
function PushTriggerFlag_Callback(hObject, eventdata, handles)
% hObject    handle to PushTriggerFlag (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
DataType = GetDataType() ; 
SendObj( [hex2dec('2000'),101,handles.RecStruct.TargetCanId] , 1 , DataType.short  , 'Set the recorder trigger flag' ) ;
disp( 'Trigger flag issued' ) ;


% --- Executes on button press in PushLoadSetup.
function PushLoadSetup_Callback(hObject, eventdata, handles)
% hObject    handle to PushLoadSetup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

hbup = handles ; 
[RecSetup,handles] = LoadRecSetup([],handles ) ;
if isempty(RecSetup) 
    return ; 
end

if ~isempty( hbup.RecSelect)
    nSelect = length(hbup.RecSelect ) ;
    for cnt = 1:nSelect
        handles.Sig2NodeMap{ hbup.RecSelect(cnt) }.UserData(2) = [] ; 
        handles.Sig2NodeMap{ hbup.RecSelect(cnt) }.Checked = 0 ; 
    end 
end 

if ~isempty( handles.RecSelect) 
    nSelect = length(handles.RecSelect ) ;
    for cnt = 1:nSelect
        handles.Sig2NodeMap{ handles.RecSelect(cnt) }.UserData(2) = handles.AxisSelect(cnt) ; 
        handles.Sig2NodeMap{ handles.RecSelect(cnt) }.Checked = 1 ; 
    end 
end 
handles = WriteRecTable(handles,RecSetup) ; 
guidata(hObject, handles);


% --- Executes on button press in CheckBlockUpload.
function CheckBlockUpload_Callback(hObject, eventdata, handles)
% hObject    handle to CheckBlockUpload (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if ~handles.BlockSupport
    set(handles.CheckBlockUpload,'Value',0)  ; 
end
% Hint: get(hObject,'Value') returns toggle state of CheckBlockUpload


% --- Executes on button press in ButtonSelectTrigger.
function ButtonSelectTrigger_Callback(hObject, eventdata, handles)
% hObject    handle to ButtonSelectTrigger (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.SelectTrigger = 1 ; 

ttype = handles.ComboTrigType.String{handles.ComboTrigType.Value} ;
arg = struct('TriggerType',ttype,'TrigVal',str2num(get(handles.EditTriggerValue,'String')) ,'TrigPercent',str2num(get(handles.EditTrigPercent,'String'))); 

h = TriggerSel(arg,handles.RecStruct)  ; 

while isvalid(h) 
    pause(0.2) ; 
end 

x =  load('TrigSelect') ;
desc = x.desc ; 
if isempty( desc.Descriptor) 
    return 
end 

handles.TrigSelect = desc ; 
set( handles.EditTrigPercent ,'String' , num2str(x.desc.Percent) ); 
handles.PreTrigPercent = x.desc.Percent ;

handles.ComboTrigType.Value = find( strcmpi(handles.ComboTrigType.String,desc.Action)) ; 

handles.RecStruct.TrigVal = desc.TrigVal ;
set(handles.edit6,'String',desc.Descriptor.Text) ;
set(handles.EditTriggerValue,'String',desc.TrigVal) ;


guidata(hObject, handles);



function edit6_Callback(hObject, eventdata, handles)
% hObject    handle to edit6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit6 as text
%        str2double(get(hObject,'String')) returns contents of edit6 as a double


% --- Executes during object creation, after setting all properties.
function edit6_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function EditTriggerValue_Callback(hObject, eventdata, handles)
% hObject    handle to EditTriggerValue (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of EditTriggerValue as text
%        str2double(get(hObject,'String')) returns contents of EditTriggerValue as a double


% --- Executes during object creation, after setting all properties.
function EditTriggerValue_CreateFcn(hObject, eventdata, handles)
% hObject    handle to EditTriggerValue (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
