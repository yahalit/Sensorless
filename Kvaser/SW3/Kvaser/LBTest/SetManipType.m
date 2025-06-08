function SetManipType() 
    ManipName = questdlg('What manipulator?', ...
                         'Select', ...
                         'Scara', 'Flex', 'Scara');
                     
    switch ManipName
        case 'Scara' 
            NewManipType = 1 ; 
        case 'Flex' 
            NewManipType = 2 ; 
        otherwise
            error('Non existent manipulator type') ; 
    end 

    CalibStr = SaveCalib ( [] , 'SetManipTypeParamsBackup.jsn' ); 
    ManipType = bitand( CalibStr.RobotConfig , 15) ;



    if NewManipType == ManipType
        uiwait( msgbox({'Ze kvar mecunfag', 'Ma ata rotze meIma shely'} ,'warn'))  ; 
        return ; 
    end


    CalibStr.RobotConfig  = CalibStr.RobotConfig - bitand(CalibStr.RobotConfig,31) + NewManipType ;
    SaveCalib ( CalibStr , 'SetManipTypeParamsNew.jsn' ); 

    ProgCalib('SetManipTypeParamsNew.jsn', 1 );

    uiwait( msgbox({'PLEASE POWER CYCLE THE ENTIRE ROBOT','Release the mushroom','Press enter when brake realease is heard'}) )  ;


end 