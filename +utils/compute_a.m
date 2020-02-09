function out = compute_a(image, k)
    [r,c,ch] = size(image);
    im = im2double(reshape(image,r*c,ch));
    if k == 1
        out = 1-(1/(1-var(im)));
    elseif k == 2
        p = imhist(image);
        res = 0;
        for i = 1:256
            res = res + (i-1)^3 * p(i);
        end
        out = res;
     elseif k == 3
        out = sum(imhist(image) .^ 2);
    elseif k == 4
        out = [1,4,6,4,1];
    elseif k == 5
        out = [-1,-2,0,2,1];
    elseif k == 6
        out = [-1,0,2,0,-1];
    elseif k == 7
        out = [1,-4,6,-4,1];
    elseif k == 8
        out = [-1,2,0,-2,1];
    end
end