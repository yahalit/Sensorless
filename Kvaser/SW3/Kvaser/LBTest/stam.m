msg = [ hex2dec('13'),hex2dec('ac'),hex2dec('2'),hex2dec('0'),...
      hex2dec('c'),hex2dec('0'),hex2dec('2f'),hex2dec('78'),...
      hex2dec('4c'),hex2dec('0'),hex2dec('a'),hex2dec('0'),...
      hex2dec('3'),hex2dec('22'),hex2dec('15'),hex2dec('0'),...
      hex2dec('4'),hex2dec('0'),hex2dec('14'),hex2dec('0'),...
      hex2dec('0'),hex2dec('0'),hex2dec('2a'),hex2dec('b9')] ; 
  
msg2 = [msg msg] ; 
msg4 = [msg2 msg2] ; 
msg8 = [msg4 msg4] ; 
msg16 = [msg8 msg8] ; 
msg32 = [msg16 msg16] ; 

  
write(s,[msg32 msg16 msg2],'uint8'); 
