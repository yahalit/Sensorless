function y = Filt2Side( y , f )
    z = y ; 
    for cnt = 2:length(y) 
        z(cnt) = z(cnt-1) + f * ( y(cnt) - z(cnt-1)) ;
    end
    z = z(end:-1:1) ; 
    y = z ;
    for cnt = 2:length(y) 
        z(cnt) = z(cnt-1) + f * ( y(cnt) - z(cnt-1)) ;
    end
    y = z(end:-1:1) ; 
end

