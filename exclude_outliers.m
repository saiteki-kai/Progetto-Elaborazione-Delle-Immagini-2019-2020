function centers = exclude_outliers(centers)
%EXCLUDE_OUTLIERS

% outer points
k = boundary(centers, 1);

% inner points
in = (1:length(centers))';
in = in(~ismember(in, k));

% center of intern points
m1 = mean(centers(in,1));
m2 = mean(centers(in,2));
center = [m1, m2];

figure; plot(m1, m2, 'b*');
hold on;

% calculate distances
norme = zeros(length(centers), 1);
for i=1:length(norme)
    norme(i) = norm(centers(i,:) - center);
    plot([centers(i,1) - center(1), 0], [centers(i,2) - center(2), 0]);
    viscircles(center, norm(centers(i,:) - center), 'Color', 'g');
end

scatter(centers(:,1), centers(:,2), 'b', 'filled'), axis image; % all points
scatter(centers(in,1), centers(in,2), 'g', 'filled'); % intern points

% exclude the first two max
[~, l] = mink(norme, 24);
scatter(centers(l,1), centers(l,2), 'm', 'filled');
%viscircles([center;center;center;center;center],norm(centers(l,1)));

centers = centers(l,:);
end