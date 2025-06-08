function AllowRefGenInMotorOff(on)
    SendObj([hex2dec('2221'),5],double( logical(on)) ,GetDataType('long'),['Set AllowRefGenInMotorOff : ',num2str(on)] ) ;
end
