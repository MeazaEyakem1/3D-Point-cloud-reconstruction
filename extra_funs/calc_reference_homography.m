function H = calc_reference_homography(Q)
% calc_reference_homography Computes the space homography that transforms the canonical reference 
% (1 0 0 0) (0 1 0 0) (0 0 1 0) (0 0 0 1) (1 1 1 1) to the 5 3D points in  Q  

% Q(N,N+1): N: general for any dimension. For P3, N=4 

N=size(Q,1);
H=zeros(N);
vec=inv(Q(:,1:N))*Q(:,N+1);
H=Q(:,1:N)*diag(vec);