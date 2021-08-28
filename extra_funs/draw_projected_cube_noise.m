function  draw_projected_cube_noise(q,q_n)
% draw_projected_cube_noise shows the 3D points projected in each camera (ideal and noisy points)
% q(3,npoints,ncam) projected points in all cameras (ideal)
% q_n(3,npoints,ncam) projected points in all cameras (noisy)

    q = un_homogenize_coords(q);
    q_n = un_homogenize_coords(q_n);
    ncam = size(q,3);
    for k=1:ncam
        figure();
        hold on
        scatter(q(1,:,k),q(2,:,k),30,[1,0,0]);
        draw_proj_cube(q(:,:,k));
        scatter(q_n(1,:,k),q_n(2,:,k),30,[0,0,1]);
    end

end

