function grid = creategrid(centers)
%CREATEGRID

% scatter(centers(:,1), centers(:,2));
% hold on;

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

% scatter(externals(:,1), externals(:,2), 'filled', 'm');
% scatter(points(:,1), points(:,2), 'filled', 'y');

% hold on;

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
[~, idx] = sort([pairs.norm]);
minPair = pairs(idx(1));
maxPair = pairs(idx(2));
minAngle = minPair.angle;
maxAngle = maxPair.angle;

% retta passante per i due punti
x = [minPair.points(1,1), minPair.points(2,1)];
y = [minPair.points(1,2), minPair.points(2,2)];
plot(x, y, 'r', 'LineWidth', 2);

% intercept of line from two points
q = minPair.points(1, 2) - minAngle * minPair.points(1, 1);

% distances
X = zeros(length(centers),1);
for k=1:length(centers)
    % calculate point-line distance
    num = abs(centers(k,2) - (minAngle * centers(k,1) + q));
    den = sqrt(1 + minAngle ^ 2);
    X(k) = num / den;
end

% find groups of lines
Y = pdist(X);
Z = linkage(Y);
T = cluster(Z, 'MaxClust', 6);
%figure; gscatter(centers(:, 1), centers(:, 2), T), axis image;

q = maxPair.points(1, 2) - maxAngle * maxPair.points(1, 1);

grid = zeros(6, 4, 2);
for r=1:6
    c = centers(T==r, :);
   % disp(T);
        
    % sort by distance
    dist = zeros(length(c), 1);
    for k=1:length(c)
        num = abs(c(k,2) - (maxAngle * c(k,1) + q));
        den = sqrt(1 + maxAngle ^ 2);
        dist(k) = num / den;
    end
    [~, indexes] = sort(dist);
    sorted = c(indexes, :);
    % problema: se manca un cioccolatino in mezzo la sua posizione verrà
    % occupata dal seguente più vicino
    
%     if (length(sorted) == 4) 
%         grid(r, :, :) = sorted;
%     else
        % regression
        y = sorted(:,2);
        X = [ones(length(c), 1), sorted(:,1)];
        b = regress(y, X);
        yfit = X * b;

        residuals = abs(y - yfit);
        %disp(residuals);

%         scatter(sorted(:,1), y, 'filled', 'y');
%         hold on;
%         plot(sorted(:,1), yfit);
        
        % row length
        len = norm(sorted(end,:) - sorted(1,:)); 

        R = len / 4.5; % similarity radius (rmax sarebbe buono ?)

        final = zeros(4, 2);
        for l=1:4
            k = l + 1;
            choice = l;
            % find similar points
            while k < length(sorted) && ...
                (norm(sorted(choice, :) - sorted(k, :)) < R)
                % choose the closest to the regression line
                xx = sorted(1, 1) + R * l; % distanza dal primo.....
                yy = b(1) + xx * b(2);
                disp("simili");
                %if (residuals(choice) > residuals(k))
                if (sorted(k, 2) - yy >= 0 && sorted(choice, 2) - yy <= 0)
                    choice = k;
                end
                k = k + 1;
            end
            final(l, :) = sorted(choice, :);
        end
        
        grid(r, :, :) = final;
%     end
end

for c=1:4
    % regression
    x = grid(:, c, 1);
    y = grid(:, c, 2);
    X = [ones(length(x), 1), x];
    b = regress(y, X);
    yfit = X * b;
    
%     disp(abs(y - yfit));
%     plot(x, yfit);
end

end