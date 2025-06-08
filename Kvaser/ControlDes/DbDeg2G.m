function g = DbDeg2G( db ,deg ) 
% function g = DbDeg2G( db ,deg ) 
% Return the complex transfer function out of db amplitude and phase
% Arguments: 
% db    : Gain in db 
% deg   : Phase in degrees 
% Returns: 
% g     : Complex transfer function 
g = 10.^( db / 20 ) .* exp(sqrt(-1) * deg * pi / 180)  ; 
g = g(:) ; 
end 


