function [position] = takeAction (position, action)
    if action == 1 && position(1) ~= 1
        position(1) = position(1) - 1;
    end
    if action == 2 && position(1) ~= 3
        position(1) = position(1) + 1;
    end
    if action == 3 && position(2) ~= 1
        position(2) = position(2) - 1;
    end
    if action == 4 && position(2) ~= 25
        position(2) = position(2) + 1;
    end
end