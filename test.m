clear;
close all;

images = get_files("Extra");

%prob = [11, 32, 37, 41, 49];
prob = [10, 9];

for i = 1:numel(images)

if (not(ismember(prob, i))) 
    continue;
end
    
im = imread(images{i});
im = im2double(im);

% Downscale the image
[h, w, ~] = size(im);
resized = imresize(im, 1/5);

% Find the box
mask = find_box(resized);
box = resized .* mask;

% e = regionprops(mask, 'Eccentricity');
% if (e.Eccentricity < 0.53)
%     disp("quadrato");
%     continue;
% else
%     disp("rettangolo");
% end

% Find the chocolates
[centers, radius] = find_cioccalatini(box, mask, i);

continue;
% Square / Non Square
% shape = shape_classifier(box, mask, 1);

% Create the abstract grid of the choco's positions
figure(i);
imshow(box);
hold on;

idx = convhull(centers);
plot(centers(idx,1), centers(idx,2), 'y', 'LineWidth', 4);

scatter(centers(:,1), centers(:,2), 50, 'filled', 'g');
scatter(centers(idx,1), centers(idx,2), 50, 'filled', 'r');
pause(1);
%grid = create_grid(centers);


% Resize measurements
% grid = grid * 5;
% radius = radius * 5;

% Look for errors
%errors = check_errors(grid, radius, shape);

%show_results(im, errors);

% %%% RISCALARE LE MASCHEREEEE E NON LE IMMAGINI e scriverlo nel progetto!!!!!!

% mask = imresize(mask, [h w]); % Deve avere la stessa dimensione
% out = im .* mask;

end


