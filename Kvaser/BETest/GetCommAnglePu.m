function Commutation_out = GetCommAnglePu(Encoder,Commutation,ClaControlPars,ind)

global gstr 
%    e1 = Commutation.OldEncoder ;
   delta = Encoder - Commutation.OldEncoder ;
   Commutation.OldEncoder = Encoder ;

   enc = Commutation.EncoderCounts + delta ;
   if ( enc < 0 )   
       enc = enc + Commutation.EncoderCountsFullRev ;
   end
   if ( enc >=  Commutation.EncoderCountsFullRev)
       enc = enc - Commutation.EncoderCountsFullRev ;
   end

   [stat,HallDecode] = GetHallComm(gstr.HallValue(max(ind-1,0)),ind) ;

   Commutation.Encoder4Hall = fix(HallDecode.HallAngle * Commutation.EncoderCountsFullRev * ClaControlPars.OneOverPP ) ;
           
   if ( stat == 1 )
        Commutation.Init = 1;
        enc = Commutation.Encoder4Hall ;
   else
   
       pu = CenterDiffPu ( Commutation.Encoder4Hall * Commutation.Encoder2CommAngle , enc * Commutation.Encoder2CommAngle ) ;
        if ( fabsf(pu) > 0.1 )
            Commutation.Init = 0 ;
        end
        if ( Commutation.Init == 0 )        
            enc = Commutation.Encoder4Hall ;
        end
   end
   pu = fSat ( CenterDiffPu(Commutation.Encoder2CommAngle * enc,Commutation.ComAnglePu) , Commutation.MaxRawCommChangeInCycle) ;
   Commutation.ComAnglePu = fracf32(Commutation.ComAnglePu+pu+1.0) ;
% Limit rate of change
Commutation.EncoderCounts = enc ;
Commutation_out = Commutation ; 
end

function   [stat,HallDecode] = GetHallComm(OldHallValue,ind) 

global gr %#ok<*GVMIS> 
global gstr 
%RecNames = {'HallAngle','EncCounts','MotSpeedHz','Iq','ThetaElect','EncoderCounts','Encoder4Hall','OldEncoder','ComStat'end  ; 
HallDecode = struct('HallValue',gstr.HallValue(ind),'HallAngle',gr.HallAngle(ind)) ;
if HallDecode.HallValue == OldHallValue 
    stat = 0 ; 
else
    stat = 1 ;
end 

end

function z = fSat( x, y )
    z = max(min(x,y),-y);
end

function y = fracf32(x) 
y = x - fix(x) ; 
end

function y = fabsf(x) 
    y = abs(x) ;
end

function  z = CenterDiffPu(  x,  y )
    z = fracf32 ( fracf32 ( x - y + 0.5 ) + 1 ) - 0.5   ;
end

