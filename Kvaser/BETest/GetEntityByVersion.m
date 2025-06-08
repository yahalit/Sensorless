function ent = GetEntityByVersion(projname,ver,EntityDir,workdir)
x = load([EntityDir,projname,'Entity_',num2str(ver) ]); 
ent = x.EntityTable ; 
ent.SwVer = ver ; 

copyfile([EntityDir,projname,'Params_',num2str(ver),'.xlsx' ],[workdir,'\',projname,'Params.xlsx']) ; 
copyfile([EntityDir,projname,'Cfg_',num2str(ver),'.xlsx' ],[workdir,'\',projname,'Cfg.xlsx']) ; 

end
