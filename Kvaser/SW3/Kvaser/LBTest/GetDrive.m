function ManDesc = GetDrive(CommFunc , shelf) 
global DataType
if ( nargin < 1 || isempty(CommFunc) )
	CommFunc = [] ;
end
if nargin < 2 
    shelf = 0 ; 
end 

LineAcc =  FetchObj( [hex2dec('2207'),1] , DataType.float , 'LineAcc command' , CommFunc) ;
CurvatureAcc =  FetchObj( [hex2dec('2207'),2] , DataType.float , 'CurvatureAcc command' , CommFunc) ;
LineSpeedCmd = FetchObj( [hex2dec('2207'),3] , DataType.float , 'Line speed command' ,  CommFunc) ;
CurvatureCmd = FetchObj( [hex2dec('2207'),4] , DataType.float , 'Curvature' ,  CommFunc) ;
NeckCmd = 0 ; % Vandal FetchObj( [hex2dec('2207'),7] , DataType.float ,'Neck cmd' ,  CommFunc) ;
% CrabCrawl = FetchObj( [hex2dec('2207'),10] , DataType.float ,'CrabCrawl cmd',CommFunc) ;
CrabCrawl = FetchObj( [hex2dec('2207'),60] , DataType.float ,'CrabCrawl cmd',CommFunc) ;

GenStat = FetchObj( [hex2dec('2207'),15] , DataType.long ,'GenStat',CommFunc) ;
Curvature = FetchObj( [hex2dec('2207'),12] , DataType.float ,'Curvature',CommFunc) ;
LineSpeed = FetchObj( [hex2dec('2207'),13] , DataType.float ,'LineSpeed',CommFunc) ;

LeaderSw2Twist= FetchObj( [hex2dec('2207'),33] , DataType.float ,'LeaderSw2Twist',CommFunc) ;
ShelfSeparation= FetchObj( [hex2dec('2207'),34] , DataType.float ,'ShelfSeparation',CommFunc) ;
StopAfterLeaderEncountersSwM= FetchObj( [hex2dec('2207'),35] , DataType.float ,'StopAfterLeaderEncountersSwM',CommFunc) ;
% PackPosM = FetchObj( [hex2dec('2207'),37] , DataType.float ,'PackPosM',CommFunc) ;

ManDesc = struct('LineAcc',LineAcc,'CurvatureAcc',CurvatureAcc,'LineSpeedCmd',LineSpeedCmd,...
    'CurvatureCmd',CurvatureCmd,'NeckCmd',NeckCmd,'CrabCrawl',CrabCrawl,'GenStat',GenStat,'Curvature',Curvature,...
    'LineSpeed',LineSpeed,'LeaderSw2Twist',LeaderSw2Twist,'ShelfSeparation',ShelfSeparation,...
    'StopAfterLeaderEncountersSwM',StopAfterLeaderEncountersSwM) ; % ,'PackPosM',PackPosM) ;

% Shelf specifics which are needed only in the heights 
if ( shelf) 
    ManDesc.NeckStretchGain = FetchObj( [hex2dec('2207'),20] , DataType.float ,'NeckStretchGain',CommFunc) ;
    ManDesc.ArcSpeed = FetchObj( [hex2dec('2207'),21] , DataType.float ,'ArcSpeed',CommFunc) ;
    ManDesc.PoleSpeed = FetchObj( [hex2dec('2207'),22] , DataType.float ,'PoleSpeed',CommFunc) ;
    ManDesc.ShelfSpeed = FetchObj( [hex2dec('2207'),23] , DataType.float ,'ShelfSpeed',CommFunc) ;
    ManDesc.PoleLineAcc = FetchObj( [hex2dec('2207'),24] , DataType.float ,'PoleLineAcc',CommFunc) ;
    ManDesc.ArcCurrent = 0 ; % FetchObj( [hex2dec('2207'),25] , DataType.float ,'ArcCurrent',CommFunc) ;
    ManDesc.RescueCurrent = 0 ; % FetchObj( [hex2dec('2207'),26] , DataType.float ,'RescueCurrent',CommFunc) ;
    ManDesc.Go = 0 ; % Default is stop for safety 
end 

end