function [approachPolicy, qValues] = learnApproach (iters, showTrain)
    learnRate = 0.1;
    approachPolicy = randi (4,25,1);
    qValues = zeros (25,4);
    qValues = qValues + 0.5;
    qValues(25,:) = qValues(25,:) - 0.5;
    
    for i = 1:iters
        position = [randi(3), 1]';
        state = position(2);
        while (state ~= 25)
            [approachPolicy, qValues, state, position] = qApproachStep (approachPolicy, qValues, state, position, learnRate);
        end
        if showTrain == 1 && mod(i,iters./50) == 0
            subplot(2,3,4);
            qValueImage = qValues';
            qValueImage = (qValueImage + 0.1)./1.1;
            imshow(qValueImage);
            title(sprintf('Q-values for Approach module, Iteration %d/%d', i, iters));
            xlabel(sprintf('For each column on the grid, rows 1-4 are Q-values for actions\nUp, Down, Left, Right respectively.Whiter cells represent higher Q-values.'));
            drawnow;
        end
    end
end
    