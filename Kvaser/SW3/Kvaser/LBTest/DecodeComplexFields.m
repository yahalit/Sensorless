function Rec = DecodeComplexFields( Rec )

if isfield(Rec,'CorrectByLineStatistics1') 
     Rec.LHypot = GetBitField(Rec.CorrectByLineStatistics1 ,1:8,'n',1) / 500 ; 
     Rec.LOffset = GetBitField(Rec.CorrectByLineStatistics1 ,9:16,'n',1) / 500  ; 
     Rec.LAzDev = GetBitField(Rec.CorrectByLineStatistics1 ,17:24,'n',1) / 500 ; 
     Rec.LAzErr = GetBitField(Rec.CorrectByLineStatistics1 ,25:32,'n',1) / 500 ;      
end

if isfield(Rec,'CorrectByLineStatistics2') 
     Rec.LCntr = GetBitField(Rec.CorrectByLineStatistics2 ,1:8,'n',0) ; 
     Rec.LAge = GetBitField(Rec.CorrectByLineStatistics2 ,9:16,'n',1) / 0.02 ; 
     Rec.Ldx = GetBitField(Rec.CorrectByLineStatistics2 ,17:24,'n',1) / 500 ; 
     Rec.Ldy = GetBitField(Rec.CorrectByLineStatistics2 ,25:32,'n',1) / 500 ;      
end

if isfield(Rec,'PackageSummary') 
     Rec.ManState = GetBitField(Rec.ManState ,1:8,'n',0) ; 
     Rec.ManStopErr = GetBitField(Rec.ManStopErr ,9:16,'n',0) ;
     Rec.ManNetOn = GetBitField(Rec.ManStopErr ,23:24,'n',0) ;
     Rec.ManMotorOn = GetBitField(Rec.ManStopErr ,26:30,'n',0) ;
end 


end

