% VecAngle2Rot  
% Computes the rotation matrix corresponding to indicated axis and angle.
% u(3) is a vector indicating the rotation axis.
% theta is an angle in radians.

% This code has been adapted from the ACT toolbox, developed by Guillermo Gallego Bonet.


function R=VecAngle2Rot(u,theta)

u=u/norm(u);
M=Cross2Matrix(u);
R = eye(3)+M*sin(theta)+M^2*(1-cos(theta)); % Rodrigues formula