% BundleErrorReproy  Function for the reprojection error applied to Bundle Adjustment
% R.Hartley, page 579
%
% Input: Parameter vector, P
% Output: Measure vector, X

% This code has been adapted from the ACT toolbox, developed by Guillermo Gallego Bonet.


function X = BundleErrorReproy(P)
global numcam
[mP,bm] = BundleP2Matrices(P,numcam);
Xh = [bm; ones(1,size(bm,2))];
xh = project_points(mP,Xh);
xa = xh(1:2,:,:); % affine
X = matriz3dim2matriz2dim(xa,'v');
X = X(:);