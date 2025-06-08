function RetCode = SetFloatPar( name , value , CanCom , card ) 
% function RetCode = SetFloatPar( name , value , CanCom , card ) 
% Set a parameter from the parameter records, either the LP or the PD card
% Name: Parameter name , from file ParRecords.h (resp. PdParRecords.h) 
% Value: Value to set (must be in range)  
% CanCom: Communication driver to use. If absent or empty, the Kvaser driver is used.
% card: 'LP' or 'PD' or 'CPU2'. If absent or empty, LP is taken
% Returns: An error code , 0 is ok
% Example: RetCode: SetFloatPar('ControlPars.HorizontalRailYewOffset',0.01,[],'LP') 
% See also: GetFloatPars


global RecStruct 
global DataType 
global TargetCanId 
global TargetCanId2 
global AtpCfg  
if nargin < 3 
    CanCom = [] ; 
end 

if nargin < 4 
    if isequal( class(CanCom),'char') || isequal( class(CanCom),'string') 
       card = char(CanCom) ; 
       CanCom = [] ; 
    else
       card = 'LP' ; 
    end
end 

if isequal( upper( card) , 'PD' ) 
    RetCode = SetFloatParPD( name , value , CanCom ) ; 
    return ; 
end


if ( nargin < 3 || isempty(CanCom))
	CanCom = AtpCfg.DefaultCom ;
end

if endsWith( card, '2' ) 
    ind = find( strcmp( name , RecStruct.ParList2 ) , 1)  ;
    if isempty( ind ) 
        error ( ['Parameter [',name,'] not found for CPU2']); 
    end
    target = TargetCanId2 ; 
else 
    if ~isequal( upper( card) , 'LP') 
        error (['Unrecognized card name: [',card,']']) ; 
    end
    ind = find( strcmp( name , RecStruct.ParList ) , 1)  ;
    if isempty( ind ) 
        error ( ['Parameter [',name,'] not found']); 
    end
    target = TargetCanId;
end



RetCode = SendObj( [hex2dec('2208'),ind-1,target] , value , DataType.float , ['Set parameter[',name,']'] ,CanCom) ;

if  RetCode && nargout == 0  
	error (['failure code= out of range or [',Errtext(RetCode),']']) ; 
end 