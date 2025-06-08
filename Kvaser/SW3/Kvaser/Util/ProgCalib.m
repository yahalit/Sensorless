function  Calib = ProgCalib(fname, burn , cfg )
% function  Calib = ProgCalib(fname, burn )
% Read a calibration file (jsn) and optionally program it to the robot
% fname: name of jsn file ([] to open a dialog box) , or a valif calibration 
% burn (default = 0) : 1 if to burn , 2 to put it into robot without burning
% cfg  (default = []) : If empty or 'LP', check for serial flash health
% Returns
% Calib: The contents of the calibration
% ProgCalib('kuku.jsn',1) burns the contents in kuku.jsn to flash 
% See also SaveCalib
% For CPU2 use ProgCalibManCpu2 
global CalibTable 
global messageFig;

messageFig = figure;
version = '1.3';
UpdateTxtBox({'SW version: ', version , ' Programing...'});

DataType = GetDataType() ; 

if nargin < 2 || isempty(burn)   
    burn = 0 ; 
end 

if nargin < 3 
    cfg = [] ;
end 

if isempty(cfg) || startsWith( lower(cfg.ProjType), 'lp' ) 
    s = GetState() ; 
    if ( s.Bit.SerialFlashFault )
        uiwait(errordlg('Serial flash is defective, check electronics') ) ; 
        return ;
    end 
end

CalibObj = hex2dec('2302') ; 
% If no file name is specified, open a dialog box 

if ~isstruct(fname)

    if nargin < 1  ||  isempty( fname)
        [fname,PathName] = uigetfile('*.jsn','Select the JSN calibration file');
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
    
    Calib = json2data.Calib ; 
else
    Calib = fname ; 
end 

if ( burn == 0 )  
    return ; 
end 

CalibNames = cell(1,length(CalibTable) ) ; 
nCalibPars = length(CalibNames); 
for cnt = 1:nCalibPars
    next = CalibTable{cnt} ; 
    CalibNames{cnt} = next{2}; 
end 

if isfield(Calib,'GyroOffsetY') 
    Calib.RWheelArmLatchTravel = 0 ; 
    Calib.LWheelArmLatchTravel = 0 ; 
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
        error ('Field is missing in the JSON data') ;
    end 
end 

for cnt = 1:nCalibPars
    next = CalibTable{cnt} ; 
    nextvalue = next{2} ; 
    if ~isequal(next{5},cnt) 
        error ('Mismatch in the order of calibration parameters') ; 
    end 
    if next{1}.IsFloat 
        SendObj( [CalibObj,cnt] , Calib.(nextvalue) , DataType.float , CalibNames{cnt}) ;
    else
        if ( cnt == 1 ) && ~( pword== Calib.(nextvalue)) 
            error(['Ilegal password for calibration should be : 0x',dec2hex(pword)]) ; 
        end 
        SendObj( [CalibObj,cnt] , Calib.(nextvalue) , DataType.long , CalibNames{cnt} ) ;
    end
end 

if burn == 1
    SendObj( [CalibObj,253] , Calib.CalibData , DataType.long , 'Burn CalibData' ) ;
else
    SendObj( [CalibObj,249] , Calib.CalibData , DataType.long , 'Activate CalibData' ) ;
end

% if ~exist('cfg','var') || isempty(cfg) || isfield ( cfg,'NoDoneMsg') %checks if a stand alone app
%     UpdateTxtBox('Done.');
%     questdlg('Successful Calibration download.', 'Notification','Close', struct ('Default','Close','Interpreter','tex') ); 
%     close all force;
% else 
%     close(messageFig);
% end

UpdateTxtBox('Done.');
questdlg('Successful Calibration download.', 'Notification','Close', struct ('Default','Close','Interpreter','tex') ); 
close(messageFig);

end 

