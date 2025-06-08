try %OBB section added to start AtpStart if deployed
    if isdeployed && ~exist('AtpCfg','var')
        AtpStart();
    end
catch
    uiwait(errordlg({'Cant run AtpStart'},'Error') ); 
end

calibData = SaveCalibManCpu2([],'CalibTempFileCpu1.jsn');
ProgCalibManCpu2('CalibTempFileCpu1.jsn',1);