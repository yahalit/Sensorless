function SetCfgPar( name , data ) 
% function RetCode = SetCfgPar( name , data ) 
% Set a configuration parameter to the default card 
% name: Configuration parameter name 
% data: Value to set (must be in range)  
% Example: RetCode=SetCfgPar('qf0PXi',0.5) 
% See also: GetCfgPar
global RecStruct %#ok<GVMIS>
global DataType %#ok<GVMIS> 
    CfgObj = hex2dec('220d') ; 
    Tab = RecStruct.CfgFullTable ; 
    Names = {Tab.Name};
    place = find(strcmp( Names , name),1);
    if isempty(place) 
        errmsg = ['Could not find parameter : ', name ] ;
        error( errmsg) ; 
    end
    next = Tab(place);
    if bitand(next.Flags,2)  
        SendObj( [CfgObj,next.Ind] , data , DataType.float , next.Name ) ;
    else
        SendObj( [CfgObj,next.Ind] , data , DataType.long , next.Name ) ;
    end
end 
