% matriz2dim2matriz3dim   turns a matrix (2D into 3D array, vertically or horizontally 
% vertically in blocks of n x size(Y,2) 
% horizontally in blocks size(Y,1) x n elements.
%
% Inverse to matriz3dim2matriz2dim
% Better for 3D matrices than reshape

% This code has been adapted from the ACT toolbox, developed by Guillermo Gallego Bonet.

function M = matriz2dim2matriz3dim(y,div_type,n)

[fy,cy]=size(y);
if lower(div_type) == 'v'
    n3= fy/n; % number of blocks
    M = zeros(n,cy,n3);
    for k=1:n3
        M(:,:,k)=y(1+n*(k-1):n*k,:);
    end
elseif lower(div_type) == 'h'
    n3= cy/n; % number of blocks
    M = zeros(fy,n,n3);
    for k=1:n3
        M(:,:,k)=y(:,1+n*(k-1):n*k);
    end
else 
    error('Incorrect concatenation type')
end