function [RetVal,err,errstr] =  FetchObj( Multiplexor , DType , Descr , CommFunc) 

global TargetCanId  
global AtpCfg 


Multiplexor = double(Multiplexor) ;
errstr = [] ; % Assume happy 

Index 		= Multiplexor(1) ; 
SubIndex 	= Multiplexor(2) ; 
if ( length(Multiplexor) >= 3   )
	NodeId = Multiplexor(3) ; 
else
	NodeId = TargetCanId ; 
end 

if nargin < 3  
	Descr = [] ; 
end 

if ( nargin < 4 || isempty(CommFunc) )
	CommFunc =  AtpCfg.DefaultCom ; % @KvaserCom ;
end

[RetVal,err] = CommFunc( 8 , [1536+NodeId ,1408+NodeId ,Index,SubIndex,DType,0,200] ); % Get records
cnt = AtpCfg.FetchRetryCnt ;
if isempty(RetVal)    
    while cnt < AtpCfg.FetchRetry 
        cnt = cnt + 1  ; 
        [RetVal,err] = CommFunc( 8 , [1536+NodeId ,1408+NodeId ,Index,SubIndex,DType,0,200] ); % Get records
        if ~isempty(RetVal) 
            break ; 
        end
    end
end
if ~isempty(RetVal) 
   AtpCfg.FetchRetryCnt = max( cnt-1,0) ; 
   return ; 
end
err = mod(err,2^32) ; %Yahali

AtpCfg.FetchRetryCnt = max( cnt ,AtpCfg.FetchRetryCnt ) ;

errstr = ['Get Sdo failure code=[',Errtext(err),'], ID=[',num2str(NodeId),']	Index = [0x',dec2hex(Index),'] SubIndex = [',num2str(SubIndex),'] , Descr = [',Descr,']']; 
if nargout < 2 
    error (errstr) ; 
end
