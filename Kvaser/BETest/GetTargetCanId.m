function [TargetId,IntfcId] = GetTargetCanId(CanId) 
global TargetCanId  %#ok<GVMIS> 
if nargin < 1 || isempty(CanId)
    CanId = TargetCanId ; 
end
TargetId = CanId ; 
IntfcId = TargetId ; 
if (TargetId == 22 ) || (TargetId == 21 ) 
     IntfcId = 24  ; 
end
if (TargetId == 12 ) || (TargetId == 11 ) 
     IntfcId = 14  ; 
end
end 