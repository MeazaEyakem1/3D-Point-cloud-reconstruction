% project_points computes the 3D projections of 3D points using the projection matrices 
% Returns unhomogenized coords

% Input:
%  - x(3,npoints,2): hom. coords of the points in the images
%  - P(3,4,2): projection matrices
%  - Q(4,npoints): 3D points in hom. coordinates
%
% Output:
%  - q(3,npoints,2): hom. coords of the points in the images

% This code has been adapted from the ACT toolbox, developed by Guillermo Gallego Bonet.


function q = project_points(P,Q)

ncam = size(P,3);
npoints = size(Q,2);
q = zeros(3,npoints,ncam);
for k=1:ncam
    Proj=P(:,:,k);
    q(:,:,k)=un_homogenize_coords(Proj*Q);
end