% DibujaCamara  Draws a camera as a piramid with its vertex in the optic center
%
% Draws a camera caracterized by the intrinsic parameter matrix K, rotation matrix R and translation T, P=K(R|-RT).
%
% Inputs: 
%  - K(3,3): intrinsic parameter matrix, upper triangular
%  - R(3,3): camera orentation
%  - T(3,1); optical center of the camera (affine coords).

% This code has been adapted from the ACT toolbox, developed by Guillermo Gallego Bonet.


function draw_camera(K,R,T,Z0,color)

global tam_img;
if isempty(tam_img)
    tam_img = [2000; 1500]; 
end

% Unitary vectors in the direction of points (+- tam_img(1)/2, +-
% tam_img(2)/2) and points in the plane Z=Z0 (camera reference)
invK = inv(K);
V = zeros(3,7);
V(:,1) = [ tam_img(1)/2; tam_img(2)/2;1];
V(:,2) = [ tam_img(1)/2;-tam_img(2)/2;1];
V(:,3) = [-tam_img(1)/2;-tam_img(2)/2;1];
V(:,4) = [-tam_img(1)/2; tam_img(2)/2;1];
V(:,5) = mean(V(:,[1,2]),2);
V(:,6) = mean(V(:,1:4),2);
V(:,7) = mean(V(:,[1,4]),2);

V = un_homogenize_coords(invK*V)*Z0;

Punto = [T, repmat(T,1,7)+R.'*V];

% 4 lines from the optic center to the vertices
draw_segments(Punto(:,[1,1,1,1]),Punto(:,2:5),color); 
% 4 lines that are the lines of the rectangle
draw_segments(Punto(:,[5,2,3,4]),Punto(:,2:5),color); 
% A small rectangle indicates the upper-left corner of the image
draw_segments(Punto(:,[8,2,6,7]),Punto(:,[2,6,7,8]),color); 