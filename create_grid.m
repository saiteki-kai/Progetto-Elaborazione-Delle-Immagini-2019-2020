function matrix = create_grid(centers)
%CREATE_GRID

scatter(centers(:,1), centers(:,2));
hold on;

% assuming there must be 24 points
if (length(centers) > 24)
    % potrebbe sbagliare se gli outliers stanno sul lato corto !!!!!!!
   % centers = exclude_outliers(centers);
end

centroid = mean(centers);

% find the external points
ch = convhull(centers);
ch = ch(2:end); % remove the last element (because it is duplicate)
externals = centers(ch, :);

% choose the first three furthest points
distances = vecnorm((externals - centroid)');
[~, indexes] = maxk(distances, 3);
points = externals(indexes, :);

scatter(externals(:,1), externals(:,2), 'filled', 'm');
scatter(points(:,1), points(:,2), 'filled', 'y');

hold on;

% look for the pair with the segment of minimum length
ab.norm = norm(points(1,:) - points(2,:));
bc.norm = norm(points(2,:) - points(3,:));
ca.norm = norm(points(3,:) - points(1,:));

ab.points = [points(1,:); points(2,:)];
bc.points = [points(2,:); points(3,:)];
ca.points = [points(3,:); points(1,:)];

ab.angle = (ab.points(1,2) - ab.points(2,2)) / (ab.points(1,1) - ab.points(2,1));
bc.angle = (bc.points(1,2) - bc.points(2,2)) / (bc.points(1,1) - bc.points(2,1));
ca.angle = (ca.points(1,2) - ca.points(2,2)) / (ca.points(1,1) - ca.points(2,1));

pairs = [ab, bc, ca];
[~, idx] = min([pairs.norm]);
min_pair = pairs(idx);
angle = min_pair.angle;

% retta passante per i due punti
% x = [min_pair.points(1,1), min_pair.points(2,1)];
% y = [min_pair.points(1,2), min_pair.points(2,2)];
% plot(x, y, 'r', 'LineWidth', 2);

% intercept of line from two points
q = min_pair.points(1, 2) - angle * min_pair.points(1, 1);

X = zeros(length(centers),1);
for k=1:length(centers)
    % calculate point-line distance
    num = abs(centers(k,2) - (angle * centers(k,1) + q));
    den = sqrt(1 + angle ^ 2);
    X(k) = num / den;
end

% find groups of lines
Y = pdist(X);
Z = linkage(Y);
T = cluster(Z, 'MaxClust', 6);
figure; gscatter(centers(:, 1), centers(:, 2), T), axis image;

% fase di rimozione duplicati se serve %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

matrix = zeros(6, 4, 2);
for r=1:6
    c = centers(T==r, :);
    p = [c; zeros(4 - length(c), 2)];
    matrix(r, :, :) = p;
end

disp(matrix);


end