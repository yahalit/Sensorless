% Get the reset reason 
resetcount = FetchObj( [hex2dec('2220'),78] , DataType.long , 'resetcount' ) ; 
if ( resetcount == 0 ) 
    disp('No further resets occured  after power ON') ; 
else
    disp('At least 1 Reset occured  after power ON') ; 
end 


erraddress0 = FetchObj( [hex2dec('2220'),54] , DataType.long , 'erraddress0' ) ; 
erraddress1 = FetchObj( [hex2dec('2220'),55] , DataType.long , 'erraddress1' ) ; 
erraddress2 = FetchObj( [hex2dec('2220'),56] , DataType.long , 'erraddress2' ) ; 
erraddress3 = FetchObj( [hex2dec('2220'),57] , DataType.long , 'erraddress3' ) ; 


accesscause0 = FetchObj( [hex2dec('2220'),58] , DataType.long , 'Access cause 0' ) ; 
accesscause1 = FetchObj( [hex2dec('2220'),59] , DataType.long , 'Access cause 1' ) ; 
accesscause2 = FetchObj( [hex2dec('2220'),60] , DataType.long , 'Access cause 2' ) ; 
accesscause3 = FetchObj( [hex2dec('2220'),61] , DataType.long , 'Access cause 3' ) ; 

nmicause0 = FetchObj( [hex2dec('2220'),62] , DataType.long , 'NMI cause 0' ) ; 
nmicause1 = FetchObj( [hex2dec('2220'),63] , DataType.long , 'NMI cause 1' ) ; 
nmicause2 = FetchObj( [hex2dec('2220'),64] , DataType.long , 'NMI cause 2' ) ; 
nmicause3 = FetchObj( [hex2dec('2220'),65] , DataType.long , 'NMI cause 3' ) ; 

cause0 = FetchObj( [hex2dec('2220'),66] , DataType.long , 'reset cause 0' ) ; 
cause1 = FetchObj( [hex2dec('2220'),67] , DataType.long , 'reset cause 1' ) ; 
cause2 = FetchObj( [hex2dec('2220'),68] , DataType.long , 'reset cause 2' ) ; 
cause3 = FetchObj( [hex2dec('2220'),69] , DataType.long , 'reset cause 3' ) ; 

time0  = FetchObj( [hex2dec('2220'),70] , DataType.long , 'Time on wake 0' ) ; 
time1  = FetchObj( [hex2dec('2220'),71] , DataType.long , 'Time on wake 1' ) ; 
time2  = FetchObj( [hex2dec('2220'),72] , DataType.long , 'Time on wake 2' ) ; 
time3  = FetchObj( [hex2dec('2220'),73] , DataType.long , 'Time on wake 3' ) ; 



NMICallAddress0 = FetchObj( [hex2dec('2220'),85] , DataType.long , 'NMICallAddress 0' ) ; 
NMICallAddress1 = FetchObj( [hex2dec('2220'),86] , DataType.long , 'NMICallAddress 1' ) ; 
NMICallAddress2 = FetchObj( [hex2dec('2220'),87] , DataType.long , 'NMICallAddress 2' ) ; 
NMICallAddress3 = FetchObj( [hex2dec('2220'),88] , DataType.long , 'NMICallAddress 3' ) ; 



disp(['First wake (run time=:',TimeString(time0) ,' :) Reset cause :  ',ResetString(cause0) ]) ; 


reasonString = {'External Reset LP','External Reset LP + PD'}; 

if ( resetcount >= 1 ) 
    reason1 = FetchObj( [hex2dec('2220'),74] , DataType.long , 'reset reason 1' ) ; 
    try 
        reasonstr = reasonString{reason1} ; 
    catch 
        reasonstr = 'Unknown' ; 
    end
    disp(['2nd   wake (reason=:',num2str(reason1) ,':)',reasonstr,' (NMI=:',num2str(nmicause0) ,':)',NMIString(nmicause0),' (ACCESS=:',...
        num2str(accesscause0) ,':)',AccessString(accesscause0),...
        ' (NMI Call address=: 0x', dec2hex(NMICallAddress0)] ) ; 
    disp(['2nd   wake (run time=:',TimeString(time1) ,':) Reset cause :' ,ResetString(cause1) ]) ; 
end 

if ( resetcount >= 2 ) 
    reason2 = FetchObj( [hex2dec('2220'),75] , DataType.long , 'reset reason 2' ) ; 
    try 
        reasonstr = reasonString{reason2} ; 
    catch 
        reasonstr = 'Unknown' ; 
    end
    disp(['3rd   wake (reason=:',num2str(reason2) ,'):',reasonstr,' (NMI=:',num2str(nmicause1) ,':)',NMIString(nmicause1),' (ACCESS=:',...
        num2str(accesscause1) ,':)',AccessString(accesscause1),...
        ' (NMI Call address=: 0x', dec2hex(NMICallAddress1) ] ); 
    disp(['3rd   wake (run time=:',TimeString(time2) ,':) Reset cause :' ,ResetString(cause2) ]) ; 
end 

if ( resetcount >= 3 ) 
    reason3 = FetchObj( [hex2dec('2220'),76] , DataType.long , 'reset reason 3' ) ; 
    try 
        reasonstr = reasonString{reason3} ; 
    catch 
        reasonstr = 'Unknown' ; 
    end
    disp(['4th   wake (reason=:',num2str(reason3) ,':)',reasonstr,' (NMI=:',num2str(nmicause2) ,':)',NMIString(nmicause2),' (ACCESS=:',...
        num2str(accesscause2) ,':)',AccessString(accesscause2),...
        ' (NMI Call address=: 0x', dec2hex(NMICallAddress2)] ) ; 
    disp(['4th   wake (run time=:',TimeString(time3) ,':) Reset cause :' ,ResetString(cause3) ]) ; 
end 

