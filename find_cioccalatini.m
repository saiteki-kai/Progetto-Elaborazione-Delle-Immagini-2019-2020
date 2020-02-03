function [centers, radius, rmin, rmax] = find_cioccalatini(im, mask, i)
%FIND_CIOCCALATINI
props = regionprops(mask, 'MajorAxisLength', 'MinorAxisLength', 'BoundingBox', 'Orientation', 'MajorAxisLength', ...
 'MinorAxisLength', 'Eccentricity', 'Centroid');

phi = linspace(0,2*pi,50);
cosphi = cos(phi);
sinphi = sin(phi);

xbar = props.Centroid(1);
ybar = props.Centroid(2);

a = props.MajorAxisLength/2;
b = props.MinorAxisLength/2;

theta = pi*props.Orientation/180;
R = [ cos(theta)   sin(theta)
     -sin(theta)   cos(theta)];

xy = [a*cosphi; b*sinphi];
xy = R*xy;

xxx = xy(1,:) + xbar;
yyy = xy(2,:) + ybar;

rmax = 40; %fix(props.MinorAxisLength / 9);
rmin = 15; %fix(rmax / 3);

disp(props.MinorAxisLength);
disp([rmin, rmax]);

% rmin * 3 < rmax
% rmax - rmin < 100

% cambiare un canale e riconvertire in grigio
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% print_color_images(bright);
% figure;

bright = imadjust(im, [], [], 0.5);
dark = imadjust(im, [], [], 1.5);

hsv = rgb2hsv(bright);
ycbcr = rgb2ycbcr(im);

%hsv = imtophat(hsv, strel('disk', rmin));
imDark = hsv(:,:,2);
imBright = im(:,:,3);

%imDark(~mask) = 1;

% imDark = imDark > 0.5;
% imDark = imclose(imDark, strel('disk', rmax));
% imDark = imerode(imDark, strel('disk', fix(rmin/4)));
% 
% imBright = imDark .* adapthisteq(rgb2gray(im));
% imDark = imDark .* hsv(:,:,2);


[centersDark, radiiDark] = imfindcircles(imDark, [rmin rmax], ...
    'Method', 'TwoStage', ...
    'Sensitivity', 0.9, ...
    'EdgeThreshold', 0.1, ...
    'ObjectPolarity', 'dark');

[centersBright, radiiBright] = imfindcircles(imBright, [rmin rmax], ...
    'Method', 'TwoStage', ...
    'Sensitivity', 0.9, ...
    'EdgeThreshold', 0.15, ...
    'ObjectPolarity', 'bright');

% centersDark = centersDark(1:24, :);
% radiiDark = radiiDark(1:24, :);

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

% subplot(1,2,1);
% imshow(imBright);title("Bright");
% hold on;
% viscircles(centersBright, m * ones(length(radiiBright), 1) - d, 'EdgeColor', 'r', 'LineWidth', 3); axis image;
% 
% subplot(1,2,2);
imshow(imDark);title("Dark");
hold on;
    plot(xxx,yyy,'r','LineWidth',2);
viscircles(centersDark, radiiDark, 'EdgeColor', 'b', 'LineWidth', 3); axis image;
rectangle('Position', props.BoundingBox, 'EdgeColor', 'r');

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