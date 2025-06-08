% Software test for SCI communication 
rxstr = struct('Payload',[],'Next',[],'TxCtr',[],'OpCode',[],'TimeTag',[],'Odd',0) ; 

% Kill configuration - so periodic message does not transmit 
[msg,~] = BuildConfigurationMessage(0,0,hex2dec('F123456F')) ; 
write(s,msg,'uint8'); 
pause( 0.1); 

% Kill RX buffer 
flush(s) ; 

% Get kill ack 
[msg,~] = BuildConfigurationMessage(0,0,hex2dec('F123456F')) ; 
write(s,msg,'uint8'); 
pause( 0.1); 
kaka = read( s , s.NumBytesAvailable , 'uint8'); 
[errcode ,rxstr] =VerifyAck(rxstr,kaka) ; 
if errcode 
    error ('Acknowledge failure for kill config') ; 
end

% Build acknowledgerequest , get answer
ss = BuildHostSciString( [] , 0  ); 
write(s,ss,'uint8'); 
pause( 0.1); 
kaka = read( s , s.NumBytesAvailable , 'uint8'); 
[errcode ,rxstr] =VerifyAck(rxstr,kaka) ; 
if errcode 
    error ('Acknowledge failure for ack request') ; 
end

% Build clear queue , get answer
Qindex = 0 ; 
[msg,~] = BuildClearQueueMessage( Qindex  ) ;
write(s,msg,'uint8'); 
pause( 0.1); 
kaka = read( s , s.NumBytesAvailable , 'uint8'); 
[errcode ,rxstr] =VerifyAck(rxstr,kaka,1) ; 
if errcode 
    error ('Acknowledge failure for clear queue') ; 
end

