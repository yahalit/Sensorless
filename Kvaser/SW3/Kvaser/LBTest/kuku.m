zinit = GetSignal('fDebug6')
z = GetSignal('fDebug5')
x = GetSignal('fDebug1')
y = GetSignal('fDebug2')
NeckPos = GetSignal('fDebug3')
Trackwidth = GetSignal('fDebug4')
CntSuccess = GetSignal('lDebug2')
CntAll = GetSignal('lDebug1')
CntStat = GetSignal('lDebug3')
totstat = GetSignal('lDebug7')
bbb = FetchObj( [hex2dec('2207'),15] , DataType.long , 'CBIT 2207 15' )  ; 
rposreach = bitand(bbb,1);
lposreach = bitand(bbb,2)/2;
rs = GetSignal('RwSpeedCmdAxis')
ls = GetSignal('LwSpeedCmdAxis')