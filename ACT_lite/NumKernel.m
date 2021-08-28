% NumKernel  Returns the unitary vector associated to the smallest singular vector of M, and that smallest singular vector

% This code has been adapted from the ACT toolbox, developed by Guillermo Gallego Bonet.

function [Y,err]=NumKernel(M)
[u,s,v]=svd(M,0);
err=s(end);
Y=v(:,end);
