function SysI=CalculateTF(Output,Input,F,IndexE,LenIden,Ts,Plot)
% Input
%   Output   = measured output every Ts units (No entry can be missing)
%   Input    = Measured input                 (No entry can be missing)
%   F        = list of frequencies
%   IndexE   = IndexE(k) is last index of signal at frequency F(k)
%   LenIden  = LenIden(k) is ignal # of element for frquency F(k) from which TF will be calculated.
%   Ts       = Sampling time.
%   Plot     = 1 to show plots for analysis, else 0
%
%   Author: Oded Yaniv, cell: 0544893673
%   Copyright BugProof, Inc.
%   Written: July 2022
%   Customers are not allowed to sell/give/show/transfer/copy this m.file to a third party without written permission from Oded Yaniv.
%

% m = 1;
for k=1:length(F)
    nb      = IndexE(k)-LenIden(k)+1;
    ne      = IndexE(k);
    Output0  = Output(nb:ne);
    Input0   = Input(nb:ne);
    %plot(Output0);gh;plot(Input0)
%     if(m>=7)
%         m=1;
%     else
%         m=m+1;
%     end
    if(k==1)
        rem = 1;
    else
        rem = 0;
    end
    [Fout(k),TFout(k)] = Findfft(Output0,Ts,'Hz',F(k),Plot,'r',rem);
    [Fin(k), TFin(k)]  = Findfft(Input0,Ts,'Hz',F(k),Plot,'b',rem);
end
SysI = frd(TFout./TFin,Fout*2*pi,Ts);
% bode(SysI);gh;bode(SysD,Fout*2*pi,'or');
% legend('Identify','Model');