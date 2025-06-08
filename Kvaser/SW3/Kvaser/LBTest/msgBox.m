function msgBox (text) %OBB
    global msgboxHandle;
    global messageFig;
    global ann;
    
    % if exist('msgboxHandle','var')
    %     msgboxHandle.delete();
    % end
    % msgboxHandle = msgbox (text);

    dim = [ .1 .1 .8 .8];
    if exist('ann', 'var')
        delete(ann);
    end

    ann = annotation(messageFig,'textbox',dim,'String',text);

    disp(text);
    
    %text(0.2
end