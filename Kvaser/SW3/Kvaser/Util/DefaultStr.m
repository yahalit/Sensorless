function str = DefaultStr( str_in , str_ref )
    str = str_in ; 
    fn = fieldnames(str_ref) ; 
    for cnt = 1:length(fn) 
        if ~isfield(str,fn{cnt})  
            str.(fn{cnt}) = str_ref.(fn{cnt}) ; 
        end
    end 
end 