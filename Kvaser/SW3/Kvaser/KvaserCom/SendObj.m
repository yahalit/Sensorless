function [Retcode,RetStr] =  SendObj( Multiplexor , Data , DType , Descr , CommFunc, tout, nrepeat ) 
% function [Retcode,RetStr] =  SendObj( Multiplexor , Data , DType , Descr , CommFunc, tout, nrepeat ) 
% CommFunc : Communication server (if unspecified or [], use default) 
% tout: Time out in milliseconds (default = 200) 

global TargetCanId  
global AtpCfg 

Multiplexor = double(Multiplexor);
RetStr = [] ; 
Index 		= Multiplexor(1) ; 
SubIndex 	= Multiplexor(2) ; 
if ( length(Multiplexor) >= 3   )
	NodeId = Multiplexor(3) ; 
else
	NodeId = TargetCanId ;  
end 

if nargin < 4  
	Descr = [] ; 
end 

if ( nargin < 5 || isempty(CommFunc))
	CommFunc = AtpCfg.DefaultCom ; %  @KvaserCom ;
end

if nargin < 6 
    tout = 200 ; 
end 
if nargin < 7
    nrepeat = AtpCfg.FetchRetry ; 
end 
cnt = AtpCfg.FetchRetryCnt ; 

Retcode = CommFunc( 7 , [1536+NodeId ,1408+NodeId ,Index,SubIndex,DType,0,tout], Data ); 
if Retcode
    while cnt < nrepeat 
        cnt = cnt + 1  ; 
        Retcode = CommFunc( 7 , [1536+NodeId ,1408+NodeId ,Index,SubIndex,DType,0,tout], Data ); 
        if ~Retcode 
            break ; 
        end
    end 
end
if ~Retcode 
   AtpCfg.FetchRetryCnt = max( cnt-1,0) ; 
   RetStr = [] ; 
   return ; 
else
    AtpCfg.FetchRetryCnt = max( AtpCfg.FetchRetryCnt , cnt)  ; 
    RetStr = ['Set Sdo failure code=[',Errtext(Retcode),'] ID=[',num2str(NodeId),']	Index = [0x',dec2hex(Index),'] SubIndex = [',num2str(SubIndex),'] , Descr = [',Descr,']'];
    if  nargout == 0  
        error (RetStr) ; 
    end
end
    
