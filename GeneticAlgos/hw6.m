iters = 100;
range = 256;
mutateProb = 0.1;
showGraphs = 1;

creatureLength = 64;
minCreatureLength = 64;
maxCreatureLength = 1024;
creaturePopulation = 256;
creatureBreeders = 64;
creatureSurvivors = 16;

parasiteLength = 16;
parasitePopulation = 64;
parasiteBreeders = 16;
parasiteSurvivors = 0;

[creatures creatureLengths parasites] = initializeGenomes(range, creatureLength, creaturePopulation, maxCreatureLength, parasiteLength, parasitePopulation);

[champion championLength fitness] = coevolve (iters, creatures, creatureLengths, parasites, range, creatureSurvivors, creatureBreeders, parasiteSurvivors, parasiteBreeders, creaturePopulation, minCreatureLength, maxCreatureLength, parasiteLength, parasitePopulation, mutateProb, showGraphs);
    
if showGraphs == 1
    subplot (3,2,[5 6]);
    displayNetwork(champion, championLength, minCreatureLength, maxCreatureLength, parasiteLength);
    title('Champion Network');
    xlabel(sprintf('Comparisons\n<-- 1-%d -->', championLength));
    ylabel(sprintf('Input indices\n<-- %d-1 -->', parasiteLength));
    drawnow;
end
