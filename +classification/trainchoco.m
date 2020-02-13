[images, labels] = utils.readlabels("Data/TrainingSet.csv", "Data/Cropped/");

nImages = numel(images);

% cedd = zeros(nImages, 144);
% for i = 1 : nImages
%     im = imread(images{i});
%     cedd(i,:) = utils.compute_CEDD(im);
% end

% lbp = zeros(nImages, 30, 'single');
% for i = 1 : nImages
%     im = imread(images{i});
%     hsv = rgb2hsv(im);
%     hsv(:,:,2) = adapthisteq(hsv(:,:,2));
%     rgb = hsv2rgb(hsv);
%     
%     R = utils.compute_lbp(rgb(:,:,1));
%     G = utils.compute_lbp(rgb(:,:,2));
%     B = utils.compute_lbp(rgb(:,:,3));
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

[train, test] = classification.partdata(lbp, labels);

chococlassifier = fitcknn(train.values, train.labels, 'NumNeighbors', 5);
save("choco-classifier.mat", "chococlassifier");

trPredicted = predict(chococlassifier, train.values);
tsPredicted = predict(chococlassifier, test.values);

train.predicted = convertCharsToStrings(trPredicted);
test.predicted = convertCharsToStrings(tsPredicted);

classification.confchart(train, test);

