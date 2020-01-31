function [centers, radius] = find_cioccalatini(im, mask, i)
%FIND_CIOCCALATINI
props = regionprops(mask, 'MajorAxisLength', 'MinorAxisLength');

rmax = fix(props.MinorAxisLength / (7.5));
rmin = fix(rmax / 3);

bright = imadjust(im, [], [], 0.5);

% cambiare un canale e riconvertire in grigio
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% print_color_images(bright);
% figure;

dark = imadjust(im, [], [], 1.5);

hsv = rgb2hsv(bright);
ycbcr = rgb2ycbcr(im);

imDark = hsv(:,:,2);
imBright = im(:,:,3);

% imDark = imDark > 0.5;
% imDark = imclose(imDark, strel('disk', rmax));
% imDark = imerode(imDark, strel('disk', fix(rmin/4)));
% 
% imBright = imDark .* adapthisteq(rgb2gray(im));
% imDark = imDark .* hsv(:,:,2);


[centersDark, radiiDark] = imfindcircles(imDark, [rmin rmax], ...
    'Method', 'TwoStage', ...
    'Sensitivity', 0.9, ...
    'EdgeThreshold', 0.15, ...
    'ObjectPolarity', 'dark');

[centersBright, radiiBright] = imfindcircles(imBright, [rmin rmax], ...
    'Method', 'TwoStage', ...
    'Sensitivity', 0.85, ...
    'EdgeThreshold', 0.1, ...
    'ObjectPolarity', 'bright');

centers = centersDark;%[centersBright; centersDark];
radii = radiiDark;%[radiiBright; radiiDark];
% saveas(h, "./Tests/circles" + i + ".jpg");
% close(h);

% Set all radius to the mean
m = mean(radii);
d = std(radii);
radii = m * ones(length(radii), 1) - 2 * d;
radius = m - 2 * d;

% Verificare se abbondare o meno col raggio

% h = figure;

subplot(1,2,1);
imshow(imBright);title("Bright");
hold on;
viscircles(centersBright, m * ones(length(radiiBright), 1) -     d, 'EdgeColor', 'r', 'LineWidth', 1); axis image;

subplot(1,2,2);
imshow(imDark);title("Dark");
hold on;
viscircles(centersDark, m * ones(length(radiiDark), 1) - d, 'EdgeColor', 'b', 'LineWidth', 1); axis image;

% saveas(h, "./Tests/circles" + i + ".jpg");
% close(h);


%BOH

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