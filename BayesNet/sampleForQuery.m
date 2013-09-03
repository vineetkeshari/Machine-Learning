function [rejectionProbability gibbsProbability] = sampleForQuery (numSamples, queryVariables, queryValues, numParents, parents, prob0, prob1, prob2, graph)

% Do rejection sampling
rejectionProbability = rejectionSample (numSamples, queryVariables, queryValues, numParents, parents, prob0, prob1, prob2, graph);

% Do Gibbs sampling
gibbsProbability = gibbsSample (numSamples, queryVariables, queryValues, numParents, parents, prob0, prob1, prob2, graph);
