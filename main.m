function out = main(im)
%MAIN 

% Downscale the image
resized = imresize(im, 1/5);
resized = im2double(resized);

% Find the box
mask = findbox(resized);
box = resized .* mask;

% Check the shape
shape = classification.getshape(box, mask);

% Find the chocolates
[centers, radii] = findchocolates(box, mask, shape);  

% Look for errors
if shape == "rectangle"
    grid = creategrid(centers);
    errors = checkerrors(grid, radii);
else
    errors = checkerrors(centers, radii);
end

% Show results
showresults(im, errors);

out = isempty(errors);

end