function [digit] = hw1KNN (testVector, projectedTrains, labels, k)
    %get all distances to training vectors
    distances = zeros(1,size(projectedTrains,2));
    for i = 1:size(projectedTrains,2)
        distances(:,i) = norm(testVector-projectedTrains(:,i));
    end

    counts = zeros(10,1);
    for i = 1:k
        [val index] = min(distances);
        label = labels(:,int16(index));
        if (label == 0)
            label = 10;
        end
        counts(label) = counts(label)+1;
        distances = [distances(:,1:index-1) distances(:,index+1:size(distances,2))];
        projectedTrains = [projectedTrains(:,1:index-1) projectedTrains(:,index+1:size(projectedTrains,2))];
        labels = [labels(:,1:index-1) labels(:,index+1:size(labels,2))];
    end

    %digit is the one with maximum count
    [val digit] = max(counts);
    if (digit == 10)
        digit = 0;
    end
end