function y = filt2side( x , z) 

y = x  ;
y1 = x ; 
for cnt = 2:length(y) 
    y(cnt) = y(cnt-1) + (1-z) * (  y1(cnt) - y(cnt-1) ) ; 
end
y1 = y(end:-1:1) ; 
for cnt = 2:length(y) 
    y(cnt) = y(cnt-1) + (1-z) * (  y1(cnt) - y(cnt-1) ) ; 
end
y = y(end:-1:1) ; 
