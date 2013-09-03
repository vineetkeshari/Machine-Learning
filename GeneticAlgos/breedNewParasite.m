function [newParasite] = breedNewParasite (parasite1, parasite2, parasiteLength, range, mutateProb)
    l1 = randi(parasiteLength);
            
    newParasite = zeros(parasiteLength,1);
    newParasite(1:l1) = parasite1(1:l1);
    newParasite(l1+1:parasiteLength) = parasite2(l1+1:parasiteLength);
            
    t = rand();
    if t < mutateProb
        z = randi(parasiteLength);
        newParasite(z) = randi(range);
    end
    
end