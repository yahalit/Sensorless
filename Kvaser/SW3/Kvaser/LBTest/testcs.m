function s = testcs(vec) 

s = 0 ; 
for cnt = 1:length(vec) 
    next = bitand( 2^16 + vec(cnt)  , 65535 )  ;
    s1 = bitand( next, 255 ) ; 
    s2 = bitand( next, 255 * 256 ) /256  ; 
    s = s + s1 + s2 ; 
end