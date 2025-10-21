function MyErrDlg(str,hdr)
% function MyErrDlg(str) Error dialog with given string and enlarged font
if ~iscell(str)
    str = {str} ; 
end
if nargin < 2 
    hdr = 'Failure' ; 
end 

str{1} = ['\fontsize{12}',str{1}];
h = msgbox(str,hdr,struct('WindowStyle','modal','Interpreter','tex'));
while isvalid(h) 
    try
        set(h,'WindowStyle','modal')
    catch
    end
    pause(0.2) ; 
end
end