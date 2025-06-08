% Get the actual number of records 
numrec  = KvaserCom( 8 , [1536+124 ,1408+124 ,8192,2,DataType.short,0,100] ); % Get num records 

% Get the list of actual records 
listlen = KvaserCom( 8 , [1536+124 ,1408+124 ,8192,3,DataType.short,0,100] ); % List length

if listlen ~= length(RecStruct.Signals) 
    error ( 'Actual number of signals is not as expected') ; 
end 


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