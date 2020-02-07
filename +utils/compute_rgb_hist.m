function out = compute_rgb_hist(image)
    R = image(:,:,1);
    G = image(:,:,2);
    B = image(:,:,3);
    r = imhist(R)' / sum(R(:));
    g =  imhist(G)' / sum(G(:));
    b = imhist(B)' / sum(B(:));
    out = ...
        mean(r(:)) + ...
        mean(g(:)) + ...
        mean(b(:));
end