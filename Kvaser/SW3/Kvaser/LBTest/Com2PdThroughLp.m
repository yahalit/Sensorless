function [RetVal,err]= Com2PdThroughLp( Service , pars , value  )
global ObjectJokerMap 
global DataType 

if isempty(ObjectJokerMap) || ~exist('ObjectJokerMap','var') 
    ObjectJokerMap = zeros(1,5)  ; 
end 

Index = pars(3) ; 
oi = find ( Index == ObjectJokerMap , 1 ) ;
if isempty( oi) 
    zi = find ( 0 == ObjectJokerMap , 1 ) ;
    if ~isempty(zi) 
       % Empty place in communication map ; 
       oi = zi(1) ; 
       ObjectJokerMap(oi) = Index ; 
    else
        % No empty place - just throw something 
        oi = fix( rand(1) * 4.99999999 ) + 1  ; 
    end 
    SendObj( [hex2dec('24ff'),oi] , Index , DataType.short , 'Set joker element') ;    
end 
parspd  = pars ; 
parspd(3) = 9471 + oi ; 

if ( parspd(end) < 160 ) 
    parspd(end) = 160 ; % Increase timeout for the double communication pipe
end 

switch Service 
    case 8 % Get 
    [RetVal,err]=KvaserCom( Service , parspd  );
    case 7 % Set
    [RetVal]=KvaserCom( Service , parspd , value  );
    otherwise
        error ( ['Unknown communication service [',num2str(Service),']']) ; 
end

