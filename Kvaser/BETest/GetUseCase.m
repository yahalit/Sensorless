function U = GetUseCase() 
% function U = GetUseCase() : Get the use case of a project 

DataType = GetDataType();
u = GetCfgPar('UseCase') ; 
HomeDirection = FetchObj([hex2dec('2223'),0],DataType.long,'HomeDirection') ;
HomeMethod = FetchObj([hex2dec('2223'),1],DataType.long,'HomeMethod') ;
HomeSwInUse = FetchObj([hex2dec('2223'),1],DataType.long,'SwInUse') ;

CurrentCommandDir = FetchObj([hex2dec('2222'),5],DataType.float,'Current command direction') ;

U = struct( 'Pot1', bitand(u , 1) , 'Pot2', bitand(u , 2 ) / 2 ,'Sw1', bitand(u , 4 ) / 4 ,...
    'Sw2', bitand(u , 8 ) / 8 , ...
    'SupportHome', bitand(u , 16 ) / 16, 'FbLim', bitand(u , 32 ) / 32,...
    'PdoConfig',bitand(u , 64*7 ) / 64, 'PosModulo' ,bitand(u , 512 ) / 512 , ...
    'Brake' ,bitand(u , 1024 ) / 1024 ,'StartStop' ,bitand(u , 2048 ) / 2048 ,...
    'HomeDirection',HomeDirection,'HomeMethod',HomeMethod,'HomeSwInUse',HomeSwInUse,...
    'CurrentCommandDir',CurrentCommandDir ); 



end