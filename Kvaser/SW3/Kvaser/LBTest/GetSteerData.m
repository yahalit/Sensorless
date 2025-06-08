function [pot,enc,ref,ang,otherpot] = GetSteerData( IsRight) 
global DataType

if IsRight 

	pot =  FetchObj( [hex2dec('2204'),9] , DataType.float , 'Get pot' ) ;

	otherpot =  FetchObj( [hex2dec('2204'),8] , DataType.float , 'Get other pot' ) ;

	enc =  FetchObj( [hex2dec('2204'),40] , DataType.float , 'R enc' ) ;
    
	ref =  FetchObj( [hex2dec('2206'),3] , DataType.long , 'R enc ref' ) ;
    
	ang =  FetchObj( [hex2dec('2204'),30] , DataType.float , 'R enc ang' ) ;
   
else
	pot =  FetchObj( [hex2dec('2204'),8] , DataType.float , 'Get pot' ) ;
   
    otherpot =  FetchObj( [hex2dec('2204'),9] , DataType.float , 'Get other pot' ) ; 
    
    enc = FetchObj( [hex2dec('2204'),41] , DataType.float , 'L enc' ) ; 
    
    ref = FetchObj( [hex2dec('2206'),4] , DataType.long , 'L enc ref' ) ;

    ang = FetchObj( [hex2dec('2204'),31] , DataType.float , 'L enc ang' );
end 
end