function [good,errstr] = AnaFlexDoorCalib(x )
%            FlexDoorZero: 726
%        FlexDoorTopLimit: 1885
%     FlexDoorBottomLimit: 383

% if nargin < 2
%     thtOffset = fix( 78.24 / 360 * 4096) ; 
% end 

good = 1 ; 
errstr = [] ; 

tht = [x.FlexDoorBottomLimit , x.FlexDoorZero , x.FlexDoorTopLimit] * 2 * pi / 4096 ; 

% Test range
if any ( tht <= 0 )
    good = 0 ; 
    errstr = 'Angles must be positive' ;
    return ; 
end 

% Test monotonicity 
if any ( diff(tht) <= 0 )
    good = 0 ; 
    errstr = 'Angles must be monotonous' ;
    return ; 
end 

% Test range 
if ( max(tht) - min(tht) < pi/2 ) 
    good = 0 ; 
    errstr = 'Angles range too low' ;
    return ; 
end 

if ( max(tht) - min(tht) > 3.1 * pi/4 ) 
    good = 0 ; 
    errstr = 'Angles range too high' ;
    return ; 
end 

% Test too high 
% if min( tht ) + thtOffset > 4096 
%     good = 0 ; 
%     errstr = 'Max reading of motor too high' ;
%     return ; 
% end


