function [approachPolicy, qValues, newState, newPosition] = qApproachStep (approachPolicy, qValues, state, position, learnRate)
    discount = 0.9;
    epsilon = 0.1;
    
    r = rand();
    if r < epsilon  % explore
        action = randi(4);
        while action == approachPolicy(state)
            action = randi(4);
        end
    else            % exploit
        action = approachPolicy(state);
    end

    newPosition = takeAction (position, action);
    newState = newPosition(2);
    
    if newState == 25
        reward = 1;
    else
        reward = -0.01;
    end
    
    maxVal = max(qValues(newState,:));
    qValues(state, action) = (1-learnRate).*(qValues(state, action)) + learnRate.*(reward + discount.*maxVal);
    [val bestAction] = max(qValues(state,:));
    approachPolicy(state) = bestAction;
    
end