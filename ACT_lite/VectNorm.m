% VectNorm  Given a matrix x(dim,num), returns a row-vector y(num) with the norms of the column vectors

% This code has been adapted from the ACT toolbox, developed by Guillermo Gallego Bonet.


function y=VectNorm(x)

y=sqrt(sum(x.*conj(x)));