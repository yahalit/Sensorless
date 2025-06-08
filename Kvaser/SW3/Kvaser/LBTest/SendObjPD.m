function [RetCode,RetStr] =  SendObjPD( Multiplexor , Data , DType , Descr ) 

global DataType  

if nargin < 3
    DType = DataType.long ; 
end 

if nargin < 4 
    Descr = 'No desccription given';
end 


Index 		= Multiplexor(1) ; 
SubIndex 	= Multiplexor(2) ; 

RetCode = SendObj( [hex2dec('24ff'),1] , Index , DataType.short , 'Set index for joker par' ) ;
if RetCode == 0 
    RetCode = SendObj( [hex2dec('2500'),SubIndex] , Data , DType , 'Set object to PD dict' ) ;
end 

if  RetCode && nargout == 0  
    RetStr = Errtext(Retcode); 
	error (['Set Sdo to PD failure code=[',RetStr,'] ID=[',num2str(NodeId),']	Index = [0x',dec2hex(Index),'] SubIndex = [',num2str(SubIndex),'] , Descr = [',Descr,']']) ; 
else
    RetStr = []; 
end