% Run this macro to find out the required shoulder distance so that the
% robot shoulder distance fits exactly the separation of the horizontal
% trails.
% - Bring the robot with GoShelf to stop so that the leading wheel is exact
% on the rotatng plate
% - Edit the ShoulderWidth variable 
% - Run this macro 
% Adjust till satisfactory. 
% Hints: 
% 
% - Use BIT to monitor the motor currents. Shoulder distance may be
% untuneable because the motor reached it's peak allowed current.
% - This macro assumes that CAN communication is already established, e.g.
% you reached destination with GoShelf.
global DataType 
ShoulderWidth = 0.487 ;   
SetFloatPar( 'AutomaticRunPars.IntershelfDist' , ShoulderWidth )      ; % Was 0.502
SendObj( [hex2dec('2207'),199] , 4 , DataType.float , 'Set submode' ) ;
