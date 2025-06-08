function [pars,misfit] = GetDetectedSlavePars(DetectedSlaves) 
%function [pars,misfit]  = GetDetectedSlavePars() 
%Decode parameters of detected slaves through the contents of their extended identity messages
% pars(:,1) : Proj type (software) , pars(:,2) : Proj Id (hardware) ,pars(:,3) : CAN ID, pars(:,4) : SW version
% SW version structure: 
% #define SubverPatch ( ((FIRM_YR-2000) << 24 ) + (FIRM_MONTH<<20) + (FIRM_DAY <<15) +(SRV_VER << 8) + (SRV_SUBVER<<4) + SRV_PATCH ) ;
% misfit: Indices where project ID does not match CAN ID
pars = [] ; 
if isempty(DetectedSlaves) 
    return ; 
end 
[m,n] = size(DetectedSlaves);
if ( m == 1 )
    SwVer = DetectedSlaves * 0 ; 
else
    SwVer = DetectedSlaves(2,:);
end

[DetectedSlaves,ind] = sort(DetectedSlaves(1,:)) ; 
SwVer = SwVer(ind); 

ProjIdList =  [1]; 
CanIdList = [44];
ind = 1:10 ; 

misfit = [] ; 
pars = zeros(n,4);
for cnt = 1:n 
    next = DetectedSlaves(cnt); 
    ProjType = bitand(next,2^24 * (2^8-1))/2^24 ; 
    ProjId = bitand(next,2^8 * (2^16-1))/2^8 ;
    CanId = bitand(next,255) ; 
    next = ind( ProjId==ProjIdList); 
    if ~isempty(next)
        if ~(CanId==CanIdList(next)) 
            misfit = [misfit,cnt]; %#ok<AGROW> 
        end
    end

    pars(cnt,:) = [  ProjType , ProjId , CanId , SwVer(cnt) ] ;
end 


end 
