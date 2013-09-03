function [digit] = hw1LAv (testVector, labelMeans)
    numLabels = size(labelMeans,2);
    
    %get distances from mean of each label
    distances = zeros(1,numLabels);
    for i = 1:numLabels
        distances(i) = norm (testVector - labelMeans(:,i));
    end
    
    %digit is the one with maximum count
    [maxCount digit] = min(distances);
    if (digit == 10)
        digit = 0;
    end
end