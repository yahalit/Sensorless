addpath('.\Tests\SciTest') ; 
global SciConfig 
global SciConfig2 
SciConfig = struct('Comport', 5 ,'BaudRate' , 230400  ) ; 
SciConfig2 = struct('Comport', 6 ,'BaudRate' , 230400  ) ; 
% SciConfig = struct('Comport', 27 ,'BaudRate' , 115200  ) ; 
 
s = serialport(['COM',num2str(SciConfig.Comport)],SciConfig.BaudRate);
v = serialport(['COM',num2str(SciConfig2.Comport)],SciConfig2.BaudRate);
set(s,'Timeout',0.1) ; 
SciConfig.s = s ; 
SciConfig.startTime = tic ; 
SciConfig.txMessageCtr = 1 ; 