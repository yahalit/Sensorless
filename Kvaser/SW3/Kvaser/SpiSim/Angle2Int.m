function u =  Angle2Int(x) 
% function u =  Angle2Int(x) 
% Argumets
% x : Angle in radians 
% Returns:
% u : Angle in 65536 count / rev 
u = fix ( mod(x * 1.043037835047045e+04 , 65536 ) ) ; 
if ( u >= -16386 && u <= -16382 ) 
    u = -16384 ; 
end 
if ( u <= 16386 && u >= 16382 ) 
    u = 16384 ; 
end 

end

