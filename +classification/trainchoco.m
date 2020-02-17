[images, labels] = utils.readlabels("Data/TrainingSet.csv", "Data/Cropped/");

nImages = numel(images);

% cedd = zeros(nImages, 144);
% for i = 1 : nImages
%     im = imread(images{i});
%     cedd(i,:) = utils.compute_CEDD(im);
% end

% lbp = zeros(nImages, 30);
% for i = 1 : nImages
%     im = imread(images{i});
%     R = utils.compute_lbp(im(:,:,1));
%     G = utils.compute_lbp(im(:,:,2));
%     B = utils.compute_lbp(im(:,:,3));
%     lbp(i,:) = [R G B];
% end

% lbp = zeros(nImages, 30);
% for i = 1 : nImages
%     im = imread(images{i});
%     im = rgb2hsv(im);
%     H = utils.compute_lbp(im(:,:,1));
%     S = utils.compute_lbp(im(:,:,2));
%     V = utils.compute_lbp(im(:,:,3));
%     lbp(i,:) = [H S V];
% end

% p = zeros(nImages, 10 + 256 + 256);
% for i = 1 : nImages
%     im = imread(images{i});
%     hsv = rgb2hsv(im);
%     lbp = utils.compute_lbp(rgb2gray(im));
%     h = utils.compute_ghist(hsv(:,:,1));
%     v = utils.compute_ghist(hsv(:,:,2));
%     p(i,:) = [lbp];
% end

% qhist = zeros(nImages, 4096);
% for i = 1 : nImages
%     im = imread(images{i});
%     qhist(i,:) = utils.compute_qhist(im);
% end

% max 293x293
% min 231x231

qhist = zeros(nImages, 4096);
hog = zeros(nImages, 10404);
lbp = zeros(nImages, 9720);
for i = 1 : nImages
    im = imread(images{i});
    im = imresize(im, [293, 293]);
    
%     [hog_4x4, vis4x4] = extractHOGFeatures(im,'CellSize',[4 4]);
%     [hog_8x8, vis8x8] = extractHOGFeatures(im,'CellSize',[8 8]);
%     [hog_16x16, vis16x16] = extractHOGFeatures(im,'CellSize', [16 16]);
%     [hog_32x32, vis32x32] = extractHOGFeatures(im,'CellSize', [32 32]);
%     
%     h =figure; 
%     subplot(2,4,1:4); imshow(im);
% 
%     % Visualize the HOG features
% 
%     subplot(2,4,5);
%     plot(vis4x4); 
%     title({'CellSize = [4 4]'; ['Length = ' num2str(length(hog_4x4))]});
% 
%     subplot(2,4,6);
%     plot(vis8x8); 
%     title({'CellSize = [8 8]'; ['Length = ' num2str(length(hog_8x8))]});
%     
%     subplot(2,4,7);
%     plot(vis16x16); 
%     title({'CellSize = [16 16]'; ['Length = ' num2str(length(hog_16x16))]});
%     
%     subplot(2,4,8);
%     plot(vis32x32); 
%     title({'CellSize = [32 32]'; ['Length = ' num2str(length(hog_32x32))]});
%     
%     pause(8);
%     close(h);

    R = utils.compute_lbp(im(:,:,1));
    G = utils.compute_lbp(im(:,:,2));
    B = utils.compute_lbp(im(:,:,3));
    
    hog(i, :) = extractHOGFeatures(im, 'CellSize', [16 16]);
    lbp(i,:) = [R G B];
   % qhist(i,:) = utils.compute_qhist(im);

end

[train, test] = classification.partdata([lbp hog], labels);

%chococlassifier = fitcknn(train.values, train.labels, 'NumNeighbors', 5);
chococlassifier = fitcecoc(train.values, train.labels);
save("choco-classifier.mat", "chococlassifier");

trPredicted = predict(chococlassifier, train.values);
tsPredicted = predict(chococlassifier, test.values);

train.predicted = convertCharsToStrings(trPredicted);
test.predicted = convertCharsToStrings(tsPredicted);

classification.confchart(train, test);

