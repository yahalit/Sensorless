tht = ThetaElectFw ;
halls = HallKeyFw ; 
thtm = zeros(1,6) ; 
key  = zeros(1,6) - 1  ; 
ikey  = zeros(1,6) - 1  ; 
for cnt = 1:6 
    ind = find(halls ==cnt) ;  
    thth = tht(ind) ; 
    if ( any(thth < 0.17 ) && any(thth > 0.83) )
        indg = find(thth > 0.7); 
        thth(indg) = thth(indg) - 1 ; 
    end 
    thtm(cnt) = mean(thth ) ; 
end 
off1 = mean(sort(thtm) - (0:1/6:5/6)) ; 
for cnt = 1:6 
    key(cnt)  = find( (thtm(cnt)-off1 > LoLimit ) & (thtm(cnt)-off1 < HiLimit )  ) ; 
    ikey(key(cnt)) = cnt - 1 ; 
end
OffFw   = off1 ; 
iKeyFw = ikey ; 
