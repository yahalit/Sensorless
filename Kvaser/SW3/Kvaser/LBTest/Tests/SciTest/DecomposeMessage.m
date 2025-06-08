function str = DecomposeMessage(strin,newdata) 
% str = struct('Payload',[],'Next',a,'TxCtr',[],'OpCode',[],'TimeTag',[],'Odd',0) ; 

if nargin  < 2
    newdata = [] ; 
end

a   = strin.Next ; 
odd = strin.Odd  ; 

if ~isempty(newdata) 
    % Test new data legality 
    ind = find( newdata < 0 ) ; 
    if ~isempty(ind) 
        newdata(ind) = newdata(ind) + 256 ; 
    end 
    if any ( newdata < 0) || any ( newdata > 255 ) 
        error ('Ilegal data characters') ; 
    end 
    
    newbytes = ceil((length(newdata) - odd)/2) ; 
    cntDst = length(a) ;
    if odd == 0 
        cntDst = cntDst + 1 ; 
    end
    
    if newbytes > 0 
        a = [a , zeros(1,newbytes) ] ; 
    end
    
    for cnt = 1:length( newdata)
        if odd == 0 
            a(cntDst) = newdata(cnt) ;
            odd = 1 ; 
        else
            odd = 0 ; 
            a(cntDst) = 256 * newdata(cnt) + a(cntDst); 
            cntDst = cntDst+ 1 ; 
        end 
    end 
    strin.Next = a ; 
    strin.Odd  = odd ; 
end 
    
str = strin ; 
str.Payload = [] ; % assume nothing

place = find( a == 44051 , 1 ) ; 
if isempty(place) 
    return ; 
end

next = a(place:end) ;
if length(next) < 7 
    % No place for overhead 
    return ; 
end 

txctr = next(2) ; 
opcode  = next(3) ; 
timetag = next(4) + 65536 * next(5) ; 
paylenbytes  = next(6) ; 
paylen = paylenbytes/2 ; 
if ~(paylen == floor( paylen)) 
    error ('payload length need be even in bytes') ; 
end 

if (length(next) < 7 + paylen ) || ( (length(next) == 7 + paylen) && odd ) 
    % No place for overhead + payload 
    return ; 
end 
cs = mod( sum(next(1:7 + paylen)), 65536 )  ;  

if ~(cs==0)
    % Another try 
    str.Next = next(2:end) ; 
    str = DecomposeMessage(next,[]) ; 
    return ; 
end 
if length(next) == 7 + paylen 
    remain = [] ; 
else
    remain = next(7+paylen+1:end) ;
end 
str = struct('Payload',next(7:7+paylen-1),'Next',remain,'TxCtr',txctr,'OpCode',opcode,'TimeTag',timetag,'Odd',odd) ; 

end 
    