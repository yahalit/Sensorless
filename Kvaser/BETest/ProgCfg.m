function  Cfg = ProgCfg(fname, CfgTable , CanIdIn  )
% function  Cfg = ProgCfg(fname) 
% Read a Cfgration file (jsn) and optionally program it to the robot
% fname: name of jsn file ([] to open a dialog box) 
% Returns
% Cfg: The contents of the Cfgration
% ProgCfg('kuku.jsn',1) burns the contents in kuku.jsn to flash 
% See also SaveCfg
global DataType %#ok<GVMIS> 

global RecStruct %#ok<GVMIS,TLEV> 
global EntityTableWheel
global EntityTableNeck
global TargetCanId ; 

CanId = TargetCanId; 
if nargin < 2 
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
if nargin >= 3 
    CanId = CanIdIn ;
end


% CfgTable = RecStruct.CfgTable ;


CfgObj = hex2dec('220d') ; 
% If no file name is specified, open a dialog box 
if nargin < 1  ||  isempty( fname)
    [fname,PathName] = uigetfile('*.jsn','Select the JSN Cfgration file');
    fname = [PathName,fname] ; 
end 
    
% Open and read the file 
fi = fopen( fname,'r') ;
if isequal( fi, -1) 
    error ( ['Could not open file [',fname,'] for read']) ; 
end

json_string = fread( fi , inf , 'uint8=>char') ;  

fclose( fi) ; 
json2data=loadjson(transpose(json_string(:))); 

Cfg = json2data.Cfg ; 

CfgNames = fieldnames (CfgTable)   ; 
nCfgPars = length(CfgNames); 

junk = isfield( Cfg, CfgNames ) ; 

if ( any ( junk ==0 ) ) 
    ind = find(junk==0) ;
%     disp ( CfgNames( ind) ) ;  %#ok<FNDSB>
    ButtonName = questdlg([{'Do you want to autocomplete (0) to the missing fields?'},CfgNames( ind)], ...
                         'Fields missing in file', ...
                         'Yes', 'No', 'No');
    if isequal(ButtonName,'Yes')
        for cnt = 1:length(ind) 
            Cfg.(CfgNames{ind(cnt)})  = 0 ; 
        end
        Cfg.PassWord = pword ; 
        
    else
        error ('Field is missing in the JSON data') ;
    end 
end 

for cnt = 2:nCfgPars
    next = CfgTable.(CfgNames{cnt})  ; 
    nextvalue = Cfg.(CfgNames{cnt}) ; 
    if ~isequal(next.Ind+1,cnt) 
        error ('Mismatch in the order of Cfgration parameters') ; 
    end 
    if bitand(next.Flags,2) 
        SendObj( [CfgObj,next.Ind,CanId] , nextvalue , DataType.float , CfgNames{cnt}) ;
    else
        SendObj( [CfgObj,next.Ind,CanId] , nextvalue , DataType.long , CfgNames{cnt} ) ;
    end
end 
SendObj( [CfgObj,0,CanId] , 1 , DataType.float , "Approve configuration") ;

end 


