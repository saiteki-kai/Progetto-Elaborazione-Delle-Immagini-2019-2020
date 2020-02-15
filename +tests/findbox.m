function findbox()
images = utils.getfiles('Acquisizioni');

for i = 1:38%numel(images)
    im2 = im2double(imread(images{i}));
    [r, c, ~] = size(im2);
    im = imresize(im2, 1/5);
    
    gray = rgb2gray(im);
    hsv = rgb2hsv(im);
    ycbcr = rgb2ycbcr(im);
    lab = rgb2lab(im);
    
    HIGH_THRESHOLD = 0.5; % scelta sperimentalmente 0.137
    SIGMA = 0.8; % dato N = 5 sigma ricavata da N = (2.5 * sigma) * 2 - 1
    bw = edge(hsv(:,:,1), 'canny');
    bw = imdilate(bw, strel('disk', 3));
    bw = imfill(bw, 'holes');
    bw = imerode(bw, strel('disk', 5));
    bw = bwareafilt(bw, 1);
    mask = bwconvhull(bw);
    box = imresize(mask, [r c]);
    
    imshow(box .* im2);
    pause(1);
    
%     box = findbox(im);    
%     box = imresize(box, [r c]);

%     imwrite(im2 .* box, ['../Images/' num2str(i) '.jpg']);
%     imwrite(box, ['../Masks/' num2str(i) '.jpg']);
% 
%     shape = shape_classifier((box .* im2), box, 1);
% 
%     if shape{1} == '1'
%         imwrite(box .* im2, ['../MASKS_TESTS/Rettangolari/' num2str(i) '.jpg']);
%     else
%         imwrite(box .* im2, ['../MASKS_TESTS/Quadrate/' num2str(i) '.jpg']);
%     end

end
end