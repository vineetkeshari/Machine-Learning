function [obstaclePolicy, qValues] = learnObstacles (iters, episodeSize, showTrain, avoidLoops)
    learnRate = 0.1;
    obstaclePolicy = randi (4,4,3,4,2,2,2);
    qValues = zeros (4,3,4,2,2,2,4);
    
    iterData = 1:iters;
    qData = zeros(1,iters);
    for i = 1:iters
        lastQValues = qValues;
        world = generateWorld();
        position = [randi(3), randi(25)]';
        while world(position(1), position(2)) == -1
            position = [randi(3), randi(25)]';
        end
        state = getObstacleState (position, world);
        for j = 1:episodeSize
            valid = 0;
            for k = 1:size(state,1)
                if state(k) ~= 1
                    valid = 1;
                    break;
                end
            end
            if valid == 1
                [obstaclePolicy, qValues, state, position, world] = qObstacleStep (obstaclePolicy, qValues, state, position, world, avoidLoops, learnRate);
            else
                break;
            end
        end
        diffQValues = abs(qValues - lastQValues);
        qData (1,i) = sum(sum(sum(sum(sum(sum(sum(diffQValues)))))),7);
        
        if showTrain == 1 && mod(i,iters./40) == 0
            subplot(2,3,5);
            curvefit (iterData(1,1:i), qData(1,1:i), 3, 'blue', 1, 1);
            axis([0 iters 0 1]);
            title(sprintf('Change in Q-Values per episode for Obstacle Module, Iteration %d/%d', i, iters));
            xlabel('Iterations -->');
            ylabel('Sum of absolute change in Q-values');
            drawnow;
        end
    end
end
    