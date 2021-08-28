% NormalizaKR  Normalices the K matrices (upper triangular) and R, so that K is a intrinsic parameter matrices

% This code has been adapted from the ACT toolbox, developed by Guillermo Gallego Bonet.

function [K,R]=NormalizaKR(K,R)

% Adjusts the main diagonal
if sign(K(2,2)) == -1
    K(2,2)= -K(2,2);
    R(2,:)= -R(2,:);
    K(1,2)= -K(1,2);
end
if sign(K(1,1)) == -1
    K(1,1)= -K(1,1);
    R(1,:)= -R(1,:);
end
