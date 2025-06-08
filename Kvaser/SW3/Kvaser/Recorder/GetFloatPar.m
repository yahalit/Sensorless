% function RetVal = GetFloatPar( name , CanCom , card ) 
% Get a parameter from the parameters table. 
% name: Name of the parameter in (Pd)ParRecords.h 
% CanCom: The communication driver (Default or empty =KvaserCom) 
% card  : 'LP' or 'PD' (default : 'LP') 
% Example: x = GetFloatPar('Geom.NeckMotCntRad') ; 
% See also: SetFloatPar


function [RetVal,Multiplexor] = GetFloatPar( name , CanCom , card ) 

global RecStruct 
global DataType 
global TargetCanId 
global TargetCanId2 
global AtpCfg  

name = strtrim(name) ; 

if nargin < 2 
    CanCom = [] ; 
end 

if nargin < 3 
    if isequal( class(CanCom),'char') || isequal( class(CanCom),'string') 
       card = char(CanCom) ; 
       CanCom = [] ; 
    else
        card = 'LP' ; 
    end
end 
if isequal( upper( card) , 'PD' ) 
    RetVal = GetFloatParPD( name , CanCom ) ; 
    return ; 
end 
if ( nargin < 2 || isempty(CanCom))
	CanCom = AtpCfg.DefaultCom ;
end

if endsWith( card, '2' ) 
    ind = find( strcmp( name , RecStruct.ParList2 ) , 1)  ;
    if isempty( ind ) 
        error ( ['Parameter [',name,'] not found for CPU2']); 
    end
    target = TargetCanId2 ; 
else 
    ind = find( strcmp( name , RecStruct.ParList ) , 1)  ;
    if isempty( ind ) 
        error ( ['Parameter [',name,'] not found']); 
    end
    target = TargetCanId;
end
if nargout >= 2 
    Multiplexor = [hex2dec('2208'),ind-1,target] ; 
    RetVal      = [] ; 
else
    RetVal = FetchObj( [hex2dec('2208'),ind-1,target] , DataType.float , ['Get parameter[',name,']'] ,CanCom) ;
end 
