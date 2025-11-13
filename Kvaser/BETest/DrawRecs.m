% function DrawRecs(r,nfig,siglist,range): Draw a complete records set
function DrawRecs(r,nfig,siglist,range)

if ~isstruct(r) || ~isfield(r,'t') || length(r.t) < 3
    error('r must be a struct with ''t'' member of length at least 3') ; 
end

if nargin >= 4 && ~isempty(range) 
    r = GetRecTimeRange( r , range ) ;
    if length(r.t) < 3
        error('Display range includes no data') ; 
    end
end

if nargin < 2 || isempty(nfig) || nfig == 0 
    figure ; 
else
    figure(nfig) ; clf ; 
end 
set(gcf, 'DefaultLegendInterpreter', 'none');


RecNames = fieldnames(r); 
for cnt = numel(RecNames):-1:1
    if strcmp(RecNames{cnt},'t') || strcmp(RecNames{cnt},'Ts') 
        RecNames(cnt) = [] ; 
    end
end


if nargin < 3 || isempty(siglist) 
    siglist = {RecNames}; 
end 

naxes = numel(siglist)  ; 
for cnt = 1:naxes
    nextlist = siglist{cnt};  
    subplot( naxes , 1 , cnt )   ;
    for c1 = 1:numel(nextlist) 
        plot( r.t , r.(nextlist{c1})) ;
        hold on
    end
    set(gca, 'TickLabelInterpreter', 'none');
    legend(nextlist ) ;  
end 
end