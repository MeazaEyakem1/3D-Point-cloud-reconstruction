% BAProjectiveCalib  Multicamera Projective Bundle Adjustment
%
% Given the projections of 3D points in ncam images, and an initial projective reconstruction
% improves the projective reconstruction using Bundle Adjustment 
%
% This code has been adapted from the BAProyectiveCalib function in the ACT toolbox, developed by Guillermo Gallego Bonet.

% Input:
%  - x(3,npoints,ncam)  : hom. coords of the points in the images
%  - P_init(3,4,ncam)   : initial projection matrices
%  - X3d_init(4,npoints): initial 3D points in hom. coordinates
%  - vp(npoints,ncam)   : point visibility in the images. If all visible, vp = ones(npoints,ncam)

% Output:
%  - P(3,4,ncam)        : projection matrices
%  - X3d(4,npuntos)     : 3D points in hom. coordinates
%  - xc(3,npuntos,ncam) : (optional) hom. coords of reprojected points

function [P,X3d,xc] = BAProjectiveCalib(x,P_init,X3d_init,vp)

    % ----- Projective Bundle Adjustment -----
    X3d_init = un_homogenize_coords(X3d_init);
    [Xa3dmin,P,xac,cost_ba] = BundleAdjustment_vp(P_init,X3d_init(1:3,:,1),x(1:2,:,:),vp);
    X3d = homogenize_coords(Xa3dmin);

    if nargout>2 % Reprojected points
        xc = homogenize_coords(xac);
    end

end