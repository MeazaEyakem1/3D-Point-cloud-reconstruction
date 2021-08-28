% CameraMatrix2KRC  Computes K, R y C associated to a Euclidean projection matrix, using the QR decomposition
% page 150 of the  Multiple View book (Hartley)
% Decomposition of the camera matrix

% Input:
%  - P(3,4,ncam): projection matrices

% Output:
%  - K(3,3,ncam): intrinsic parameter matrix, upper triangular
%  - R(3,3,ncam): camera orentation
%  - C(4,ncam); optical center of the camera (hom. coords are compatible with affine ones C(4)=1 ).

% This code has been adapted from the ACT toolbox, developed by Guillermo Gallego Bonet.


function [K,R,C] = CameraMatrix2KRC(P)

ncam=size(P,3);

for m=1:ncam
    % RQ factorization RQ using QR decomposition
    [R(:,:,m),K1(:,:,m)]=qr(inv(P(1:3,1:3,m)));
    K2(:,:,m)=inv(K1(:,:,m));
    R(:,:,m)=R(:,:,m).'; % R=inv(R), but it is a rotation matrix --> R.'=R^(-1)

    scale=K2(3,3,m); 
    K(:,:,m)=K2(:,:,m)/scale;  % Affine normalization of K
    %C(1:3)=C(1:3)*scale;

    [K(:,:,m),R(:,:,m)]=NormalizaKR(K(:,:,m),R(:,:,m));

    if(det(R(:,:,m)) < 0)
        R(:,:,m)=-R(:,:,m);  % det(R)=1
    end

    % Camera centre , Assumes Kint*[R  -R*C]
    C(:,m)=null(P(:,:,m));
    % Alseo valid:
    % C=[ det(P(:,2:4));  - det([P(:,1) P(:,3:4)]);  det([P(:,1:2) P(:,4)]);  - det([P(:,1:3)])];
    C(:,m)=C(:,m)/C(4,m); % Affine normalization

end
