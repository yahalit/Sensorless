function x = ulong(x) 
   x = bitand( x + 2^32 , 2^32 -1 ); % + 2^32 to translate from signed to us. bitand to eliminate all gigits above 32 bit.
end