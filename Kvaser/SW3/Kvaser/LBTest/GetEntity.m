function ent = GetEntity(name) 
try
    if isstruct(name) 
        name = [name.folder,'\',name.name] ;
    end
    x = load(name) ; 
    ent = x.EntityTable ; 
catch
    ent = [] ; 
end
end