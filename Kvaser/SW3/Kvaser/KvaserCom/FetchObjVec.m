function [RetVal,err,errstr] =  FetchObjVec(VarsVec, CommFunc) 
%each vector var contains: Multiplexor , DType , Descr , CommFunc
global TargetCanId  
global AtpCfg 


errstr = [] ; % Assume happy 
CommFuncVecs = [];
[rows,~] = size(VarsVec);

if ( nargin < 2 || isempty(CommFunc) )
CommFunc =  AtpCfg.DefaultCom ; % @KvaserCom ;
end 

for i = 1:rows
    vars = VarsVec(i,:);
    Multiplexor = vars{1};
    DType = vars{2};

    if (length(vars) < 3)  
	Descr = [] ; 
    else 
    Descr = vars{3};
    end
    
    
    Index 		= Multiplexor(1) ; 
    SubIndex 	= Multiplexor(2) ; 
    if ( length(Multiplexor) >= 3   )
        NodeId = Multiplexor(3) ; 
    else
        NodeId = TargetCanId ; 
    end 
    
    CommFuncVecs = [CommFuncVecs ; [1536+NodeId ,1408+NodeId ,Index,SubIndex,DType,0,200]];
end 


for cnt = 1: AtpCfg.FetchRetry 
    [RetVal,err] = CommFunc( 9 , CommFuncVecs ); % Get records
    if ~isempty(RetVal) 
        return ; 
    end 
end
% if  isempty(RetVal) 
    errstr = ['Get Sdo failure code=[',Errtext(err),'], ID=[',num2str(NodeId),']	Index = [0x',dec2hex(Index),'] SubIndex = [',num2str(SubIndex),'] , Descr = [',Descr,']']; 
    if nargout < 2 
        error (errstr) ; 
    end
% end 
