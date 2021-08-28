function theta = angle_3points(p,q,r)
% angle_3points Returns the angle (radians) formed by 3 3D points (p,q,r) in homgeneous
% coordinates. The angle is formed by lines pq and qr

% --> Input: 
% p,q,r(4): hom. coordinates of the 3D points, point q is the crossing point of the two 3D lines
% <-- Ouptput:
% theta: angle in radians

r1 = line_2points_plucker(p,q);
r2 = line_2points_plucker(q,r);

theta = angle2LinesCoPlan(r1,r2);


function mat_points = line_2points_plucker(p,q)
mat_points=p*q.'-q*p.';

function theta = angle2LinesCoPlan(line1,line2)
planeInf=[0 0 0 1].';
dir1 = cross_line_plane_plucker(line1,planeInf);
dir2 = cross_line_plane_plucker(line2,planeInf);

scalar=dot(dir1,dir2);
module = sqrt(sum(dir1.^2)*sum(dir2.^2));
theta = acos(scalar/module);

function point = cross_line_plane_plucker(mat_line,plane)
point=mat_line*plane;
 