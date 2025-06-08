function [TabPars,aa,indArray,CfgTab,CgfRaw,CfgInd] = InitDrvSetup(fname,cfgfname) 
[~,cc,aa] = xlsread(fname,'DefaultPars'); 
TabPars =table(aa(2:end,2),aa(2:end,3),aa(2:end,4),aa(2:end,5),cc(2:end,6)) ;
TabPars.Properties.VariableNames = aa(1,2:end) ; 
RowNames = cell(5,1); 
[m,~] = size(aa) ; 
indArray = zeros( m-1,1);
for cnt = 1:m-1 
    RowNames{cnt} = num2str(aa{cnt+1,1}) ;
    indArray(cnt) = aa{cnt+1,1} ; 
end
TabPars.Properties.RowNames = RowNames ; 

[~,~,aa] = xlsread(cfgfname,'DefaultCfg'); 
CgfRaw  = aa ; 
CfgTab =table(aa(2:end,2),aa(2:end,3),aa(2:end,4),aa(2:end,5),aa(2:end,6),aa(2:end,7),aa(2:end,8),aa(2:end,5)) ;
CfgTab.Properties.VariableNames = aa(1,2:end) ; 
RowNames = cell(5,1); 
[m,~] = size(aa) ; 
CfgInd = zeros( m-1,1);
for cnt = 1:m-1 
    RowNames{cnt} = num2str(aa{cnt+1,1}) ;
    CfgInd(cnt) = aa{cnt+1,1} ; 
end
CfgTab.Properties.RowNames = RowNames ; 


end 