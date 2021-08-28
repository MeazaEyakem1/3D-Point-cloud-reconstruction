% unitarize_coords  Makes the hm. coordinates of a  point set unitary Hace unitarias las coordenadas homogéneas de un conjunto de puntos
% Q(N,M) are the M points.
% QQ(N,M) are the normalized points.

% This code has been adapted from the ACT toolbox, developed by Guillermo Gallego Bonet.


function QQ = unitarize_coords(Q)
N=size(Q,1);
QQ=Q./repmat(sqrt(sum(Q.*conj(Q))),[N,1]);