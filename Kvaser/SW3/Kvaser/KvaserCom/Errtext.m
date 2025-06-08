function [txt,txtelab] = Errtext( num ) 

global RecStruct  

txtelab = 'Unspecified' ; 
if ~isa(num,'numeric') 
	txt = num ; 
	return ; 
end 
if length(num) > 1 
	error ('An error code must be a single number') ; 
end

switch num 
    case 0
        txt = 'Ok';
        txtelab = txt ; 
    case -8
        txt = 'Failed to get a UDP recorder stream' ;
    case -7  
        txt = 'Too short recorder answer' ; 
    case -6
        txt = 'Bad record for state vector' ; 
    case -5 
		txt = 'Ill formatted UDP response' ;         
    case -1
		txt = 'Target not responding' ; 
    case 4294967295 
		txt = 'Target not responding' ;         
	case 84082688 % 0x05030000,
		txt = 'Toggle_bit_not_alternated' ; 
        txtelab = 'Problem in CAN message formatting ' ; 
	case 84148224 % 0x5040000
		txt = 'SDO_protocol_timed_out' ; 
	case 84148225 %0x5040001 ,
		txt = 'Client_server_command_specifier_not_valid_or_unknown' ; 
	case 100794368 % 0x06020000
		txt = 'Object_does_not_exist_in_the_object_dictionary' ; 
	case 100728832 % 0x6010000,
		txt = 'Unsupported_access_to_an_object' ; 
	case 100925507 % = 0x6040043,
		txt = 'General_parameter_incompatibility_reason' ; 
	case 101122064 % =0x6070010,
		txt = 'length_of_service_parameter_does_not_match' ;
	case 101253137 % = 0x6090011,
		txt = 'Sub_index_does_not_exist' ; 
	case 84148229 % = 0x5040005,
		txt = 'Out_of_memory' ; 
    otherwise 
		mancode = ( num - 150994944); % 0x9000000
        junk = find( RecStruct.ErrCodes.Code == mancode , 1)  ;
        if isempty(junk) 
            if abs( mancode) <= 65536 
                txt = ['Manufacturer_error_detail code = ',num2str(mancode) ];
            else
                ind = find( RecStruct.ErrCodes.Code == num , 1 )  ;
                if isempty( ind) 
                    if (num < 2^16 )
                        ind = find( RecStruct.ErrCodes.Code == (num - 2^16), 1 )  ;
                    end
                end
                if isempty( ind) 
                    txt = ['Unknown error code = 0',dec2hex(mod(num,2^32) ) ];			
                end
                if ~isempty(ind) 
                    txt = [RecStruct.ErrCodes.Formal{ind},' Fatality:',RecStruct.ErrCodes.Fatality{ind}] ;
                    txtelab = RecStruct.ErrCodes.Description{ind} ;
                end 
            end 
        else
            ind = junk(1) ; 
            txt = [RecStruct.ErrCodes.Formal{ind},' Fatality:',RecStruct.ErrCodes.Fatality{ind}] ;
            txtelab = RecStruct.ErrCodes.Description{ind} ;
        end 
end 
