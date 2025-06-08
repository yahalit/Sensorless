
global DataType
SendObj( [hex2dec('1f00'),3] , 1 , DataType.short , 'Set analog stop control' ) ;

SetFloatPar( 'Geom.SteerColumn2WheelDist', 0.075 ) ;
SplineTest  = struct( 'StartAz',0 , 'TargetAz' , 0 , 'TargetLoc' , [ 0.03 , 0.3 ] , ...
    'MaxLineSpeed' , 0.3 , 'MaxLineAcc' , 0.2 , 'MaxSteerSpeed' , 0.3 ) ; 

% Estimate the outcomes of our spline 
[ pS , Fail] = FindSplineRoute( 0, 0 ,  SplineTest.StartAz+pi/2,  SplineTest.TargetLoc(1),  SplineTest.TargetLoc(2),  SplineTest.TargetAz+pi/2 );


SendObj( [hex2dec('2220'),20] , SplineTest.StartAz , DataType.float , 'SplineTest.StartAz' ) ;
SendObj( [hex2dec('2220'),21] , SplineTest.TargetAz , DataType.float , 'SplineTest.TargetAz' ) ;
SendObj( [hex2dec('2220'),22] , SplineTest.TargetLoc(1) , DataType.float , 'SplineTest.TargetLoc(1)' ) ;
SendObj( [hex2dec('2220'),23] , SplineTest.TargetLoc(2) , DataType.float , 'SplineTest.TargetLoc(2)' ) ;

SendObj( [hex2dec('2220'),24] , SplineTest.MaxLineSpeed , DataType.float , 'SplineTest.MaxLineSpeed' ) ;
SendObj( [hex2dec('2220'),25] , SplineTest.MaxLineAcc , DataType.float , 'SplineTest.MaxLineAcc' ) ;

SendObj( [hex2dec('2220'),26] , SplineTest.MaxSteerSpeed , DataType.float , 'SplineTest.MaxSteerSpeed' ) ;
    
return ; % Finish preprog 
SendObj( [hex2dec('2220'),30] , 1 , DataType.float , 'Initial curve' ) ;
SendObj( [hex2dec('2220'),31] , 1 , DataType.float , 'Do spline' ) ;
SendObj( [hex2dec('2220'),32] , 1 , DataType.float , 'Kill spline' ) ;