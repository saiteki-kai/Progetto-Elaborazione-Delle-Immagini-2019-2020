clear;
close all;

images = get_files("Acquisizioni");

for i = 1:1 %numel(images)
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

% centers = centers * 5;
% radii = radii * 5;
% 
% %%% RISCALARE LE MASCHEREEEE E NON LE IMMAGINI e scriverlo nel progetto!!!!!!
% 
% mask = imresize(mask, [h w]); % Deve avere la stessa dimensione
% out = im .* mask;
% 
% imshow(out);
% hold on;
% rs = ones(length(centers), 1) * 150;
% viscircles(centers, rs, 'EdgeColor', 'r', 'LineWidth', 3), axis image;



% props = regionprops(mask, 'BoundingBox', 'Orientation', 'Extrema');
% 
% bbox = props.BoundingBox;
% ex = props.Extrema;

% figure, imshow(box);
% hold on;
% rectangle('Position', bbox, 'EdgeColor', 'r');
% scatter(ex(2:3,1), ex(2:3,2));
% scatter(ex(4:5,1), ex(4:5,2));
% 
% line1 = abs(ex(2,:) - ex(3,:));
% line2 = abs(ex(4,:) - ex(5,:));
% 
% ll = line1;
% if (norm(line2) > norm(line1))
%     ll = line2;
% end


end


