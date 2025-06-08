AtpStart
CalcGeomData

uiwait( msgbox( {'You need a SigRec record with the following signels:',...
      'RWheelEncPos','LWheelEncPos','RWheelDriveEnc','LWheelDriveEnc'} ) ) ; 

[file,path] = uigetfile('*.mat','Select file for records' ) ;
x = load([path,file]) ; 
t = x.t ; 
r = x.RecStr ;

we = r.RWheelDriveEnc; 
we =  unwrap( we * pi / 2^17 ) * 2^17 / pi * Geom.Calc.MotEncoder2MeterGnd; 
rme = we - we(1) ; 

we = r.LWheelDriveEnc; 
we = unwrap( we * pi / 2^17 ) * 2^17 / pi * Geom.Calc.MotEncoder2MeterGnd ; 
lme = we - we(1) ; 

we =Geom.Calc.WheelEncoder2MeterGnd * r.RWheelEncPos ; 
rwe = we - we(1) ; 

we = Geom.Calc.WheelEncoder2MeterGnd * r.LWheelEncPos ; 
lwe = we - we(1) ; 

figure ; clf 
plot( t , rme ,'d', t , lme,'x' , t , rwe , t , lwe ,'+') ;  
legend('RME','LME','RWE','LWE') ; 