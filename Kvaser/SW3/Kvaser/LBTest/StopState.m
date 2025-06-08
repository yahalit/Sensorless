function StopState( brkflag , brkmode )
global DataType
if nargin > 0 
    SendObj( [hex2dec('2220'),51] , brkflag , DataType.short , 'Set break flag' ) ;
    if nargin > 1 
        SendObj( [hex2dec('2220'),50] , brkmode , DataType.short , 'Set Break mode' ) ;
    end
end 



ss = ["EN_CommitCrab_Init","Undef","EN_CommitCrab_PreAdjustDirection","EN_CommitCrab_AdjustDirection",...
"EN_CommitCrab_CommitYew","EN_CommitCrab_WaitFinalFix","EN_CommitCrab_DecideFinalGo","EN_CommitCrab_WaitGoAhead",...
"EN_CommitCrab_FinalArc","EN_CommitCrab_WaitSteerCorrect","EN_CommitCrab_WaitSteerCorrectFix","EN_CommitCrab_WaitSteerCorrect2",...
"EN_CommitCrab_WaitFunellTravel","EN_CommitCrab_WaitReady4Funnel","EN_CommitCrab_WaitFinalFunnelFix","EN_CommitCrab_WaitRecrab",...
"Undef","Undef","Undef","Undef",...
"Undef","Undef","Undef","Undef",...
"Undef","Undef","Undef","Undef",...
"Undef","Undef","Undef","Undef",...
"E_CommitCrab_AllocStateOffset","Undef","Undef","Undef",...
"Undef","Undef","E_CommitCrab_FinalArc","E_CommitCrab_WaitSteerCorrect",...
"E_CommitCrab_WaitSteerCorrectFix","E_CommitCrab_WaitSteerCorrect2","E_CommitCrab_WaitFunellTravel","E_CommitCrab_WaitReady4Funnel",...
"E_CommitCrab_WaitFinalFunnelFix","E_CommitUnCrab_CommitBackToY","E_CommitUnCrab_WaitFirstFix","E_CommitUnCrab_CommitSteer",...
"E_CommitUnCrab_WaitUncrab","E_CommitUnCrab_WaitSecondFix","E_CommitUnCrab_WaitFinalFix","E_CommitUnCrab_WaitComplete",...
"E_CommitUnCrab_CommitPerpendicularCorrect"] ; 

    
BrkNow = FetchObj( [hex2dec('2220'),50] , DataType.short , 'V36' ) ; 
OldState= FetchObj( [hex2dec('2220'),51] , DataType.short , 'VBat54' ) ; 
NewState = FetchObj( [hex2dec('2220'),52] , DataType.short , 'V24' ) ; 

disp(['BrkNow  OldState NewState: ' ,num2str([BrkNow,OldState,NewState]) ]) ;
nold = OldState + 1; 
if nold >0 && nold <= length(ss)
    disp(['Old: ',ss(nold)]) ; 
end
nold = NewState + 1; 
if nold >0 && nold <= length(ss)
    disp(['New: ',ss(nold)]) ; 
end


end

