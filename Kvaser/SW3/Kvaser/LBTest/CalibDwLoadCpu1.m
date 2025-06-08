try %OBB section added to start AtpStart if deployed
    if isdeployed && ~exist('AtpCfg','var')
        AtpStart();
    end
catch
    uiwait(errordlg({'Cant run AtpStart'},'Error') ); 
end

calibData = SaveCalib([],'CalibTempFileCpu1.jsn');
ProgCalib('CalibTempFileCpu1.jsn',1);