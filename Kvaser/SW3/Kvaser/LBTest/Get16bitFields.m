function [field1, field2] = Get16bitFields(num32bit) %n is the 16 bit field num starting with the LSB
    %temp = num32bit + 2^32; %in case the long unsigned that is read as signed number is interpreted as negative.
    temp = uint32( mod(num32bit,2^32) )  ; %mod is in case the long unsigned that is read as signed number is interpreted as negative.

    field1_ = mod (temp, 2^16);
    field2_ = (temp - field1_)/2^16;

    field1 = int32(field1_); %int32 turns the uint32 to int32 (unsigned to signed)
    field2 = int32(field2_); %int32 turns the uint32 to int32 (unsigned to signed)
end