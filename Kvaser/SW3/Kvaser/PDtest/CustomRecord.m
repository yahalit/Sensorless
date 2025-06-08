function [RecStructUser,options] = CustomRecord(handles) 
TrigTypes = struct('Immediate', 0 , 'Rising' , 1 , 'Falling' , 2 ,'Equal' , 3) ; 
TrigSigName = 'Buck24_MotorOn' ; 
%TrigSigName = 'Buck12_MotorOn' ; 
% TrigSigName = 'Buck12_Exception' ; 

TrigSig   = find( strcmp( handles.RecNames ,TrigSigName) , 1) ; 


% Gap and length taken from dialog 
RecStructUser = struct('TrigSig',TrigSig,'TrigType',TrigTypes.Rising ,'TrigVal',1) ; 
%,...
%    'Sync2C', 0 , 'Gap' , 1 , 'Len' , 600 ) ; 
% Pre trigger delay is taken from main menu
% RecStructUser.PreTrigPercent = 0.3 ;

options = struct( 'InitRec' , 1 , 'BringRec' , 0 ,'ProgRec' , 1 ); 
