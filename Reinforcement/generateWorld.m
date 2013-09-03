% Generates a new 3x25 world with random obstacles.
% reachable contains information about what cells in the last column could
%   be reached from the starting column. This prevents us from blocking the
%   path to the last column.
% Guarantees a path from start to end column.
function [world] = generateWorld ()
    world = zeros(3,25);
    reachable = ones(3,1);
    for i = 2:24
        % r determines how many obstacles to place in the column
        r = randi(3);
        if r == 2
            s = randi(3);
            world (s,i) = -1;
        end
        if r == 3
            s = randi(3);
            for j = 1:3
                if j == s
                    continue;
                else
                    world (j,i) = -1;
                end
            end
        end
        % Find out if we have blocked the path
        canAccess = 0;
        for j = 1:3
            if world (j,i) == 0 && reachable(j) == 1
                canAccess = 1;
                break;
            end
        end
        
        % Determine what cells can be reached from previous row
        % If we blocked the path earlier, open it at an appropriate place
        for j = 1:3
            if reachable(j) == 1
                if canAccess == 0
                    world (j,i) = 0;
                    canAccess = 1;
                else if world(j,i) == -1
                        reachable (j) = 0;
                    end
                end 
            else
                reachable (j) = 0;
            end
        end
        
        % Determine what cells can be reached from the same column
        if reachable(1) == 1
            if world(2,i) == 0
                reachable(2) = 1;
                if world(3,i) == 0
                    reachable(3) = 1;
                end
            end
        end
    
        if reachable(2) == 1
            if world(1,i) == 0
                reachable(1) = 1;
            end
            if world(3,i) == 0
                reachable(3) = 1;
            end
        end
    
        if reachable(3) == 1
            if world(2,i) == 0
                reachable(2) = 1;
                if world(1,i) == 0
                    reachable(1) = 1;
                end
            end
        end
    end
end
