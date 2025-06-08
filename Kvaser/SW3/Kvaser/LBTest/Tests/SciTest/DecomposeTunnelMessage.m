function a = DecomposeTunnelMessage(newdata)

odd = 0  ; 

if ~isempty(newdata) 
    % Test new data legality 
    newbytes = ceil((length(newdata) - odd)/2) ; 
    a = zeros(newbytes,1) ;

    
    
    for cnt = 1:length( newdata)
        if odd == 0 
            a(ceil(cnt/2)) = newdata(cnt) ;
            odd = 1 ; 
        else
            odd = 0 ; 
            a(ceil(cnt/2)) = 256 * newdata(cnt) + a(ceil(cnt/2)); 
        end 
    end 

end 

a = transpose(a);
end 
    