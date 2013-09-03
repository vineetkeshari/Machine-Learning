function [numSteps, obstacles, steps, failed] = testOnWorld (world, approachValues, obstacleValues, obstacleWeight, displayGrid, tries, avoidLoops)
    failThreshold = 100;

    position = [randi(3) 1]';
    steps = zeros(1,failThreshold);

    numSteps = 0;
    obstacles = 0;
    failed = 0;
    while position(2) ~= 25
        approachState = position(2);
        approachValueSet = approachValues(approachState,:);
    
        obstacleState = getObstacleState (position, world);
        obstacleValueSet = obstacleValues(obstacleState(1), obstacleState(2), obstacleState(3), obstacleState(4), obstacleState(5), obstacleState(6), :);
        obstacleValueSet = [obstacleValueSet(1,1,1,1,1,1,1), obstacleValueSet(1,1,1,1,1,1,2), obstacleValueSet(1,1,1,1,1,1,3), obstacleValueSet(1,1,1,1,1,1,4)];
    
        weightedValueSet = obstacleWeight .* obstacleValueSet + (1-obstacleWeight) .* approachValueSet;
        [val action] = max (weightedValueSet);
        
        if avoidLoops == 1
            if world(position(1), position(2)) ~= -1
                world(position(1), position(2)) = -0.5;
            end
        end
        position = takeAction (position, action);
        numSteps = numSteps + 1;
        if world(position(1), position(2)) == -1
            obstacles = obstacles + 1;
        end
        steps(1,numSteps) = action;
        if numSteps == failThreshold
            numSteps = 0;
            obstacles = 0;
            failed = 1;
            break;
        end
        
        if displayGrid == 1
            graphWorld = world + 0.7;
            graphWorld(position(1),position(2)) = 1;
            subplot(2,3,6);
            imshow(graphWorld);
            title (sprintf('Testing on grid for obstacleWeight = %.2f\nSteps Taken: %2d, Obstacles Hit: %2d', obstacleWeight, numSteps, obstacles));
            xlabel (sprintf('Note: This figure is shown for only one episode for some values of obstacleWeight,\nbut each data point in the graphs above is averaged over %d episodes\nfor each value of obstacleWeight.', tries));
            drawnow;
        end
        
    end
end