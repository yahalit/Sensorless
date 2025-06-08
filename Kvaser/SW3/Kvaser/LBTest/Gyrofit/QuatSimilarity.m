function q = QuatSimilarity(q1,q2) 
q3 = q1 ; 
q3(2:4) = -q3(2:4) ; 
q = QuatOnQuat(q1,QuatOnQuat(q2,q3)) ;

end 
