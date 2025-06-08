function p = WRegression(xin,yin,Nbin) 

x = xin(:) ; 
y = yin(:) ; 

[N,~,bin] = histcounts(x,Nbin); 

Nmin = max(median(N)/ 2 ,1) ; 

w = bin(:) ;
for cnt = 1:Nbin
    w( bin == cnt ) = 1 / max(N(cnt),Nmin) ;
end
H = [x,0*x+1]; 
p = (H' * diag(w) *H ) \ H' * (w.*y) ; 
end
