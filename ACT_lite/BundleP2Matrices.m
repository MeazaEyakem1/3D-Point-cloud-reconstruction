% BundleP2Matrices  Turns the parameter vector of the reprojection function
% error (Bundle adjustment) into Projection matrices and points
% R.Hartley, page 581
%
% Input: parameter array P
%   a1 = P(1:12) projection matrix of the 1st camera
%   a2 = P(1+12:12*2) projection matrix of the 2nd camera
%   ...
%   am = P(1+12*(ncam-1):12*ncam)) projection matrix of the m-th camera
%   b1 = P(1+12*ncam:1+12*ncam+3) affine coords of a point in P^3
%   b2 = ...
%
% Salida: measure vector X
%   - mP (3,4,ncam): projection matrices
%   - bm (3,npuntos): affine coords of 3D points 

% This code has been adapted from the ACT toolbox, developed by Guillermo Gallego Bonet.



function [mP,bm] = BundleP2Matrices(P,ncam)

% Cameras
P0=reshape(P(1:12*ncam),12,ncam);
%--- Projection matrices
mP=zeros(3,4,ncam);
for k=1:ncam
    mP(:,:,k) = reshape(P0(:,k),4,3).';
end

% Affine coordinates of 3D points
b = P(1+12*ncam:length(P));            
bm = reshape(b,3,length(b)/3);