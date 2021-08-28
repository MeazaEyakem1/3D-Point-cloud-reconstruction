% factorize_E Computes the camera movement fron the Essential matrix, finding R, T such that E ~ R T_x
% R(3,3,2): the two possible solutions for R.
% T(3): unitary vector that represents the solutions for T (up to scale).

% This code has been adapted from the ACT toolbox, developed by Guillermo Gallego Bonet.


function [R,T] = factorize_E(E)

[U,S,V]=svd(E);

R0=zeros(3);
R0(1,2)=-1;
R0(2,1)=1;
R0(3,3)=1;
sigma=(S(1,1)+S(2,2))/2;
S=diag([sigma,sigma,0]);

%U_S_Vt_minus_E = U*S*V'-E

A=zeros(3);
A(1,2)=sigma;
A(2,1)=-sigma;

R1 = U*R0*V';
MT=V*A*V';
if (det(R1)<0)
    R1=-R1;
    MT=-MT;
end
T = Matrix2Cross(MT);
T = T/norm(T);

%R0_Vt_V_A_minus_S = R0*V'*V*A-S
%R1_MT_minus_E = R1*MT-E

Rp=VecAngle2Rot(T,pi);
R2=R1*Rp;

R = zeros(3,3,2);
R(:,:,1) = R1;
R(:,:,2) = R2;