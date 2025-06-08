function SetTestBiquad(on)
    SendObj([hex2dec('2221'),6],double( logical(on)) ,GetDataType('long'),['Set SetTestBiquad : ',num2str(on)] ) ;
end
