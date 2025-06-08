global DataType 
% Issue queue start and run the recorder immediately on start

% End the queue
NextPt = NextPt + 1 ; 
[str,~] = SpiSetPathWait( 1 , NextPt , inf ,SpiDoTx  ) ;
try 
    SendObj( [hex2dec('2000'),100] , 1 , DataType.short , 'Recorder start' ) ;
catch 
end
[str,~] = SpiQueueExec( 1 , 0 , 1 , SpiDoTx  ) ; 