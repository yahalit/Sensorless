function x = h2d(str) 
% function x = h2d(str) get number from a string that may include 0x, always unsigned
if startsWith(lower(str),'0x')
    x = hex2dec(str(3:end)); 
else
    x = hex2dec(str); 
end