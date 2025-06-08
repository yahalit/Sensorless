function y =  dec2baseY( n , base ) 
y = zeros(1,20); 
y(1) = mod(n,base) ; 
for cnt = 2:20 
    n = n - y(cnt-1); 
    if n == 0 
        y(cnt:end) = [] ; 
        return ;
    end
    n = n / base ;
    y(cnt) =  mod(n,base) ;
end
error ('Two many digits') ; 
