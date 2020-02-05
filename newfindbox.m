function out = newfindbox(image)
    image = imresize(image, 1/5);
    image = im2double(image);
    %hsv = rgb2hsv(image);
    [r, c, ch] = size(image);
    triples = reshape(image, r * c, ch);
    T = kmeans(triples, 7);
    T1 = reshape(T, r, c);
    out = T1;
end