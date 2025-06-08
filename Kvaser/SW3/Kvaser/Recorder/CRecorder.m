classdef CRecorder < handle
	properties
		ExpectedRecTime
		WaitForRecords = true
		tStart
		RecStruct
	end
	
	methods
		function obj = CRecorder()
			global DataType
			DataType = struct( 'long' , 0 , 'float', 1 , 'short' , 2 , 'char' , 3 ,'string', 9 ,'lvec' , 10 ,'fvec' , 11 , 'ulvec' , 20 ) ; 
		end
		
		function RecVec = Record(obj, RecNames , RecStruct, waitForRecords )
			% 
			% RecStruct.TrigType:   0 = immediate 
			%                       1 = Up trigger 
			%                       2 = Dn trigger
			global TargetCanId
			global DataType
			obj.WaitForRecords = waitForRecords;
			[RecStruct.Signals] = ImportRecSignals(RecStruct.SigList, RecNames ) ; 
			RecStruct.RecNames = RecNames; 

			% Just clear the state of the SDO machine by dummy read
			KvaserCom( 8 , [1536+TargetCanId ,1408+TargetCanId ,8192,2,DataType.short,0,100] ); % Get num records 

			% Download a single expedit SDO 
			stat = KvaserCom( 7 , [1536+TargetCanId ,1408+TargetCanId ,8192,1,DataType.short,0,100], RecStruct.Gap ); % Recorder gap 
			if stat , error ('Sdo failure') ; end 
			stat = KvaserCom( 7 , [1536+TargetCanId ,1408+TargetCanId ,8192,2,DataType.short,0,100], RecStruct.Len ); % Recorder rec len 
			if stat , error ('Sdo failure') ; end 
			stat = KvaserCom( 7 , [1536+TargetCanId ,1408+TargetCanId ,8192,3,DataType.short,0,100], length(RecStruct.Signals) ); % Number of recorded vars 
			if stat , error ('Sdo failure') ; end 
			stat = KvaserCom( 7 , [1536+TargetCanId ,1408+TargetCanId ,8192,4,DataType.short,0,100], RecStruct.TrigType ); % Set trigger to type immediate,rising,falling
			if stat , error ('Sdo failure') ; end 
			stat = KvaserCom( 7 , [1536+TargetCanId ,1408+TargetCanId ,8192,5,DataType.short,0,100], RecStruct.PreTrigCnt ); % Pre trigger cnt 
			if stat , error ('Sdo failure') ; end 
			stat = KvaserCom( 7 , [1536+TargetCanId ,1408+TargetCanId ,8192,6,DataType.short,0,100], RecStruct.Sync2C ); % Set Time basis
			if stat , error ('Sdo failure') ; end 

			if RecStruct.Sync2C 
				Ts = KvaserCom( 8 , [1536+TargetCanId ,1408+TargetCanId ,hex2dec('2000'),63,DataType.long,0,100] ) ;  % Get records vector length
			else
				Ts = KvaserCom( 8 , [1536+TargetCanId ,1408+TargetCanId ,hex2dec('2000'),62,DataType.short,0,100] );  
			end 
			Ts = Ts * RecStruct.Gap * 1e-6 ;


			stat = KvaserCom( 7 , [1536+TargetCanId ,1408+TargetCanId ,8192,50,DataType.short,0,100], RecStruct.TrigSig ); % Set trigger signal 
			if stat , error ('Sdo failure') ; end 
			fval = fix(RecStruct.TrigVal );
			if ( fval == RecStruct.TrigVal ) 
				stat = KvaserCom( 7 , [1536+TargetCanId ,1408+TargetCanId ,8192,52,DataType.long,0,100], RecStruct.TrigVal ); % Set trigger signal 
				if stat , error ('Sdo failure') ; end 
			else
				stat = KvaserCom( 7 , [1536+TargetCanId ,1408+TargetCanId ,8192,52,DataType.float,0,100], RecStruct.TrigVal ); % Set trigger signal 
				if stat , error ('Sdo failure') ; end 
			end 

			for cnt = 1:length(RecStruct.Signals) 
				stat = KvaserCom( 7 , [1536+TargetCanId ,1408+TargetCanId ,8192,9+cnt,DataType.short,0,100], RecStruct.Signals(cnt) );  % Program recorder entries
				if stat , error ('Sdo failure') ; end 
			end 

			stat= KvaserCom( 7 , [1536+TargetCanId ,1408+TargetCanId ,8192,100,DataType.short,0,100], 1 ); % Set the recorder on
			if stat , error ('Sdo failure') ; end 

			obj.ExpectedRecTime = max( [Ts * RecStruct.Len, 1 ] )  ; 
			obj.tStart = clock(); 
			disp( ['Expected time length for recorder (sec): ', num2str(obj.ExpectedRecTime) ]) ; 

			if (obj.WaitForRecords)
			%if(true)
				RecVec = waitAndGetSignals(obj);
			else
				RecVec = [];
			end
			obj.RecStruct = RecStruct;
		end
		
		function RecVec = waitAndGetSignals(obj)
			waitForRecordingCompletion(obj);
			RecVec = getSignals(obj);
		end
		
		function waitForRecordingCompletion(obj)
			global TargetCanId
			global DataType
			te = etime( clock , obj.tStart );
			if(te > obj.ExpectedRecTime)
				disp('Recording completed.');
			else
				for cnt = 1:100
					s99= KvaserCom( 8 , [1536+TargetCanId ,1408+TargetCanId ,8192,99,DataType.short,0,100] ); % Get records
					if ( s99 == 23 ) 
						break; % Activated and ready 
					end 
					if ( cnt == 100) 
						error ('Recorder did not complete on time') ; 
					end 
					if ( fix(cnt/10) * 10 == cnt ) 
						te = etime( clock , obj.tStart ); 
						disp( ['Recording, elapsed (Sec) = ' , num2str( fix( te * 10) / 10  ) ] ) ; 
					end 
					pause(obj.ExpectedRecTime/90) ; 
				end
			end
		end
		
		function RecVec = getSignals(obj)
			global TargetCanId
			global DataType
			% Get the actual number of records 
			numrec  = KvaserCom( 8 , [1536+TargetCanId ,1408+TargetCanId ,8192,2,DataType.short,0,100] ); % Get num records 

			% Get the list of actual records 
			listlen = KvaserCom( 8 , [1536+TargetCanId ,1408+TargetCanId ,8192,3,DataType.short,0,100] ); % List length

			if listlen ~= length(obj.RecStruct.Signals) 
				error ( 'Actual number of signals is not as expected') ; 
			end 

			% For all the list members, get their attributes 
			ListItems = zeros(listlen,2) ; 
			for cnt = 1:listlen
				Next = KvaserCom( 8 , [1536+TargetCanId ,1408+TargetCanId ,8192,9+cnt,DataType.long,0,100] ); % List length
				ListItems(cnt,1) = mod( Next , 65536 ) ; 
				ListItems(cnt,2) = fix( Next / 65536 ) ; 
			end     

			disp( 'Uploading recorded vectors, wait...') ; 

			RecVec = zeros(listlen,numrec) ; 
			nrsess = length(0:120:numrec-1) ; 
			nload = 0; 
			for cnt = 0:120:numrec-1  
			% Bring recorder SDO 
				% Signal index
				stat= KvaserCom( 7 , [1536+TargetCanId ,1408+TargetCanId ,8192,8,DataType.short,0,100], cnt ); % Select the first to bring 0 
				if stat , error ('Sdo failure') ; end 
				LastCnt =  min(cnt+119,numrec-1); 
				stat= KvaserCom( 7 , [1536+TargetCanId ,1408+TargetCanId ,8192,9,DataType.short,0,100],LastCnt ); % Select the last to bring 
				if stat , error ('Sdo failure') ; end 

				for csig = 1:listlen
					stat= KvaserCom( 7 , [1536+TargetCanId ,1408+TargetCanId ,8192,7,DataType.short,0,100], csig-1 ); % Select the signal to record 
					if stat , error ('Sdo failure') ; end 

					if ( ListItems(csig,2) == 2 )
						s1 = KvaserCom( 8 , [1536+TargetCanId ,1408+TargetCanId ,8192,100,DataType.fvec,0,100] ); % Get records
					else
						s1 = KvaserCom( 8 , [1536+TargetCanId ,1408+TargetCanId ,8192,100,DataType.ulvec,0,100] ); % Get records
						% Treat signed / unsigned
						if  bitget( ListItems(csig,2) , 3 ) == 0
							junk = find( s1 >= 2^31 ) ; 
							s1(junk) = s1(junk) - 2^32 ; 
						end                 
					end
					RecVec( csig , (cnt+1):(LastCnt+1)) = s1 ;  
				end 

				nload = nload + 1 ; 
				disp( ['Downloaded %' , num2str( fix(100*nload/nrsess) ) ] ) ; 
			end
		end
		
	end
end