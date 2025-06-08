success = KvaserCom(1) ; 
DataType=struct( 'long' , 0 , 'float', 1 , 'short' , 2 , 'char' , 3 ,'string', 9 ,'lvec' , 10 ,'fvec' , 11 , 'ulvec' , 20 ) ; 
RecStruct = struct('Gap',1,'Len',300,'TrigSig',26,'TrigVal',2,'TrigType',1) ; 

% Download a single expedit SDO 
stat = KvaserCom( 7 , [1536+124 ,1408+124 ,8192,1,DataType.short,0,100], RecStruct.Gap ); % Recorder gap 
if stat , error ('Sdo failure') ; end 
stat = KvaserCom( 7 , [1536+124 ,1408+124 ,8192,2,DataType.short,0,100], RecStruct.Len ); % Recorder rec len 
if stat , error ('Sdo failure') ; end 
stat = KvaserCom( 7 , [1536+124 ,1408+124 ,8192,3,DataType.short,0,100], 5 ); % Number of recorded vars 
if stat , error ('Sdo failure') ; end 
stat = KvaserCom( 7 , [1536+124 ,1408+124 ,8192,4,DataType.short,0,100], 0 ); % Set trigger to immediate
if stat , error ('Sdo failure') ; end 
stat = KvaserCom( 7 , [1536+124 ,1408+124 ,8192,5,DataType.short,0,100], 3 ); % Pre trigger cnt 
if stat , error ('Sdo failure') ; end 
stat = KvaserCom( 7 , [1536+124 ,1408+124 ,8192,6,DataType.short,0,100], 0 ); % Set Time basis
if stat , error ('Sdo failure') ; end 

stat = KvaserCom( 7 , [1536+124 ,1408+124 ,8192,10,DataType.short,0,100], 16 );  % Program recorder entries
if stat , error ('Sdo failure') ; end 
stat = KvaserCom( 7 , [1536+124 ,1408+124 ,8192,11,DataType.short,0,100], 19 );  
if stat , error ('Sdo failure') ; end 
stat= KvaserCom( 7 , [1536+124 ,1408+124 ,8192,12,DataType.short,0,100], 25 ); 
if stat , error ('Sdo failure') ; end 
stat= KvaserCom( 7 , [1536+124 ,1408+124 ,8192,13,DataType.short,0,100], 26 ); 
if stat , error ('Sdo failure') ; end 
stat= KvaserCom( 7 , [1536+124 ,1408+124 ,8192,14,DataType.short,0,100], 27 ); 
if stat , error ('Sdo failure') ; end 

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

% Get the actual number of records 
numrec  = KvaserCom( 8 , [1536+124 ,1408+124 ,8192,2,DataType.short,0,100] ); % Get num records 
% Get the list of actual records 
listlen = KvaserCom( 8 , [1536+124 ,1408+124 ,8192,3,DataType.short,0,100] ); % List length
% For all the list members, get their attributes 
ListItems = zeros(listlen,2) ; 
for cnt = 1:listlen, 
    Next = KvaserCom( 8 , [1536+124 ,1408+124 ,8192,9+cnt,DataType.long,0,100] ); % List length
    ListItems(cnt,1) = mod( Next , 65536 ) ; 
    ListItems(cnt,2) = fix( Next / 65536 ) ; 
end     

RecVec = zeros(listlen,numrec) ; 
for cnt = 0:120:numrec-1  
% Bring recorder SDO 
    % Signal index
    stat= KvaserCom( 7 , [1536+124 ,1408+124 ,8192,8,DataType.short,0,100], cnt ); % Select the first to bring 0 
    if stat , error ('Sdo failure') ; end 
    LastCnt =  min(cnt+119,numrec-1); 
    stat= KvaserCom( 7 , [1536+124 ,1408+124 ,8192,9,DataType.short,0,100],LastCnt ); % Select the last to bring 
    if stat , error ('Sdo failure') ; end 

    for csig = 1:listlen,
        stat= KvaserCom( 7 , [1536+124 ,1408+124 ,8192,7,DataType.short,0,100], csig-1 ); % Select the signal to record 
        if stat , error ('Sdo failure') ; end 
        
        if ( ListItems(csig,2) == 2 )
            s1 = KvaserCom( 8 , [1536+124 ,1408+124 ,8192,100,DataType.fvec,0,100] ); % Get records
        else
            s1 = KvaserCom( 8 , [1536+124 ,1408+124 ,8192,100,DataType.ulvec,0,100] ); % Get records
        end
        RecVec( csig , (cnt+1):(LastCnt+1)) = s1 ;  
    end 
end