function [stat] = WriteNewUdp ( pars_in ) 
global AtpCfg 
global UdpHandle 

pars = pars_in ; % This routine is called by reference from a DLL, assure that the input is not chsnged
for cnt = 1:length(pars) 
    pars(cnt) = bitand( pars(cnt) + 65536 , 255 ) ;
end

stat = 0;
if ( AtpCfg.Udp.On ) 
    %id = pars(1) ; 
    fwrite(UdpHandle,char(pars(1:16)),'uchar'); 
    x = 1 ;  %#ok<NASGU>
    % disp( dec2hex((double(pars(1:16)) ) ) )
else
    stat = -1 ; 
end

end