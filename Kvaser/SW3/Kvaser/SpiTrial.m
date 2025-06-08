% Build the SPI message 
cmdmode = 0; 

switch  cmdmode , 
    case 1,
SpiMsgStr = struct('Preamble',hex2dec('ac13'),'TxCntr',5 , 'RflctCnt' , 7,'TimeTag' ,12345678, ...
    'MsgOpCode',2 ,...
    'qIndex',1,'EntryIndex',17,'qOpCode',1 , ...
    'Pos' ,[-1000,10000,-2222] , 'CosX' , 1111 , 'CosY' , 22222 , 'CosZ', -1222 )  ; 
    otherwise, 
SpiMsgStr = struct('Preamble',hex2dec('ac13'),'TxCntr',5 , 'RflctCnt' , 7,'TimeTag' ,12345678, ...
    'MsgOpCode',13 ,...
    'CobId',hex2dec('619') ,'dLen',8,'Payload',[1,2,3,4,5,6,7,8] )  ; 
end


SpiMsgBin = SimSpi( SpiMsgStr ) ; 


success = KvaserCom(1) ; 
DataType=struct( 'long' , 0 , 'float', 1 , 'short' , 2 , 'char' , 3 ,'string', 9 ,'lvec' , 10 ,'fvec' , 11 , 'ulvec' , 20 ) ; 

KvaserCom(1) ; 
stat = KvaserCom( 7 , [1536+124 ,1408+124 ,8193,1,DataType.string,0,100], SpiMsgBin ); % Recorder gap 
