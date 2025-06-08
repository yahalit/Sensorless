function x = h2s(str) 
if startsWith(lower(str),'0x')
    x = hex2dec(str(3:end)); 
else
    x = hex2dec(str); 
end
if x >= 2^31
    x = x - 2^32 ; 
end