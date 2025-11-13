%ddt(x, t) Numerical first derivative of a signal with respect to time.
%   y = DDT(x, t) computes an approximate time derivative dx/dt using
%   forward and backward finite differences at the edges and central
%   differences elsewhere. The function supports non-uniform sampling.
%
%   Inputs
%   ------
%   x : vector (length N)
%       Signal samples to differentiate.
%   t : vector (length N)
%       Corresponding time samples (monotonically increasing, not
%       necessarily uniform). Must be same length as x.
%
%   Output
%   ------
%   y : vector (length N)
%       Numerical derivative of x with respect to t, same length as input.
% -------------------------------------------------------------------------


function y = ddt(x,t) 
    n = length(x) ; 
    ind1 = [1 , 1:n-2 , n-1]; 
    ind2 = [ 2, 3:n , n ] ; 
    y = ( x(ind2) - x(ind1)) ./ ( t(ind2) - t(ind1));
end 