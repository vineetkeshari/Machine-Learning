% Randomly generate a query.
% Must have at least one query node.
% Can have no evidence node.
function [queryVariables, queryValues] = generateQuery ()
    queryVariables = int32(zeros(2,10));
    queryValues = int32(zeros(2,10));
    for i = 1:10
        p = rand(1);
        % Variable is either query or evidence node
        if p < 0.5
            q = rand(1);
            queryOrEvidence = 1;
            % Node is evidence. Otherwise it is query.
            if q > 0.5
                queryOrEvidence = 2;
            end
            queryVariables (queryOrEvidence, i) = 1;
            r = rand(1);
            % Query or evidence value is 1
            if r > 0.5
                queryValues (queryOrEvidence, i) = 1;
            end
        end
    end
    % No query node? Find first query and first "neither" node.
    % A "neither" node is a non-query non-evidence (unassigned) node
    firstQuery = 0;
    firstNeither = 0;
    for i = 1:10
        if queryVariables(1,i) == 1
            firstQuery = i;
            break;
        else if queryVariables(2,i) == 0 && firstNeither == 0
                firstNeither = i;
            end
        end
    end
    % If we didn't find a first query node we need to manually set one
    if firstQuery == 0
        % If there is no "neither" node, just flip the first one to query
        if firstNeither == 0
            queryVariables(:,1) = [1 0]';
            queryValues(1,1) = queryValues(2,1);
            queryValues(2,1) = 0;
        % Otherwise set the first "neither" node to query node
        else
            queryVariables(1,firstNeither) = 1;
            r = rand(1);
            if r > 0.5
                queryValues(1,firstNeither) = 1;
            end
        end
    end
        
end