clear all;
load ('sounds.mat')

% Choose the signals to process
choice = [1 2 3 4 5]';
pickedSounds = [];
for i = 1 : size(choice,1)
    pickedSounds = [pickedSounds' sounds(choice(i),:)']';
end
sounds = pickedSounds;

% Get a time range from the signals
timeRange = [1 44000];
sounds = sounds (:,timeRange(1):timeRange(2));
[n time] = size (sounds);

% Max no. of iterations
iters = 10000;
epsilon = 0.000001;

% Mixed signals = mixedMult x Input signals
mixedMult = 1;

% Get no. of mixed signals
m = mixedMult.*n;

% Learning rate depends on no. of mixed signals.. Too high and it won't
% converge. Too low and it will take eternity.
learnRate = 0.0001 ./ m;

% Mix the signals
A = rand (m, n);
for i = 1:size(A,1)
    A(i,:) = A(i,:) ./ norm (A(i,:));
end
X = A * sounds;

% Initialize random weights
W = rand(n,m);

% Keep a history of W (for plots)
data = zeros(iters,m,n);

% Iterate
for t = 1:iters
    Y = W * X;

    % Calculate Z
    Z = 1 ./ (1 + exp(-Y));

    dW = learnRate .* ((eye(n) + ((1 - 2.*Z) * Y')) * W);
    
    % Stop converging if all elements of dW get very small
    if (abs(dW) < epsilon)
        data = data(1:t-1,:,:);
        break;
    else
        W = W + dW;
    end

    % Data collection
    data(t,:,:) = W';
    
    % Realtime data plot
    %hw2_plot (data, m, n);
end

% Reconstruct signals and normalize for comparison
Y = W * X;
minY = min(min(Y));
maxY = max(max(Y));
rangeY = maxY - minY;
Y = ((Y - minY)./ rangeY).*2 - 1;

S = sounds;
minS = min(min(S));
maxS = max(max(S));
rangeS = maxS - minS;
S = ((S - minS)./ rangeS).*2 - 1;

% Plot the signals
hw2_vis (S, Y, n);

% How well did we do? Calculate the sum of squared errors in the
% normalized signals for each permutation of rows of Y.
% Then, pick the lowest.
permute = perms([1:n]);
minError = 10.^10;
for i = 1:size(permute, 1)
    error = 0;
    for j = 1:size(permute, 2)
        difference = Y(permute(i,j),:) - S(j,:);
        error = error + sum (difference.^2);
    end
    if (error < minError)
        minError = error;
    end
end

% Curve-fit and plot error data
%hw2_curvefit (errorData, 2);