for AnglePu = 0:1/30:1/3 
    disp("AnglePU=" +  num2str(AnglePu) + "   Wait 20 seconds for angle stabilization") ; 
    
    for rrr = 1:3
        SetAngleError = 0 ; 
            % uiwait( msgbox({'Motor turned off by fault','Exception code:',errstr},struct('Interpreter','none','WindowStyle' , 'modal') ) ) ; 
        SetAngleExp() ; 
        if (SetAngleError == 0  ) 
            break ; 
        end
        uiwait( msgbox({'Motor turned off by fault','Exception code:',errstr},struct('Interpreter','none','WindowStyle' , 'modal') ) ) ; 
        if ( rrr < 3 ) 
            disp("Motoring attempt " + num2str(rrr) + " Failed.... retry ") ; 
        else
            error ('Cant set angle') ; 
        end
    end
    disp("Starting learning pulses") ; 
    
    for Direction = 0: 5 
        VoltExp ; 
    end

end 
