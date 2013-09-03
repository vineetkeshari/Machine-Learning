function [creatures creatureLengths parasites] = initializeGenomes (range, creatureLength, creaturePopulation, maxCreatureLength, parasiteLength, parasitePopulation) 
    creatures = zeros(2,maxCreatureLength,creaturePopulation);
    parasites = zeros(parasiteLength,parasitePopulation);
    creatureLengths = zeros(creaturePopulation, 1) + creatureLength;
    
    for i = 1:creaturePopulation
        creature = randi(parasiteLength, 2, creatureLength);
        for j = 1:creatureLength
            while creature(1,j) == creature(2,j)
                creature(:,j) = randi(parasiteLength, 2, 1);
            end
            if creature(1,j) > creature(2,j)
                temp = creature(2,j);
                creature(2,j) = creature(1,j);
                creature(1,j) = temp;
            end
        end
        if creatureLength < maxCreatureLength
            creature(:,creatureLength+1:maxCreatureLength) = 0;
        end
        creatures(:,:,i) = creature;
    end
    
    for i = 1:parasitePopulation
        parasite = randi(range, parasiteLength, 1);
        parasites(:,i) = parasite;        
    end
end