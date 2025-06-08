function x = h2d(str) 
if startsWith(lower(str),'0x')
    x = hex2dec(str(3:end)); 
else
    x = hex2dec(str); 
end