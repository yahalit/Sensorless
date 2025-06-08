function [CalibStr,fname] = SaveCalibManCpu2 ( CalibIn , fname  ) 
% function [CalibStr,fname] = SaveCalibManCpu2 ( CalibIn , fname  ) 
% Calib: A struct like
%     Calib = struct( 'ParArr0',ParArr0 , 'ParArr1',ParArr1 , ...
%         'ParArr2', ParArr2 ,'ParArr3', ParArr3 , ...
%         'ParArr4',ParArr4 , 'ParArr5', ParArr5 , ...
%          'ParArr6',ParArr6 , 'ParArr7', ParArr7, ...
%          'CalibDate', CalibDate ,'CalibData', CalibData )  ; 
% If Calib = [] , the calibration is read from the robot
% if Calib = 0  , the calibration is set zero 
%
% fname: Valid file name for JSON storage (text) 
%        If absent storage is not made
%        If empty , user selects file name by dialog
% Example: 
% SaveCalib([],'kuku.jsn')  reads the calibration from the robot and save
% it to kuku.jsn
% See also ProgCalib


global DataType 
global CalibTable2 
global TargetCanId2
CalibObj = hex2dec('2303');
ODItems = struct( 'SetPass',[CalibObj,1,TargetCanId2],'ReadFlashStruct',[CalibObj,251,TargetCanId2]) ; 

nCalibPars = FetchObj( [CalibObj,0,TargetCanId2] , DataType.long ,'Set the password') ;  
pword      = hex2dec('12345600') + nCalibPars ;

if isempty( CalibIn) 
    % Load the calibration from the flash to the programming struct , also
    % clears te calibration candidate 
    stat = SendObj( ODItems.SetPass , pword , DataType.long ,'Set the password') ;  
    if stat 
        error ( 'Cant set flash password') ; 
    end 
    
    stat = SendObj( ODItems.ReadFlashStruct , 0 , DataType.long ,'Load the calibration from the flash to the programming struct',[],300) ;  

    if stat  
        ButtonName = questdlg({'The calibration flash may be unprogrammed';['Error code: ', Errtext(stat)];'Continue assuming no existing calibration?'}, ...
                         'Attention', ...
                         'Yes', 'No','Yes');
        if ~isequal(ButtonName,'Yes' ) 
           error ( 'Could not backup the existing calibration from the flash') ;  
        else 
            SendObj( [hex2dec('2303'),253,TargetCanId2] , 0 , DataType.long  , 'Save in flash all zeros calibration' ) ;
            %             CalibIn = 0 ; 
        end
    end
end 

CalibNames = cell(1,length(CalibTable2) ) ; 
nCalibPars = length(CalibNames); 
for cnt = 1:nCalibPars
    next = CalibTable2{cnt} ; 
    CalibNames{cnt} = next{2}; 
end 

CalibStr = struct() ; 
            
if isempty( CalibIn)  
   
    % Get the program calibration from the robot
    for CalibElementCnt = 1:length(CalibNames)
        next =CalibNames{CalibElementCnt}; 
        nextTabLine  = CalibTable2{CalibElementCnt} ; 
        if nextTabLine{1}.IsFloat     
            CalibStr.(next) = FetchObj( [CalibObj,CalibElementCnt,TargetCanId2] , DataType.float ,next) ;
        else
            CalibStr.(next) = FetchObj( [CalibObj,CalibElementCnt,TargetCanId2] , DataType.long ,next) ;
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