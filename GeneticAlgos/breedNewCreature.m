function [newCreature newCreatureLength] = breedNewCreature (creature1, creature2, creatureLength1, creatureLength2, minCreatureLength, maxCreatureLength, parasiteLength, mutateProb)
    
    [newCreature newCreatureLength] = creatureCrossover (creature1, creature2, creatureLength1, creatureLength2, minCreatureLength, maxCreatureLength);
            
    t = rand();
    if t < mutateProb
        z = randi(newCreatureLength);
                
        newPair = randi(parasiteLength, 2, 1);
        while newPair(1) == newPair(2)
            newPair = randi(parasiteLength, 2, 1);
        end
                
        newCreature(:,z) = newPair;
    end
end            
