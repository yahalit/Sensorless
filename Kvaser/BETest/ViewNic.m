function ViewNic(nFig,pf,fInterp,org_db, org_deg ,int_db,int_deg,M) 
% function ViewNic(nFig,pf,fInterp,org_db, org_deg ,int_db,int_deg,M) View a Nichols chart

cM = M/(M^2-1) ; 
scM = cM ; 
xcM = (-scM:scM/200:scM) * 0.99999 ; 
ycM = sqrt( scM^2 - xcM.^2) ; 
xcM = xcM - cM * M  ; 
xcM = [xcM , xcM(end:-1:1)] ; 
xcM = [xcM , xcM(1)];
ycM = [ycM , -ycM(end:-1:1)] ; 
ycM = [ycM , ycM(1)];
gcM = xcM + sqrt(-1) * ycM ; 
dbg = 20 * log10( abs( gcM) ) ; 
dbp = 180 / pi  * unwrap( angle( gcM) ) - 360 ; 


figure(nFig) ; 
% nichols(dsys,w) ; 
hold on ; 
% nichols(ggrid,wgrid,'d') ; 
plot( dbp, dbg , 'bx-') ; % Thats the M circle 

% Label texts
pw = pf/2/pi ; 
h_t = zeros(10,1) ; 
if ( length(pf) <= 10 )
    for cnt = 1:length(pf) 
        h_t(cnt) = text(org_deg(cnt) ,org_db(cnt) ,num2str( pw(cnt))); 
%         set(h_t(cnt),'ButtonDownFcn',@VNgrtext )
    end
else
    pfi = log10( logspace(log10(pw(1)),log10(pw(end)),10) ) ; 
    pfj = log10(pw) ; 
    for cnt = 1:10
        [~,nn] = min(abs(pfi(cnt) - pfj) ) ; 
        h_t(cnt) = text(org_deg(nn) ,org_db(nn) ,num2str( pw(nn) )); 
%         set(h_t(cnt),'ButtonDownFcn',@VNgrtext )
    end
    
end 


% Data lines 
h_org = plot( org_deg , org_db , 'd') ; % Original data 
h_int = plot( int_deg   , int_db  ,'r-'); % interpolated data 
set(gca,'UserData',struct('h_org',h_org,'h_int',h_int,'fInterp',fInterp)); 
set(h_int,'ButtonDownFcn',@grstam )
set(h_int,'UserData',struct('h_org',h_org,'h_int',h_int,'fInterp',fInterp)); 
set(h_org,'ButtonDownFcn',@grstam );
set(h_org,'UserData',struct('h_org',h_org,'h_int',h_int,'fInterp',pf)); 

ngrid

yy = get(gca,'ylim') ; 
llim = -50 ; 
if ( yy(1) < llim && yy(2) >=0 )
    set(gca,'ylim',[llim,yy(2)]); 
end 


