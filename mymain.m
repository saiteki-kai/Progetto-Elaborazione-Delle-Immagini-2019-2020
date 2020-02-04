function mymain(im)
% .....

% Downscale the image
resized = imresize(im, 1/5);
resized = im2double(resized);

% Find the box
mask = findbox(resized);
box = resized .* mask;

% Check the shape
shape = classification.shape_classifier(box, mask, 0);

% Find the chocolates
[centers, radius] = findchocolates(box, mask, shape); 

utils.showcircles(box, centers, radius, 0);

% % Look for errors
% if shape == "1"
%     grid = creategrid(centers);
%     errors = checkerrors(grid, radii);
% else
%     errors = checkerrors(centers, radii);
% end
% 
% % Show results
% showresults(im, errors);

end