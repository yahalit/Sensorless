function UpdateTxtBox (text , doDisp) %OBB
    global msgboxHandle;
    global messageFig;
    global ann;
    
    if nargin < 2 
        doDisp = 1 ; 
    end
    % if exist('msgboxHandle','var')
    %     msgboxHandle.delete();
    % end
    % msgboxHandle = msgbox (text);

    dim = [ .1 .1 .8 .8];
    if exist('ann', 'var')
        delete(ann);
    end

    ann = annotation(messageFig,'textbox',dim,'String',text);
    %refresh(messageFig);
    drawnow;

    if ( doDisp) 
        disp(text);
    end
    
    %text(0.2
end