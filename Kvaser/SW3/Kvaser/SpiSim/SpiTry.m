global SimTime ;  %#ok<*NUSED>
global RxCtr ; 
global TxCtr ; 

 
SpiSetPathPt( 1 , 2 , [1,2,3] , [0.1,0.5,0.6] , 1 ) ;

% cmd = struct ('OpCode', 0 ) ; % Just get a status report
% [str,reply] = SendSpiSim( cmd ); 