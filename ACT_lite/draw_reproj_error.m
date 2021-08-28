% draw_reproj_error  Draws the reprojection error given the observed points q and a projective reconstruction (P,Q)
% q(3,npuntos,ncam) projected points
% P(3,4,ncam) projection matrices
% Q(4,cam) 3D points

% This code has been adapted from the ACT toolbox, developed by Guillermo Gallego Bonet.


function draw_reproj_error(q,P,Q,vp)

[dim,npoints,ncam] = size(q);
q = un_homogenize_coords(q);

if nargin<3
    q_rep = P; 
elseif nargin>=3
    q_rep = project_points(P,Q);
end

% Afinne
q_error = q(1:2,:,:)-q_rep(1:2,:,:); %(2,npoints,ncam) 

% Color code for each image:
colors = 'mcrgbk';

figure,
num=gcf;
if nargin==4
    % Visible Points
    for k = 1:ncam,
        idx_vp = find(vp(:,k));
        eval(['plot(q_error(1,idx_vp,' num2str(k) '),q_error(2,idx_vp,' num2str(k) '),''' colors(rem(k-1,6)+1) '+'');']);
        hold on;
    end
else
    % Affine
    for k = 1:ncam,
        eval(['plot(q_error(1,:,' num2str(k) '),q_error(2,:,' num2str(k) '),''' colors(rem(k-1,6)+1) '+'');']);
        hold on;
    end    
end
hold off;
grid
axis('equal');
title('Reprojection error (in pixel)');   
xlabel('x');
ylabel('y');
set(num,'color',[1 1 1]);
set(num,'Name','Reproyection Error','NumberTitle','off');

if nargin==4
    % Visible Points
    xy_error = [];
    for k = 1:ncam,
        idx_vp = find(vp(:,k));
        xy_error = [xy_error, q_error(:,idx_vp,k)];
    end    
else
    xy_error = matriz3dim2matriz2dim(q_error,'h');
    %[err_mean,err_std,mi,dti] = normfit(xy_error.');
end
err_mean = mean(xy_error.');
err_std = std(xy_error.');

fprintf(1,'Pixel error:          mean = [ % 3.5f   % 3.5f]\n',err_mean); 
fprintf(1,'Pixel error:          std  = [ % 3.5f   % 3.5f]\n',err_std); 

% % q_error(find(abs(q_error)>4))=0;
% % nbins=60;

% x,y coordinates of the error are independent
num_hist=figure;
v = xy_error.';
v = v(:);
npoints = size(q,2);
nbins = min(200,3*sqrt(npoints));
hist(v,nbins);

% % edges=linspace(-4,4,nbins);
% % edges=edges(1:end-1);
% % histograma=histc(v,edges);
% % bar(edges,histograma,'histc','g');
% % xlabel('pixel'), grid, axis([-4 4 0 900])
% % set(gca,'XTick',[-4:1:4],'YTick',[0:100:900])
% % set(gca,'FontSize',16)

set(num_hist,'Name','Error Histogram','NumberTitle','off');


% Gaussian fit: comando histfit
x_min = min(v);
x_max = max(v);
xx = linspace(x_min,x_max,100);
rangex = x_max-x_min;      
binwidth = rangex/nbins;   
mr = nanmean(v);
sr = nanstd(v);
yy = normpdf(xx,mr,sr);
yy = sum(~isnan(v))*(yy*binwidth);
hold on, plot(xx,yy,'m'),hold off
grid
