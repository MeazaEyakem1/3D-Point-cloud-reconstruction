% normalize_matrix  Normalizes a matrix, vector or tensor, dividing it by its euclidean norm 
% 
%
% Vectors -> equivalent to dividing it by its euclidean norm
% Matrices -> equivalent to dividing it by its Frobenius norm

% This code has been adapted from the ACT toolbox, developed by Guillermo Gallego Bonet.


function M = normalize_matrix(M)
norma = norm(M(:));
if (norma ~= 0)
    M = M/norma;
end