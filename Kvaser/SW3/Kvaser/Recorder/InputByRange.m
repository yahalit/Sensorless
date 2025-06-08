function out = InputByRange(str,limits,dflt) 

out = [] ; 
while isempty(out) || out < limits(1) || out  > limits(2) 
    ppText = inputdlg(['\fontsize{12}',str],['Range: [',num2str(limits(1)),':',num2str(limits(2)),']'],...
        1,{num2str(dflt)},struct('Resize','on','WindowStyle','modal','Interpreter','tex'))  ;
    try
        out  = str2double(ppText) ; 
    catch
        out = [] ; 
    end 
end 

end 