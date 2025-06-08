function [z,g] = KpKi2ZG(kp,ki) 
    if ki <= 1e-7 
        z =  inf ;
        g  = kp  ; 
    else
        z = ki / kp / (2 * pi) ; 
        g = ki ; 
    end 
end 