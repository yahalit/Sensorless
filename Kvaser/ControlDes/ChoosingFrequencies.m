function [F,LenIden,LenRun,Ts,Amplitude,SignalRun,IndexE]=ChoosingFrequencies
%This function calculates frquencies and amplituded for identification
%  Outputs to extract from the identification session
%   F       - frequencies [Hz]
%   LenIden - LenIden(k) is # of elements for fft (per F(k))
%   LenRun  - LenRun(k) is # of elements to run experiment  (per F(k))
%             LenIden(k)<=LenRun(k) because I give several cycles for clearing transients
%   Ts      - Sampling time
%   Amplitude - Signal amplitude (can be a vector per F)
%   SignalRun - SignalRun{k} is the signal in time domain for F{k}
%   IndexE    - Let Signal=[SignalRun{1} ... SignalRun{end}].
%               IndexE(k) is index of SignalRun when F(k) ends. F(k+1) starts at IndexE(k)+1
%   Inputs (see options inside the m.file)
%      Ts        -   Sampling time
%       f        -   list of frequencies to identify TFs
%      Amplitude -   Amplitude per frequency (scalar all the same)
%                    Identification signal Amplitude(k)*sin(f(k)*t)
%      MinTime   -   minimum time to collect data, per frequency
%      MinCycle  -   minimum number of cycles to collect data, per frequency
%      Min2SS    -   Minimum cycles to eliminate transients (between freqs). 
%                    Near resonances use Min2SS~=10, otherwise Min2SS~=1.
%      dot_sat   -   signal saturation rate, Amplitude will be changed so
%                    that Amplitude(k)*w(k)<=dot_sat
%      Example: Ts = 0.01
%               f  = [2 4 8 16]
%               Amplitude = [1 1 1 1]
%               MinTime   = [3 3 3 4]
%               MinCycles = [5 5 5 7]
%               Min2SS    = 2
%               dot_sat   = 100
%      
%   Author: Oded Yaniv, cell: 0544893673
%   Copyright BugProof, Inc.
%   Written: July 2022
%   Customers are not allowed to sell/give/show/transfer/copy this m.file to a third party without written permission from Oded Yaniv.
%

Ts      = 1/20000;   %Sampling time
% Oren, the following are otions to build a list of frequencies (can also be given as a list)
fb      = 5;        %First frequency [Hz]
fe      = 1000;     %Last frequency [Hz]
PickF   = 1;   %Options to choose frequencies 1,2 or 3 (2 ans 3 are the same)
if(PickF==1)   %logspace
    nC   = 30; %number of frequencies
    f    = logspace(log10(fb),log10(fe),nC);
    %  f=1205.8:0.1:1206.6;
elseif(PickF==2)  %F(k+1)/F(k)=jump
    jump  = 1.25; %f(k+1)/f(k)=Fact
    nC    = log(fe/fb)/log(jump);
    nC    = round(nC)+1;
    f     = logspace(log10(fb),log10(fe),nC);
elseif(PickF==3)  %F(k+1)/F(k)=jump
    jump  = 1.25; %f(k+1)/f(k)=Fact
    nC    = log(fe/fb)/log(jump);
    nC    = round(nC)+1;
    f     = zeros(1,nC);
    f(1)  = fb;
    for k=2:nC
        f(k) = f(k-1)*jump;
    end
elseif(PickF==4)  
    fprintf('MinTime*fb should be an integer\n') 
    fDither = fb;    %Dither signal [Hz]
    FDither = fDither;
    N     = 1; %F(k),...,F(k+N+1)=2*F(k)
    f     = ChoosingFrequenciesE(fb,fe,N);
%     jump  = 2^(1/N);
%     f(1)  = fb;
%     nC    = 1;
%     while(f(nC)<=fe)
%         nC = nC+1;
%         f(nC) = f(nC-1)*jump;
%     end
%     %Fix numerical at integers jumps
%     nC    = 1;
%     while(f(nC)<=fe)
%         nC = nC+N;
%         f(nC) = f(nC-N)*2;
%     end
%     I = find(f<=fe*sqrt(jump));
%     f = f(I);
end
% End of frequency list
Amplitude  = 5+zeros(size(f));  %Amplitude per frequency
if(1)
    MinTime    = 8;     %Minimum time to measure
    %when dither is used MinTime/fb should be an integer 
else
    MinTime    = 8+round(f/100);
end
if(1)
    MinCycle   = 5;     %Minimum cycles to measure
else
    MinCycle   = 10; %round(5+f/50);
end
Min2SS  = 25;    %   Minumum cycles to eliminate transients (between freqs). 
                 %   Near resonances use Min2SS~=10, otherwise Min2SS=1.
dot_sat = 1000;   %speed saturation: dot_IdenSignal must be less than this value
% Option
AmplitudeDither=1;  %Dither amplitude
%
%Start calculations
if(length(MinTime)==1)
    MinTime = MinTime+zeros(size(f));
end
if(length(MinCycle)==1)
    MinCycle = MinCycle+zeros(size(f));
end
%F=[5 14 21 28]
[LenIden,LenRun,F,W,SignalIden,SignalRun]=ChoosingFrequenciesB(f);%Allocare data
for k=1:length(f)
    f0    = f(k);
%     w0    = f0*2*pi;
    T     = (MinCycle(k))/f0;
    T     = max(T,MinTime(k));
    C     = ceil(T*f0);
    % w*N*Ts = 2*pi*Integer=2*pi*C
%     LenIden(k) = 2*pi*C/Ts/w0;   %w*N
    LenIden(k) = C/Ts/f0;   %w*N
    N     = round(LenIden(k)); %2*pi*w*Ts*n=2*pi
%     if(LenIden(k)~=N)
%         k
%     end
    LenIden(k) = N;
    F(k)  = C/Ts/LenIden(k);
    W(k)  = 2*pi*F(k);
    % Sampling for Min2ss cycles: F*N*Ts = Min2SS ==> N=Min2SS/F/Ts
    %Min2SS_samples = ceil(Min2SS/F(k)/Ts);%Might not be exactly integer cycles but error==> ss and small
    Min2SS_samples = round(Min2SS/F(k)/Ts);%Might not be exactly integer cycles but error==> ss and small
    if(0)
        [PhaseE,PhaseRes]=ChoosingFrequenciesD(Min2SS_samples,Min2SS,F(k),Ts);
        %[PhaseE,PhaseRes]
    end
    LenRun(k) = LenIden(k)+Min2SS_samples;
    if(0) %Test
%         T0    = 0:Ts:LenIden(k)*Ts;
%         T1    = 0:Ts:LenRun(k)*Ts;
%         %plot(T1,sin(W(k)*T1),'or');gh
%         %plot(T0,sin(W(k)*T0),'.b');gh
%         T2    = 0:Ts:(LenIden(k)-1)*Ts;
%         Signal = sin(W(k)*T2);
%         [Fx,TFx,Yx,YAx,wAllx]=fftAnalysis(Signal,Ts,Ts,'Hz',F(k),1,'b');
    else
        TIden         = 0:Ts:(LenIden(k)-1)*Ts;
        TRun          = 0:Ts:(LenRun(k)-1)*Ts;
        SignalIden{k} = Amplitude(k)*sin(W(k)*TIden);
        SignalRun{k}  = Amplitude(k)*sin(W(k)*TRun);
        Derv          = diff(SignalIden{k})/Ts;
        Derv          = max(abs(Derv));
        if(Derv>dot_sat)
            Amplitude(k)  = Amplitude(k)*dot_sat/Derv;
            SignalIden{k} = SignalIden{k}*dot_sat/Derv;
            SignalRun{k}  = SignalRun{k}*dot_sat/Derv;
        end
    end
    %SignalE = sin(W(k)*T0(end))
end
IndexE = cumsum(LenRun);
if(0)
    FDither=ChoosingFrequenciesC(fDither,LenIden,Ts);
end
%plot(LenIden*Ts);gh
% % % fDither = 6.2; %[Hz]
% % % TI      = LenIden*Ts;
% % % Cycles  = fDither*TI;
% % % Cycles  = round(Cycles);
% % % FDither = Cycles./TI;
% % % FDither = FDither(end); %sum(FDither)/length(FDither);
% % % Cycles  = FDither*TI;
% % % Cycles  = Cycles-round(Cycles);
% % % Tf      = 1./F;
% % % for k=0:10
% % %     TI      = LenIden*Ts+k*Tf;
% % %     Cycles  = fDither*TI;
% % %     Cycles  = round(Cycles);
% % %     FDither = Cycles./TI;
% % %     FDither = FDither(end); %sum(FDither)/length(FDither);
% % %     Cycles  = FDither*TI;
% % %     Cycles  = Cycles-round(Cycles);
% % %     plot(Cycles);gh
% % % end
%[f' F']


function w=ChoosingFrequenciesA(wb,we,n)
%Choose frequencies in log separation

w  = logspace(log10(wb),log10(we),n); %rad/sec

function [LenIden,LenRun,F,W,SignalIden,SignalRun]=ChoosingFrequenciesB(f)
%Allocate data

Lenf      = length(f);
LenIden   = zeros(1,Lenf);
LenRun    = zeros(1,Lenf);
F         = zeros(1,Lenf);
W         = zeros(1,Lenf);
SignalIden = cell(1,Lenf);
SignalRun  = cell(1,Lenf);

function FDither=ChoosingFrequenciesC(fDither,LenIden,Ts)

TI      = LenIden*Ts;
Cycles  = fDither*TI;
Cycles  = round(Cycles);
FDither = Cycles./TI;
FDither = FDither(end); %sum(FDither)/length(FDither);
Cycles  = FDither*TI;
Cycles  = Cycles-round(Cycles);
% Tf      = 1./F;
% for k=0:10
%     TI      = LenIden*Ts+k*Tf;
%     Cycles  = fDither*TI;
%     Cycles  = round(Cycles);
%     FDither = Cycles./TI;
%     FDither = FDither(end); %sum(FDither)/length(FDither);
%     Cycles  = FDither*TI;
%     Cycles  = Cycles-round(Cycles);
%     plot(Cycles);gh
% end

function [PhaseE,PhaseRes]=ChoosingFrequenciesD(Min2SS_samples,Min2SS,F,Ts)
% Calculate 
% PhaseE - phase error from phase zero when jump to next frquency
% PhaseRes - phase resolution due to F and Ts

x1 = Min2SS/F/Ts;
x2 = Min2SS_samples;
x3 = Min2SS-x2*F*Ts;  %Cycles error
x4 = x3*2*pi;  %phase error in rad
PhaseE = x3*360;   %phase error in deg
PhaseRes = F*Ts*360; %phase resolution
%[x5 x6]

function f=ChoosingFrequenciesE(fb,fe,N)
%Choose frequencies such tha f(1),f(1+N),f(1+2*N),... = fb,fb*2,fb*4,....

fprintf('MinTime*fb should be an integer\n') 

fDither = fb;    %Dither signal [Hz]
FDither = fDither;
jump  = 2^(1/N);
f(1)  = fb;
nC    = 1;
while(f(nC)<=fe)
    nC = nC+1;
    f(nC) = f(nC-1)*jump;
end
%Fix numerical at integers jumps
nC    = 1;
while(f(nC)<=fe)
    nC = nC+N;
    f(nC) = f(nC-N)*2;
end
I = find(f<=fe*sqrt(jump));
f = f(I);

