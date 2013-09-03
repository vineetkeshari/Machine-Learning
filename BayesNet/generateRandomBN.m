% Generates a Bayesian Network of fixed structure, but random conditional
% probabilities at each node. Can be easily generalized to generate a random
% network as well, but that's beyond the scope here. Max. parents of a node
% restricted to 2.
function [numParents, parents, prob0, prob1, prob2] = generateRandomBN ()
    % define no. of parents for each node (nodes are ordered topologically)
    numParents = [0 0 0 2 2 0 1 2 2 1];
    
    % define the actual parents for each node
    % [0 0] => no parents,
    % [x 0] => one parent x,
    % [x y] => two parents x & y
    parents = int32(zeros(2,10));
    parents(:,4) = [1 2];
    parents(:,5) = [2 3]';
    parents(:,7) = [4 0]';
    parents(:,8) = [4 5]';
    parents(:,9) = [5 6]';
    parents(:,10) = [8 0]';
    
    % define the probability that node = 1 given parents
    %   prob0 : p(x=1) for each node x with no parent
    %   prob1 : p(x=1|y=[0/1]) for each node x with parent y
    %   prob2 : p(x=1|y=[0/1],z=[0/1]) for each node x with parents y and z
    % other values are all zero (they should never be checked if we know
    % the value of numParents)
    prob0 = zeros(10,1);
    prob1 = zeros(10,2);
    prob2 = zeros(10,2,2);
    for i = 1:10
        if numParents(i) == 0
            prob0(i) = rand(1);
        else if numParents(i) == 1
                prob1(i,:) = rand(1,2);
            else
                prob2(i,:,:) = rand(2,2);
            end
        end
    end
end
    