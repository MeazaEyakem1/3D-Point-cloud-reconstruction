% matriz3dim2matriz2dim  turns a 3D array  into a matrix (2D). concatenates
% the  matrices of the 3rd dim, vertically or horizontally

%
%   Y = matriz3dim2matriz2dim(M,'h')   
%          | M(:,:,1)  M(:,:,2) ... M(:,:,n3) |
%
%   Y = matriz3dim2matriz2dim(M,'v')  
%          | M(:,:,1) |
%          | M(:,:,2) |
%          |    ...   |
%          | M(:,:,n3)|

% This code has been adapted from the ACT toolbox, developed by Guillermo Gallego Bonet.


function y = matriz3dim2matriz2dim(M,type)

[n1,n2,n3]=size(M);
if lower(type) == 'h'
    y = zeros(n1,n2*n3);
    for k=1:n3
        y(:,1+n2*(k-1):n2*k)=M(:,:,k);
    end
elseif lower(type) == 'v'
    y = zeros(n1*n3,n2);
    for k=1:n3
        y(1+n1*(k-1):n1*k,:)=M(:,:,k);
    end
else 
    error('wrong concatenation type')
end