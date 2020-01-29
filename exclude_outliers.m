function points = exclude_outliers(points)
%EXCLUDE_OUTLIERS exclude the most distant points

N = length(points);

% inner points indexes
out = boundary(points, 1);
in = (1:N)';
in = in(~ismember(in, out));

% center of inner points
centroid = mean(points(in,:));

% figure; plot(centroid(1), centroid(2), 'b*');
% hold on;

% calculate distances
distances = zeros(N, 1);
for i=1:N
    distances(i) = norm(points(i,:) - centroid);
    %plot([points(i,1) - centroid(1), 0], [points(i,2) - centroid(2), 0]);
    %viscircles(centroid, norm(points(i,:) - centroid), 'Color', 'g');
end

% scatter(points(:,1), points(:,2), 'b', 'filled'), axis image; % all points
% scatter(points(in,1), points(in,2), 'g', 'filled'); % intern points

% exclude the first N - 24 max
[~, l] = mink(distances, 24);
points = points(l,:);

%scatter(points(l,1), points(l,2), 'm', 'filled');
end