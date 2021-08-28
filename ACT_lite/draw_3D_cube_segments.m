% draw_3D_cube_segments Draws the segments of a 3D cube from its hom. coords in a known set
% This code has been adapted from the ACT toolbox, developed by Guillermo Gallego Bonet.

function draw_3D_cube_segments(Q)

Q = un_homogenize_coords(Q);
linea_punto = [1,2; 2,3; 3,4; 4,1; 5,6; 6,7; 7,8; 8,5; 1,5; 2,6; 3,7; 4,8];
origin = Q(1:3,linea_punto(:,1));
ending  = Q(1:3,linea_punto(:,2));
line([origin(1,:); ending(1,:)], [origin(2,:); ending(2,:)], [origin(3,:); ending(3,:)], 'Color', [1 0 0]);