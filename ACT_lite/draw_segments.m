% draw_segments Adds the segments to a 2D/3D fig
%
% origin: a matrix with origin points (columns)
% ending: a matrix with ending points (columns)

% This code has been adapted from the ACT toolbox, developed by Guillermo Gallego Bonet.


function draw_segments(origin,ending,color)

[dim,npoints]=size(origin);

if nargin==3
    % Color(s) as a parameter 
    if dim==2
        line([origin(1,:); ending(1,:)], [origin(2,:); ending(2,:)], 'Color', color);
    elseif dim == 3
        line([origin(1,:); ending(1,:)], [origin(2,:); ending(2,:)], [origin(3,:); ending(3,:)], 'Color', color);
    end
else
    % random colors
    if dim==2
        line([origin(1,:); ending(1,:)], [origin(2,:); ending(2,:)]);
    elseif dim == 3
        line([origin(1,:); ending(1,:)], [origin(2,:); ending(2,:)], [origin(3,:); ending(3,:)]);
    end
end