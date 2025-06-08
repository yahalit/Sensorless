function cfg = SaveConfig(  ) 
DataType = GetDataType() ; 
try
    cfg = struct() ; 
    cfg.VerticalRailPitchType = FetchObj([hex2dec('2228'),1],DataType.long,'Set RailPitchType') ; 
    cfg.ManipType = FetchObj([hex2dec('2228'),2],DataType.long,'Set ManipConfig') ; 
    cfg.WheelArmType = FetchObj([hex2dec('2228'),3],DataType.long,'Set WheelArmType') ; 
catch 
    error ( 'Could not upload configuration'); 
end
end
