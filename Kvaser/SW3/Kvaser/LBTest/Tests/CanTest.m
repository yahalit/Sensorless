AtpStart;

RecNames = {'UsecTimer'} ; 
RecStruct.TrigType = 0 ; % Immediate record 
RecStruct.Gap = 4 ; 
RecStruct.Sync2C = 0 ; 


uiwait(msgbox('Connect Kvaser ro CAN #2','Attention','modal'));

disp( 'Wait up to 30 seconds...') 
RecVec = Recorder(RecNames , RecStruct  ) ;
d = diff( RecVec) ; 
d = d(find(d)) ;  %#ok<FNDSB>
if  any ( d < 4100 & d > 4090 ) 
   disp( 'CAN #2 Test + CPU timing passed ok') ;  
else
   disp( 'CAN #2 Test + CPU timing incorrect records - FAIL') ;  
end 

uiwait(msgbox('Connect Kvaser ro CAN #1','Attention','modal'));

disp( 'Wait up to 30 seconds...') 
RecVec = Recorder(RecNames , RecStruct  ) ;
d = diff( RecVec) ; 
d = d(find(d)) ;  %#ok<FNDSB>
if  any ( d < 4100 & d > 4090 ) 
   disp( 'CAN #1 Test + CPU timing passed ok') ;  
else
   disp( 'CAN #1 Test + CPU timing incorrect records - FAIL') ;  
end 


