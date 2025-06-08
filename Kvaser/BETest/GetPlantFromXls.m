function [pf,pdb,pdeg] = GetPlantFromXls(fname,sname) 
    if nargin < 1 
        error ('First parameter must be file name '); 
    end 
    if ~contains(fname,'.')
        fname = [fname,'.xlsx'] ; 
    end

    if nargin < 2 || isempty(sname)
        sname = 'Plant' ; 
    end 
    try 
    [~,~,raw] = xlsread( fname, sname ); 
    catch me 
        error( ['Failed to open excel : ', me.message]); 
    end 
    N = readcellnum( raw(2,1) ) ; 
    
    if ~fix(N)==N || N < 2 || N > 2000 
        error( ['Not a valid data count : ', num2str(N)]); 
    end 
 
    pf = zeros(N,1); pdb = pf ; pdeg = pf ; 
    for cnt = 1:N 
        pf(cnt) = readcellnum(  raw(3+cnt,1) ) ;
        pdb(cnt) = readcellnum( raw(3+cnt,2) ) ;
        pdeg(cnt) = readcellnum( raw(3+cnt,3) ) ;
    end 
end 

function d = readcellnum( c ) 
    d = c{1} ; 
    if ~isequal(class(d),'double') || ~isfinite(d) 
        error(['Expected a number : ',c]) ; 
    end 
end 