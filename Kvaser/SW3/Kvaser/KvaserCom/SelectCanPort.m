function port = SelectCanPort(KvaserPortsDescriptor)
    if isempty(KvaserPortsDescriptor) 
        port = [] ; 
        return ;
    end
    [m,~] = size(KvaserPortsDescriptor) ; 
    k1 = KvaserPortsDescriptor(1,:) ; 
    if m == 1
        port = k1{1} ; 
        return ; 
    end
    if m == 2
        k2 = KvaserPortsDescriptor(2,:) ; 

        ButtonName = questdlg('Select CAN adapter', ...
                             'KvaserSerialNumber', ...
                             num2str(k1{2}), num2str(k2{2}), num2str(k1{2}));
        if isequal( str2double(ButtonName),k1{2} )  
            port = k1{1} ; 
        else
            port = k2{1} ; 
        end
        return ; 
    end
    error('Not implemented, for now Can deal with 2 Kvasers at most' ) ;


end