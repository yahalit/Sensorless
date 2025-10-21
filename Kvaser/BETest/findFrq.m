function [F1,F2] = findFrq(vec_in,Ts, filt )
% function F = findFrq(vec,T)
% Find the frequency of a recorded signal 
% Works only for a relatively clean signal with no significant lobes
% vec : Recorded signal 
% Ts  : Sampling time 

% Take even number of samples 
if  mod( length(vec_in),1) 
    vec = vec_in(1:end-1) ; 
else
    vec = vec_in ;
end
nvec = length(vec) ;

[r,~] = xcorr(vec - mean(vec), 'biased');
r0 = r + r(end:-1:1) ; % Remove asymmetric term 

if nargin > 2
    if isempty(filt) 
         filt = tf( [1,1,1]/3,[1, 0,0], Ts) ;
    end 
    r1 = lsim( filt , r0  ) ; 
    r1 = r1(end:-1:1) ; 
    r  = lsim( filt , r1  ) ; 
else
    r = r0 ; 
end 

r1 = r(1:nvec-1) ; 
r2 = r(nvec+1:end) ; 
ind = 2:(length(r1)-1); 
crossind1 = find( r1(ind) .* r1(ind+1) < 0 ) ;
ind = 2:(length(r2)-1); 
crossind2 = find( r2(ind) .* r2(ind+1) < 0 ) ;

ind1 = length(crossind1) ;
ind2 = 1 ; 
% [~,ind1] = min(abs(crossind1 - length(r1) )) ; 
% [~,ind2] = min(abs(crossind2)) ;

na = ind(crossind1(ind1)) ; 
nb = ind(crossind2(ind2))+nvec ; 
ta = na - r(na) / (r(na+1)-r(na)); 
tb = nb - r(nb) / (r(nb+1)-r(nb)); 
T  = (tb - ta + 1/3) * Ts * 2 ; 
F1  = 1/T ;

if ( nargout > 1 ) 
    ind1 = length(crossind1)-1 ;
    ind2 = 1+1 ; 
    na = ind(crossind1(ind1)) ; 
    nb = ind(crossind2(ind2))+nvec ; 
    ta = na - r(na) / (r(na+1)-r(na)); 
    tb = nb - r(nb) / (r(nb+1)-r(nb)); 
    T  = (tb - ta + 1/3) * Ts * 2 ; 
    F2  = 1/T ;
end 

end

