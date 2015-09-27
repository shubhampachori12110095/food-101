function prunedLeaves = pruneLeaves(sortedLeaves)
%pruneLeaves Removes the leaves whose samples consist of more than half of
%the same superpixels as any better scoring leaf.
%   Detailed explanation goes here
fprintf('Pruning leaves\n');

numLeaves = length(sortedLeaves);
prunedLeaves = struct('trData', [], 'cvData', []);
toRemove = zeros(numLeaves, 1);

leafSamples = struct('samples', []);
for l = 1:numLeaves
    leafSamples(l).samples = extractfield(sortedLeaves(l).cvData, 'validationIndex');
end

for l = 1:numLeaves
%     score = scores(l);
    current = sortedLeaves(l);
%     bestOfTheRest = sortedLeaves(1:l-1);
    % Compare current sample with every sample in the bestOfTheRest list
    % If it consists of more than half of the sample spixels as any leaf in
    % that list, mark it for removal.
    for r = 1:l-1
        if toRemove(r) == 1
            continue;
        end
        if similarity(leafSamples(l).samples, leafSamples(r).samples ) > 0.5
            fprintf('Similar leaves found\n');
            toRemove(l) = 1;
            break;
        end
    end
    
    if toRemove(l) == 0
        prunedLeaves(l) = current;
    end
    
end

end

function  s = similarity( a, b )
%similarity Returns the similarity s, of a vector a in regards to a vector
%b
% Similarity of a to b is defined as how many elements of a also appear in
% b, divided by the number of elemnents in a.
lenA = length(a);
s = 0;

for i = 1:lenA
    if sum(b == a(i)) == 1
        s = s + 1;
    end 
end

s = s / lenA;

end
