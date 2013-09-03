% use chain rule to calculate the joint probability for all variables
% values contain the assignment to each variable
function [product] = getJointProb (values, numParents, parents, prob0, prob1, prob2)
    product = 1;
    for i = 1:10
        prob = 1;
        if numParents(i) == 0
            prob = prob0(i);
        else if numParents(i) == 1
                prob = prob1(i, values(parents(1,i))+1);
            else if numParents(i) == 2
                    prob = prob2(i, values(parents(1,i))+1, values(parents(2,i))+1);
                end
            end
        end
        if values(i) == 0
            prob = 1 - prob;
        end
        product = product .* prob;
    end
end