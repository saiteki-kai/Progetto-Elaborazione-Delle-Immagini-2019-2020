function out = compute_average_color(image)
    [r,c,ch] = size(image);
    tmp = reshape(image, r*c, ch);
    out = mean(tmp);
end