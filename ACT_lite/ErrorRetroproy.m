% ErrorRetroproy  Computes the reprojection error given the observed points q and a projective reconstruction (P,Q)
% q(3,npuntos,ncam) projected points
% P(3,4,ncam) projection matrices
% Q(4,cam) 3D points 
% This code has been adapted from the ACT toolbox, developed by Guillermo Gallego Bonet.


function err = ErrorRetroproy(q,P,Q)

[dim,npoints,ncam] = size(q);
q = un_homogenize_coords(q);

if nargin<3
    q_rep = P; 
elseif nargin==3
    q_rep = project_points(P,Q);
else
    error('Incorrect number of input arguments');
end

err = sum(sum(sum((q_rep(:,:,:)-q(:,:,:)).^2)))/ncam/npoints;
