% Cross2Matrix  Computes the ant-skew matrix M associated to x (3-dim), such that M*y=cross(x,y)
% This code has been adapted from the ACT toolbox, developed by Guillermo Gallego Bonet.


function M=Cross2Matrix(x)
M=zeros(3);
M(1,2)=-x(3);
M(1,3)= x(2);
M(2,3)=-x(1);
M=M-M';