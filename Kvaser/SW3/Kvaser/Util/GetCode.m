function code = GetCode( num , shift , mask ) 
code = bitand (2^32 +  num , 2^shift * mask ) / 2^shift ; 
end

