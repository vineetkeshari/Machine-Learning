function [successMatrix] = evaluateSorting (creatures, creatureLengths, parasites, parasiteLength, creaturePopulation, parasitePopulation)
    successMatrix = zeros(creaturePopulation, parasitePopulation);
    orderedPairs = (parasiteLength.*(parasiteLength-1))./2;
    for i = 1:creaturePopulation
        creature = creatures(:,:,i);
        length = creatureLengths(i);
        for j = 1:parasitePopulation
            parasite = parasites(:,j);
            for k = 1:length
                if parasite(creature(2,k)) < parasite(creature(1,k))
                    temp = parasite(creature(1,k));
                    parasite(creature(1,k)) = parasite(creature(2,k));
                    parasite(creature(2,k)) = temp;
                end
            end
            count = 0;
            for k = 1:parasiteLength-1
                for l = k+1:parasiteLength
                    if parasite(k) <= parasite(l)
                        count = count + 1;
                    end
                end
            end
            successMatrix(i,j) = count./orderedPairs;
        end
    end
end