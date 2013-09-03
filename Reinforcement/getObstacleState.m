function [state] = getObstacleState (position, world)

% State for 4 directions
%{
    state = ones(4,1);
    
    if position(1) ~= 1
        state(1) = world(position(1)-1,position(2))+2;
    end
    if position(1) ~= 3
        state(2) = world(position(1)+1,position(2))+2;
    end
    if position(2) ~= 1
        state(3) = world(position(1),position(2)-1)+2;
    end
    if position(2) ~= 25
        state(4) = world(position(1),position(2)+1)+2;
    end
    for i = 1:4
        if state(i) == 1.5
            state(i) = 1;
        end
    end
%}

% State for 8 directions
%{
    state = ones(8,1);
    
    if position(1) ~= 1
        state(1) = world(position(1)-1,position(2))+2;
    end
    if position(1) ~= 3
        state(2) = world(position(1)+1,position(2))+2;
    end
    if position(2) ~= 1
        state(3) = world(position(1),position(2)-1)+2;
    end
    if position(2) ~= 25
        state(4) = world(position(1),position(2)+1)+2;
    end
    if position(1) > 1 && position(2) > 1
        state(5) = world(position(1)-1, position(2)-1)+2;
    end
    if position(1) < 3 && position(2) > 1
        state(6) = world(position(1)+1, position(2)-1)+2;
    end
    if position(1) > 1 && position(2) < 25
        state(7) = world(position(1)-1, position(2)+1)+2;
    end
    if position(1) < 3 && position(2) < 25
        state(8) = world(position(1)+1, position(2)+1)+2;
    end
    for i = 1:8
        if state(i) == 1.5
            state(i) = 1;
        end
    end
%}

% State for 4 directions
%{
    state = zeros(4,1);
    
    state(1) = 3;
    for i = position(1)-1:-1:max(0,position(1)-3)
        if i == 0 || world(i,position(2)) == -1 || world(i,position(2)) == -0.5
            state(1) = position(1) - i;
            break;
        end
    end
    
    state(2) = 3;
    for i = position(1)+1:1:min(4,position(1)+3)
        if i == 4 || world(i,position(2)) == -1 || world(i,position(2)) == -0.5
            state(2) = i - position(1);
            break;
        end
    end
    
    state(3) = 5;
    for i = position(2)-1:-1:max(0,position(2)-5)
        if i == 0 || world(position(1),i) == -1 || world(position(1),i) == -0.5
            state(3) = position(2) - i;
            break;
        end
    end
    
    state(4) = 5;
    for i = position(2)+1:1:min(26,position(2)+5)
        if i == 26 || world(position(1),i) == -1 || world(position(1),i) == -0.5
            state(4) = i - position(2);
            break;
        end
    end
%}
        
% State for 6 arrows

    state = zeros(6,1);
    
    if position(1) == 1
        state(1) = 1;
    else
        for i = position(2):1:position(2)+3
            if i > 25 || world(position(1)-1,i) == -1 || world(position(1)-1,i) == -0.5
                state(1) = i-position(2)+1;
                break;
            end
        end
        if state(1) == 0
            state(1) = 4;
        end
    end
    
    for i = position(2)+1:1:position(2)+3
        if i > 25 || world(position(1),i) == -1 || world(position(1),i) == -0.5
            state(2) = i-position(2);
            break;
        end
    end
    if state(2) == 0
        state(2) = 3;
    end
    
    if position(1) == 3
        state(3) = 1;
    else
        for i = position(2):1:position(2)+3
            if i > 25 || world(position(1)+1,i) == -1 || world(position(1)+1,i) == -0.5
                state(3) = i-position(2)+1;
                break;
            end
        end
        if state(3) == 0
            state(3) = 4;
        end
    end
    
    if position(1) == 1
        state(4) = 1;
    else
        for i = position(2)-1:-1:position(2)-2
            if i < 1 || world(position(1)-1,i) == -1 || world(position(1)-1,i) == -0.5
                state(4) = position(2)-i;
                break;
            end
        end
        if state(4) == 0
            state(4) = 2;
        end
    end
    
    for i = position(2)-1:-1:position(2)-2
        if i < 1 || world(position(1),i) == -1 || world(position(1),i) == -0.5
            state(5) = position(2)-i;
            break;
        end
    end
    if state(5) == 0
        state(5) = 2;
    end
    
    if position(1) == 3
        state(6) = 1;
    else
        for i = position(2)-1:-1:position(2)-2
            if i < 1 || world(position(1)+1,i) == -1 || world(position(1)+1,i) == -0.5
                state(6) = position(2)-i;
                break;
            end
        end
        if state(6) == 0
            state(6) = 2;
        end
    end

end

