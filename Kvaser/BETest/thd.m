function rslt = thd ( vec , tht)
    H = [sin(tht(:)),cos(tht(:)),tht(:)*0+1] ; 
    b = (H' * H)\H' * vec ; 
    rslt = [norm(b(1:2)) ; atan2(b(1),b(2)) ; sqrt(1 - norm(H * b ) / norm(vec))] ;  
end