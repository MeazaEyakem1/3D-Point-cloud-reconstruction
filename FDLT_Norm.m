% FDLT_Norm  The normalized DLT 8-point algorithm for F (fundamental matrix) 
% Algorithm  10.1 p.265 from  Multiple View (Hartley)
%
% Input: point correspondences (P,Q)
%  - P(3,npoints) : hom. coords of the points in the first image
%  - Q(3,npoints) : hom. coords of the points in the second image
%
% Output:
%  - F(3,3) : fundamental matix computed using SVD or eigen-values/vectors of (A'*A)
%  - cost: value of the smallest singular value of F


function [F,cost]=FDLT_Norm(P,Q)

    % 1. Affine normalization of the points in the first image
    [Pn,Tp] = NormalizAfin(P);

    % 2. Affine normalization of the points in the second image
    [Qn,Tq] = NormalizAfin(Q);

    % ------------------------------------------------------------------------
    % Create matrix A that represents the homogeneous system Af=0. Vector f contains the coefficients of the fundamental matrix
    % A is a matrix with as many rows as point correspondences and 9 columns
    % ------------------------------------------------------------------------
    % ...
    A = zeros(size(Qn,2),9);
    
    A(:,1) = Qn(1,:).*Pn(1,:);
    A(:,2) = Qn(1,:).*Pn(2,:);
    A(:,3) = Qn(1,:);
    
    A(:,4) = Qn(2,:).*Pn(1,:);
    A(:,5) = Qn(2,:).*Pn(2,:);
    A(:,6) = Qn(2,:);
    
    A(:,7) = Pn(1,:);
    A(:,8) = Pn(2,:);
    A(:,9) = 1;

    % ----------------------------------------------------------------
    % SVD solution for F. Use svd() To reshape a column vector Vect into a 3x3
    % matrix use reshape(Vect,3,3).';
    % ----------------------------------------------------------------
    [U,D,V] =  svd(A);
    
    F = reshape(V(:,end),3,3).';
    
    if (size(P,2)==8) 
        cost=0; 
    else
        S = diag(D);
        cost = S(9);
    end
    disp(['Minimum singular value = ',num2str(cost)]);
     
    % ----------------------------------------------------------------
    % Enforce rank 2 for F
    % ----------------------------------------------------------------
    % SVD F again
    [Uf,Df,Vf] = svd(F);
    
    F = Uf*diag([Df(1) Df(5) 0])*(Vf.');
    
    
    % 4. De-normalization
    F = normalize_matrix((Tq.')*F*Tp);
    
end
