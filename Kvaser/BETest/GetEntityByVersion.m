function ent = GetEntityByVersion(projname,ver,EntityDir,workdir)
% function ent = GetEntityByVersion(projname,ver,EntityDir,workdir)  Get entity database by version number
x = load([EntityDir,projname,'Entity_',num2str(ver) ]); 
ent = x.EntityTable ; 
ent.SwVer = ver ; 

copyfile([EntityDir,projname,'Params_',num2str(ver),'.xlsx' ],[workdir,'\',projname,'Params.xlsx']) ; 
copyfile([EntityDir,projname,'Cfg_',num2str(ver),'.xlsx' ],[workdir,'\',projname,'Cfg.xlsx']) ; 

end
