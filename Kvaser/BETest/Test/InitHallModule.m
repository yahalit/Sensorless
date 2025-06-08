function InitHallModule()
SetEnums ; 
global HallDecode %#ok<GVMIS> 
    HallDecode.HallValue = HALL_BAD_VALUE ;
    HallDecode.HallException  = 0 ;
    HallDecode.HallAngle = 0 ; 
    HallDecode.Init = 0 ; 
end
