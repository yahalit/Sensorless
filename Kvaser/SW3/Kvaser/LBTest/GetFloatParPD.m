function RetVal = GetFloatParPD( name , CanCom  ) 

global RecStruct 
global DataType 

if ( nargin < 2 || isempty(CanCom))
	CanCom = @KvaserCom ;
end

ind = find( strcmp( name , RecStruct.PdParList ) , 1)  ;
if isempty( ind ) 
    error ( ['PD Parameter [',name,'] not found']); 
end

RetVal = FetchObj( [hex2dec('220c'),ind-1] , DataType.float , ['Get parameter[',name,']'] ,CanCom) ;
