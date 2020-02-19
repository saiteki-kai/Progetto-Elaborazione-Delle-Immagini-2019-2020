function showresults(im, errors)
%SHOWRESULTS

[r,~,~] = size(im);
imshow(im);
hold on;
if ~isempty(errors)
    rs = ones(size(errors, 1), 1) * 150; %% fix the radius
    viscircles(errors, rs, 'EdgeColor', 'r', 'LineWidth', 3), axis image;
    text(100, (r - 100), "NON CONFORME",'FontSize',14,'Color','red');
else
    text(100, (r - 100), "CONFORME",'FontSize',14,'Color','green');
end
end