% homogenize_coords  Adds a unitary coordinate to each column x(:,point,cam)

% This code has been adapted from the ACT toolbox, developed by Guillermo Gallego Bonet.


function xh = homogenize_coords(x)
[sx,sy,sz] = size(x);
xh = ones(sx+1,sy,sz);
xh(1:sx,:,:) = x;
