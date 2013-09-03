function [fitness] = evaluateOnInputs (creature, length, inputs)
    count = 0;
    for i = 1:size(inputs, 1)
        input = inputs(i,:)';
        for k = 1:length
            if input(creature(2,k)) < input(creature(1,k))
                temp = input(creature(1,k));
                input(creature(1,k)) = input(creature(2,k));
                input(creature(2,k)) = temp;
            end
        end
            
        if input == sort(input)
            count = count+1;
        end
    end
    fitness = count./size(inputs,1);
end