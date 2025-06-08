% Simulation of identification process in frequency domain
%
% Step 1: Choise of frequencies and amplitudes
[F,LenIden,LenRun,Ts,Amplitude,SignalRun,IndexE]=ChoosingFrequencies;

%Step 2: Build measurement signal (Output, Input)
Signal = [];
for k=1:length(F)
%     sb  = LenRun(k)-LenIden(k)+1;
%     se  = LenRun(k);
%     plot(1:se,SignalRun{k});gh
%     plot(sb:se,SignalRun{k}(sb:se));gh
    Signal = [Signal SignalRun{k}];
end
IdenTime = length(Signal)*Ts; %Idintification time in seconds
fprintf('-------------------------------\n')
fprintf('Identification time:%6.0f [sec]\n',IdenTime)
fprintf('-------------------------------\n')
% plot(Signal)
w1     = 200; d1 = 0.1;
w2     = 500; d2 = 0.1;
w3     = 1000;
SysC   = tf(1,[1 0])*tf(w2^2,[1 2*w2*d2 w2^2])/tf(w1^2,[1 2*w1*d1 w1^2]);
SysC   = SysC*tf(w3^2,[1 w3 w3^2]);%nichols(SysC)
SysD   = c2d(SysC,Ts,'zoh');
Output = lsim(SysD,Signal);
Input  = Signal;

%Step 3: Calculate TF
Plot = 0;  %1 to show fft plots
SysI = CalculateTF(Output,Input,F,IndexE,LenIden,Ts,Plot);

%Step 4: some checks to prove that everything is OK
if(1) %Test simulation
    bode(SysI);grid on;hold on;bode(SysD,F*2*pi,'or');%in rad/sec
    legend('Identify','Model');
end
if(0) %Test Accumulate2Iden
    frdA = Accumulate2Iden(SysI,SysI)
    bode(SysI);grid on;hold on;bode(frdA);
end
% legend('Identify','Model');
