global RecStruct
global DataType 

nSig   = find( strcmpi( RecStruct.SigNames ,'WheelEncoderTarget1')) ;  
nFlags = RecStruct.SigList{nSig}{1} ; 
if ( nFlags.IsFloat ) 
    nType = DataType.float ; 
elseif ( nFlags.IsShort ) 
    nType = DataType.short ; 
else
    nType = DataType.long ; 
end 

WheelEncoderTarget1 =  FetchObj( [hex2dec('2002'),nSig] , nType , 'WheelEncoderTarget1' ) ;

nSig   = find( strcmpi( RecStruct.SigNames ,'WheelEncoderTarget2')) ;  
nFlags = RecStruct.SigList{nSig}{1} ; 
if ( nFlags.IsFloat ) 
    nType = DataType.float ; 
elseif ( nFlags.IsShort ) 
    nType = DataType.short ; 
else
    nType = DataType.long ; 
end 

WheelEncoderTarget2=  FetchObj( [hex2dec('2002'),nSig] , nType , 'WheelEncoderTarget2' ) ;

nSig   = find( strcmpi( RecStruct.SigNames ,'DinCapture0')) ;  
nFlags = RecStruct.SigList{nSig}{1} ; 
if ( nFlags.IsFloat ) 
    nType = DataType.float ; 
elseif ( nFlags.IsShort ) 
    nType = DataType.short ; 
else
    nType = DataType.long ; 
end 

DinCapture0=  FetchObj( [hex2dec('2002'),nSig] , nType , 'DinCapture0' ) ;

nSig   = find( strcmpi( RecStruct.SigNames ,'DinCapture1')) ;  
nFlags = RecStruct.SigList{nSig}{1} ; 
if ( nFlags.IsFloat ) 
    nType = DataType.float ; 
elseif ( nFlags.IsShort ) 
    nType = DataType.short ; 
else
    nType = DataType.long ; 
end 

DinCapture1=  FetchObj( [hex2dec('2002'),nSig] , nType , 'DinCapture1' ) ;

