% PDLT_NA  The normalized DLT algorithm for the Camera Matrix P
% 6.1 page 170 from Multiple View (Hartley) 
%
% Input: 
%  - x(3,npoints): 2D image points. Hom. coordinates
%  - X(4,npoints): 3D points. Hom. coordinates 
%
%  - sol_type: solution type 
%     0 (default) -> SVD of the design matrix.
%     1 -> eigenvalues, computes all eigen -values -vectors of A'*A.
%
%  - verb: verbosity
%     0 -> Does not print costs in the command line
%
% Output:
%  - P: 3x4 projection matrix
%  - cost: algebraic distance cost
%  - A_reduced: norm(A*p)=norm(A_reduced*p). Only in sol_type=0 (SVD)

% This code has been adapted from the ACT toolbox, developed by Guillermo Gallego Bonet.


function [P,cost]= PDLT_NA(x,X,sol_type,verb)

[fx,cx]=size(x);
[fX,cX]=size(X);

if nargin==2
    sol_type=0;
    verb=0;
end

% ------------------------------------------------------------------------
% Previous checks
% ------------------------------------------------------------------------

if( cx~=cX )
   error('Error in PDLT_NA: Points without correspondences');
elseif( fx~=3 )
   error('Error in PDLT_NA: Not points of the projective plane P^2');
elseif( fX~=4 )
   error('Error in PDLT_NA: Not points of the projective space P^3');
elseif( cx<6 )
   error('Error in PDLT_NA: Not enough points to compute P');
else
    
    % 1. Normalization
    [xnh,T]=NormalizAfin(x);
    [Xnh,U]=NormalizAfin(X);
    
    % 2. Linear solution: PDLT_B
    [P,cost]=PDLT_B(xnh,Xnh,sol_type,verb);
    
    % 3. de_normalization
    P=normalize_matrix(inv(T)*P*U);
end