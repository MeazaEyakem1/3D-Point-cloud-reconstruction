function [X_tf] = transform_P(H,X,t)

H_inv = inv(H);
for k=1:size(X,3)
    if t == 1
        X_tf(:,:,k) = X(:,:,k)*H_inv;
    elseif t == 0
        X_tf(:,:,k) = H*X(:,:,k);
    end
end

end