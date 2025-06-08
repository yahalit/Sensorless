ProjectDir = 'C:\Nimrod\Software\PDSoft\';
success = KvaserCom(1) ; 
DataType=struct( 'long' , 0 , 'float', 1 , 'short' , 2 , 'char' , 3 ,'string', 9 ,'lvec' , 10 ,'fvec' , 11 , 'ulvec' , 20 ) ; 
RecStruct = struct('Gap',1,'Len',300,'TrigSig',26,'TrigVal',2,'TrigType',1,'Signals',[16,19,25,26,28],...
    'Sync2C', 0 ,'PreTrigCnt', 150 , 'SigList' , {ReadSigList( [ProjectDir,'Application\ProjRecorderSignals.h'])} ) ; 

RecNames = {'Volts5','Volts12_0','Cur12','Buck12_Exception','Buck12_MotorOn'} ; 
[RecStruct.Signals] = ImportRecSignals(RecStruct.SigList, RecNames ) ; 
RecStruct.SigNames = RecNames; 

% Just clear the state of the SDO machine by dummy read
junk  = KvaserCom( 8 , [1536+124 ,1408+124 ,8192,2,DataType.short,0,100] ); % Get num records 

% Download a single expedit SDO 
stat = KvaserCom( 7 , [1536+124 ,1408+124 ,8192,1,DataType.short,0,100], RecStruct.Gap ); % Recorder gap 
if stat , error ('Sdo failure') ; end 
stat = KvaserCom( 7 , [1536+124 ,1408+124 ,8192,2,DataType.short,0,100], RecStruct.Len ); % Recorder rec len 
if stat , error ('Sdo failure') ; end 
stat = KvaserCom( 7 , [1536+124 ,1408+124 ,8192,3,DataType.short,0,100], length(RecStruct.Signals) ); % Number of recorded vars 
if stat , error ('Sdo failure') ; end 
stat = KvaserCom( 7 , [1536+124 ,1408+124 ,8192,4,DataType.short,0,100], RecStruct.TrigType ); % Set trigger to type immediate,rising,falling
if stat , error ('Sdo failure') ; end 
stat = KvaserCom( 7 , [1536+124 ,1408+124 ,8192,5,DataType.short,0,100], RecStruct.PreTrigCnt ); % Pre trigger cnt 
if stat , error ('Sdo failure') ; end 
stat = KvaserCom( 7 , [1536+124 ,1408+124 ,8192,6,DataType.short,0,100], RecStruct.Sync2C ); % Set Time basis
if stat , error ('Sdo failure') ; end 
stat = KvaserCom( 7 , [1536+124 ,1408+124 ,8192,50,DataType.short,0,100], RecStruct.TrigSig ); % Set trigger signal 
if stat , error ('Sdo failure') ; end 
fval = fix(RecStruct.TrigVal );
if ( fval == RecStruct.TrigVal ) 
    stat = KvaserCom( 7 , [1536+124 ,1408+124 ,8192,52,DataType.long,0,100], RecStruct.TrigVal ); % Set trigger signal 
    if stat , error ('Sdo failure') ; end 
else
    stat = KvaserCom( 7 , [1536+124 ,1408+124 ,8192,52,DataType.float,0,100], RecStruct.TrigVal ); % Set trigger signal 
    if stat , error ('Sdo failure') ; end 
end 

for cnt = 1:length(RecStruct.Signals) 
    stat = KvaserCom( 7 , [1536+124 ,1408+124 ,8192,9+cnt,DataType.short,0,100], RecStruct.Signals(cnt) );  % Program recorder entries
    if stat , error ('Sdo failure') ; end 
end 

stat= KvaserCom( 7 , [1536+124 ,1408+124 ,8192,100,DataType.short,0,100], 1 ); % Set the recorder on
if stat , error ('Sdo failure') ; end 

% Wait recorder ready 
for cnt = 1:100, 
    s99= KvaserCom( 8 , [1536+124 ,1408+124 ,8192,99,DataType.short,0,100] ); % Get records
    if ( s99 == 23 ) 
        break; % Activated and ready 
    end 
    if ( cnt == 100) 
        error ('Recorder did not complete on time') ; 
    end 
    pause(0.01) ; 
end

GetSignals ; 
