% Matrix2Cross  Computes the vector x (3-dim) associated to the anti-skew matrix M, such that M*y=cross(x,y)
% M(3,3) : anti-skew matrix
% x(3,1) : column vector

% This code has been adapted from the ACT toolbox, developed by Guillermo Gallego Bonet.


function x = Matrix2Cross(M)
x = zeros(3,1);
x(3) = -M(1,2);
x(2) =  M(1,3);
x(1) = -M(2,3);