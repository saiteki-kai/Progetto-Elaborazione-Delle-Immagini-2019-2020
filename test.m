clear;
close all;

images = get_files("Extra");

for i = 9:9%numel(images)
im = imread(images{i});
im = im2double(im);

% Downscale the image
[h, w, ~] = size(im);
resized = imresize(im, 1/5);

% Find the box
mask = find_box(resized);
box = resized .* mask;

% Find the chocolates
[centers, radii] = find_cioccalatini(box, mask, i);

% Square/ Non Square

% Create the abstract grid of the choco's positions
grid = create_grid2(centers);

continue;

% Resize measurements
centers = centers * 5; %%% magari devi prenderli da grid EH...
radii = radii * 5;

% Look for errors
errors = check_errors(grid);

show_results(im, errors);

% %%% RISCALARE LE MASCHEREEEE E NON LE IMMAGINI e scriverlo nel progetto!!!!!!

% mask = imresize(mask, [h w]); % Deve avere la stessa dimensione
% out = im .* mask;

end


