% linear_triangulation  The Linear Triangulation Method for n points
% 11.2 p. 297  Multiple View (Hartley)

% Input:
%  - x(3,npoints,2): hom. coords of the points in the images
%  - P(3,4,2): projection matrices
%
% Salida:
%  - X(4,npoints): 3D points in hom. coordinates
%  - costs(npoints): adjust cost of each 3D point

% This code has been adapted from the ACT toolbox, developed by Guillermo Gallego Bonet.


function [X,costs] = linear_triangulation(x,P)
npoints=size(x,2);
X=zeros(4,npoints);
costs=zeros(npoints,1);

% un_homogenize_coords
u = x(3,:,:);
if ~all(u(:)==1)
    x = un_homogenize_coords(x); % Dangerous
end
xa = x(1:2,:,:);

A1=[ P(1:2,:,1);
     P(1:2,:,2)];

for k=1:npoints
    A=[ xa(:,k,1)*P(3,:,1);
        xa(:,k,2)*P(3,:,2)] - A1;
    [u,d,v]=svd(A,0);
    X(:,k) =v(:,4);
    costs(k) = d(4,4);
end
% X=un_homogenize_coords(X); Not good for infinity points