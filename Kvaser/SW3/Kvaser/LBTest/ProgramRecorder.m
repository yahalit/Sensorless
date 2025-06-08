function [stat,RecStructLoc] = ProgramRecorder(RecNames , RecStructLoc , CommFunc  ) 
% 
% RecStructLoc.TrigType:   0 = immediate 
%                       1 = Up trigger 
%                       2 = Dn trigger
    global DataType; 

    if ( nargin < 3 )
        CommFunc = []  ;
    end 
    
    [RecStructLoc.Signals] = ImportRecSignals(RecStructLoc.SigList, RecNames ) ; 
    RecStructLoc.SigNames = RecNames; 

    % Just clear the state of the SDO machine by dummy read
	FetchObj( [8192,2] , DataType.short ,'GetNumRecs') ;

    % Download a single expedit SDO 
    SendObj( [8192,1] , RecStructLoc.Gap , DataType.short ,'RecStructLoc.Gap') ;  
    SendObj( [8192,2] , RecStructLoc.Len , DataType.short ,'RecStructLoc.Len') ;  
    SendObj( [8192,3] , length(RecStructLoc.Signals) , DataType.short ,'length(RecStructLoc.Signals)') ;  
    SendObj( [8192,4] , RecStructLoc.TrigType , DataType.short ,'RecStructLoc.TrigType') ;  
    SendObj( [8192,5] , RecStructLoc.PreTrigCnt , DataType.short ,'RecStructLoc.PreTrigCnt') ;  
    SendObj( [8192,6] , RecStructLoc.Sync2C , DataType.short ,'RecStructLoc.Sync2C') ;  

    SendObj( [8192,50] , RecStructLoc.TrigSig , DataType.short ,'RecStructLoc.TrigSig') ;  
	
    fval = fix(RecStructLoc.TrigVal );
    if ( fval == RecStructLoc.TrigVal ) 
		SendObj( [8192,52] , RecStructLoc.TrigVal , DataType.long ,'RecStructLoc.TrigVal') ;  
    else
		SendObj( [8192,52] , RecStructLoc.TrigVal , DataType.float ,'RecStructLoc.TrigVal') ;  
    end 

    for cnt = 1:length(RecStructLoc.Signals) 
		SendObj( [8192,9+cnt] , RecStructLoc.Signals(cnt) , DataType.short ,'RecStructLoc.Signals(cnt)') ;  
    end 

	SendObj( [8192,100] , 1 , DataType.short ,'Set the recorder on') ;  
    stat =0 ;
end