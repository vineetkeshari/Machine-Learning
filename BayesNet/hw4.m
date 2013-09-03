numQueries = 100;
numSamples = 1000;
graph = 1;

% Generate a new network if generate is 1, otherwise load it
if generate == 0
    load ('BN1.mat');
else
    [numParents, parents, prob0, prob1, prob2] = generateRandomBN();
    save('BN1.mat', 'numParents', 'parents', 'prob0', 'prob1', 'prob2');
end
    
sum = 0;
data = zeros(1,numQueries);
for t = 1:numQueries
    % Generate a new query
    [queryVariables, queryValues] = generateQuery();
    
    % perform both rejection and gibbs sampling
    [rejectionProbability gibbsProbability] = sampleForQuery (numSamples, queryVariables, queryValues, numParents, parents, prob0, prob1, prob2, graph);
    
    % plot difference between the two values
    error = (gibbsProbability - rejectionProbability)^2;
    data(1,t) = error;
    sum = sum + error;
    avg = sum ./ t;
    if graph == 1
        subplot (2,2,[3 4]);
    else
        subplot (2,2,[1 2 3 4]);
    end
    
    plot (data, 'Marker', 's', 'MarkerEdgeColor', 'red', 'MarkerFaceColor', 'red', 'LineStyle', '--', 'LineWidth', 1, 'Color', 'black');
    axis([0,numQueries,0,0.01]);
    xpos = numQueries./10;
    text(xpos, 0.009, sprintf('Queries: %d/%d', t, numQueries));
    text(xpos, 0.0085, sprintf('Average: %.4f', avg));
    text(xpos, 0.008, sprintf('Last Query: %s', generateQueryString(queryVariables, queryValues)));
    xlabel('Queries');
    ylabel('Error');
    title('Squared Difference Error between Gibbs and Rejection sampling');
    drawnow;
end

