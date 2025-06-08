function str = GetIdentData() 
    val = zeros(36,1 ) ; 
    datatype = GetDataType('float') ; 
    for cnt = 1:36 
       val(cnt)  = FetchObj( [hex2dec('2221'),cnt-1] , datatype ,'Get floats') ;
    end 

    v11 = val(1:3:10) ;
    v21 = val(2:3:11) ; 
    v31 = val(3:3:12) ; 

    v12 = val(13:3:22) ;
    v22 = val(14:3:23) ; 
    v32 = val(15:3:24) ; 

    Mat = [val(25) , val(29) , val(30) , val(31) ; 
           val(29) , val(26) , val(32) , val(33) ; 
           val(30) , val(32) , val(28) , val(34) ; 
           val(31) , val(33) , val(34) , val(35) ]; 

    Ts = val(36); 

    str = struct('v11',v11,'v21',v21,'v31',v31,'v12',v12,'v22',v22,'v32',v32,'Mat',Mat,'Ts',Ts) ; 
end 

