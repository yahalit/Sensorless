function [RecVec,recstruct,RecStr,errString] = Recorder(RecNames , recstruct , action  , CommFunc , TargetId ) 
% 
% recstruct
%       .TrigType:   0 = immediate 
%                       1 = Up trigger 
%                       2 = Dn trigger (by recstruct.TrigVal)  
%       .TrigSigName : Name of trigger signal 
%       .Sync2C: 
%                    1: Synchronize to major cycle, 0: Synchronize to minor cycle
% action: A struct with fields 
% .BlockUpLoad (default = 0) : Use fast block upload
% .T : Entire recording time (overrides length and gap definitions in recstruct) 
% If defined, also applies: 
%   .MaxLen         : Maximum per signal length 
%   .PreTrigPercent : If triggered, percents of signal before the trigger
global BitKillTime 
global AtpCfg 
global TargetCanId  
global TargetCanId2
RecStr = [] ;
RecVec = [] ;
errString = [] ;
second = [0 0 0 0 0 1];

if ( nargin < 4 || isempty(CommFunc) )
	CommFunc = AtpCfg.DefaultCom ;
end

if ( nargin < 5 || isempty(TargetId) )
    TargetId = struct('Id',TargetCanId,'Id2',TargetCanId2) ; 
else
    if ~isfield(TargetId,'Id2')
        TargetId.Id2 = TargetId.Id ; 
    end
end

    if nargin < 3  
        action = struct( 'InitRec' , 1 , 'BringRec' , 1 ,'ProgRec' , 1 ,'Struct' , 0  ) ; 
    end 

    if isfield( action , 'BlockUpLoad')
        blockupload = action.BlockUpLoad ; 
    else   
        if isfield(recstruct,'BlockUpLoad') 
            blockupload = recstruct.BlockUpLoad ; 
        else
            blockupload = 0 ; 
        end 
    end

    
    if ~isfield( action,'Struct') 
        action.Struct = 0 ; 
    end 
    
    if ~isfield(action,'OwnerFlag') 
        action.OwnerFlag = [] ; 
    end

    if action.InitRec 
        action.ProgRec = 1 ; 
    end 

    DataType = GetDataType() ; 

    %Added for compiled version debuging - do not delete.
	try 
        [recstruct.Signals,s2] = ImportRecSignals(recstruct.SigList, RecNames ) ; 
    catch ME
        uiwait( errordlg({'Recorder, ImportRecSignals issue, probably missing or problematic RecStruct (check if AtpStart ran). ';ME.message}) ); %added for debugging
		return
    end

    
    if any( ~s2) 
        if ~isfield(recstruct,'SigList2') 
            missing = RecNames(~s2) ; 
            disp('Missing recorder signals:') ; 
            disp(missing) ; 
            error ('Could not program recorder')  ;
        end 

        % One output arg - this time we want to emit an error if an item is still missing 
        recstruct.Signals = recstruct.Signals(s2); 
        recstruct.Signals2  = ImportRecSignals(recstruct.SigList2, RecNames(~s2) ) ; 
        nS2 = length(recstruct.Signals2);
        Sig2NameAtCpu1 = cell(1,nS2) ; 
        for c1 = 1:nS2 
            Sig2NameAtCpu1{c1} = ['Cpu2Signal_',num2str(c1)] ;
        end
        recstruct.Signals2AtCpu1  = ImportRecSignals(recstruct.SigList, Sig2NameAtCpu1 ) ;   
    else
        recstruct.Signals2 = [] ; 
    end
    
    recstruct.SigNames = RecNames; 
    % RecVec = [ ] ; 
    if action.ProgRec  

        if isfield( action,'T' ) 
            if ( action.T <= 0 )
                error ('Record time need be > 0') ; 
            end 
            if isfield( action,'MaxLen' )
                MaxLen = action.MaxLen ; 
            else
                MaxLen = [] ; 
            end
            [recstruct.Gap , recstruct.Len] = SetRecTime( action.T , length(RecNames) , recstruct.Sync2C  , MaxLen );
            if isfield( action,'PreTrigPercent') == 0 
                action.PreTrigPercent = 0 ; 
            end
            recstruct.PreTrigCnt = max(min(( action.PreTrigPercent * recstruct.Len / 100 ),recstruct.Len-3),3)  ;
        end 
        
        BitKillTime =  datevec(datenum(clock + 2* second)); 
        
        if isequal( CommFunc,@Comm2MatIntfc) 
            reclen_datatype = DataType.long ; 
        else
            reclen_datatype = DataType.short ; 
        end
        
        % Just clear the state of the SDO machine by dummy read
        FetchObj( [hex2dec('2000'),60,TargetId.Id] , DataType.long ,'FullRecLen') ;

        % Download a single expedit SDO 
        SendObj( [hex2dec('2000'),1,TargetId.Id] , recstruct.Gap , DataType.short , 'recstruct.Gap' ) ;
        SendObj( [hex2dec('2000'),2,TargetId.Id] , recstruct.Len , reclen_datatype  , 'recstruct.Len' ) ;
        SendObj( [hex2dec('2000'),3,TargetId.Id] , length(recstruct.Signals)+length(recstruct.Signals2) , DataType.short  , 'recstruct.Signals' ) ;
        SendObj( [hex2dec('2000'),4,TargetId.Id] , recstruct.TrigType , DataType.short  , 'recstruct.TrigType' ) ;
        SendObj( [hex2dec('2000'),5,TargetId.Id] , recstruct.PreTrigCnt , reclen_datatype  , 'recstruct.PreTrigCnt' ) ;
        SendObj( [hex2dec('2000'),6,TargetId.Id] , recstruct.Sync2C , DataType.short  , 'recstruct.Sync2C' ) ;

        if isfield(recstruct,'TrigSigName') 
            try 
                [~,recstruct.TrigSig] = GetSignal(recstruct.TrigSigName) ; 
            catch
            end
        end
        SendObj( [hex2dec('2000'),50,TargetId.Id] , recstruct.TrigSig , DataType.short  , 'recstruct.TrigSig' ) ;

        fval = fix(recstruct.TrigVal );
        if ( fval == recstruct.TrigVal ) 
            SendObj( [hex2dec('2000'),52,TargetId.Id] , recstruct.TrigVal , DataType.long  , 'recstruct.TrigVal' ) ;
        else
            SendObj( [hex2dec('2000'),53,TargetId.Id] , recstruct.TrigVal , DataType.float  , 'recstruct.TrigVal' ) ;
        end 

        L1 = length(recstruct.Signals);
        for cnt = 1:L1
            SendObj( [hex2dec('2000'),9+cnt,TargetId.Id] , recstruct.Signals(cnt), DataType.short  , ['recstruct.Signals(',num2str(cnt),')'] ) ;
        end 
        
        for cnt = 1:length(recstruct.Signals2) 
        % Inform CPU2 to put the recorded signal in the IPC buffer
            SendObj( [hex2dec('2000'),9+cnt,TargetId.Id2] , recstruct.Signals2(cnt)-1, DataType.short  , ['recstruct.Signals2(',num2str(cnt),')'] ) ;
        % Inform CPU1 to take signal from IPC2 
            SendObj( [hex2dec('2000'),9+cnt+L1,TargetId.Id] , recstruct.Signals2AtCpu1(cnt), DataType.short  , ['recstruct.Signals2AtCpu1(',num2str(cnt),')'] ) ;
        end

        if  action.InitRec  
            if ~isempty(action.OwnerFlag)   
                SendObj( [hex2dec('2000'),100,TargetId.Id] , action.OwnerFlag , DataType.short  , 'Set the recorder on' ) ;
            else
                SendObj( [hex2dec('2000'),100,TargetId.Id] , 1 , DataType.short  , 'Set the recorder on' ) ;
            end
        else
            disp( 'Recorder has been programmed without starting') ; 
            return ;
        end 
    end % End recorder programming
    
    if ( action.BringRec == 0  ) 
        disp( 'Recorder has been initialized, use BringRec button to bring records') ; 
        return ;
    end 
    
    if recstruct.Sync2C 
        Ts = FetchObj( [hex2dec('2000'),63,TargetId.Id] , DataType.long ,'Get TS') ; 
    else
        Ts = FetchObj( [hex2dec('2000'),62,TargetId.Id] , DataType.short ,'Get TS') ; 
    end 
    Ts = Ts * recstruct.Gap * 1e-6 ;

    % Verify the recorder is correct 
    if ~isempty(action.OwnerFlag)
        RecOwner = FetchObj( [hex2dec('2000'),111,TargetId.Id] , DataType.long ,'Get Recorder owner') ; 
        if ~isequal( action.OwnerFlag , RecOwner ) 
            error( ['Recorder ownership mismatch: expected: ',num2str(action.OwnerFlag),'  Found: ',num2str(RecOwner) ]) ;
        end 
    end
    
    % Wait recorder ready 
    ExpectedRecTime = max( [Ts * recstruct.Len, 1e-4 ] )  ; 
    tStart = clock(); 
    disp( ['Expected time length for recorder (sec): ', num2str(ExpectedRecTime) ]) ; 
    for cnt = 1:100 
        BitKillTime =  datevec(datenum(clock + 2* second)); 
        s99 = FetchObj( [hex2dec('2000'),99,TargetId.Id] , DataType.short ,'Get records state') ; 
        if ( s99 == 23 ) 
            break; % Activated and ready 
        end 
        if ( cnt == 100) 
            errString = 'Recorder did not complete on time'; 
            if nargout >= 4 
                return ; 
            else
                error (errString) ; 
            end 
        end 
        
        if isequal( CommFunc , @Comm2MatIntfc ) 
            MatIntfc( 3 , ExpectedRecTime/90 ) ;           
        else
            if ( fix(cnt/10) * 10 == cnt ) 
                te = etime( clock , tStart ); 
                disp( ['Recording, elapsed (Sec) = ' , num2str( fix( te * 10) / 10  ) ] ) ; 
            end 
        end      
        pause(ExpectedRecTime/90) ; 
    end

%    GetSignals ; 
    % Get the actual number of records 
    numrec = FetchObj( [hex2dec('2000'),2,TargetId.Id] , DataType.short ,'Get num records ') ; 

    % Get the list of actual records 
    listlen = FetchObj( [hex2dec('2000'),3,TargetId.Id] , DataType.short ,'List length ') ; 

    if listlen ~= (length(recstruct.Signals)+length(recstruct.Signals2)) 
        error ( 'Actual number of signals is not as expected') ; 
    end 


    % For all the list members, get their attributes 
    ListItems = zeros(listlen,2) ; 
    for cnt = 1:listlen 
        Next = FetchObj( [hex2dec('2000'),9+cnt,TargetId.Id] , DataType.long ,'Signal attributes ') ; 
        ListItems(cnt,1) = mod( Next , 65536 ) ;  % List index 
        ListItems(cnt,2) = fix( Next / 65536 ) ;  % Flags
    end     

    disp( 'Uploading recorded vectors, wait...') ; 

    RecVec = zeros(listlen,numrec) ;
    if ( AtpCfg.Udp.On)
        SingleFetchLength = 104 ; 
    else
        SingleFetchLength = 120 ; 
    end 

    nrsess = length(0:SingleFetchLength:numrec-1) ; 
    nload = 0; 
    for cnt = 0:SingleFetchLength:numrec-1  
    % Bring recorder SDO 
        % Signal index
        SendObj( [hex2dec('2000'),8,TargetId.Id] , cnt , DataType.short , 'Set the first record to bring' ,CommFunc) ;
        
        LastCnt =  min(cnt+SingleFetchLength-1,numrec-1); 
        SendObj( [hex2dec('2000'),9,TargetId.Id] , LastCnt , DataType.short , 'Set the last record to bring' ,CommFunc) ;
        BlockUploadIndex = hex2dec('2006') ; 

        for csig = 1:listlen
            BitKillTime =  datevec(datenum(clock + 2* second)); 
            stype = ListItems(csig,2);
          
            if ( AtpCfg.Udp.On)
                SendObj( [hex2dec('2000'),7,TargetId.Id] ,  csig-1 , DataType.short , 'Select the signal to bring' ,CommFunc) ;    
                [s1,err]  = CommFunc( 201 , [1536+TargetId.Id ,1408+TargetId.Id ,8192,stype,stype,LastCnt-cnt+1,800] ); % Get records
                if ~isempty(err) 
                    RetStr = ['Set Sdo failure code=[',Errtext(err),'] Bring recorder vector'];
                    error (RetStr) ; 
                end 

                
            else
                SendObj( [hex2dec('2000'),7,TargetId.Id] ,  csig-1 , DataType.short , 'Select the signal to bring' ,CommFunc)  ;   
    
                
                switch ( stype )
                case 2 % Float 
                    if blockupload
                        s1 = CommFunc( 21 , [1536+TargetId.Id ,1408+TargetId.Id ,BlockUploadIndex,100,DataType.float,0,100] ); % Get records
                    else
                        s1 = CommFunc( 8 , [1536+TargetId.Id ,1408+TargetId.Id ,8192,100,DataType.fvec,0,100] ); % Get records
                    end 
                case 66 % Double 
                    s1 = CommFunc( 8 , [1536+TargetId.Id ,1408+TargetId.Id ,8192,100,DataType.fvec,0,100] ); % Get records
                case 8 % Signed short 
                    s1 = CommFunc( 8 , [1536+TargetId.Id ,1408+TargetId.Id ,8192,100,DataType.ulvec,0,100] ); % Get records
                    junk = find( s1 >= 2^31 ) ; 
                    s1(junk) = s1(junk) - 2^32 ; 
                    s1 = bitand( s1 + 2^32 , 65535 ) ; 
                    junk = find( s1 >= 2^15 ) ; 
                    s1(junk) = s1(junk) - 2^16 ; 
                case 12 % unsigned short 
                    for retry = 1:3
                        [s1,errnum] = CommFunc( 8 , [1536+TargetId.Id ,1408+TargetId.Id ,8192,100,DataType.ulvec,0,100] ); % Get records
                        if isempty( errnum) 
                            break;
                        end
                    end
                    if ~isempty(errnum) 
                        errstr = ['Get Sdo failure code=[',Errtext(errnum),'], ID=[',num2str(TargetId.Id),']	Index = [0x',dec2hex(8192),'] SubIndex = [',num2str(100),'] , Descr = [Fetch recorder]']; 
                        
                        error( errstr) ;
                    end 
                    junk = find( s1 < 0 ) ; 
                    s1(junk) = s1(junk) + 1^16 ; 
                    % s1 = bitand( ss1 , 65535 ) ; 
                    
                otherwise % long
                    if blockupload
                        s1 = CommFunc( 21 , [1536+TargetId.Id ,1408+TargetId.Id ,BlockUploadIndex,100,DataType.long,0,100] ); % Get records
                    else
                        [s1,errnum] = CommFunc( 8 , [1536+TargetId.Id ,1408+TargetId.Id ,8192,100,DataType.ulvec,0,100] ); % Get records
                        if ~isempty(errnum) 
                            errstr = ['Get Sdo failure code=[',Errtext(errnum),'], ID=[',num2str(TargetId.Id),']	Index = [0x',dec2hex(8192),'] SubIndex = [',num2str(100),'] , Descr = [Fetch recorder]']; 
                            
                            error( errstr) ;
                        end 
                    end 
                    
                    if  bitget( stype , 3 ) == 0 % Bug fix, Yahali Mar 27 2017 
                        junk = find( s1 >= 2^31 ) ; 
                        s1(junk) = s1(junk) - 2^32 ; 
                    end
                    
                    
                end
            end % End if UDP is on 
            RecVec( csig , (cnt+1):(LastCnt+1)) = s1 ;  
        end % End records bring loop 
       
        nload = nload + 1 ; 
               
        if ~isequal( CommFunc , @Comm2MatIntfc ) 
            disp( ['Uploaded %' , num2str( fix(100*nload/nrsess) ) ] ) ; 
        end 
    end
    
    if  action.Struct 
%         gap = FetchObj( [hex2dec('2000'),1,TargetId.Id] , DataType.short , 'Gap' ) ;
%         s2c = FetchObj( [hex2dec('2000'),6,TargetId.Id] , DataType.short  , 'Sync2C' ) ;
%         if s2c 
%             Ts = FetchObj( [hex2dec('2000'),63,TargetId.Id] , DataType.long ,'Get TS') ; 
%         else
%             Ts = FetchObj( [hex2dec('2000'),62,TargetId.Id] , DataType.short ,'Get TS') ; 
%         end 
%         Ts = Ts * gap * 1e-6 ;
        
        Ts = FetchObj( [hex2dec('2000'),67,TargetId.Id] , DataType.float ,'Get TS') ; 
        RR = struct( 't' ,  Ts * (0:(length(RecVec(1,:) )-1) ),'Ts',Ts) ; 
        for cnt = 1:listlen
            RR.(strtrim(RecNames{cnt})) = RecVec(cnt,:); 
        end 
        % Decode additional fields 
        try  
            % Because the DecodeComplexFields function is local - specific and not always at hand 
            RecStr = DecodeComplexFields(RR);       
        catch 
            RecStr = RR ; 
        end 
    end 
end

