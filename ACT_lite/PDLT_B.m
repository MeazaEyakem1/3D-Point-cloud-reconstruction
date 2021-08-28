% PDLT_B  Basic DLT algorithm for the estimation of Camera Matrix P
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
%
% In practice, both methods provide the same solution

% This code has been adapted from the ACT toolbox, developed by Guillermo Gallego Bonet.


function [P,cost,A_reduced]= PDLT_B(x,X,sol_type,verb)

[fx,cx]=size(x);
[fX,cX]=size(X);

if nargin==2
    sol_type=0;
    verb=0;
end

% Use eigenvalues for many points. Memory problems
if cx>600
    sol_type=1;
    % disp('Resection with many points. Using eigenvalues instead of SVD');
end 

% ------------------------------------------------------------------------
% Previous checks
% ------------------------------------------------------------------------

if( cx~=cX )
   error('Error in PDLT_B: Points without correspondences');
elseif( fx~=3 )
   error('Error in PDLT_B: Not points of the projective plane P^2');
elseif( fX~=4 )
   error('Error in PDLT_B: Not points of the projective space P^3');
elseif( cx<6 )
   error('Error in PDLT_B: Not enough points to compute P');
else
    npoints=cx;
    
    % --------------------------------------------------------------------
    % Creation of A that defines the homogeneous system
    % --------------------------------------------------------------------
    x=x.'; % easier to build A
    X=X.';
    A=zeros(3*npoints,12);
    for i=1:npoints
        n=1+3*(i-1);
        A(n,5:8)=-x(i,3)*X(i,:);
        A(n,9:12)= x(i,2)*X(i,:);
        A(n+1,1:4)= x(i,3)*X(i,:);
        A(n+1,9:12)=-x(i,1)*X(i,:);
        A(n+2,1:4)=-x(i,2)*X(i,:);
        A(n+2,5:8)= x(i,1)*X(i,:);
    end;
    
    % Exact correspondence x,X  <=> rank(A)=11 -> exact solution
    % Numerice errors, etc, el rank(A)=12 -> square-minimum solution
    
    if sol_type ==1
        % ----------------------------------------------------------------
        % Eigenvalue solution (eig)
        % ----------------------------------------------------------------
        B=A'*A;
        [VB,LB]=eig(B);
        L=diag(LB);
        [MinEigVal,position] = min(L);
        MaxEigVal = max(L);
        MinEigVect= VB(:,position);
        P = reshape(MinEigVect,4,3).';
        cost = MinEigVal/MaxEigVal;	
        
        if verb ~=0
            disp(['Cost EIG = ',num2str(abs(cost))]);
        end
        
    else
        % ----------------------------------------------------------------
        % SVD Solution
        % ----------------------------------------------------------------
        [U,D,V]=svd(A,0);
        S=diag(D);			% main diagonal vector.
        MinSingVect= V(:,12);
        P = reshape(MinSingVect,4,3).';
        cost = S(12)/S(1);

        if verb ~=0
            disp(['Cost SVD = ',num2str(cost)]);
        end
        if nargout==3
            A_reduced = diag(S)*V.';
        end
    end
end
