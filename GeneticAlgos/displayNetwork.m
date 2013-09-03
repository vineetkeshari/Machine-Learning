function [] = displayNetwork (creature, creatureLength, minCreatureLength, maxCreatureLength, parasiteLength)
    s = 2;
    img = ones(parasiteLength.*s, creatureLength.*s);
    for i = 1:creatureLength
        if creature(1,i) == 0
            break;
        end;
        img(creature(1,i).*s, i.*s) = 0;
        for j = creature(1,i).*s+1:creature(2,i).*s-1
            img(j,i.*s) = 0.5;
        end
        img(creature(2,i).*s, i.*s) = 0;
    end
    imshow(img);
end