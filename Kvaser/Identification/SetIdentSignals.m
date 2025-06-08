function SetIdentSignals(varargin) 

if nargin > 3
    disp( 'At most 3 pointers may be set') ; 
end 

for cnt = 1 : nargin 
    next = varargin{cnt} ; 
    if isempty(next)
        continue ; 
    end 
    if isequal ( class(next) , 'string')
        next = char(next) ; 
    end 
    if ~ischar(next)
        error ('Only empty and strin arguments expected') ; 
    end
    [~,sigind,sigtype] = GetSignal(next); 
    if ~(sigtype == GetDataType('float') )
        error ('Only floating point signals are expected') ; 
    end
    SendObj([hex2dec('2221'),20+cnt],sigind,GetDataType('long'),['Set signal : ',num2str(cnt)] ) ;
end


