function points = exclude_outliers(points, externals)
%EXCLUDE_OUTLIERS exclude the most distant points

N = length(points);

% inner points
in = (1:N)';
in = in(~ismember(in, externals));

% center of inner points
centroid = mean(points(in,:));

figure; plot(centroid(1), centroid(2), 'b*');
hold on;

% calculate distances
norme = zeros(N, 1);
for i=1:N
    norme(i) = norm(points(i,:) - centroid);
    plot([points(i,1) - centroid(1), 0], [points(i,2) - centroid(2), 0]);
    viscircles(centroid, norm(points(i,:) - centroid), 'Color', 'g');
end

scatter(points(:,1), points(:,2), 'b', 'filled'), axis image; % all points
scatter(points(in,1), points(in,2), 'g', 'filled'); % intern points

% exclude the first N - 24 max
[~, l] = mink(norme, 24);
scatter(points(l,1), points(l,2), 'm', 'filled');
%viscircles([center;center;center;center;center],norm(centers(l,1)));

points = points(l,:);
end