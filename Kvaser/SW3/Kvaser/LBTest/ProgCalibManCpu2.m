function  Calib = ProgCalibMan(fname, burn  )
% function  Calib = ProgCalibPD(fname, burn  )
% Read a calibration file (jsn) and optionally program it to the robot
% fname: name of jsn file ([] to open a dialog box) 
% burn (default = 0) : 1 if to burn 
% Returns
% Calib: The contents of the calibration
% ProgCalib('kuku.jsn',1) burns the contents in kuku.jsn to flash 
% See also SaveCalib
global TargetCanId2
global DataType
global CalibTable2
global messageFig;

if nargin < 2 || isempty(burn)   
    burn = 0 ; 
end 

messageFig = figure;
version = '1.3';
UpdateTxtBox({'SW version: ', version , ' Programing...'});

CalibObj = hex2dec('2303') ; 
% If no file name is specified, open a dialog box 
if nargin < 1  ||  isempty( fname)
    [fname,PathName] = uigetfile('*.jsn','Select the JSN calibration file');
    fname = [PathName,fname] ; 
end 
    
% Open and read the file 
fi = fopen( fname,'r') ;
if isequal( fi, -1) 
    errorClose ( ['Could not open file [',fname,'] for read'], messageFig) ; 
end

json_string = fread( fi , inf , 'uint8=>char') ;  

fclose( fi) ; 
json2data=loadjson(transpose(json_string(:))); 

Calib = json2data.Calib ; 

if ( burn == 0 )  
    return ; 
end 

CalibNames = cell(1,length(CalibTable2) ) ; 
nCalibPars = length(CalibNames); 
for cnt = 1:nCalibPars
    next = CalibTable2{cnt} ; 
    CalibNames{cnt} = next{2}; 
end 
junk = isfield( Calib, CalibNames ) ; 

pword = hex2dec('12345600') + nCalibPars ; 

if ( any ( junk ==0 ) ) 
    ind = find(junk==0) ;
%     disp ( CalibNames( ind) ) ;  %#ok<FNDSB>
    ButtonName = questdlg([{'Do you want to autocomplete (0) to the missing fields?'},CalibNames( ind)], ...
                         'Fields missing in file', ...
                         'Yes', 'No', 'No');
    if isequal(ButtonName,'Yes')
        for cnt = 1:length(ind) 
            Calib.(CalibNames{ind(cnt)})  = 0 ; 
        end
        Calib.PassWord = pword ; 
        
    else
        errorClose ('Field is missing in the JSON data', messageFig) ;
    end 
end 
Calib.PassWord = pword ; 
for cnt = 1:nCalibPars
    next = CalibTable2{cnt} ; 
    nextvalue = next{2} ; 
    if ~isequal(next{5},cnt) 
        errorClose ('Mismatch in the order of calibration parameters', messageFig) ; 
    end 
    if next{1}.IsFloat 
        SendObj( [CalibObj,cnt,TargetCanId2] , Calib.(nextvalue) , DataType.float , CalibNames{cnt}) ;
    else
        if ( cnt == 1 ) && ~( pword== Calib.(nextvalue)) 
            errorClose(['Ilegal password for calibration should be : 0x',dec2hex(pword)], messageFig) ; 
        end 
        SendObj( [CalibObj,cnt,TargetCanId2] , Calib.(nextvalue) , DataType.long , CalibNames{cnt} ) ;
    end
end 

SendObj( [CalibObj,253,TargetCanId2] , Calib.CalibData , DataType.long , 'Burn CalibData' ) ;

UpdateTxtBox('Done.');
questdlg('Successful Calibration download.', 'Notificatoin','Close', struct ('Default','Close','Interpreter','tex') ); 

% if ~exist('cfg','var') || isempty(cfg) || isfield ( cfg,'NoDoneMsg')
%     close all force;
% end

UpdateTxtBox('Done.');
questdlg('Successful Calibration download.', 'Notification','Close', struct ('Default','Close','Interpreter','tex') ); 
close(messageFig);

end 



