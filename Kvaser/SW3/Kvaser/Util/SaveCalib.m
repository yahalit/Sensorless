function [CalibStr,fname] = SaveCalib ( CalibIn , fname , cfg  ) %#ok<INUSD> 
%function CalibStr = SaveCalib ( Calib , fname ) 
% Calib: A struct like
%     Calib = struct( 'RSteerPotCenter',RSteerPotCenter , 'LSteerPotCenter',LSteerPotCenter , ...
%         'RSteerPotGainFac', RSteerPotGainFac ,'LSteerPotGainFac', LSteerPotGainFac , ...
%         'RNeckPotCenter',RNeckPotCenter , 'LNeckPotCenter', LNeckPotCenter , ...
%          'RNeckPotGainFac',RNeckPotGainFac , 'LNeckPotGainFac', LNeckPotGainFac, ...
%          'CalibDate', CalibDate ,'CalibData', CalibData )  ; 
% If Calib = [] , the calibration is read from the robot with the flashed contents loaded first
% If Calib = -1 , the calibration is read from the robot RAM
% if Calib = 0  , the calibration is set zero 
%
% fname: Valid file name for JSON storage (text) 
%        If absent storage is not made
%        If empty , user selects file name by dialog
% Example: 
% SaveCalib([],'kuku.jsn')  reads the calibration from the robot and save
% it to kuku.jsn
% See also ProgCalib
% For CPU2 use SaveCalibManCpu2()


global CalibTable 
CalibObj = hex2dec('2302');

DataType = GetDataType() ; 

ODItems = struct( 'SetPass',[CalibObj,1],'ReadFlashStruct',[CalibObj,251]) ; 
NoFlash = 0 ; 
if isequal( CalibIn ,-1)
    NoFlash = 1 ; 
    CalibIn = [] ;
end

nCalibPars = FetchObj( [CalibObj,0] , DataType.long ,'Set the password') ;  
pword      = hex2dec('12345600') + nCalibPars ;
if NoFlash 
    pword      = pword + hex2dec('20000000');
end

if isempty( CalibIn) 
    % Load the calibration from the flash to the programming struct 
    stat = SendObj( ODItems.SetPass , pword , DataType.long ,'Set the password') ;  
    if stat 
        error ( 'Cant set flash password') ; 
    end 
    
    if ( NoFlash == 0 )
        stat = SendObj( ODItems.ReadFlashStruct , 0 , DataType.long ,'Load the calibration from the flash to the programming struct') ;  
    
        if stat  
            ButtonName = questdlg({'The calibration flash may be unprogrammed';'Continue assuming no existing calibration?'}, ...
                             'Attention', ...
                             'Yes', 'No','Yes');
            if ~isequal(ButtonName,'Yes' ) 
               error ( 'Could not backup the existing calibration from the flash') ;  
            else 
                CalibIn = 0 ; 
            end
        end
    end
end 

CalibNames = cell(1,length(CalibTable) ) ; 
nCalibPars = length(CalibNames); 
for cnt = 1:nCalibPars
    next = CalibTable{cnt} ; 
    CalibNames{cnt} = next{2}; 
end 

CalibStr = struct() ; 
            
if isempty( CalibIn)  
   
    % Get the program calibration from the robot
    for CalibElementCnt = 1:length(CalibNames)
        next =CalibNames{CalibElementCnt}; 
        nextTabLine  = CalibTable{CalibElementCnt} ; 
        if nextTabLine{1}.IsFloat     
            CalibStr.(next) = FetchObj( [CalibObj,CalibElementCnt] , DataType.float ,next) ;
        else
            CalibStr.(next) = FetchObj( [CalibObj,CalibElementCnt] , DataType.long ,next) ;
        end
    end
elseif isequal( CalibIn , 0) 
    CalibStr = struct() ; 
    for cnt = 1:nCalibPars
        NextName = CalibNames{cnt};
        CalibStr.(NextName) = 0 ; 
    end
    CalibStr.PassWord = pword ; 
    CalibStr.CalibDate = fix( now )  ;
    CalibStr.CalibData = 1 ; 
else
   for cnt = 1:length(CalibNames)
       try 
            next =CalibNames{cnt}; 
            CalibStr.(next) = CalibIn.(next);
       catch 
           error (['Calibration struct field does not have the expected names, [',next,'] not found']) ;
       end 
   end 
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

str = savejson('Calib',CalibStr,struct('ParseLogical',1)) ; 
fi = fopen( fname,'w') ;
if isequal( fi, -1) 
    error ( ['Could not open file [',fname,'] for write']) ; 
end

fwrite(fi,str,'char') ; 

fclose(fi) ; 
end 