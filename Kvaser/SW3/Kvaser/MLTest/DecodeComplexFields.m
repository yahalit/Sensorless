function Rec = DecodeComplexFields( Rec )

%if isfield(Rec,'CorrectByLineStatistics1') 
%     Rec.LHypot = GetBitField(Rec.CorrectByLineStatistics1 ,1:8,'n',1) / 500 ; 
%     Rec.LOffset = GetBitField(Rec.CorrectByLineStatistics1 ,9:16,'n',1) / 500  ; 
%     Rec.LAzDev = GetBitField(Rec.CorrectByLineStatistics1 ,17:24,'n',1) / 500 ; 
%     Rec.LAzErr = GetBitField(Rec.CorrectByLineStatistics1 ,25:32,'n',1) / 500 ;      
%end

end

