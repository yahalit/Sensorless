function val = SetSignal( name , data )
global RecStruct ;
global DataType  ; 
    junk = find( strcmp(name, RecStruct.SigNames ) ,1 ) ;
    if isempty( junk ) 
        junk = find( strcmpi(name, RecStruct.SigNames ) ,1 ) ;
        if isempty( junk) 
            error ( ['Recorder object [',name,'] not found']) ; 
        else
            error ( ['Recorder object [',name,'] not found, maybe you mean [',RecStruct.SigNames{junk},']']) ; 
        end 
    end 
    rec  = RecStruct.SigList{junk} ; 
    rtype = rec{1} ; 
    if ( rtype.IsFloat ) 
        [val,ErrStr] = SendObj( [hex2dec('2002'),junk] , data , DataType.float ,'Set float') ;
        % [val,ErrStr] = SendObj( [hex2dec('2002'),junk] , IEEEFloat(data) , DataType.float ,'Set float') ;
    else 
        if ~( data == fix(data))  
            error (['Recorder object [',name,'] sould accept an integer'] ) ; 
        end 

        if ( rtype.IsShort ) 
            if ( rtype.IsUnsigned ) 
                if ( data < 0 ) 
                    data = data + 65536 ; 
                end 
                if ( data < 0 || data >= 65536 ) 
                    error (['Recorder object [',name,'] outside short unsigned range'] ) ; 
                end 
            else
                if ( data < -32768 || data >= 32768 ) 
                    error (['Recorder object [',name,'] outside short signed range'] ) ; 
                end 
            end 
            [val,ErrStr] = SendObj( [hex2dec('2002'),junk] , data , DataType.short ,'Set short') ;
        else
            if ( rtype.IsUnsigned ) 
                if ( data < 0 ) data = data + 2^32 ; end 
            end 
            [val,ErrStr] = SendObj( [hex2dec('2002'),junk] , data , DataType.long ,'Set long') ;
        end 
    end 
    if ~isempty(ErrStr) 
        disp(ErrStr) ; 
    end 
end

