global gr %#ok<*GVMIS> 
global gstr 
x = load('RecordSpeedRslt.mat') ;
r = x.r ; 
str = DecodeHallStat(r.ComStat) ; 

gr = r ; 
gstr = str ; 

%RecNames = {'HallAngle','EncCounts','MotSpeedHz','Iq','ThetaElect','EncoderCounts','Encoder4Hall','OldEncoder','ComStat'}  ; 

Commutation = struct('OldEncoder',r.OldEncoder(1),'EncoderCounts',r.EncoderCounts(1),'Init',str.Init(1),'ComAnglePu',str.CommAngle(1) ,...
    'EncoderCountsFullRev',65536,'Encoder2CommAngle',3.05175781e-05,'MaxRawCommChangeInCycle',0.17000000,'HallAngleOffset', 0.044214 ) ; 
ClaControlPars = struct('OneOverPP',0.5) ; 


N = length(r.t) ; 

vCommAngle = zeros(1,N) ;
vCommAngle(1) = str.CommAngle(1) ; 

ti = 1:length(t) ; 
for cnt = 1:N-1
    ind = cnt + 1 ; 
    if ind == 24 
        indx = 1 ; 
    end

    Commutation_out = GetCommAnglePu(r.OldEncoder(ind),Commutation,ClaControlPars,ind);
    Commutation = Commutation_out ; 
    vCommAngle(ind)  = Commutation.ComAnglePu ; 
end 

figure(50) ; clf 
plot( ti , vCommAngle)
