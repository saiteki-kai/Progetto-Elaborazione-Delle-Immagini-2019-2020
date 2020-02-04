clear;
close all;

images = getfiles("Extra");

%prob = [4, 11, 32, 37, 41, 49];
prob = [10, 9];

rr = zeros(numel(images), 2);
for i = 1:numel(images)

if (not(ismember(prob, i))) 
    continue;
end

im = imread(images{i});

% Downscale the image
[h, w, ~] = size(im);
resized = imresize(im, 1/5);

% If the size of the output image is not an integer, 
% then imresize does not use the scale specified.
% imresize uses ceil when calculating the output image size.
im = im2double(im);

% Find the box
mask = findbox(resized);
box = resized .* mask;

% Find the chocolates
[centers, radius, rmin, rmax] = findcioccalatini(box, mask, i);                
%rr(i, :) = [rmin, rmax];

% Square / Non Square
% shape = shape_classifier(box, mask, 1);
% 
% Create the abstract grid of the choco's positions
% pezzo per cercare di risolvere gli outliers
figure(i);
imshow(box);
hold on;

idx = convhull(centers);
plot(centers(idx,1), centers(idx,2), 'y', 'LineWidth', 4);

scatter(centers(:,1), centers(:,2), 50, 'filled', 'g');
scatter(centers(idx,1), centers(idx,2), 50, 'filled', 'r');



folder = "";
e = regionprops(mask, 'Eccentricity');
if (e.Eccentricity < 0.53)
    disp("quadrato");
    folder = "TrainingSet/Quadrate";
    % continue;
else
    folder = "TrainingSet/Rettangolari";
    disp("rettangolo");
    % grid = create_grid(centers);
end

% Resize measurements
%grid = grid * 5;
centers = centers * 5;
radius = fix(radius * 10);

%generate_data(im, centers, radius, folder, i);

% figure;
% imshow(im);
% hold on;
% 
% g1 = grid(:,:,1);
% g2 = grid(:,:,2);
% scatter(g1(:), g2(:), 'filled', 'g');

% Look for errors
%errors = check_errors(grid, radius, shape);

% RISCALARE LE MASCHEREEEE E NON LE IMMAGINI e scriverlo nel progetto!!!!!!

% mask = imresize(mask, [h w]); % Deve avere la stessa dimensione
% out = im .* mask;

%show_results(im, errors);
end


