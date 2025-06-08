function RetCode = SetFloatParPD( name , value , CanCom ) 
global RecStruct 
global DataType 

if ( nargin < 3 || isempty(CanCom))
	CanCom = @KvaserCom ;
end

ind = find( strcmp( name , RecStruct.PdParList ) , 1)  ;
if isempty( ind ) 
    error ( ['PD Parameter [',name,'] not found']); 
end

RetCode = SendObj( [hex2dec('220c'),ind-1] , value , DataType.float , ['Set parameter[',name,']'] ,CanCom) ;

if  RetCode && nargout == 0  
	error (['Set Sdo to PD failure code=[',Errtext(Retcode),'] ID=[',num2str(NodeId),']	Index = [0x',dec2hex(Index),'] SubIndex = [',num2str(SubIndex),'] , Descr = [',Descr,']']) ; 
end 