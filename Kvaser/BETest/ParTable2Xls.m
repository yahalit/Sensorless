function ParTable2Xls(ParFullTable,fname,Sheet)
% function ParTable2Xls(ParFullTable,fname,Sheet): Store a parameters table in an excel file
    m       = length(ParFullTable) ; 
    fields  = fieldnames(ParFullTable(1)) ; 
    n = length(fields); 
    c = cell( m+1, n ); 
    
    c(1,:) = fields ; 
    for mcnt = 1:m 
        for ncnt = 1:n 
            c{mcnt+1,ncnt} = ParFullTable(mcnt).(fields{ncnt}) ; 
        end 
    end
    try 
        % Clear sheet contents 
         [~, ~, Raw]=xlsread(fname, Sheet); %#ok<XLSRD> 
         [Raw{:, :}]=deal(NaN);
         xlswrite(fname, Raw, Sheet); %#ok<XLSWT> 


        xlswrite(fname,c,Sheet) ; %#ok<XLSWT> 
    catch ccc
        uiwait( errordlg({'Error saving default parameters file',ccc.message}) ) ; 
    end 
end 


