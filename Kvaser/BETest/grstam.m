function grstam(varargin) 
% Handler for the ViewNic mouse, displays frequency + cursor data
line = varargin{1} ; 
hit  = varargin{2} ; 
deg = hit.IntersectionPoint(1) ; 
db  = hit.IntersectionPoint(2) ; 
ud   = line.UserData ; 

[~,n] = min(vecnorm([line.XData ; line.YData] - [deg;db] , 2 , 1 ) ) ; 
f = ud.fInterp(n)/2/pi ; 
% if length(line.XData) < 200 
%     f = f * 1.00001 ; 
% end 
xlabel ( line.Parent, ['F=',num2str(f) ,' Ph: ',num2str(line.XData(n)),' Amp: ',num2str(line.YData(n))]) ; 

end 