function q3 = InvQuatOnQuat(q1,q2) 
q1i=InvertQuat ( q1 ) ;
q3=QuatOnQuat( q1i, q2);

end