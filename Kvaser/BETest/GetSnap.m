function RecStr = GetSnap(RecNames,TypeFlags,CanId) 
% function RecStr = GetSnap(RecNames,TypeFlags,CanId) : Get a snapped short of programmed recorder signals 
global TargetCanId %#ok<GVMIS> 
global DataType ; %#ok<GVMIS> 
global AtpCfg ; %#ok<GVMIS> 

if nargin < 3
    CanId = TargetCanId ; 
end 
    SendObj( [hex2dec('2000'),110,CanId] , 1  , DataType.long , 'Snap' ) ;
    s1 = AtpCfg.DefaultCom( 8 , [1536+CanId ,1408+CanId ,8192,110,DataType.ulvec,0,100] ); % Get records
    RecStr = ConvertSnap(s1(1:end-1) ,TypeFlags ,RecNames ) ; 
    RecStr.TimeUsec = s1(end) ; 
end 
