function str = GetProjectAttributesByName(strin)
    strin = lower(strin) ; 
    if contains( strin , 'wheel')
        str = struct( 'Card' , 'Servo' ,'Axis','Wheel','Proj','Dual') ;  
        ShortHand = 'W' ;
        sided = 1 ; 
    elseif contains( strin , 'steer')
        str = struct( 'Card' , 'Servo' ,'Axis','Steering','Proj','Dual') ; 
        ShortHand = 'S' ;
        sided = 1 ; 
    elseif contains( strin , 'intfc')
        str = struct( 'Card' , 'Intfc' ,'Axis','None','Proj','Dual') ; 
        ShortHand = 'I' ;
        sided = 1 ; 
    else 
    %elseif contains( strin , 'neck')
        str = struct( 'Card' , 'Neck' ,'Axis',strin,'Proj','Single') ; 
        sided = 0 ; 
        ShortHand = 'NK' ;
%     else
%         error('Unknown entity') ; 
    end 
    if sided 
        if contains( strin,'_r')
            str.Side = 'Right' ; 
            ShortHand = ['R',ShortHand];
        elseif contains( strin,'_l')
            str.Side = 'Left' ; 
            ShortHand = ['L',ShortHand];
        else
            if contains( strin,'boot')
                str.Side = 'None' ; 
            else
                error ([strin ,' : Undefined side, set left or right']) ; 
            end
        end
    else
        str.Side = 'None' ; 
    end
    str.ShortHand = ShortHand;
end