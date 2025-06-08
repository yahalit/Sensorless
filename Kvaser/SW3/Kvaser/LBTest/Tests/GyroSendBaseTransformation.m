global DataType

tilts = [-1.6,0; 
    -1.2 , -6.2
    -1.0 , -14.4
    -13.3 3.5 ;
    11.2 , 1.3 ];
RollOffset = 1.6 * pi / 180 ; 
PitchOffset = 0 *pi / 180 ; 

tilts = tilts * pi / 180 ; 

accs = [9.5536    0.1927   -2.2395 ; 
    9.2309    0.1181   -3.3377 ; 
    8.6424    0.0136   -4.6706
    9.3904    2.1688   -1.7243
    9.4313   -2.0618   -1.7534] ; 

nMeas = size( tilts , 1) ; 

alpha = asin(0.2449 ) ; 
M1 = [cos(alpha) , 0 , -sin(alpha) ; 0 , 1, 0 ; sin(alpha) , 0 , cos(alpha) ] ; 
M2 = [ 0,0,1; 0,1,0; -1,0,0 ] ; 
M  = M1 * M2; 
Mr = M'  ; Mr = Mr(:) ;

SendObj( [hex2dec('2220'),56] , Mr(1), DataType.float ,'Gyro calib') ;  
SendObj( [hex2dec('2220'),57] , Mr(2), DataType.float ,'Gyro calib') ;  
SendObj( [hex2dec('2220'),58] , Mr(3), DataType.float ,'Gyro calib') ;  
SendObj( [hex2dec('2220'),59] , Mr(4), DataType.float ,'Gyro calib') ;  
SendObj( [hex2dec('2220'),60] , Mr(5), DataType.float ,'Gyro calib') ;  
SendObj( [hex2dec('2220'),61] , Mr(6), DataType.float ,'Gyro calib') ;  
SendObj( [hex2dec('2220'),62] , Mr(7), DataType.float ,'Gyro calib') ;  
SendObj( [hex2dec('2220'),63] , Mr(8), DataType.float ,'Gyro calib') ;  
SendObj( [hex2dec('2220'),64] , Mr(9), DataType.float ,'Gyro calib') ;  



% for cnt = 1 : nMeas 
%     NextTilt = tilts(cnt,:) ; 
%     NextRoll = NextTilt(1) + RollOffset ; 
%     NextPitch = NextTilt(2) + PitchOffset ; 
%     cr = cos(NextRoll) ; sr =  sin(NextRoll) ; 
%     cp = cos(NextPitch) ; sp =  sin(NextPitch); 
%     Rroll  = [1 , 0 ,0 ; 0 , cr , sr ; 0 , -sr , cr ]; 
%     Rpitch = [cp , 0 , -sp ; 0 , 1 , 0 , sp , 0 , cp ] ; 
%     if ( abs(NextRoll) > abs(NextPitch) ) 
%         RN2R = Rpitch * Rroll ; 
%     else
%         RN2R = Rroll * Rpitch ; 
%     end
%     
% end 