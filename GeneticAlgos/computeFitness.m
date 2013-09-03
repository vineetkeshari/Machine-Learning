function [creatureFitness parasiteFitness] = computeFitness (successMatrix, creatureLengths, parasiteLength, creaturePopulation, parasitePopulation, minCreatureLength, maxCreatureLength)
    creatureFitness = zeros(creaturePopulation,1);
    parasiteFitness = zeros(parasitePopulation,1);
    
    for i = 1:creaturePopulation
        fitness = sum(successMatrix(i,:),2)./parasitePopulation;
        if minCreatureLength < maxCreatureLength./2
            if creatureLengths(i) == maxCreatureLength
                fitness = 0;
            else
                fitness = fitness .* (log(maxCreatureLength-creatureLengths(i))./log(maxCreatureLength-minCreatureLength));
            end
        end
        creatureFitness(i) = fitness;
    end
    
    for i = 1:parasitePopulation
        parasiteFitness(i) = sum(1-successMatrix(:,i),1)./creaturePopulation;
    end
    
end