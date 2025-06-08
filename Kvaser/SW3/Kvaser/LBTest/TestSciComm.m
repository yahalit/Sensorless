% Software test for SCI communication 
rxstr = struct('Payload',[],'Next',[],'TxCtr',[],'OpCode',[],'TimeTag',[],'Odd',0) ; 

% Kill configuration - so periodic message does not transmit 
[msg,~] = BuildConfigurationMessage(0,0,0.1,0) ; % hex2dec('F123456F'),0) ; 
write(s,msg,'uint8'); 
pause( 0.1); 

% Kill RX buffer 
flush(s) ; 

% Get kill ack 
[msg,~] = BuildConfigurationMessage(0,0,hex2dec('F123456F'),0) ; 
write(s,msg,'uint8'); 
pause( 0.1); 
kaka = read( s , s.NumBytesAvailable , 'uint8'); 
[errcode ,rxstr] =VerifyAck(rxstr,kaka) ; 
if errcode 
    error ('Acknowledge failure for kill config') ; 
end

% Build acknowledgerequest , get answer
% ss = BuildHostSciString( [] , 0  ); 
% write(s,ss,'uint8'); 
% pause( 0.1); 
% kaka = read( s , s.NumBytesAvailable , 'uint8'); 
% [errcode ,rxstr] =VerifyAck(rxstr,kaka) ; 
% if errcode 
%     error ('Acknowledge failure for ack request') ; 
% end

% Build clear queue , get answer
Qindex = 0 ; 
[msg,~] = BuildClearQueueMessage( Qindex  ) ;
write(s,msg,'uint8'); 
pause( 0.1); 
kaka = read( s , s.NumBytesAvailable , 'uint8'); 
[errcode ,rxstr] =VerifyAck(rxstr,kaka,0) ; 
if errcode 
    error ('Acknowledge failure for clear queue') ; 
end

%delete later - second try for clear queue, get answer
% [msg,~] = BuildClearQueueMessageSameLikeAll( ) ; 
% write(s,msg,'uint8'); 
% pause( 0.1); 
% kaka = read( s , s.NumBytesAvailable , 'uint8'); 
% [errcode ,rxstr] =VerifyAck(rxstr,kaka,0) ; 
% if errcode 
%     error ('Acknowledge failure for handle package message') ; 
% end



% Build handle package, get answer
[msg,~] = BuildHandlePackageMessage( ) ; 
write(s,msg,'uint8'); 
pause( 0.1); 
kaka = read( s , s.NumBytesAvailable , 'uint8'); 
[errcode ,rxstr] =VerifyAck(rxstr,kaka,0) ; 
if errcode 
    error ('Acknowledge failure for handle package message') ; 
end


% Build Emergency Stop message, get answer
[msg,~] = BuildEmergencyStopMessage( ) ; 
write(s,msg,'uint8'); 
pause( 0.1); 
kaka = read( s , s.NumBytesAvailable , 'uint8'); 
[errcode ,rxstr] =VerifyAck(rxstr,kaka,0) ; 
if errcode 
    error ('Acknowledge failure for emergncy stop message') ; 
end

% Build Deviation Report message, get answer
[msg,~] = BuildDeviationReportMessage( ) ; 
write(s,msg,'uint8'); 
pause( 0.1); 
kaka = read( s , s.NumBytesAvailable , 'uint8'); 
[errcode ,rxstr] =VerifyAck(rxstr,kaka,0) ; 
if errcode 
    error ('Acknowledge failure for deviation report message') ; 
end

% Build Position Report message, get answer
[msg,~] = BuildPositionReportMessage( ) ; 
write(s,msg,'uint8'); 
pause( 0.1); 
kaka = read( s , s.NumBytesAvailable , 'uint8'); 
[errcode ,rxstr] =VerifyAck(rxstr,kaka,0) ; 
if errcode 
    error ('Acknowledge failure for position report message') ; 
end

% Build set queue execution pointer message, get answer
[msg,~] = BuildSetQueueExecutionPointerMessage( ) ; 
write(s,msg,'uint8'); 
pause( 0.1); 
kaka = read( s , s.NumBytesAvailable , 'uint8'); 
[errcode ,rxstr] =VerifyAck(rxstr,kaka,0) ; 
if errcode 
    error ('Acknowledge failure for set queue execution pointer message') ; 
end


% Build set queue entry message, get answer
[msg,~] = BuildSetQueueEntryMessage( ) ; 
write(s,msg,'uint8'); 
pause( 0.1); 
kaka = read( s , s.NumBytesAvailable , 'uint8'); 
[errcode ,rxstr] =VerifyAck(rxstr,kaka,0) ; 
if errcode 
    error ('Acknowledge failure for set queue execution pointer message') ; 
end

% Build Set Parameter message, get answer
[msg,~] = BuildSetParameterMessage( ) ; 
write(s,msg,'uint8'); 
pause( 0.1); 
kaka = read( s , s.NumBytesAvailable , 'uint8'); 
[errcode ,rxstr] =VerifyAck(rxstr,kaka,0) ; 
if errcode 
    [txt,txtelab] = Errtext( errcode );
    error (['Acknowledge failure for Set Parameter message code:',num2str(errcode),': ',txt,' : ',txtelab]) ; 
end

% Build Set Configuration Message, get answer
[msg,~] = BuildConfigurationMessage( 0.5,0.6, 1) ; 
%function [msg,str] = BuildConfigurationMessage( BitPeriod , StatusPeriod, RCVersion ) 
write(s,msg,'uint8'); 
pause( 3); 
kaka = read( s , s.NumBytesAvailable , 'uint8'); 
[msg,~] = BuildConfigurationMessage(0,0,0,hex2dec('F123456F'),0) ; 
write(s,msg,'uint8'); 
pause( 0.1); 
flush(s) ;
[opcodes,times,msgs] = TestMessageStatistics(kaka); 


