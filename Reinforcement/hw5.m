displayGrid = 1;
showTrain = 1;

avoidLoops = 1;

approachIters = 600;
obstacleIters = 10000;
episodeSize = 100;

[approachPolicy approachValues] = learnApproach(approachIters, showTrain);

[obstaclePolicy obstacleValues] = learnObstacles(obstacleIters, episodeSize, showTrain, avoidLoops);

tries = 100;
obstacleWeightData = 0.1:0.01:0.9;
numStepsData = zeros(1,size(obstacleWeightData,2));
obstaclesData = zeros(1,size(obstacleWeightData,2));
failsData = zeros(1,size(obstacleWeightData,2));
for iters = 1:size(obstacleWeightData,2)
    totalNumSteps = 0;
    totalObstacles = 0;
    fails = 0;
    showEpisode = randi(tries);
    for i = 1:tries
        world = generateWorld();
        obstacleWeight = obstacleWeightData(1,iters);
        if i == showEpisode && mod(iters,5) == 0
            [numSteps obstacles steps failed] = testOnWorld (world, approachValues, obstacleValues, obstacleWeight, displayGrid, tries, avoidLoops);
        else
            [numSteps obstacles steps failed] = testOnWorld (world, approachValues, obstacleValues, obstacleWeight, 0, tries, avoidLoops);
        end
        totalNumSteps = totalNumSteps + numSteps;
        totalObstacles = totalObstacles + obstacles;
        fails = fails + failed;
    end
    if fails == tries
        numStepsData (1,iters) = 0;
        obstaclesData (1,iters) = 0;
    else
        numStepsData (1,iters) = totalNumSteps ./ (tries - fails);
        obstaclesData (1,iters) = totalObstacles ./ (tries - fails);
    end
    failsData (1,iters) = 100 - (fails.*100)./tries;
    
    % Plot graphs
    subplot(2,3,1);
    %plot (obstacleWeightData, numStepsData, 'Color', 'green', 'LineWidth', 3);
    curvefit (obstacleWeightData(1,1:iters), numStepsData(1,1:iters), 3, 'green', 1, 20);
    axis([0 1 25 40]);
    title ('Approach module performance vs obstacleWeight');
    ylabel('Average steps taken');
    xlabel('Weight of obstacle module -->');
    subplot(2,3,2);
    %plot (obstacleWeightData, obstaclesData, 'Color', 'red', 'LineWidth', 3);
    curvefit (obstacleWeightData(1,1:iters), obstaclesData(1,1:iters), 3, 'red', 1, 20);
    axis([0 1 0 3]);
    title ('Obstacles module performace vs obstacleWeight');
    ylabel('Average obstacles hit');
    xlabel('Weight of obstacle module -->');
    subplot(2,3,3);
    %plot (obstacleWeightData, failsData, 'Color', 'blue', 'LineWidth', 3);
    curvefit (obstacleWeightData(1,1:iters), failsData(1,1:iters), 3, 'blue', 1, 20);
    axis([0 1 0 105]);
    title ('Success %  vs obstacleWeight');
    ylabel('% Attempts successful');
    xlabel('Weight of obstacle module -->');
    drawnow;

end
