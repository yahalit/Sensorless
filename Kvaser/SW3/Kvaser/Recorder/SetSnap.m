function TypeFlags = SetSnap( RecNames, CanId  )
global RecStruct %#ok<GVMIS> 
global TargetCanId ; %#ok<GVMIS> 
DataType = GetDataType() ;

if nargin < 3 || ( CanId == TargetCanId ) 
    CanId = TargetCanId ; 
    SigList = RecStruct.SigList ; 
else
    proj    = GetProjectByCanId(CanId) ; 
    SigList = GetSigListByProject(proj) ; 
end 

    Signals = ImportRecSignals(SigList, RecNames ) ; 
    L1 = length(Signals);
    for cnt = 1:L1
        SendObj( [hex2dec('2000'),9+cnt,CanId] , Signals(cnt), DataType.short  , ['Signals(',num2str(cnt),')'] ) ;
    end 
    listlen = length(Signals);
    SendObj( [hex2dec('2000'),3,CanId] , listlen , DataType.short  , 'recstruct.Signals' ) ;

% For all the list members, get their attributes 
    TypeFlags = zeros(listlen,1) ; 
    for cnt = 1:listlen 
        Next = FetchObj( [hex2dec('2000'),119+cnt,CanId] , DataType.long ,'Signal attributes ') ; 
        TypeFlags(cnt) = fix( Next / 65536 ) ;  % Flags
    end     
end 