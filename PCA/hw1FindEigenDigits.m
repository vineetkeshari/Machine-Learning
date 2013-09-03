function [meanVector V] = hw1FindEigenDigits(inputMatrix)
    % x : no. of features
    % k : no. of training examples
    [x k] = size(inputMatrix);
    
    meanVector = mean(inputMatrix,2);
    
    covariance = zeros(x);
    for i = 1:k
        difference = double(inputMatrix(:,i)) - meanVector;
        covariance = covariance + (difference*difference') ./ k;
    end
    
    % We must ask eigs for no. of eigenvectors < no. of columns (x-1)
    % or the no. of training examples we have if it's smaller.
    [V vals] = eigs(covariance,min(k,x-1));
    
    % normalize each eigenVector
    for i=1:size(V,2)
        V(:,i) = V(:,i)./norm(V(:,i));
    end
end
