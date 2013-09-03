function [obstaclePolicy, qValues, newState, newPosition, world] = qObstacleStep (obstaclePolicy, qValues, state, position, world, avoidLoops, learnRate)
    discount = 0.9;
    epsilon = 0.1;
    
    r = rand();
    if r < epsilon  % explore
        action = randi(4);
        while action == obstaclePolicy(state(1),state(2),state(3),state(4),state(5),state(6))
            action = randi(4);
        end
    else            % exploit
        action = obstaclePolicy(state(1),state(2),state(3),state(4),state(5),state(6));
    end

    newPosition = takeAction (position, action);
    if avoidLoops == 1
        world(position(1),position(2)) = -1;
    end
    newState = getObstacleState(newPosition,world);
  
    reward = 0;
    if world(newPosition(1),newPosition(2)) == -1 || position(1) == newPosition(1) && position(2) == newPosition(2)
        reward = -1;
    end
    
    maxVal = max(qValues(newState(1),newState(2),newState(3),newState(4),newState(5),newState(6),:));
    qValues(state(1),state(2),state(3),state(4),state(5),state(6), action) = (1-learnRate).*(qValues(state(1),state(2),state(3),state(4),state(5),state(6), action)) + learnRate.*(reward + discount.*maxVal);
    [val bestAction] = max(qValues(state(1),state(2),state(3),state(4),state(5),state(6),:));
    obstaclePolicy(state(1),state(2),state(3),state(4),state(5),state(6)) = bestAction;
    
end