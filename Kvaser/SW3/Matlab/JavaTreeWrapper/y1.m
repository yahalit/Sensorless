% Generate a tree control 
%% Create the figure and display the tree
% Copyright 2012-2014 The MathWorks, Inc.

import uiextras.jTree.*
f = figure ; 
t = CheckboxTree('Parent',f);

%% Create tree nodes
Node1 = CheckboxTreeNode('Name','Node_1','Parent',t.Root);
Node1_1 = CheckboxTreeNode('Name','Node_1_1','Parent',Node1,'TooltipString','BabAlla');
Node1_2 = CheckboxTreeNode('Name','Node_1_2','Parent',Node1,'TooltipString','BabMustafa');
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
