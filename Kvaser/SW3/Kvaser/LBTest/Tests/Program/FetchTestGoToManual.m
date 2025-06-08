% global DataType
% rdy = FetchObj( [hex2dec('2000'),101] , DataType.long , 'Recorder flag' ) ;
% if rdy
%     disp( 'Event did not happen, recorder is not loaded') ; 
%     return ;
% end

load ProgTest2Manual
[~,~,r] = Recorder(RecNames , L_RecStruct , RecBringAction   ); 
save('AnaProg2Manual.mat','r' ) ; 
t = r.t ; 
Ts = r.Ts ;
