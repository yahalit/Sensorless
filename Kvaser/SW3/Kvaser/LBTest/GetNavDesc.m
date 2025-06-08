function NavDesc = GetNavDesc(CommFunc ) 
global DataType %#ok<GVMIS> 
if ( nargin < 1 || isempty(CommFunc) )
	CommFunc = [] ;
end   
% DevCnt = FetchObj( [hex2dec('2204'),100] , DataType.long ,'SysState.Mot.Deviation.MsgCntr',CommFunc) ;
DevAge = FetchObj( [hex2dec('2204'),101] , DataType.float ,'SysState.Mot.Deviation.Age',CommFunc) ;
DevAz  = FetchObj( [hex2dec('2204'),102] , DataType.float ,'SysState.Mot.Deviation.AzimuthDev',CommFunc) ;
DevOffset = FetchObj( [hex2dec('2204'),103] , DataType.float ,'SysState.Mot.Deviation.Offset',CommFunc) ;

CamCntObj = FetchObj( [hex2dec('2204'),104] , DataType.long ,'SysState.Mot.PosReport.MsgCntr',CommFunc) ;
QrCnt = bitand( CamCntObj ,1023 ) ; 
CamCntObj  = (CamCntObj - QrCnt ) / 1024 ; 
DevCnt = bitand( CamCntObj ,1023 ) ; 
CamCntObj  = (CamCntObj - DevCnt ) / 1024 ; 
RelPosCnt = bitand( CamCntObj ,1023 ) ; 

QrAz = FetchObj( [hex2dec('2204'),105] , DataType.float ,'SysState.Mot.PosReport.Azimuth',CommFunc) ;
QrX = FetchObj( [hex2dec('2204'),106] , DataType.float ,'SysState.Mot.PosReport.X[0]',CommFunc) ;
QrY = FetchObj( [hex2dec('2204'),107] , DataType.float ,'SysState.Mot.PosReport.X[1]',CommFunc) ;

PosX = FetchObj( [hex2dec('2204'),108] , DataType.float ,'SysState.Nav.iPos[0]',CommFunc) ;
PosY = FetchObj( [hex2dec('2204'),109] , DataType.float ,'SysState.Nav.iPos[1]',CommFunc) ;
PosZ = FetchObj( [hex2dec('2204'),110] , DataType.float ,'SysState.Nav.iPos[2]',CommFunc) ;

Heading = FetchObj( [hex2dec('2204'),111] , DataType.float ,'SysState.Nav.yaw',CommFunc) ;
Roll = FetchObj( [hex2dec('2204'),56] , DataType.float ,'SysState.Nav.yaw',CommFunc) ;
Pitch = FetchObj( [hex2dec('2204'),57] , DataType.float ,'SysState.Nav.yaw',CommFunc) ;



NavDesc = struct('DevCnt',DevCnt,'DevAge',DevAge,'DevAz',DevAz,'DevOffset',DevOffset,'QrCnt',QrCnt,'RelPosCnt',RelPosCnt,...
    'QrAz',QrAz,'QrX',QrX,'QrY',QrY,...
    'PosX',PosX,'PosY',PosY,'PosZ',PosZ,'Heading',Heading,'Roll',Roll,'Pitch',Pitch) ; 
end