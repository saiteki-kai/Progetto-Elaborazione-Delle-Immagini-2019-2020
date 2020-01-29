function grid = create_grid(centers)
%CREATE_GRID

scatter(centers(:,1), centers(:,2));
hold on;

% assuming there must be 24 points
if (length(centers) > 24)
    % potrebbe sbagliare se gli outliers stanno sul lato corto !!!!!!!
    centers = exclude_outliers(centers);
end

scatter(centers(:,1), centers(:,2), 'filled');

centroid = mean(centers);
ch = convhull(centers);
externals = centers(ch, :);
distances = vecnorm((externals - centroid)');
[~, index] = max(distances);
farthest = externals(index, :);
scatter(farthest(1), farthest(2), 'filled', 'y');

% vettore coeff. angolare
X = zeros(length(centers), 1);
for k=1:length(centers)            
    dy = centers(k,2) - externals(index,2);
    dx = centers(k,1) - externals(index,1);

    m = 0;
    if (dx ~= 0) 
        m = dy / dx; 
    end

    % dist = norm(centers(k,:) - centers(index,:)); %%%% togliere se non serve
    X(k) = m;
end

%Y = pdist(X);
%Z = linkage(Y);
T= kmeans(X, 2);
%T = cluster(Z, 'MaxClust', 8);   % guardare con 11

hold on;

for k=1:length(centers)
    x = [centers(k,1), farthest(1)];
    y = [centers(k,2), farthest(2)];
    plot(x, y, 'r', 'LineWidth', 1);
end

counts = histogram(T).Values;
cline = centers(T == find(counts == 5), :);
scatter(cline(:, 1), cline(:,2), 'filled', 'y');

figure; gscatter(centers(:, 1), centers(:, 2), T);

grid = []; % rows and cols ...
end