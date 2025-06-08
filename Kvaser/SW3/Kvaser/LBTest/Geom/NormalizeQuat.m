function q2=NormalizeQuat(q1) 
if norm(q1) < 1e-6
    q2 = 0 * q1 ; q2(1) = 1 ; 
else
    q2 = q1 / norm(q1) ;
end
 