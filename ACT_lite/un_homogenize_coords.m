% un_homogenize_coords  Divides  each column x(:,point,cam) by its last coordinate

% This code has been adapted from the ACT toolbox, developed by Guillermo Gallego Bonet.


function y = un_homogenize_coords(x)
d=size(x,1);

% check if it has been already done 
u = x(d,:,:);
if ~all(u(:)==1)
    y=x./repmat(x(d,:,:),[d,1,1]);
else
    y=x;
end
