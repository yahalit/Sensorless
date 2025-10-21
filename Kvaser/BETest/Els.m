% Get the inductance seen L-L given inductance (normalized to 1) and coupling between coils
% zd : Direct L-L vetween ports 1 and 2
% zt : From port 1 to the shorted ports 2 and 3 
% Note that for symmetric arrangement always zt/zd = 0.75
vs = 1 ; % Normalization
m = -0.4  ;  % Coupling , relative
z11 = 1 ; z12 = m ; z13 = m ; 
z21 = m ; z22 = 1 ; z23 = m ; 
z31 = m ; z32 = m ; z33 = 1 ; 

vnd = vs / ( 1 - (z11-z12)/(z12-z22)) ;
id = -vnd / (z12-z22); 
zd  = vs / id; 

f = [ z11 - z13 , z12 - z13 ] * inv([z21-z23,z22-z23;z31-z33,z32-z33]) * [-1;-1] + 1 ;  
vnt = vs / f ; 
it = inv([z21-z23,z22-z23;z31-z33,z32-z33]) * [-1;-1]* vnt ; %#ok<MINV>
zt = vs / it(1) ; 