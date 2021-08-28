% Exercises for N views
% N view reconstruction. Initial reconstruction using the F matrix
% between 2 cameras. Resection for the rest of cameras and bundle adjustment
% Euclidean reconstruction is obtained using the knowledge of
% the inf plane and scene structure

clear, close all,

% include ACT_lite path
ACT_path = './ACT_lite/';
addpath(genpath(ACT_path));
% include extra funs
extra_funs_path = './extra_funs/';
addpath(genpath(extra_funs_path));

addpath(genpath('./vgg_mvg/'));
warning off
disp('************************************* START')

load('KAZE_KAZE_5.mat')
point_matrix = n_view_matching(points, features, ima, 0.6, 'SSD');
q_r= homogenize_coords(point_matrix);

% ------------------------------------------------------------------------
% 0  . Select projected points (noisy version)
% ------------------------------------------------------------------------
%q_data = q_r(:,:,1:6); % Uncomment this one to use noisy points
q_data = q_r;
ncam = 5;
% ------------------------------------------------------------------------
% 2. Compute the fundamental matrix using the first and last cameras
% of the camera set (N cameras)
% ------------------------------------------------------------------------
q_2cams(:,:,1)=q_data(:,:,1); 
q_2cams(:,:,2)=q_data(:,:,ncam);

[F, P_2cam_est,Q_2cam_est,q_2cam_est] = MatFunProjectiveCalib(q_2cams);
disp(['Residual reprojection error. 8 point algorithm   = ' num2str( ErrorRetroproy(q_2cams,P_2cam_est,Q_2cam_est)/2 )]);
draw_reproj_error(q_2cams,P_2cam_est,Q_2cam_est);
%%
% ------------------------------------------------------------------------
% 3. Resection. Obtain the projection matrices of the rest of cameras using the PDLT_NA function 
% ------------------------------------------------------------------------
% ...
for(i=2:ncam-1)
     [P_ncam(:,:,i),cost(i)] = PDLT_NA(q_data(:,:,i),Q_2cam_est);
end

P_ncam(:,:,1)=P_2cam_est(:,:,1);
P_ncam(:,:,ncam)=P_2cam_est(:,:,2);
% ------------------------------------------------------------------------
% 4. Compute the statistics of the reprojection error for the initial projective reconstruction
% ------------------------------------------------------------------------
% ...
disp(['Resudual reprojection error. 8 point algorithm   = ' num2str( ErrorRetroproy(q_data,P_ncam,Q_2cam_est)/2 )]);
draw_reproj_error(q_data,P_ncam,Q_2cam_est);


% 6a. Projective Bundle Adjustment. Use BAProjectiveCalib function
% Coordinates of 3D and 2D points are given in homogeneus coordinates
% ------------------------------------------------------------------------
% auxiliary matrix that indicates that all points are visible in all the cameras
npoints = size(q_data,2);
vp = ones(npoints,ncam);
% ...
[P_bundle,X3d_bundle,xc_bundle] = BAProjectiveCalib(q_data,P_ncam,Q_2cam_est,vp);
% ------------------------------------------------------------------------
% 6b. Compute the statistics of the reprojection error for the improved projective reconstruction
% ------------------------------------------------------------------------
% ...
disp(['Resudual reprojection error. 8 point algorithm   = ' num2str( ErrorRetroproy(q_data,P_bundle,X3d_bundle)/2 )]);
draw_reproj_error(q_data,P_bundle,X3d_bundle);

%fundamental matrix after bundle adjusment

p_1=P_bundle(:,:,1);
p_2=P_bundle(:,:,end);
F_p = vgg_F_from_P(p_1,p_2);
%%
% -----------------------


 %3. Obtain the essential matrix (E) from the fundamental matrix (F) and the
% intrinsic parameter matrices (K).
% ------------------------------------------------------------------------

K(:,:,1)=[1072.56040932381,-1.55530620427749,371.174532549516;
    0,1066.32241285233,636.894096255490;
    0,0,1];



K(:,:,2)=[1072.56040932381,-1.55530620427749,371.174532549516;
    0,1066.32241285233,636.894096255490;
    0,0,1];

 E = K(:,:,2).'*F_p*K(:,:,1);

% ------------------------------------------------------------------------
% 4. Factorize the essential matrix with the 2 possible solutions for
% R. Use the function factorize_E to obtain R_est(:,:,1) and R_est(:,:,2) and T_est.
% ------------------------------------------------------------------------
 [R_est,T_est] = factorize_E(E);

% ------------------------------------------------------------------------
% Save the 4 solutions (R,t) in the structures Rcam(3,3,cam,sol), T(3,cam,sol),
% where cam indicates the camera number and sol indicates the solution number (1, 2, 3 or 4).
% ------------------------------------------------------------------------
Rcam = zeros(3,3,2,4);
Tcam = zeros(3,2,4);
% ...

% FIRST CAMERA

for i=1:4
    Rcam(:,:,1,i) = eye(3,3);
    Tcam(:,1,i) = zeros(3,1);
end
% SECOND CAMERA
Rcam(:,:,2,1) = R_est(:,:,1);
Tcam(:,2,1)   =  T_est;

Rcam(:,:,2,2) =  R_est(:,:,1);
Tcam(:,2,2)   = - T_est;

Rcam(:,:,2,3) = R_est(:,:,2);
Tcam(:,2,3)   =   T_est;

Rcam(:,:,2,4) =  R_est(:,:,2);
Tcam(:,2,4)   = - T_est;

% ------------------------------------------------------------------------
% 5. For each solution we obtain an Euclidean solution and we visualize it.
% ------------------------------------------------------------------------
npoints = size(q_data,2);
Q_euc = zeros(4,npoints); % Variable for recontructed points
q_rep =  zeros(3,npoints,2);% Variable for reprojected points
P_euc = zeros(3,4,2);       % Variable for projection matrices
figNo=figure;
cam = 1;
xc_bundle_new(:,:,1) = xc_bundle(:,:,1);
xc_bundle_new(:,:,2) = xc_bundle(:,:,end);
for sol=1:4
    
    
    % Euclidean triangulation to obtain the 3D points (use TriangEuc)
     %Q_euc(:,:,1) = TriangEuc(Rcam(:,:,1,1),Tcam(:,1,1),K,q_data);
     Q_euc = TriangEuc(Rcam(:,:,2,sol),Tcam(:,2,sol),K,xc_bundle_new);
    % visualize 3D reconstruction
    figure();
    draw_scene(Q_euc, K, Rcam(:,:,:,sol), Tcam(:,:,sol));
    title(sprintf('Solution %d', sol));
     
    % Compute the projection matrices from K, Rcam, Tcam
    for k=1:2
        P_euc(:,:,k) = K(:,:,k)*[Rcam(:,:,k,sol) -Rcam(:,:,k,sol)*Tcam(:,k,sol)] ;
    end
    % Obtain the re-projected points q_rep
    % q_rep = ...; 
    for i=1:size(Q_euc,2)
        
        q_rep(:,i,1) = P_euc(:,:,1)*Q_euc(:,i);
        q_rep(:,i,2) = P_euc(:,:,2)*Q_euc(:,i);
        
    end
    
    % Visualize reprojectd points to check that all solutions correspond to
    % the projected images
    q_rep = un_homogenize_coords(q_rep);
    for k=1:2
      figure(figNo); subplot(4,2,2*(sol-1)+k); scatter(q_rep(1,:,k),q_rep(2,:,k),30,[1,0,0]);
      title(sprintf('Reprojection %d, image %d', sol, k));
      daspect([1, 1, 1]);
      pbaspect([1, 1, 1]);
      axis([-1000, 1000, -1000, 1000]);
    end
    
end

    disp(['Resudual reprojection error. 8 point algorithm   = ' num2str( ErrorRetroproy(q_2cams,P_euc,Q_euc)/2 )]);
    draw_reproj_error(q_2cams,P_euc,Q_euc);
disp('************* END')





