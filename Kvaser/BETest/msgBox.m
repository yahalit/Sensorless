function msgBox(str)
% function msgBox(str) - Message box with enlarged text 
if ~iscell(str)
    str = {str} ; 
end
str{1} = ['\fontsize{12}',str{1}];
h = msgbox(str,'Attention',struct('WindowStyle','modal','Interpreter','tex'));
while isvalid(h) 
    try
        set(h,'WindowStyle','modal')
    catch
    end
    pause(0.2) ; 
end
end