% BundleAdjustment_vp  Projective Bundle Adjustment. Improves a projective
% calibration minimizing the re-projection error. Multiple View (Hartley)
% 
% Input:
%  - P(3,4,ncam)   : initial projection matrices
%  - X3d_init(3,npoints): initial 3D points in affine coordinates
%  - x(2,npoints,ncam)  : affine coords of the observed points in the images
%  - vp(npoints,ncam)   : point visibility in the images. If all visible, vp = ones(npoints,ncam)

%
% Output:
%   - X3dmin(3,npuntos)     : 3D points in affine coordinates
%   - pmin(3,4,ncam)        : projection matrices
%   - xc(2,npuntos,numcam)  : affine coords of reprojected points
%   - cost: minimum geometric distance (in pixels) 

function [X3dmin,pmin,xc,cost] = BundleAdjustment_vp(P,X3d,x,vp)
global numcam
numcam=size(P,3);
npoints=size(X3d,2);

% Non-linear optimization. Functio BundleErrorReproy
%--- Objective measures array 
X=matriz3dim2matriz2dim(x,'v');
X=X(:);    

%--- Initial parameter array
P0=zeros(numcam*12,1);
for j=1:numcam
    P1=P(:,:,j).';
    P0(1+(j-1)*12:j*12,1)=P1(:);
end
P0=[P0; X3d(:)];

%---  Levenbrg-Marquardt optimization
% global verb_BA; verb_BA=2; % Verbosity
[Pmin,cost,Xmin] = LMPSBAI_visiblepoints(X,P0,vp);
cost=sqrt(cost);  % = feval(func_coste,Pmin,X);

% Corrected points, projection matrices de proyeccion and 3D points
[pmin,X3dmin] = BundleP2Matrices(Pmin,numcam);
if exist('Xmin')
    xc = matriz2dim2matriz3dim(reshape(Xmin,2*numcam,npoints),'v',2); 
else
    % Project points
    for k=1:numcam
        xc(:,:,k)=pmin(:,:,k)*[X3dmin; ones(1,size(X3dmin,2))];
    end
    xc=un_homogenize_coords(xc);
    xc=xc(1:2,:,:); % affine coords 
end