function [pic,kp,ki] = GetPiFunc(z,Ts,gain)
% function [pic,kp,ki] = GetPiFunc(z,Ts,gain)
% Get the PI gains and the controller TF from zero and gain 
% Arguments: 
% z     : zero of PI controller 
% Ts    : Sampling time, seconds 
% gain  : Gain 
% Returns 
% pic   : PI controller transfer function 
% kp    : Proportional gain 
% ki    : Integral gain 

    if nargin < 3 
        gain = 1 ; 
    end 

    if isfinite(z)
        if ( abs(z) < 1e-6)
            pic = tf(1,1,Ts) ; % Zero at the origin kills integrator
        else
            zd = exp(-2*pi*z*Ts ); 
            pic = tf ( Ts * [1,-zd]/(1-zd),[1,-1],Ts) ; 
        end
    else
        pic = tf(1,[1,-1],Ts) ; % Zero at infinity is pure integrator 
    end
    pic = pic * gain ; 

    % Integrator is updated before command issue 
    if ( abs(sum(pic.den{1})) > 1e-8  )
        ki = 0 ; 
        kp = sum(pic.num{1}) /sum(pic.den{1});
    else
        n = pic.num{1} ;
        a = n(1) ; b = n(2) ; 
        ki = (a+b) / Ts ;
        kp = -b ; 
    end 
end
