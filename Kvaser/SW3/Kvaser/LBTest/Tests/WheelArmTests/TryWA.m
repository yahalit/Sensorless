
global DataType 
WAAct = struct('E_TrackWidthNothing',0,'E_TrackWidthRetract',1,'E_TrackWidthExtend',2)  ; 
SendObj( [hex2dec('2220'),17] , 6790 , DataType.long , 'ShutUpOlivier' ) ;

SendObj( [hex2dec('2222'),18] , 0 , DataType.long , 'Set debug variables to wheel arm') ; 
SendObj( [hex2dec('2222'),19] , 0 , DataType.long , 'Set stop at wheelarm transitions') ; 
SendObj( [hex2dec('2222'),20] , 0 , DataType.long , 'Kill use flag' ) ;


%SendObj( [hex2dec('2222'),21] , 0.07 , DataType.float , 'Set crawl' ) ;
if ClimbDir >= 0 
    SendObj( [hex2dec('2222'),28] , 0.05 , DataType.float , 'Set crawl right' ) ;
else
    SendObj( [hex2dec('2222'),29] , 0.05 , DataType.float , 'Set crawl left' ) ;
end


SendObj( [hex2dec('2222'),9] , 1 , DataType.long , 'Set wheelarm cheat ' ) ;
SendObj( [hex2dec('2222'),7] , 1 , DataType.long , 'Allow manual wheelarm ' ) ;
SendObj( [hex2dec('2222'),6] , 1 , DataType.long , 'Allow debubg wheelarm (stretch arm in manual mode)' ) ;

FetchObj( [hex2dec('220b'),24]  , DataType.long , 'Get wheelarm cheat ' )
return

SendObj( [hex2dec('2207'),57] , WAAct.E_TrackWidthExtend , DataType.long , 'Extend command') ; %#ok<UNRCH>
SendObj( [hex2dec('2207'),57] , WAAct.E_TrackWidthRetract , DataType.long , 'Retractcommand') ; %#ok<UNRCH>


%SendObj( [hex2dec('2220'),92] , hex2dec('717b') , DataType.long , 'Abort exp_intetional_fault_sim' ) ;
