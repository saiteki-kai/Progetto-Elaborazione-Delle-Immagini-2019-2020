function out = compute_stdev(image)
    [r,c,ch] = size(image);
    tmp = reshape(image, r*c, ch);
    out = std(tmp);
end