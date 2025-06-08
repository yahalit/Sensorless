function data = GetCfgPar( name  ) 
% function data = GetCfgPar( name  ) 
% Get a configuration parameter from the default card 
% name: Configuration parameter name 
% Returns: read value 
% Example: data=GetCfgPar('qf0PXi') 
% See also: SetCfgPar
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
        data = FetchObj( [CfgObj,next.Ind] , DataType.float , next.Name ) ;
    else
        data = FetchObj( [CfgObj,next.Ind] , DataType.long , next.Name ) ;
    end
end 
