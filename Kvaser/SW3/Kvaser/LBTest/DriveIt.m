function DriveIt (  ManDesc  ,CanCom , shelf ) 
% function DriveIt (  ManDesc  ,CanCom , shelf ) 
% shelf: Absent or 0 for ground, instruction struct for shelf  
global DataType
    if ( nargin < 2 || isempty(CanCom) )
        CanCom = [] ;
    end
    if nargin < 3  
        shelf = 0 ; 
    end 
    
    if shelf == 0  
        % ManDesc = struct('LineAcc',1,'CurvatureAcc',2,'LineSpeedCmd',1,'CurvatureCmd',1,'NeckCmd',0,'CrabCrawl',0) ; 
        % Setup the manual motion
        SendObj( [hex2dec('2207'),16] , shelf , DataType.float , 'Shelf mode cmd' ) ;
        SendObj( [hex2dec('2207'),1] , ManDesc.LineAcc , DataType.float , 'LineAcc command') ;
        SendObj( [hex2dec('2207'),2] , ManDesc.CurvatureAcc , DataType.float , 'CurvatureAcc command') ;
        SendObj( [hex2dec('2207'),3] , ManDesc.LineSpeedCmd , DataType.float , 'Line speed command' ) ;
        SendObj( [hex2dec('2207'),4] , ManDesc.CurvatureCmd , DataType.float , 'Curvature') ;
%         SendObj( [hex2dec('2207'),7] , ManDesc.NeckCmd , DataType.float ,'Neck cmd' ,  CanCom) ;
        SendObj( [hex2dec('2207'),10] , ManDesc.CrabCrawl , DataType.float ,'CrabCrawl cmd') ;
        SendObj( [hex2dec('2207'),100] , 1 , DataType.float , 'Start manual ground cmd' ) ;
        return 
    else
        error ( 'These actions are only intended for ground runs') ;         
    end 
%{   
    if ( shelf < 1 || shelf > 6 || shelf == 4 ) 
        error ( ['Ilegal shelf mode :[',num2str(shelf) ,']' ]) ; 
    end
    if ~any( ManDesc.Go == [0,-1,1] ) 
        error ( ['Ilegal direction value :[',num2str(ManDesc.Go) ,']' ]) ; 
    end 
    
    if ~isfield( ManDesc,'FirstWheelCorr') 
        ManDesc.FirstWheelCorr = 0 ; 
    end 
    if ~isfield( ManDesc,'FollowerCorrect')
        ManDesc.FollowerCorrect = 0 ; 
    end 
    
    SendObj( [hex2dec('220b'),1] , 0 , DataType.long , 'Set to manual mode' ) ;
%     SendObj( [hex2dec('2207'),24] , ManDesc.PoleLineAcc , DataType.float , 'PoleLineAcc' ,CanCom) ;
%     SendObj( [hex2dec('2207'),25] , ManDesc.ArcCurrent * ManDesc.Go , DataType.float , 'ArcCurrent' ,CanCom) ;
        
    SendObj( [hex2dec('2207'),22] , abs( ManDesc.PoleSpeed * ManDesc.Go)  , DataType.float , 'PoleSpeed' ) ;
    SendObj( [hex2dec('2207'),20] , ManDesc.NeckStretchGain , DataType.float , 'Neck stretch gain' ) ;

    SendObj( [hex2dec('2207'),21] , ManDesc.ArcSpeed * ManDesc.Go , DataType.float , 'ArcSpeed' ) ;   
    SendObj( [hex2dec('2207'),23] , ManDesc.ShelfSpeed , DataType.float , 'ShelfSpeed') ;
    
    SendObj( [hex2dec('2207'),16] , shelf , DataType.float , 'Shelf mode cmd') ;

% Not really necessry     
%     SendObj( [hex2dec('2207'),26] , ManDesc.RescueCurrent * ManDesc.Go , DataType.float , 'RescueCurrent' ,CanCom) ;
%     SendObj( [hex2dec('2207'),31] , ManDesc.FirstWheelCorr   , DataType.float , 'FirstWheelCorr' ,CanCom) ;
%     SendObj( [hex2dec('2207'),32] , ManDesc.FollowerCorrect  , DataType.float , 'FollowerCorrect' ,CanCom) ;
    
    SendObj( [hex2dec('2207'),10] , ManDesc.CrabCrawl , DataType.float ,'CrabCrawl cmd') ;

    SendObj( [hex2dec('2207'),33] , ManDesc.LeaderSw2Twist , DataType.float ,'LeaderSw2Twist cmd') ;
    SendObj( [hex2dec('2207'),34] , ManDesc.ShelfSeparation , DataType.float ,'ShelfSeparation cmd') ;
    SendObj( [hex2dec('2207'),35] , ManDesc.StopAfterLeaderEncountersSwM , DataType.float ,'StopAfterLeaderEncountersSwM cmd') ;
    SendObj( [hex2dec('2207'),37] , ManDesc.PackPosM , DataType.float ,'PackPosM cmd') ;  

    SendObj( [hex2dec('2207'),100] , 1 , DataType.float , 'Start manual ground cmd') ;
    
%         SendObj( [hex2dec('2207'),101] , 1 , DataType.float , 'Start manual climb cmd' ,CanCom) ;
% 
%}
end



