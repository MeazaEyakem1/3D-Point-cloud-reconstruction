% Coste_Epipolar  Cost function associated to the epipolar restriction 
% 
%    cost = sum_{i} ( q2(i).'*F*q1(i) )^2 
% 
% Input: 
%   - q(3,npoints,2): hom. coords of the points in the images
%   - Z: if Z(3,3), fundamental matrix
%        if Z(3,4,2), projection matrices
%
% Output: 
%   - cost

% This code has been adapted from the ACT toolbox, developed by Guillermo Gallego Bonet.


function cost = Coste_Epipolar(q,Z,mode)

if numel(Z)==9 & size(Z,1)==3 & size(Z,2)==3
    % fundamental matrix
    F = normalize_matrix(Z);
elseif numel(Z)==24 & all([3,4,2] == size(Z))
    % fundamental matrix from projection matrices
    F = normalize_matrix(CameraMatrix2F(Z));
end

q = unitarize_coords(q);
if nargin == 2
    cost = sum( sum( q(:,:,2).*(F*q(:,:,1)), 1).^2 );
else
    % slowe if loops are used
    npuntos = size(q,2);
    cost=0;
    for k=1:npuntos
        cost = cost + ( q(:,k,2).'*(F*q(:,k,1)) )^2;
    end
end