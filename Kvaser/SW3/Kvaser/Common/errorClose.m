function errorClose (text, messageFig) %OBB
    questdlg(text, 'Notificatoin','Close', struct ('Default','Close','Interpreter','tex') ); 

    % if ~exist('cfg','var') || isempty(cfg) || isfield ( cfg,'NoDoneMsg')
    %     close all force;
    % else
    %     close(messageFig);
    %     error (text); 
    % end

    close(messageFig);
end