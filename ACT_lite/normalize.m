% normalize  computes the affine normalization, given a set of points in P^n
%
% Input: 
%   P : affine coordinates P=[x,y,...].' of the points to be normalized
%
% Output :
%   Pn: affine normalized coordinates of the points. Pn=[xn,yn,...].'
%   T : Affine transformation (normalization)
%
% page  92 Multiple View (Hartley).
% Sirve para puntos del plano afín si P tiene 2 filas, puntos del espacio 

%     1. Translation to move the origin to the centroid of the points
%     2. Points are scaled such as the mean distance from the origin is sqrt(dim(P^n))

% This code has been adapted from the ACT toolbox, developed by Guillermo Gallego Bonet.


function [Pn, T]=normalize(P)
[dim,npoints]=size(P);
t = mean(P,2);
Pc= P - t*ones(1,npoints);
dist_mean = mean(sqrt(sum(Pc.*conj(Pc),1)));
a = sqrt(dim)/dist_mean;
Pn= a*Pc;
T = eye(dim+1);
T(1:dim,dim+1)=-t;
T = a*T;
T(dim+1,dim+1)=1;