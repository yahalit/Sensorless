function  base = GetSignalsByList(proto) 

    base = proto.out ; 
    nbase = length(proto.str) ; 
    for cnt = 1:nbase
        next = proto.str(cnt) ; 
        base.(next.Signal) = FetchObj( [hex2dec('2002'),next.Ind] , next.datatype ,'Get Signal') ;
    end 
