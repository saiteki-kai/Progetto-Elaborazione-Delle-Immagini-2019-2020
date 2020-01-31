function iscomplaiant = main(path)
    
    image = im2double(imread(path));
    
    [r, c, ~] = size(image);
    resized = imresize(image, 1/5);
    
    mask = findbox(resized);
    mask = imresize(mask, [r c]);
    
    box = mask .* image;
    
    iscomplaiant = false;

end
