function  draw_3Dcube(Q)
% draw_3Dcube shows the 3D cube 
% Q(3,npoints,ncam) hom. coords of all 3D points

    Q=un_homogenize_coords(Q);
    figure, scatter3(Q(1,:),Q(2,:),Q(3,:));
    % daspect([1, 1, 1]),pbaspect([1, 1, 1]),axis vis3d;
    draw_3D_cube_segments(Q);

end

