% AnaLoop: Analysis loop for R/L in v experiment, using AnaExp and AnaExp2
Deg30 = 0 ; 

eind = [6,2,4,3,5,1] ; 
Rvec = eind * 0 ; 
Cvec = cell(1,6) ; 
Vvec = cell(1,6) ; 
Svec = cell(1,6) ; 
Tvec = cell(1,6) ; 

for seq = 1:6
    sind = eind(seq)  ; 
    AnaExp ; 
    Rvec(sind) = R ; 
    Cvec{sind} =  Cur(:) ;  %#ok<*AGROW>
    Vvec{sind} =  v(:) ; 
    Svec{sind} =  state(:) ; 
    Tvec{sind} = t(:); 
end

R = mean(Rvec) ;
L0 = Rvec * 0 ;
L1 = Rvec * 0 ; 
L2 = Rvec * 0 ; 
Ts = mean( diff( r.t)) ; 

for seq = 1:6
    sind = eind(seq)  ;
    V = Vvec{seq};
    Cur = Cvec{seq};
    state = Svec{seq};
    t = Tvec{seq} ; 
    Ts = mean(diff(t)) ; 
    AnaExp2 ; 
    L0(seq) = 1 / tht(1) ; 
    L1(seq) =  tht(2) / tht(1)^2 ; 
    L2(seq) =  (tht(2)^2 - tht(1) * tht(3)) / tht(1)^3 ; 
end
