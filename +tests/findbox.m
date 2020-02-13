function findbox()
images = utils.getfiles('Acquisizioni');

for i = 1:numel(images)
    im2 = im2double(imread(images{i}));
    [r, c, ~] = size(im2);
    im = imresize(rgb2gray(im2), 1/5);
 
%     HIGH_THRESHOLD = 0.1; % scelta sperimentalmente 0.137
%     SIGMA = 0.8; % dato N = 5 sigma ricavata da N = (2.5 * sigma) * 2 - 1
%     bw = edge(im, 'canny', HIGH_THRESHOLD, SIGMA);
%     bw = imdilate(bw, strel('disk', 3));
%     bw = imfill(bw, 'holes');
%     bw = imopen(bw, strel('disk', 9));
%     bw = bwareafilt(bw, 1);
%     mask = bwconvhull(bw);
%     box = imresize(mask, [r c]);
%     
%     imwrite(im2 .* box, ['Presentazione/findbox/soglia troppo bassa/' num2str(i) '.jpg']);
%     
% 
%     HIGH_THRESHOLD = 0.137; % scelta sperimentalmente 0.137
%     SIGMA = 0.8; % dato N = 5 sigma ricavata da N = (2.5 * sigma) * 2 - 1
%     bw = edge(im, 'canny', HIGH_THRESHOLD, SIGMA);
%     bw = imdilate(bw, strel('disk', 3));
%     bw = imfill(bw, 'holes');
%     bw = imopen(bw, strel('disk', 9));
%     bw = bwareafilt(bw, 1);
%     mask = bwconvhull(bw);
%     box = imresize(mask, [r c]);
%     
%     imwrite(im2 .* box, ['Presentazione/findbox/soglia scelta/' num2str(i) '.jpg']);
    

%     HIGH_THRESHOLD = 0.16; % scelta sperimentalmente 0.137
%     SIGMA = 0.8; % dato N = 5 sigma ricavata da N = (2.5 * sigma) * 2 - 1
%     bw = edge(im, 'canny', HIGH_THRESHOLD, SIGMA);
%     bw = imdilate(bw, strel('disk', 3));
%     bw = imfill(bw, 'holes');
%     bw = imopen(bw, strel('disk', 9));
%     bw = bwareafilt(bw, 1);
%     mask = bwconvhull(bw);
%     box = imresize(mask, [r c]);
%     
%     imwrite(im2 .* box, ['Presentazione/findbox/soglia troppo alta/' num2str(i) '.jpg']);
    

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