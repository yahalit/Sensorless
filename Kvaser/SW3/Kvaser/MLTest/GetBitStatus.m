function s = GetBitStatus() 
global TargetCanIdPD;

s = struct() ;
DataType=struct( 'long' , 0 , 'float', 1 , 'short' , 2 , 'char' , 3 ,'string', 9 ,'lvec' , 10 ,'fvec' , 11 , 'ulvec' , 20 ) ; 

val = KvaserCom( 8 , [1536+TargetCanIdPD ,1408+TargetCanIdPD ,hex2dec('2104') ,1,DataType.long,0,100] ); % Get status
val2 = KvaserCom( 8 , [1536+TargetCanIdPD ,1408+TargetCanIdPD ,hex2dec('2104') ,2,DataType.long,0,100] ); % Get status
val3 = KvaserCom( 8 , [1536+TargetCanIdPD ,1408+TargetCanIdPD ,hex2dec('2104') ,3,DataType.long,0,100] ); % Get status
if ( val < 0) 
    val = val + 2^32 ; 
end 
s.raw = val ; 
if bitget( val ,1  )
    s.str24 = '[V24 Fail]' ; 
else
    s.str24 = '[V24 Ok]' ; 
end

if bitget( val ,2  )
    s.str12 = '[V12 Fail]' ; 
else
    s.str12 = '[V12 Ok]' ; 
end

if bitget( val ,7  )
    s.str54 = '[V54 Fail]' ; 
else
    s.str54 = '[V54 Ok]' ; 
end

if bitget( val ,3  )
    s.MushrumState = 'Depressed';
else
    s.MushrumState = 'Released';
end

if bitget( val ,17  )
    s.str12 = [s.str12, '[Pwm On]'];
    s.V12On = 1; 
else
    s.str12 =  [s.str12, '[Pwm Off]'];
    s.V12On = 0; 
end

if bitget( val ,21  )
    s.str24 = [s.str24, '[Pwm On]'];
    s.V24On = 1; 
else
    s.str24 =  [s.str24, '[Pwm Off]'];
    s.V24On = 0; 
end

if bitget( val ,25  )
    s.str54 = [s.str54, '[Pwm On]'];
    s.V54On = 1; 
else
    s.str54 =  [s.str54, '[Pwm Off]'];
    s.V54On = 0; 
end

v12exp = bitget( val , 18:20)  * [1;2;4] ;
switch ( v12exp ) 
    case 0,
        s.str12 = [s.str12, '[No error]'];        
    case 3, 
        s.str12 = [s.str12, '[Over current]'];
    case 2, 
        s.str12 = [s.str12, '[Over voltage, output]'];
    case 1,
        s.str12 = [s.str12, '[Bad voltage, input]'];
    otherwise,
        s.str12 = [s.str12, '[Error=',num2str(v12exp),']'];
end 

v24exp = bitget( val , 22:24)  * [1;2;4] ;
switch ( v24exp ) 
    case 0,
        s.str24 = [s.str24, '[No error]'];        
    case 3, 
        s.str24 = [s.str24, '[Over current]'];
    case 2, 
        s.str24 = [s.str24, '[Over voltage, output]'];
    case 1,
        s.str24 = [s.str24, '[Bad voltage, input]'];
    case 4,
        s.str24 = [s.str24, '[12V PS is down]'];
    otherwise,
        s.str24 = [s.str24, '[Error=',num2str(v24exp),']'];
end 

v54exp = bitget( val , 26:28)  * [1;2;4] ;
switch ( v54exp ) 
    case 0,
        s.str54 = [s.str54, '[No error]'];        
    case 3, 
        s.str54 = [s.str54, '[Over current]'];
    case 1,
        s.str54 = [s.str54, '[Bad voltage, input]'];
    otherwise,
        s.str54 = [s.str54, '[Error=',num2str(v54exp),']'];
end 


% Get Bits
%%%%%%%%%%%%%%%%%

if  bitget( val2,1 ) , 
    s.ManSw1 = 1; 
else
    s.ManSw1 = 0; 
end 

if  bitget( val2,2 ) , 
    s.ManSw2 = 1; 
else
    s.ManSw2 = 0; 
end 

if  bitget( val2,3 ) , 
    s.StopSw1 = 1; 
else
    s.StopSw1 = 0; 
end 

if  bitget( val2,4 ) , 
    s.StopSw2 = 1; 
else
    s.StopSw2 = 0; 
end

if  bitget( val2,5 ) , 
    s.Dynamixel12On = 1; 
else
    s.Dynamixel12On = 0; 
end 

if  bitget( val2,6 ) , 
    s.InitState12 = 1; 
else
    s.InitState12 = 0; 
end 

if  bitget( val2,7 ) , 
    s.Dynamixel24On = 1; 
else
    s.Dynamixel24On = 0; 
end 

if  bitget( val2,8 ) , 
    s.InitState24 = 1; 
else
    s.InitState24 = 0; 
end 

if  bitget( val2,9 ) , 
    s.Disc2 = 1; 
else
    s.Disc2 = 0; 
end 

if  bitget( val2,10 ) , 
    s.MONShoulder = 1; 
else
    s.MONShoulder = 0; 
end

if  bitget( val2,11 ) ,
    s.MONElbow = 1; 
else
    s.MONElbow = 0; 
end 

if  bitget( val2,12 ) ,
    s.MONWrist = 1; 
else
    s.MONWrist = 0; 
end 

if  bitget( val2,13 ) ,
    s.MONLeft = 1; 
else
    s.MONLeft = 0; 
end 

if  bitget( val2,14 ) ,
    s.MONRight = 1; 
else
    s.MONRight = 0; 
end 


% Get open drain status 
%%%%%%%%%%%%%%%%%%%%%%%
if bitget( val3 ,1  )
    s.SteerBrake = 1; 
else
    s.SteerBrake = 0; 
end

if bitget( val3 ,2  )
    s.WheelBrake = 1; 
else
    s.WheelBrake = 0; 
end

if bitget( val3 ,3  )
    s.NeckBrake = 1; 
else
    s.NeckBrake = 0; 
end

if bitget( val3 ,4  )
    s.Shunt = 1; 
else
    s.Shunt = 0; 
end

if bitget( val3 ,5  )
    s.SoftStart = 1; 
else
    s.SoftStart = 0; 
end

s.PumpOn = zeros( 1 , 3) ;
if bitget( val3 ,6  )
    s.PumpOn(1) = 1; 
end
if bitget( val3 ,7  )
    s.PumpOn(2) = 1; 
end
if bitget( val3 ,8  )
    s.PumpOn(3) = 1; 
end

if bitget( val3 ,9  )
    s.Chakalaka = 1; 
else
    s.Chakalaka = 0; 
end

if bitget( val3 ,10  )
    s.StopBrake = 1; 
else
    s.StopBrake = 0; 
end

if bitget( val3 ,11  )
    s.StopRelay = 1; 
else
    s.StopRelay = 0; 
end

if bitget( val3 ,12  )
    s.Fan = 1; 
else
    s.Fan = 0; 
end

if bitget( val3 ,13  )
    s.TailLamp = 0; % Inverse logics is intensional
else
    s.TailLamp = 1; 
end


if bitget( val3 ,14  )
    s.Disc1 = 1; 
else
    s.Disc1 = 0; 
end

if bitget( val3 ,15  )
    s.ServoPwrOn = 1; 
else
    s.ServoPwrOn = 0; 
end





