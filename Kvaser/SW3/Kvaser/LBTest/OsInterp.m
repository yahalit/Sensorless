function [strout,ok] = OsInterp(AxId ,  strin , RetType , tout )
global DataType 

if nargin < 3 , 
    RetType = 's' ; 
else
    RetType = lower(RetType) ; 
end

if nargin < 4 , 
    tout = 0.1 ; 
end 
if tout > 10 , 
    tout = 10 ; 
end 

stat = KvaserCom( 7 , [1536+AxId ,1408+AxId ,hex2dec('1023') ,1,DataType.string,0,100], strin ); %upload string
if stat , error (['Sdo failure - could not send string to OS interpreter, : ',dec2hex(stat)]) ; end 

t1 = clock  ; 
while  1 

    stat = KvaserCom( 8 , [1536+AxId ,1408+AxId ,hex2dec('1023') ,2,DataType.short,0,100] ) ;% Get status
    if isempty(stat) , error ('Sdo failure - could not get status OS interpreter') ; end     
    if stat == 1 , 
        ok = 1 ; 
        break ; 
    end 
    if stat == 3 , 
        ok = 0 ; 
        break ; 
    end 
    t2 = clock ;
    if etime( t2 , t1 ) > tout 
        error 'Timeout elapsed, OS interpreter not ready'; 
    end 
end 
    
strout = KvaserCom( 8 , [1536+AxId ,1408+AxId ,hex2dec('1023') ,3,DataType.string,0,100] ) ;
if isempty(strout) , error ('Sdo failure - could not upload string to OS interpreter') ; end 

if isequal(RetType,'n') || isequal(RetType,'x')
    place = strfind( strout,';'); 
    if ~isempty(place) 
        strout = strout(1:place-1) ; 
    end
    strout = str2num(strout) ;  %#ok<*ST2NM>
    if isequal(RetType,'x'), 
        strout = dec2hex( mod( strout , 2^32 ) ) ; 
    end 
end

% Object 1023.2 - Response (1 ok, 3 error) 
% Object 1023.3 - Get Response
end

