% x = 
% 
%   struct with fields:
% 
%                    time: [0 1.0000e-03 0.0020 0.0030 0.0040 0.0050 0.0060 … ]
%            joint_angles: [3×95773 double]
%        joint_velocities: [3×95773 double]
%     joint_accelerations: [3×95773 double]
%           joint_torques: [3×95773 double]
x = load('joint_dynamics_reference_milking') 
t = x.time ; 
T = x.joint_torques ; 
V = x.joint_velocities; 
figure(30) ; clf 
subplot( 2,1,1);
plot( t , T ) 
subplot( 2,1,1);
plot( t , V ) 
