global DataType 


dec2hex(GetSignal('MotLog')) 
dec2hex(GetSignal('MotLog2')) 

SendObj( [hex2dec('2220'),17] , 1234 , DataType.long , 'ShutUpOlivier' ) ;
SendObj( [hex2dec('2220'),94] , hex2dec('717b') , DataType.long , 'Abort exp_intetional_fault_sim' ) ;

% Qindex = 1 ; 
% SpiDoTx = 2 ; 

[str,reply] = SpiQueueExec( 1 , 0 , 1 , 2 ) ; 



[MQ,nGet,nPut,UsrQ] = GetMotionQueue() 


expnum = FetchObj( [hex2dec('220b'),2] , DataType.long ,'Captured exceptions') ;
expnow = GetCode( expnum , 0 , 65535  ) ; 
expold = GetCode( expnum , 16 , 65535  ) ; 

expnum = FetchObj( [hex2dec('220b'),3] , DataType.long ,'Mode status') ;
expold2 = GetCode( expnum , 0 , 65535  ) ; 
expold3 = GetCode( expnum , 16 , 65535  ) ; 


expnum = FetchObj( [hex2dec('220b'),4] , DataType.long ,'Mode status') ;
expold4 = GetCode( expnum , 0 , 65535  ) ; 
expold5 = GetCode( expnum , 16 , 65535  ) ; 



[etext,elabtext] = Errtext(expnow); 
    disp ( ['1: 0x',dec2hex(expnow),' : ',etext ,' : ',elabtext] ) ; 
        [etext,elabtext] = Errtext(expold); 
    disp (['2: 0x',dec2hex(expold),' : ',etext ,' : ',elabtext] ) ; 
        [etext,elabtext] = Errtext(expold2); 
    disp (['3: 0x',dec2hex(expold2),' : ',etext ,' : ',elabtext] ) ; 
        [etext,elabtext] = Errtext(expold3); 
    disp ( ['4: 0x',dec2hex(expold3),' : ',etext ,' : ',elabtext] ) ;  
        [etext,elabtext] = Errtext(expold4); 
    disp ( ['5: 0x',dec2hex(expold4),' : ',etext ,' : ',elabtext] ) ;  
        [etext,elabtext] = Errtext(expold5); 
    disp ( ['6: 0x',dec2hex(expold5),' : ',etext ,' : ',elabtext] ) ;  

save kuku.mat
! ren kuku.mat kuku.anything