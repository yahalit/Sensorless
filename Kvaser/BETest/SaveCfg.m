function [CfgStr] = SaveCfg ( CfgIn , fname , CfgTable , CanIdIn) 
%function CfgStr = SaveCfg ( Cfg , fname ) 
% Cfg: A struct like
%     Cfg = struct( 'Name1' bval_of_name1, ... )  ; 
% If Cfg = [] , the Cfgration is read from the robot
%
% fname: Valid file name for JSON storage (text) 
%        If absent storage is not made
%        If empty , user selects file name by dialog
% Example: 
% SaveCfg([],'kuku.jsn')  reads the Cfgration from the robot and save
% it to kuku.jsn
% See also ProgCfg


global DataType %#ok<GVMIS> 
global EntityTableWheel
global EntityTableNeck
global TargetCanId ; 

CanId = TargetCanId; 
if nargin < 3 
    global RecStruct %#ok<GVMIS,TLEV> 
    CfgTable = RecStruct.CfgTable ;
else
    if ischar(CfgTable)
        str = GetProjectAttributesByName(CfgTable) ;
        switch str.ShortHand
            case 'LW'
                ent = EntityTableWheel  ; 
                CfgTable = ent.CfgTable ;
                CanId = 12 ; 
            case 'RW'
                ent = EntityTableWheel  ; 
                CfgTable = ent.CfgTable ;
                CanId = 22 ; 
            case 'LS'
                ent = EntityTableWheel  ; 
                CfgTable = ent.CfgTable ;
                CanId = 11 ; 
            case 'RS'
                ent = EntityTableWheel  ; 
                CfgTable = ent.CfgTable ;
                CanId = 21 ; 
            case 'NK'
                ent = EntityTableNeck ;
                CfgTable = ent.CfgTable ;
                CanId = 30 ; 
%         EntName = [str.ShortHand,'Entity'] ;
%         if isfield (RecStruct, EntName) 
%             Ent = RecStruct.(EntName) ; 
%             CfgTable = Ent.
%         end
        end
    end
end
if nargin >= 4 
    CanId = CanIdIn ;
end

CfgObj = hex2dec('220d');

nCfgPars = FetchObj( [CfgObj,255,CanId] , DataType.long ,'Get number of configuration parameters') ; 
CfgNames = fieldnames(CfgTable) ; 
if ~(nCfgPars==length( CfgNames))
    error(['Length of configuration does not match (expected: ',num2str(length( CfgNames)),' Found:',num2str(nCfgPars) ])  ; 
end 

Values = zeros(nCfgPars,1) ; 

for cnt = 1:length(CfgNames) 
    ind = CfgTable.(CfgNames{cnt}).Ind ; 
    if ~(ind==cnt-1)
        error('Configuration fields are out of order') ; 
    end 
end


if isempty( CfgIn) 
    % Load the Cfgration from the flash to the programming struct 
    for cnt = 1:length(CfgNames) 
        ind = CfgTable.(CfgNames{cnt}).Ind ; 
        if  bitand( CfgTable.(CfgNames{cnt}).Flags , 2 )
            Values(ind+1) = FetchObj( [CfgObj,ind,CanId] , DataType.float ,['Config par: ',CfgNames{cnt}]) ;
        else
            Values(ind+1) = FetchObj( [CfgObj,ind,CanId] , DataType.long ,['Config par: ',CfgNames{cnt}]) ;
        end
    end
else
   for cnt = 1:length(CfgNames)
       try 
            next =CfgNames{cnt}; 
            Values(next) = CfgIn.(next).Value;
       catch 
           error (['Configuration struct field does not have the expected names, [',next,'] not found']) ;
       end 
   end 
end

CfgStr = struct() ; 
for cnt = 1:length(CfgNames) 
    next =CfgNames{cnt}; 
    CfgStr.(next) = Values(cnt) ; 
end


if nargin < 2 
    return ; 
end 

if isempty( fname)  
    [file,path] = uiputfile('*.jsn');
    if isequal(file,0) 
        return ; 
    end 
    fname = [path,file];
end

str = savejson('Cfg',CfgStr,struct('ParseLogical',1)) ; 
fi = fopen( fname,'w') ;
if isequal( fi, -1) 
    error ( ['Could not open file [',fname,'] for write']) ; 
end

fwrite(fi,str,'char') ; 

fclose(fi) ; 
end 