
clear all
close all

[F,LenIden,LenRun,Ts,Amplitude,SignalRun,IndexE]=ChoosingFrequencies;

f1 = F(1);
Ae = Amplitude(1);
ts = Ts;
t1 = LenRun(1)*Ts;

k = 1;
for t=ts:ts:t1

DOFFS = Ae*sin(2*pi*f1*t);

input1(k)=DOFFS;

k=k+1;
end
plot(input1,'b');grid on; hold on;

f1 = F(2);
Ae = Amplitude(2);
ts = Ts;
t1 = LenRun(2)*Ts;

k = 1;
for t=ts:ts:t1

DOFFS = Ae*sin(2*pi*f1*t);

input2(k)=DOFFS;

k=k+1;
end
sb = length(input1)+1;
se = sb+length(input2)-1;
plot(sb:se,input2,'r');grid on; hold on;

f1 = F(3);
Ae = Amplitude(3);
ts = Ts;
t1 = LenRun(3)*Ts;

k = 1;
for t=ts:ts:t1

DOFFS = Ae*sin(2*pi*f1*t);

input3(k)=DOFFS;

k=k+1;
end
sb = se+1;
se = se+length(input3);
plot(sb:se,input3,'c');grid on; hold on;



return
f1=5.12;
t1=2.34;

f2=6.25;
t2=20.12;

f3=38.95;
t3=30.12;


Ae=5;
k=1;
ts=1/8000;
%  SET TIME = 0;
%  while TIME<T1

for t=1/8000:ts:t1

DOFFS = Ae*sin(2*pi*f1*t);

input(k)=DOFFS;

k=k+1;
end



k=1;

for t=1/8000:ts:t2

DOFFS = Ae*sin(2*pi*f2*t);

input2(k)=DOFFS;

k=k+1;
end



k=1;

for t=1/8000:ts:t3

DOFFS = Ae*sin(2*pi*f3*t);

input3(k)=DOFFS;

k=k+1;
end

input_total=[input,input2,input3];
time=[1/8000:ts:(t1+t2+t3)];




plot(time,input_total)



