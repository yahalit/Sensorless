function Calib = SaveCalibPD ( Calib , fname  , FieldNames) 
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
%        If absent, storage is not made


global DataType 

if isempty( Calib) 
    % Load the calibration from the flash to the programming struct 
    
    % SendObj( [hex2dec('2302'),1] , hex2dec('12345678') , DataType.long , 'Pass for calibration operations' ) 
    stat = SendObj( [hex2dec('2302'),31] , 0 , DataType.long , 'Load the calib structs from flash' ) ;
    if stat   
        ButtonName = questdlg({'The calibration flash may be unprogrammed';'Continue assuming no existing calibration?'}, ...
                         'Attention', ...
                         'Yes', 'No','Yes');
        if ~isequal(ButtonName,'Yes' ) 
           error ( 'Could not backup the existing calibration from the flash') ;  
        else 
            Calib = 0 ; 
        end
    end
end

nCalib   = FetchObj( [hex2dec('2302'),22] , DataType.long , 'Get number of calibration pars') ; 

CalibVec = zeros( 1 , nCalib) ; 
CalibDate = 0 ; 
CalibData = 0 ; 

if isempty( Calib)  
    % Get the calibration from the robot
    for cnt = 1:nCalib  
        CalibVec(cnt) = FetchObj( [hex2dec('2302'),1+cnt] , DataType.float , ['Get Parameter [',num2str(cnt-1),']']) ; 
    end
    CalibDate = FetchObj( [hex2dec('2302'),20] , DataType.long , 'Get CalibDate') ; 
    CalibData = FetchObj( [hex2dec('2302'),21] , DataType.long , 'Get ID') ;  
end

if isempty( Calib)  || isequal( Calib , 0) 
    if nargin < 2
        FieldNames = cell(1,nCalib ) ; 
        for nf = 1 : nCalib 
            FieldNames{nf} = ['CalibPar',num2str(nf)] ; 
        end 
    end 
    if nCalib ~= length(FieldNames)
        error ('Number of calibration parameters does not match the number of fields in the calib struct') ; 
    end 
    Calib = struct( 'CalibDate', CalibDate ,'CalibData', CalibData )  ;
    for cnt = 1:nCalib  
        Calib.(FieldNames{cnt}) = CalibVec(cnt) ;  
    end
end

if nargin < 2 || isempty(fname) 
    return ; 
end 



str = savejson('Calib',Calib,struct('ParseLogical',1)) ; 
fi = fopen( fname,'w') ;
if isequal( fi, -1) 
    error ( ['Could not open file [',fname,'] for write']) ; 
end

fwrite(fi,str,'char') ; 

fclose(fi) ; 
end 