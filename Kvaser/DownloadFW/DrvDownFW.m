
KvaserLibRoot = '..\..\..\Sw3\Kvaser'; 

% addpath('..\NKTest');  
% addpath('..\NKTest\ATP');  

if ~isdeployed %change by OBB to determine if run compiled on not.
    addpath([KvaserLibRoot,'\KvaserCom']);  
    addpath([KvaserLibRoot,'\Recorder']);  
    addpath([KvaserLibRoot,'\Util']);  
    addpath([KvaserLibRoot,'\DownloadFW']);  
    addpath([KvaserLibRoot,'\LBTest']);  
end
DrvDownFWBody ; 