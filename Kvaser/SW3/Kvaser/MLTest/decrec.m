% Decode a record 

x = load('ManErr5.mat') ;
x = x.RecStr; 

%                           t: [1×1000 double]
%                          Ts: 0.0164
%                 ShoulderPos: [1×1000 double]
%       ShoulderCombinedState: [1×1000 double]
%              ShoulderPosTgt: [1×1000 double]
%        ShoulderProfileSpeed: [1×1000 double]
%              ShoulderPosErr: [1×1000 double]
%     RecoveryCounterAndState: [1×1000 double]

% pDyn->CombinedState = ( pDyn->HardErrorStat & 0xff) |  ( ( pDyn->Moving & 0xf ) << 8 ) | ( ( pDyn->MotorOn & 0xf ) << 12 )  | ( (long)shortCur << 16 ) ;
ss = x.ShoulderCombinedState ;  junk = find( ss< 0) ; ss(junk) = ss(junk) + 2^32 ; 
errstat = bitand( ss , 255  ); 
Moving = bitand( ss , 256 * 15   ) / 256 ; 
n = 12 ; 
MotorOn = bitand( ss , 2^n * 15   ) / 2^n ; 
n = 16 ; 
Cur = bitand( ss , 2^n * 65535   ) / 2^n ; junk = find( Cur > 32767 ) ; Cur(junk) = Cur(junk) - 65536 ; 
t = x.t ; 
