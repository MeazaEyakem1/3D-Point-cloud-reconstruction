% NormalizAfin  Returns normalized points and the affine normalization matrix that was used to obtain it

% From the hom. ccordinates  of points in  P^n, computes the affine coordinates and the affine transformation that locates the coordinate origin
% at the centroid of the points and scaales the points such as the avg. distance from the origin is sqrt(n)

% Input: 
%  - Q(dim:n,npoints) : hom. coords of the points in the image
%
% Output:
%  - qnh(dim:n,npoints) : normalized hom. coords of the points in the image
%  - Tq(dim:n,dim:n) : fundamental matix Affine transformation 

% This code has been adapted from the ACT toolbox, developed by Guillermo Gallego Bonet.


function [qnh,Tq]=NormalizAfin(Q)
[dim,npoints] = size(Q);
Q = un_homogenize_coords(Q);
q_afin = Q(1:dim-1,:);
[Q_afin,Tq]=normalize(q_afin);
qnh = homogenize_coords(Q_afin);

