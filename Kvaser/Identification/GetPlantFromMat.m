function [pf,pdb,pdeg,fp] = GetPlantFromMat(fname,varname) 
    if nargin < 1 
        error ('First parameter must be file name '); 
    end 
    if ~contains(fname,'.')
        fname = [fname,'.mat'] ; 
    end

    if nargin < 2 || isempty(sname)
        varname = 'fp' ; 
    end 
   

    try 
        fr = load(fname,varname) ; 
        fp = fr.(varname) ; 
        if contains(lower(fp.Outvar),'pos')
            gozer = tf( (1/fp.Ts)*[1,-1],[1,0],fp.Ts) ; 
            ggoz  = freqresp(gozer,fp.f*2*pi) ; 
            ggoz  = ggoz(:) ; 
            gozerdb = 20 * log10( abs(ggoz) ) ; 
            gozerdeg = angle(ggoz) * 180 / pi  ; 
        else
            gozerdb = 0 * fp.f ;
            gozerdeg = gozerdb  ; 
        end
        pf = fp.f ; 
        pdb = fp.logamp + gozerdb ;
        pdeg  = fp.phdeg + gozerdeg  ;
    catch 
        error ('Could not load data from mat file '); 
    end 
end 

