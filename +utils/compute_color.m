function out = compute_color(image)
    [r,c,ch] = size(image);
    im = reshape(image, r*c, ch);
    out = mean(im);
end