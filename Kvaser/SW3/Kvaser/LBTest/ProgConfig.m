function good = ProgConfig( cfg ) 
DataType = GetDataType() ; 
try
    SendObj([hex2dec('2228'),0],6568 ,DataType.long,'Set PWORD') ; 
    SendObj([hex2dec('2228'),1],cfg.VerticalRailPitchType ,DataType.long,'Set RailPitchType') ; 
    SendObj([hex2dec('2228'),2],cfg.ManipType ,DataType.long,'Set ManipConfig') ; 
    SendObj([hex2dec('2228'),3],cfg.WheelArmType ,DataType.long,'Set WheelArmType') ; 
    SendObj([hex2dec('2228'),0],3333 ,DataType.long,'UnSet PWORD') ; 
    SendObj([hex2dec('2304'),1],hex2dec('12345678') ,DataType.long,'Set PWORD') ; 
    SendObj([hex2dec('2304'),253],12345 ,DataType.long,'Set PWORD') ; 
catch 
    error ( 'Could not program configuration'); 
end
end
