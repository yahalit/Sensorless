function frdA = Accumulate2Iden(frd1,frd2)
% frdA = Accumulate2Iden(frd1,frd2)
% Accumulates two identifications given in frd form
% frdA is accumulation of frd1 and frd2
% If frd1 and frd2 include the same frequencies then calculates average
%
%   Author: Oded Yaniv, cell: 0544893673
%   Copyright BugProof, Inc.
%   Written: July 2022
%   Customers are not allowed to sell/give/show/transfer/copy this m.file to a third party without written permission from Oded Yaniv.
%


if(isempty(frd1))
    frdA = frd2; return;
end
if(isempty(frd2))
    frdA = frd1; return;
end
Ts1    = frd1.Ts;
Ts2    = frd2.Ts;
if(Ts1~=Ts2)
    error('Both inputs must have the same Ts')
else
    Ts = Ts1;
end
w1    = frd1.Freq;
w2    = frd2.Freq;
Res1  = freqresp(frd1,w1); 
Res1  = squeeze(Res1);
Res2  = freqresp(frd2,w2);
Res2  = squeeze(Res2);

[w,I] = sort([w1;w2]);
Res   = [Res1;Res2];
Res   = Res(I);
Iw    = find(diff(w)==0);
if(~isempty(Iw))
    w(Iw+1)   = [];
    Res(Iw)   = (Res(Iw+1)+Res(Iw))/2;
    Res(Iw+1) = [];
end
frdA = frd(Res,w,Ts);
