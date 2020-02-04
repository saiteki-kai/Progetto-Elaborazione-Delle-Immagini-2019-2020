function showresults(im, errors)
%SHOWRESULTS

imshow(im);
hold on;
rs = ones(length(errors), 1) * 150; %% fix the radius
viscircles(errors, rs, 'EdgeColor', 'r', 'LineWidth', 3), axis image;
end