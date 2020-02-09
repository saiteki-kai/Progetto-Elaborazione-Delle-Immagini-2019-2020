function iscompliant = main(im)
%MAIN 

% Downscale the image
resized = imresize(im, 1/5);
%resized = im2double(resized);

% Find the box
mask = findbox(resized);
box = im2double(resized) .* mask;

% Check the shape
shape = classification.shape_classifier(box, mask, 0);

% Find the chocolates
[centers, radii] = findchocolates(box, mask, shape);  

% Look for errors
if shape{1} == '1'
    grid = creategrid(centers);
    errors = checkerrors(im, grid, radii);
else
    errors = checkerrors(im, centers, radii);
end

iscompliant = isempty(errors);

% Show results
showresults(im, errors);
end
