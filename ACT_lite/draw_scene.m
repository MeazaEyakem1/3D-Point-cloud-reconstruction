% draw_scene  Draws a 3D point set and the cameras (english version of DibujaEscena)
%
% Q(4,npuntos) euclidean coordinates of the 3D points.
% K(3,3,ncam) intrinsc parameter matrices (with K(3,3) = 1).
% R(3,3,ncam) Rotation matrices
% T(3,ncam) translation vectors
% The camera projection matrices are P = K(R|-RT).

% This code has been adapted from the ACT toolbox, developed by Guillermo Gallego Bonet.


function draw_scene(Q,K,R,T,flag_pixel_size,tri)

% Draw 3D points
Q = un_homogenize_coords(Q);
if nargin<=5
    scatter3(Q(1,:),Q(2,:),Q(3,:));
else
    trimesh(tri,Q(1,:),Q(2,:),Q(3,:));
end
daspect([1, 1, 1]); pbaspect([1, 1, 1]); axis vis3d;

ncam = size(K,3);

% Draw cameras
fig = figure; colormap('jet'); close(fig)
cmap = colormap;
Offset = 6; % lower color of the colormap
idx = round(linspace(1+Offset,size(cmap,1)-1-Offset,ncam));

global r;
for k=1:ncam
    color = cmap(idx(k),:);
    if nargin>=5 & flag_pixel_size
        if isempty(r)
            r = 1; 
        end
        DibujaCamara(K(:,:,k),R(:,:,k),T(:,k),K(1,1,k)*r,color);
    else
        % Avg distanec of the cameras to the point centroid
        Cent = mean(Q,2);
        dist_med = mean( VectNorm(T-Cent(1:3,ones(1,ncam))) );
        if isempty(r)
            r = 0.5; 
        end
        draw_camera(K(:,:,k),R(:,:,k),T(:,k),dist_med*r,color);        
    end
end
