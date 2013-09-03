% generates a string for the query
function [query] = generateQueryString (queryVariables, queryValues)
    queries = '';
    evidences = '';
    for i = 1:10
        if queryVariables(1,i) == 1
            queries = sprintf('%s X%d=%d', queries, i, queryValues(1,i));
        end
        if queryVariables(2,i) == 1
            evidences = sprintf('%s X%d=%d', evidences, i, queryValues(2,i));
        end
    end
    query = sprintf('P(%s | %s )', queries, evidences);
end