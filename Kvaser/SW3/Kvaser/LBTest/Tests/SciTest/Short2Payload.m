function x = Short2Payload( a ) 

if a == 0 
    x = 0 ; 
    return ; 
end 
    

x = round( min( max( a, -32768),65536))  ; 
if x < 0 
    x = x + 65536 ; 
end 

end