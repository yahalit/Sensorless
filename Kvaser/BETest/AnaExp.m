% PulseSequenceForStart
% AnaExp: Analyze resistance out ov V-experiment results
fnames = ["VolExpRslt10_0.mat","VolExpRslt10_1.mat","VolExpRslt10_2.mat","VolExpRslt10_3.mat","VolExpRslt10_4.mat","VolExpRslt10_5.mat" ]; 
fnames2 = ["AVolExpRslt10_6.mat","AVolExpRslt10_7.mat","AVolExpRslt10_8.mat","AVolExpRslt10_9.mat","AVolExpRslt10_10.mat","AVolExpRslt10_11.mat" ]; 

if ( Deg30 ) 
    fname = fnames2(seq) ; 
else
    fname = fnames(seq) ; 
end
% 
Vdc = 28 ; 
R = CalcR(fname,seq,Deg30,1, Vdc ) ; 

%place = strfind( fname,'.') ; 
%seq =  str2double(fname(place-1)) ; 
% Consider EMF 
% Take nonlinear elements instead of first harmony 
% More exact timing 
% Full nonlinear optimization 
