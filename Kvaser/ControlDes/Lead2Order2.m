function Lead2Order2

Ts = 1/8000;
ph = -170;
wp = 8000*2*pi;
Lead = 0;
d = 1;
% [SearchLead,PH,WP,D] = PhWp2Complex(ph,wp,d,Lead,Ts);
% w1 = SearchLead.w1;
% d1 = SearchLead.d1;
% w2 = SearchLead.w2;
% d2 = SearchLead.d2;
w1 = 0.9*pi/Ts; d1 =1;
w2 = 500*2*pi; d2=1;
Sys1 = tf([1 2*d1*w1 w1^2],[1 2*d2*w2 w2^2])*w2^2/w1^2;
Sys2 = tf(w2^2,[1 2*d2*w2 w2^2]);
bode(Sys1,'b');gh;bode(Sys2,'r');