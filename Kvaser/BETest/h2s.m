function x = h2s(str) 
% function x = h2s(str) : get a number out of exadecimal string, that may include 0x and may be negative
if startsWith(lower(str),'0x')
    x = hex2dec(str(3:end)); 
else
    x = hex2dec(str); 
end
if x >= 2^31
    x = x - 2^32 ; 
end