function iscompliant = main(im)

% Downscale the image
resized = imresize(im, 1/5);

% Find the box
mask = findbox(resized);
box = im2double(resized) .* mask;

% Check the shape
shape = classification.getshape(mask);

% Find the chocolates
[centers, radii] = findchocolates(box, mask, shape); 

% Look for errors
if shape == "rettangolare"  
    grid = creategrid(centers);
    errors = checkerrors(im, grid, radii);
else
    errors = checkerrors(im, centers, radii);
end

iscompliant = isempty(errors);

% Show results
showresults(im, errors);
end
