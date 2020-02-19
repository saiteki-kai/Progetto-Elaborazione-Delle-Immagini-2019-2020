function grid = creategrid(centers)
%CREATEGRID genera la matrice della disposizione dei centri

% assuming there must be 24 points
if length(centers) > 24
    error("there must be 24 points");
end

centroid = mean(centers);

% choose the first three furthest points
distances = vecnorm((centers - centroid)');
[~, indexes] = maxk(distances, 3);
points = centers(indexes, :);

% look for the pair with the segment of minimum length
ab.norm = norm(points(1,:) - points(2,:));
bc.norm = norm(points(2,:) - points(3,:));
ca.norm = norm(points(3,:) - points(1,:));

ab.points = [points(1,:); points(2,:)];
bc.points = [points(2,:); points(3,:)];
ca.points = [points(3,:); points(1,:)];

ab.slope = (ab.points(1,2) - ab.points(2,2)) / (ab.points(1,1) - ab.points(2,1));
bc.slope = (bc.points(1,2) - bc.points(2,2)) / (bc.points(1,1) - bc.points(2,1));
ca.slope = (ca.points(1,2) - ca.points(2,2)) / (ca.points(1,1) - ca.points(2,1));

pairs = [ab, bc, ca];
[~, idx] = sort([pairs.norm]);

minPair = pairs(idx(1));
maxPair = pairs(idx(2));

minSlope = minPair.slope;
maxSlope = maxPair.slope;

% intercept of line from two points
q = minPair.points(1, 2) - minSlope * minPair.points(1, 1);

% distances
X = zeros(length(centers),1);
for k=1:length(centers)
    % calculate point-line distance
    num = abs(centers(k,2) - (minSlope * centers(k,1) + q));
    den = sqrt(1 + minSlope ^ 2);
    X(k) = num / den;
end

% find groups of lines
Y = pdist(X);
Z = linkage(Y);
T = cluster(Z, 'MaxClust', 6);

q = maxPair.points(1, 2) - maxSlope * maxPair.points(1, 1);

grid = zeros(6, 4, 2);
for r = 1 : 6
    c = centers(T == r, :);
    
    % calculate distances 
    dist = zeros(length(c), 1);
    for k=1:length(c)
        num = abs(c(k,2) - (maxSlope * c(k,1) + q));
        den = sqrt(1 + maxSlope ^ 2);
        dist(k) = num / den;
    end
    
    % sort by distance
    [~, indexes] = sort(dist);
    sorted = c(indexes, :);

    grid(r, :, :) = sorted;
end
end