function [newCreature newCreatureLength] = creatureCrossover (creature1, creature2, creatureLength1, creatureLength2, minCreatureLength, maxCreatureLength)
% Choose a method of crossover:
%{
% Crossover between 1/3rd and 2/3rds of the lengths
    mid1 = int16(creatureLength1./3);
    mid2 = int16(creatureLength2./3);
    l1 = randi(creatureLength1-2.*mid1)+mid1;
    l2 = randi(creatureLength2-2.*mid2)+mid2;
    while l1+l2 < minCreatureLength
        mid1 = int16(creatureLength1./3);
        mid2 = int16(creatureLength2./3);
        l1 = randi(creatureLength1-2.*mid1)+mid1;
        l2 = randi(creatureLength2-2.*mid2)+mid2;
    end
%}
% Crossover between arbitrary lengths
    l1 = randi(creatureLength1);
    l2 = randi(creatureLength2);
    while l1+l2 < minCreatureLength
        l1 = randi(creatureLength1);
        l2 = randi(creatureLength2);
    end

    
    % Do the crossover
    newCreatureLength = min(l1+l2, maxCreatureLength);
    l2 = newCreatureLength-l1;
      
    newCreature = zeros(2,maxCreatureLength);
    newCreature(:,1:l1) = creature1(:,1:l1);
    newCreature(:,l1+1:newCreatureLength) = creature2(:,creatureLength2-l2+1:creatureLength2);
    
end