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
[~, indexes] = maxk(distances, 3);
points = externals(indexes, :);
scatter(points(:,1), points(:,2), 'filled', 'y');

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
[~, idx] = sort([pairs.norm]);
pairs = pairs(idx);
%median = pairs(2);  % median value (no min, no max) spiegare poi...
minimun = pairs(1); %%%%%%%%%% prendere retta passante per questi punti
angle = minimun.angle;

x = [minimun.points(1,1), minimun.points(2,1)];
y = [minimun.points(1,2), minimun.points(2,2)];
hold on;
plot(x, y, 'r', 'LineWidth', 1);

% retta passante per un estremo e con angolo fissato
q = minimun.points(1, 2) - angle * minimun.points(1, 1); % serve sotto, la calcolo una volta
x = linspace(minimun.points(1, 1) - 10, minimun.points(1, 1) + 10);
y = angle * x + q;
plot(x, y, 'g', 'LineWidth', 2);


%X = zeros(length(centers), length(centers), 2);
X = zeros(length(centers),1);
%for j=1:length(centers)
    for k=1:length(centers)            
%         dy = centers(k,2) - centers(j,2);
%         dx = centers(k,1) - centers(j,1);
% 
%         m = 0;
%         if (dx ~= 0) 
%             m = dy / dx; 
%         end

        dist = abs(centers(k,2) - (angle * centers(k,1) + q)) ...
            / sqrt(1 + angle ^ 2);
        
        %X(j, k, 1) = m - angle;
        %X(j, k, 2) = dist;
        X(k) = dist;
    end
%end

Y = pdist(X);
Z = linkage(Y);
T = cluster(Z, 'MaxClust', 6);
figure; gscatter(centers(:, 1), centers(:, 2), T), axis image;

grid = []; % rows and cols ...
end