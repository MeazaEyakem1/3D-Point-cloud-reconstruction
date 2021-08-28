% draw_proj_cube  Draws a projected cube. Vertices of the cube are in the 8
% first positions

% This code has been adapted from the ACT toolbox, developed by Guillermo Gallego Bonet.


function draw_proj_cube(q)

q = un_homogenize_coords(q);
lines_points = [1,2; 2,3; 3,4; 4,1; 5,6; 6,7; 7,8; 8,5; 1,5; 2,6; 3,7; 4,8];
origin = q(1:2,lines_points(:,1));
ending  = q(1:2,lines_points(:,2));
line([origin(1,:); ending(1,:)], [origin(2,:); ending(2,:)], 'Color', [1 0 0]);