% performs gibbs sampling on a network
function [prob] = gibbsSample (numSamples, queryVariables, queryValues, numParents, parents, prob0, prob1, prob2, graph)
    values = zeros(10,1);
    positive = 0;
    samples = 0;
    burnin = int32(numSamples./10);
    probs = zeros(1,numSamples);
    burninCounter = 0;
    for i = 1:10
        % if evidence, do not sample, value is same as in query.
        if queryVariables(2,i) == 1
            values(i) = queryValues(2,i);
        end
    end
    for t = 1:(numSamples + burnin)
        accept = 1;
        for i = 1:10
            % sample if not evidence
            if queryVariables(2,i) == 0
                % calculate condition probability for this node conditioned
                % on all other nodes
                values(i) = 0;
                probVal0 = getJointProb (values, numParents, parents, prob0, prob1, prob2);
                values(i) = 1;
                probVal1 = getJointProb (values, numParents, parents, prob0, prob1, prob2);
                conditional = probVal1 ./ (probVal0 + probVal1);

                % assign value based on conditional probability
                p = rand(1);
                if p < conditional
                    values(i) = 1;
                else
                    values(i) = 0;
                end
            end
            % if a query variable does not have the desired value, we don't
            % accept the entire sample.
            if accept == 1 && queryVariables(1,i) == 1 && values(i) ~= queryValues(1,i)
                accept = 0;
            end
        end
        if t > burnin
            samples = samples + 1;
            if accept == 1
                positive = positive + 1;
            end
            prob = positive ./ samples;
            probs(samples) = prob;
        else
            prob = 0;
            burninCounter = burninCounter + 1;
        end
        
        % plot realtime data
        if graph == 1
            subplot(2,2,2);
            plot (probs, 'LineWidth', 2, 'Color', 'blue');
            axis([0,numSamples,0,1]);
            xpos = numSamples./11;
            text(xpos, 0.9, sprintf('Positive samples: %d/%d', positive, samples));
            text(xpos, 0.85, sprintf('Probability: %.4f', prob));
            text(xpos, 0.8, sprintf('Last Sample: %d %d %d %d %d %d %d %d %d %d', values(1), values(2), values(3), values(4), values(5), values(6), values(7), values(8), values(9), values(10)));
            text(xpos, 0.75, sprintf('Burnin: %d/%d', burninCounter, burnin));
            xlabel('Samples');
            ylabel('Probability');
            title(sprintf('Gibbs Sampling Probability\nQuery: %s', generateQueryString(queryVariables, queryValues)));
            drawnow;
        end
    end
end