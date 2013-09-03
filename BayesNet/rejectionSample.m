% performs rejection sampling on a given network
function [prob] = rejectionSample (numSamples, queryVariables, queryValues, numParents, parents, prob0, prob1, prob2, graph)
    samples = 0;
    positive = 0;
    probs = zeros(1,numSamples);
    t = 0;
    prob = 0;
    while samples < numSamples && t < 100*numSamples
        t = t + 1;
        values = zeros(10,1);
        reject = 0;
        agree = 1;
        for i = 1:10
            % perform ancestral sampling based on values of parents and the
            % conditional probability given the parents
            p = rand(1);
            if (numParents(i) == 0 && p < prob0(i) || numParents(i) == 1 && p < prob1(i,values(parents(1,i))+1) || numParents(i) == 2 && p < prob2(i,values(parents(1,i))+1,values(parents(2,i))+1))
                values(i) = 1;
            end
            % if this is an evidence variable, reject sample if value
            % doesn't match
            if queryVariables(2,i) == 1 && values(i) ~= queryValues(2,i)
                reject = 1;
                break;
            % if not rejected, check if this is a query variable, and if
            % it agrees with the desired value
            else if agree == 1 && queryVariables(1,i) == 1 && values(i) ~= queryValues(1,i)
                    agree = 0;
                end
            end
        end
        if reject == 0
            samples = samples + 1;
            if agree == 1
                positive = positive + 1;
            end
            prob = positive ./ samples;
        
            % plot realtime data
            if graph == 1
                probs(samples) = prob;
                subplot(2,2,1);
                plot (probs, 'LineWidth', 2, 'Color', 'green');
                axis([0,numSamples,0,1]);
                xpos = numSamples./10;
                text(xpos, 0.9, sprintf('Positive samples: %d/%d', positive, samples));
                text(xpos, 0.85, sprintf('Probability: %.4f', prob));
                text(xpos, 0.8, sprintf('Last Sample: %d %d %d %d %d %d %d %d %d %d', values(1), values(2), values(3), values(4), values(5), values(6), values(7), values(8), values(9), values(10)));
                text(xpos, 0.75, sprintf('Samples accepted: %d/%d', samples, t));
                text(xpos, 0.7, sprintf('Percent rejected: %.2f', 100.*(1-(samples./t))));
                xlabel('Samples');
                ylabel('Probability');
                title(sprintf('Rejection Sampling Probability\nQuery: %s', generateQueryString(queryVariables, queryValues)));
                drawnow;
            end
        end
    end
end

        