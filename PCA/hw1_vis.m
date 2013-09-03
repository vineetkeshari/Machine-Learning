clear all;
load ('digits.mat');

noOfTrainSamples = 10000;
noOfDimensions = 2;
[m n p q] = size(trainImages);

%Get random images from training set
trainImsSet = zeros(m,n,p,noOfTrainSamples);
labels = [];
r = (randi (q,noOfTrainSamples));
r = r(:,1);
for i = 1:size(r,1)
    trainImsSet(:,:,:,i) = trainImages(:,:,:,r(i));
    labels = [labels trainLabels(r(i))];
end

%Convert train images to vectors
trainIms = [];
for i = 1:size(trainImsSet,4)
    trainIms = [trainIms reshape(trainImsSet(:,:,:,i), ...
                size(trainImsSet,1).*size(trainImsSet,2),1)];
end

%imshow(trainIms);

%Calculate mean and eigenVectors
[mean eigVectors] = hw1FindEigenDigits(trainIms);

%reduce the no. of dimensions for PCA
eigVectors = eigVectors(:,1:noOfDimensions);
%imshow(eigVectors);

%project training images to eigenspace
projectedTrains = [];
for i = 1:size(trainIms,2)
    projectedTrains = [projectedTrains eigVectors' * (trainIms(:,i) - mean)];
end

scatter(projectedTrains(1,:),projectedTrains(2,:),5,labels,'filled');
%scatter3(projectedTrains(1,:),projectedTrains(2,:),projectedTrains(3,:),20,labels,'filled');