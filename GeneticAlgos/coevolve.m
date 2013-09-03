function [actualChampion actualChampionLength maxCreatureFitness] = coevolve (iters, creatures, creatureLengths, parasites, range, creatureSurvivors, creatureBreeders, parasiteSurvivors, parasiteBreeders, creaturePopulation, minCreatureLength, maxCreatureLength, parasiteLength, parasitePopulation, mutateProb, showGraphs)
    itersData = 1:iters;
    maxFitnessData = zeros(1,iters);
    avgFitnessData = zeros(1,iters);
    lengthData = zeros(1,iters);
    avgLengthData = zeros(1,iters);
    parasiteFitnessData = zeros(1,iters);
    avgParasiteFitnessData = zeros(1,iters);
    actualFitnessData = zeros(1,iters);
    actualLengthData = zeros(1,iters);
    
    actualChampionLength = maxCreatureLength;
    actualChampionFitness = 0;
    
    % Create all binary inputs to check the champion on
    allInputs = zeros(2.^parasiteLength, parasiteLength);
    for i = 0:parasiteLength-1
        j = 2.^i;
        for k = 0:j.*2:2.^parasiteLength-1
            for l = k+1:k+j
                allInputs(l, parasiteLength-i) = 0;
            end
            for l = k+j+1:k+j+j
                allInputs(l, parasiteLength-i) = 1;
            end
        end
    end
    
    for i = 1:iters
        % compute fitness for each creature, parasite pair
        successMatrix = evaluateSorting (creatures, creatureLengths, parasites, parasiteLength, creaturePopulation, parasitePopulation);
        [creatureFitness parasiteFitness] = computeFitness (successMatrix, creatureLengths, parasiteLength, creaturePopulation, parasitePopulation, minCreatureLength, maxCreatureLength);
        
        % sort fitness and collect data
        [creatureFitness creatureIndices] = sort(creatureFitness, 'descend');
        avgCreatureFitness = sum(creatureFitness)./creaturePopulation;
        avgCreatureLength = sum(creatureLengths)./creaturePopulation;
        champion = creatures(:,:,creatureIndices(1));
        championLength = creatureLengths(creatureIndices(1));
        maxCreatureFitness = creatureFitness(1);
        if sum(creatureFitness) ~= 0
            creatureFitness = creatureFitness ./ sum(creatureFitness);
        else
            creatureFitness = zeros(1,creaturePopulation);
        end
        creatureFitness = cumsum(creatureFitness);
        
        [parasiteFitness parasiteIndices] = sort(parasiteFitness, 'descend');
        avgParasiteFitness = sum(parasiteFitness)./parasitePopulation;
        maxParasiteFitness = parasiteFitness(1);
        if sum(parasiteFitness) ~= 0
            parasiteFitness = parasiteFitness ./ sum(parasiteFitness);
        else
            parasiteFitness = zeros(1,parasitePopulation);
        end
        parasiteFitness = cumsum(parasiteFitness);
        
        % select breeding populations
        creatureBreed = zeros(2,maxCreatureLength,creatureBreeders);
        creatureBreedLengths = zeros(creatureBreeders);
        for j = 1:creatureBreeders
            if creatureFitness(1,1) == 0
                index = randi(creaturePopulation);
            else
                r = rand();
                index = find(creatureFitness >= r, 1);
            end
            
            creatureBreed (:,:,j) = creatures (:,:,creatureIndices(index));
            creatureBreedLengths (j) = creatureLengths (creatureIndices(index));
        end
        
        parasiteBreed = zeros(parasiteLength, parasiteBreeders);
        for j = 1:parasiteBreeders
            if parasiteFitness(1,1) == 0
                index = randi(parasitePopulation);
            else
                r = rand();
                index = find(parasiteFitness >= r, 1);
            end
                
            parasiteBreed (:,j) = parasites (:,parasiteIndices(index));
        end

        % create new population with survivors
        newCreatures = zeros(2,maxCreatureLength,creaturePopulation);
        newCreatureLengths = zeros(creaturePopulation,1);
        for j = 1:creatureSurvivors
            newCreatures(:,:,j) = creatures(:,:,creatureIndices(j));
            newCreatureLengths(j) = creatureLengths(creatureIndices(j));
        end
        
        newParasites = zeros(parasiteLength,parasitePopulation);
        for j = 1:parasiteSurvivors
            newParasites(:,j) = parasites(:,parasiteIndices(j));
        end
        
        % evolve selected populations
        for j = 1:creaturePopulation-creatureSurvivors
            r = randi(creatureBreeders);
            s = randi(creatureBreeders);
            while s == r
                s = randi(creatureBreeders);
            end
    
            creature1 = creatureBreed(:,:,r);
            creature2 = creatureBreed(:,:,s);
            creatureLength1 = creatureBreedLengths(r);
            creatureLength2 = creatureBreedLengths(s);
            
            [newCreature newCreatureLength] = breedNewCreature (creature1, creature2, creatureLength1, creatureLength2, minCreatureLength, maxCreatureLength, parasiteLength, mutateProb);
            for k = 1:newCreatureLength
                if newCreature(1,k) > newCreature(2,k)
                    temp = newCreature(2,k);
                    newCreature(2,k) = newCreature(1,k);
                    newCreature(1,k) = temp;
                end
            end
            
            newCreatures(:,:,j+creatureSurvivors) = newCreature;
            newCreatureLengths(j+creatureSurvivors) = newCreatureLength;
        end
        
        for j = 1:parasitePopulation-parasiteSurvivors
            r = randi(parasiteBreeders);
            s = randi(parasiteBreeders);
            while s == r
                s = randi(parasiteBreeders);
            end
            
            parasite1 = parasiteBreed(:,r);
            parasite2 = parasiteBreed(:,s);
            
            newParasite = breedNewParasite (parasite1, parasite2, parasiteLength, range, mutateProb);
            newParasites(:,j+parasiteSurvivors) = newParasite;
        end       
        
        % Test champion on all combinations of 1s & 0s
        realMaxFitness = evaluateOnInputs (champion, championLength, allInputs);
        
        parasites = newParasites;
        creatureLengths = newCreatureLengths;
        creatures = newCreatures;
        
        if realMaxFitness > actualChampionFitness || realMaxFitness == actualChampionFitness && championLength < actualChampionLength
            actualChampion = champion;
            actualChampionLength = championLength;
            actualChampionFitness = realMaxFitness;
        end
        
        % Data collection and plots
        maxFitnessData(1,i) = maxCreatureFitness;
        avgFitnessData(1,i) = avgCreatureFitness;
        lengthData(1,i) = championLength;
        avgLengthData(1,i) = avgCreatureLength;
        parasiteFitnessData(1,i) = maxParasiteFitness;
        avgParasiteFitnessData(1,i) = avgParasiteFitness;
        actualFitnessData(1,i) = actualChampionFitness;
        actualLengthData(1,i) = actualChampionLength;
        
        if showGraphs == 1 && mod(i,int16(iters./100)) == 0
            subplot (3,2,1);
            plot (itersData(1:i), actualFitnessData(1:i), 'LineWidth', 3, 'Color', 'red');
            hold on;
            scatter (itersData(1:i), maxFitnessData(1:i), 10, 'black', 'filled');
            curvefit (itersData(1:i), avgFitnessData(1:i), 9, 'green', 0, 1);
            title('Champion and Average Fitness for Sorting network');
            xlabel('Generations -->');
            ylabel('Fitness -->');
            axis([0 i 0.8 1]);
            text(i./10, 0.82, sprintf('Generation: %d/%d', i, iters));
            text(i./10, 0.83, sprintf('Average Fitness: %.4f', avgCreatureFitness));
            text(i./10, 0.84, sprintf('Champion Fitness: %.4f', maxCreatureFitness));
            text(i./10, 0.85, sprintf('Champion Actual Fitness: %.4f', realMaxFitness));
            text(i./10, 0.87, sprintf('Maximum Actual Fitness: %.4f', actualChampionFitness));
            hold off;
            subplot (3,2,2);
            plot (itersData(1:i), actualLengthData(1:i), 'LineWidth', 3, 'Color', 'red');
            hold on;
            scatter (itersData(1:i), lengthData(1:i), 10, 'black', 'filled');
            curvefit (itersData(1:i), avgLengthData(1:i), 9, 'blue', 0, 1);
            title('Champion and Average Length for Sorting network');
            xlabel('Generations -->');
            ylabel('Length -->');
            axis([0 i 0 minCreatureLength.*8]);
            text(i.*0.1, minCreatureLength.*8.*0.7, sprintf('Generation: %d/%d', i, iters));
            text(i.*0.1, minCreatureLength.*8.*0.75, sprintf('Average Length: %d', int16(avgCreatureLength)));
            text(i.*0.1, minCreatureLength.*8.*0.8, sprintf('Champion Length: %d', championLength));
            text(i.*0.1, minCreatureLength.*8.*0.9, sprintf('Actual Champion Length: %d', actualChampionLength));
            hold off;
            subplot (3,2,3);
            scatter (itersData(1:i), parasiteFitnessData(1:i), 10, 'black', 'filled');
            hold on;
            curvefit (itersData(1:i), avgParasiteFitnessData(1:i), 9, 'red', 0, 1);
            title('Champion and Average Fitness for Input (parasites)');
            xlabel('Generations -->');
            ylabel('Fitness -->');
            axis([0 i 0 0.2]);
            text(i./10, 0.16, sprintf('Generation: %d/%d', i, iters));
            text(i./10, 0.17, sprintf('Average Fitness: %.4f', avgParasiteFitness));
            text(i./10, 0.18, sprintf('Champion Fitness: %.4f', maxParasiteFitness));
            hold off;
            subplot (3,2,4);
            imshow(successMatrix');
            title('Sort Score (fraction of pairs in output in sorted order) for each \{network,input\}');
            xlabel('Sorting networks');
            ylabel('Inputs');
            subplot (3,2,[5 6]);
            displayNetwork(champion, championLength, minCreatureLength, maxCreatureLength, parasiteLength);
            title('Champion Network');
            xlabel(sprintf('Comparisons\n<-- 1-%d -->', championLength));
            ylabel(sprintf('Input indices\n<-- %d-1 -->', parasiteLength));
            drawnow;
        end

    end

end