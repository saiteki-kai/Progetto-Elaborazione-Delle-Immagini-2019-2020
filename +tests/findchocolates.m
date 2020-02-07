images = utils.getfiles('Acquisizioni/');
for i = 1:numel(images)
    im = imread(images{i});
    
    resized = imresize(im, 1/5, 'bilinear'); %%% why double doesn't work with bicubic, bilinear....
    resized = im2double(resized);
    
    mask = findbox(resized);
    box = resized .* mask;
    
    shape = classification.shape_classifier(box, mask, 0);
    
    [centers, radius] = findchocolates(box, mask, shape);
    % utils.showcircles(box, centers, radius, i);
    
    if shape{1} == '1'
        utils.generatedata(box, centers, radius, 'training set/rettangoli/', i);
    else
        utils.generatedata(box, centers, radius, 'training set/quadrate/', i);
    end
end
