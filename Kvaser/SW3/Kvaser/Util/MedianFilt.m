function y = MedianFilt(x,L)
n = length(x) ; 
if n < L 
    error ('Too short for median') ; 
end 

x = (x(:))' ; 
kuku = zeros(L,n); 

for cnt = 1:L
    kuku(cnt,cnt:end) = x(1:end-cnt+1); 
    if cnt > 1
        kuku(cnt,1:cnt-1) = zeros(1,cnt-1)+x(1); 
    end
end

y = median(kuku,1) ; 



