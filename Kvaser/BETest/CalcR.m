% CalcR(fname,seq,Deg30,doplot,VdcOverRide)  - Get motor resistance from V experiment results

function [R,Cur,v,r] = CalcR(fname,seq,Deg30,doplot,VdcOverRide)  
x = load(fname); 
r = x.r ; 
t = r.t ; 

state =  bitand(r.ExtLmeasState+2^32,15); 
ind = find( state == 1) ; 
I1 = r.PhaseCur0 - mean(r.PhaseCur0(ind)) ;
I2 = r.PhaseCur1 - mean(r.PhaseCur1(ind)) ;
I3 = r.PhaseCur2 - mean(r.PhaseCur2(ind)) ;



v = r.Vdc ;
%Vandal 

if nargin < 5 
    VdcOverRide = v(1) ;
end
v = v - v(1) + VdcOverRide ; 

ind = find( (state == 1) | (state ==4)  | (state ==6) | (state==8) | (state==11)) ; 
v(ind) = 0 ;  %#ok<FNDSB>
ind = find( (state == 3) | (state ==5) | (state==10) ) ; 
v(ind) = -v(ind) ; 

if doplot 
    figure(seq) ; 
    subplot(3,1,1) ;
    plot( t , r.PhaseCur0 , t , r.PhaseCur1 , t , r.PhaseCur2) ;
    legend('a','b','c') ; 
    subplot(3,1,2) ;
    plot( t , state ) ; grid on
    subplot(3,1,3) ;
    plot( t , v) ;
end 

if Deg30 == 0 
    switch ( seq) 
        case 1
            Cur = (I1-I2)/2 ; 
        case 2
            Cur = (I2-I3)/2 ; 
        case 3
            Cur = (I3-I1)/2 ; 
        case 4
            Cur = (I2-I1)/2 ; 
        case 5
            Cur = (I3-I2)/2 ; 
        case 6
            Cur = (I1-I3)/2 ; 
        otherwise
            disp('Bad sequence') ; 
    end
else
    switch ( seq) 
        case 1
            Cur = (I1-I2-I3)/2 ; 
        case 2
            Cur = (I2-I3-I1)/2 ; 
        case 3
            Cur = (I3-I1-I2)/2 ; 
        case 4
            Cur = (I2-I1-I3)/2 ; 
        case 5
            Cur = (I3-I2-I1)/2 ; 
        case 6
            Cur = (I1-I3-I2)/2 ; 
        otherwise
            disp('Bad sequence') ; 
    end
end

indr = find( (state >= 4) & ( state <=7));

if doplot 
    figure(10) ; 
    plot( t(indr)  , Cur(indr)  ) ; 
end
Cur = Cur(:) ; 
v   = v(:) ; 
R = sum( v(indr)) / sum(Cur(indr)) ;

end