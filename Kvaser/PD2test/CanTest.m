AtpStart;

RecNames = {'UsecTimer'} ; 
RecStruct.TrigType = 0 ; % Immediate record 
RecStruct.Gap = 4 ; 
RecStruct.Sync2C = 0 ; 


% uiwait(msgbox('Connect Kvaser ro CAN ','Attention','modal'));

disp( 'Wait up to 30 seconds...') 
options = struct( 'InitRec' , 1 , 'BringRec' , 0 ,'ProgRec' , 1 ); 
RecVec = Recorder(RecNames , RecStruct , options ) ;
d = diff( RecVec) ; 
d = d(find(d)) ;  %#ok<FNDSB>
if  any ( d < 4120 & d > 4090 ) 
   disp( 'CAN Test + CPU timing passed ok') ;  
else
   disp( 'CAN Test + CPU timing incorrect records - FAIL') ;  
end 


