function varargout = TreeTry(varargin)
% TREETRY MATLAB code for TreeTry.fig
%      TREETRY, by itself, creates a new TREETRY or raises the existing
%      singleton*.
%
%      H = TREETRY returns the handle to a new TREETRY or the handle to
%      the existing singleton*.
%
%      TREETRY('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in TREETRY.M with the given input arguments.
%
%      TREETRY('Property','Value',...) creates a new TREETRY or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before TreeTry_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to TreeTry_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help TreeTry

% Last Modified by GUIDE v2.5 01-Apr-2017 13:35:50

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @TreeTry_OpeningFcn, ...
                   'gui_OutputFcn',  @TreeTry_OutputFcn, ...
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


% --- Executes just before TreeTry is made visible.
function TreeTry_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to TreeTry (see VARARGIN)

% Choose default command line output for TreeTry
handles.output = hObject;

% Generate a tree control 
%% Create the figure and display the tree
% Copyright 2012-2014 The MathWorks, Inc.

import uiextras.jTree.*
t = CheckboxTree('Parent',handles.PanelTree);

%% Create tree nodes
Node1 = CheckboxTreeNode('Name','Node_1','Parent',t.Root);
Node1_1 = CheckboxTreeNode('Name','Node_1_1','Parent',Node1,'TooltipString','Node1_1','TooltipString','BabAlla');
Node1_2 = CheckboxTreeNode('Name','Node_1_2','Parent',Node1,'TooltipString','Node1_2','TooltipString','BabMustafa');
Node2 = CheckboxTreeNode('Name','Node_2','Parent',t.Root);

%% Select nodes
t.SelectionType = 'discontiguous';
% t.SelectedNodes = [Node1_2 Node1];

%% Drag and drop
t.DndEnabled = false;

t.Editable = false;

%% Hide the root
t.RootVisible = false;


t.Enable = true;


% Update handles structure
guidata(hObject, handles);

% UIWAIT makes TreeTry wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = TreeTry_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;
