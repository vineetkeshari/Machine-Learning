clear all;
load ('digits.mat');

% we average over iterations since we are taking random train/test images
noOfIterations = 10;

noOfTrainSamples = 100;
noOfTestSamples = 100;

% no of dimensions must be less than min (28x28=784, noOfTrainSamples)
noOfDimensions = 100;

% no of neighbors for k-nearest neighbors
k = 3;

[m n p q] = size(trainImages);

accuracy = 0;
%Because we are randomly choosing training and test vectors,
% we average over some no. of iterations
for y = 1:noOfIterations
    %Get random images from training set
    trainImsSet = zeros(m,n,p,noOfTrainSamples);
    labels = zeros(1,noOfTrainSamples);
    r = (randi (q,noOfTrainSamples));
    r = r(:,1);
    for i = 1:size(r,1)
        trainImsSet(:,:,:,i) = trainImages(:,:,:,r(i));
        labels(:,i) = trainLabels(r(i));
    end

    %Get random images from test set
    testImsSet = zeros(m,n,p,noOfTestSamples);
    testLabs = zeros(1,noOfTestSamples);
    r = (randi (size(testImages,4),noOfTestSamples));
    r = r(:,1);
    for i = 1:size(r,1)
        testImsSet(:,:,:,i) = testImages(:,:,:,r(i));
        testLabs(:,i) = testLabels(r(i));
    end

    %Convert train images to vectors
    trainIms = zeros(m.*n, size(trainImsSet,4));
    for i = 1:size(trainImsSet,4)
        trainIms(:,i) = reshape(trainImsSet(:,:,:,i), m.*n,1);
    end

    %Calculate mean and eigenVectors
    [mean eigVectors] = hw1FindEigenDigits(trainIms);

    %reduce the no. of dimensions for PCA
    eigVectors = eigVectors(:,1:noOfDimensions);

    %project training images to eigenspace
    projectedTrains = zeros(size(eigVectors,2),size(trainIms,2));
    for i = 1:size(trainIms,2)
        projectedTrains(:,i) = eigVectors' * (trainIms(:,i) - mean);
    end

    %find the label (category) means
    %(used only if using hw1LAv for classification instead of hw1KNN)
    labelMeans = zeros(size(projectedTrains,1),10);
    labelCounts = zeros(1,10);
    for i = 1:size(projectedTrains,2)
        label = labels(i);
        if (label == 0)
            label = 10;
        end
        labelMeans(:,label) = labelMeans(:,label) + projectedTrains(:,i);
        labelCounts(label) = labelCounts(label) + 1;
    end
    for i = 1:10
        labelMeans(:,i) = labelMeans(:,i) ./ labelCounts(i);
    end

    %convert test images to vectors and project to eigenspace
    projectedTests = zeros(size(eigVectors,2),size(testImsSet,4));
    for i = 1:size(testImsSet,4)
        imageVector = double(reshape(testImsSet(:,:,:,i),m.*n,1));
        projectedTests(:,i) = eigVectors' * (imageVector - mean);
    end

    correct = 0;
    debug = [];
    for z = 1:size(projectedTests,2)
        testVector = projectedTests(:,z);
        testLabel = testLabs(z);
    
        % use k nearest neighbors (EXTREMELY SLOW!)
        [result] = hw1KNN(testVector, projectedTrains, labels, k);
    
        % OR use label (category) means
        %[result] = hw1LAv(testVector, labelMeans);
    
        %if correct classification
        if (result == testLabel)
            correct = correct + 1;
        end
    
        %debug = [debug [digit testLabel distances(1:2.*k)]'];
    end
    accuracy = accuracy + ((correct * 100)./size(testImsSet,4))./noOfIterations;
end