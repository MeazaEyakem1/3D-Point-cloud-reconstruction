% draw_lines  Draws the lines (in P2) given by their hom.coordinates in the indicated rectangle
% Each column of a are the hom. coords of a line:  a(1,k)*x+a(2,k)*y+a(3,k)=0;
% If the rectangle is not indicated, lines are drawn in the active figure

% This code has been adapted from the ACT toolbox, developed by Guillermo Gallego Bonet.


function draw_lines(a,xmin,xmax,ymin,ymax,color)
color='g';
if nargin==1
    eje_x = get(get(gcf,'CurrentAxes'),'Xlim');
    eje_y = get(get(gcf,'CurrentAxes'),'Ylim');
    xmin = eje_x(1); 
    xmax = eje_x(2);
    ymin = eje_y(1);
    ymax = eje_y(2);
end

if numel(a)==3 
    % only one line
    n_lines = 1;
    q = zeros(2,4);
    q(:,1) = [xmin,(-a(3)-a(1)*xmin)/a(2)]';
    q(:,2) = [xmax,(-a(3)-a(1)*xmax)/a(2)]';
    q(:,3) = [(-a(3)-a(2)*ymin)/a(1),ymin]';
    q(:,4) = [(-a(3)-a(2)*ymax)/a(1),ymax]';
    
    [p,index]=sort([q(1,:)]);
    
    p1 = q(:,index(2));
    p2 = q(:,index(3));
    
    X = [p1(1),p2(1)];
    Y = [p1(2),p2(2)];
    
    line(X,Y);
else
    % several lines
    n_lines = size(a,2);    
    fin = 2*n_lines;
    q = zeros(4,2*n_lines);
    q(1,[1:2:fin]) = xmin;q(2,[1:2:fin]) = xmax;
    q(3,[2:2:fin]) = ymin;
    q(4,[2:2:fin]) = ymax;
    q(1,[2:2:fin]) = -(a(3,:)+a(1,:)*xmin)./a(2,:);
    q(2,[2:2:fin]) = -(a(3,:)+a(1,:)*xmax)./a(2,:);
    q(3,[1:2:fin]) = -(a(3,:)+a(2,:)*ymin)./a(1,:);
    q(4,[1:2:fin]) = -(a(3,:)+a(2,:)*ymax)./a(1,:);
    
    [x_ord,index] = sort(q(:,[1:2:fin]),1);
    idd = repmat([0:n_lines-1]*8,4,1) + index;
    idd = idd(:)+4;
    y_ord = reshape(q(idd),4,n_lines);
    
    line( x_ord(2:3,:), y_ord(2:3,:),'Color',color );
end