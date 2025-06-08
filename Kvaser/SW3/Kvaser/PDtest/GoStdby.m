side =2 ; 
if ( side < 1 || side > 2 ) 
    error( 'Undefined side') ; 
end 

w = 7 + 32 * side ; 
SendObj( [hex2dec('2103'),1] , w , DataType.long , 'Go stdby' ) ;
