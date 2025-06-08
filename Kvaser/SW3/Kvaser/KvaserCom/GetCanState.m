function str=GetCanState() 
out = KvaserCom(36) ; 
canst = out(4) ; 
if canst ==0 
    str = {'ok'} ;
else
    str = cell(1,10) ; 
    errcnt =  0; 
    if bitand(canst,1)
        errcnt = errcnt+1 ; 
        str{errcnt} = 'canSTAT_ERROR_PASSIVE';
    end
    if bitand(canst,2)
        errcnt = errcnt+1 ; 
        str{errcnt} = 'canSTAT_BUS_OFF';
    end
    if bitand(canst,4)
        errcnt = errcnt+1 ; 
        str{errcnt} = 'canSTAT_ERROR_WARNING';
    end
    if bitand(canst,8)
        errcnt = errcnt+1 ; 
        str{errcnt} = 'canSTAT_ERROR_ACTIVE';
    end
    if bitand(canst,16)
        errcnt = errcnt+1 ; 
        str{errcnt} = 'canSTAT_TX_PENDING';
    end
    if bitand(canst,32)
        errcnt = errcnt+1 ; 
        str{errcnt} = 'canSTAT_RX_PENDING';
    end
    if bitand(canst,128)
        errcnt = errcnt+1 ; 
        str{errcnt} = 'canSTAT_TXERR';
    end
    if bitand(canst,256)
        errcnt = errcnt+1 ; 
        str{errcnt} = 'canSTAT_RXERR';
    end
    if bitand(canst,512)
        errcnt = errcnt+1 ; 
        str{errcnt} = 'canSTAT_HW_OVERRUN';
    end
    if bitand(canst,1024)
        errcnt = errcnt+1 ; 
        str{errcnt} = 'canSTAT_SW_OVERRUN';
    end
    str = str(1:errcnt);
    str = struct('txErr',out(1),'rxErr',out(2),'ovErr',out(3),'canst',{str}) ; 

end

