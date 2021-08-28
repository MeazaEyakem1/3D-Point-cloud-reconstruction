% TriangEuc  Computes the euclidean reconstruction corresponding to the projections and camera parameters
%
% Input: 
%   - R(3,3) rotation matrix
%   - T(3) translation vector
%   - K(3,3,2) intrinsic parameter matrices
%   - q(3,npuntos,ncam) hom. coordinates of the projected points
%
% Output: 
%   - Q(4,npuntos) euclidean homogeneus coordinates of the obtained 3D points


function Q = TriangEuc(R,T,K,q)

npoints = size(q,2);
ncam = size(q,3);
Q = zeros(3,npoints);

invK = zeros(3,3,2);
invK(:,:,1) = inv(K(:,:,1));
invK(:,:,2) = inv(K(:,:,2));

% Checking input parameters
T  = normalize_matrix(T);
MT = Cross2Matrix(T);
E  = normalize_matrix(R*MT);

% normalized coordinates
q_n = unitarize_coords(cat(3, invK(:,:,1)*q(:,:,1), invK(:,:,2)*q(:,:,2) ));

% Epipolar restriction cost
err = Coste_Epipolar(q_n,E);
error_mat_esen = err/npoints

% 3D error
A = zeros(3,3);
err = 0;
q_nR = R.'*q_n(:,:,2);
vv = unitarize_coords(cross(q_n(:,:,1),q_nR,1));
for k=1:npoints
   u1 = q_n(:,k,1);
   u2 = q_nR(:,k);
   v  = vv(:,k);
   A = [u1, -u2, v];
   a = inv(A)*T;
   Q1 = a(1)*u1;
   Q2 = T + a(2)*u2;
   Q(1:3,k) = (Q1 + Q2)/2;
   Q(4,k) = 1;
   err = err + norm(Q1-Q2);
end

err_3D_rec = err/npoints