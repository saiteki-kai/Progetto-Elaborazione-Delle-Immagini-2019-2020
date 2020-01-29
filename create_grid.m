function grid = create_grid(centers)
%CREATE_GRID 

centers = exclude_outliers(centers);

% Prendere gli esterni ?

% vettore coeff. angolare
X = zeros(length(centers), length(centers), 1);
for j=1:length(centers)
    for k=1:length(centers)            
        m = 0;
        den = (centers(k,1) - centers(j,1));
        if (j ~= k || den ~= 0)
            m = (centers(k,2) - centers(j,2)) / den;
        end
        
        dist = norm(centers(k,:) - centers(j,:)); %%%% togliere se non serve
        X(j, k) = m;
    end
end

K = 3;
Y = pdist(X(:, K));
Z = linkage(Y);
T = cluster(Z, 'MaxClust', 12);   % guardare con 11

hold on;

for k=1:length(centers)
    x = [centers(k,1), centers(K,1)];
    y = [centers(k,2), centers(K,2)];
    plot(x, y, 'r', 'LineWidth', 1);
end

counts = histogram(T).Values;
cline = centers(T == find(counts == 5), :);
scatter(cline(:, 1), cline(:,2), 'filled', 'y');

figure; gscatter(X(:,1), T);

grid = []; % rows and cols ...
end