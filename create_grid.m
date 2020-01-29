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

ab.angle = atan2(ab.points(2,1)-ab.points(2,2), ab.points(1,1)-ab.points(1,2));
bc.angle = atan2(bc.points(2,1)-bc.points(2,2), bc.points(1,1)-bc.points(1,2));
ca.angle = atan2(ca.points(2,1)-ca.points(2,2), ca.points(1,1)-ca.points(1,2));

pp = [ab, bc, ca];
[angles, a] = mink([pp.angle], 2);
pairs = pp(a);

[~, b] = max([pairs.norm]);
pair = pp(b);
angle = -1/angles(b);

x = [pair.points(1,1), pair.points(2,1)];
y = [pair.points(1,2), pair.points(2,2)];
plot(x, y, 'r', 'LineWidth', 1);

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

        q = pair.points(1, 2) - angle * pair.points(1, 1);
        dist = abs(centers(k,2) - (angle * centers(k,1) + q)) ...
            / sqrt(1 + angle ^ 2);
        
        %X(j, k, 1) = m - angle;
        %X(j, k, 2) = dist;
        X(k) = dist;
    end
%end

Y = pdist(X);
Z = linkage(Y);
T = cluster(Z, 'MaxClust', 4);
figure; gscatter(centers(:, 1), centers(:, 2), T), axis image;

grid = []; % rows and cols ...
end