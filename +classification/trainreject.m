[images, labels] = utils.readlabels("Data/reject-labels.csv", "Data/Cropped/");

images = images(1:end);
labels = labels(1:end);

nImages = numel(images);

%lbp = zeros(nImages, 30, 'single');
cedd = zeros(nImages, 144);
for i = 1 : nImages
    im = imread(images{i});
%     R = utils.compute_lbp(im(:,:,1));
%     G = utils.compute_lbp(im(:,:,2));
%     B = utils.compute_lbp(im(:,:,3));
%     lbp(i,:) = [R G B];
    cedd(i,:) = utils.compute_CEDD(im);
end

[train, test] = classification.partdata(cedd, labels);

rejectClassifier = fitcknn(train.values, train.labels, 'NumNeighbors', 5);
save("reject-classifier.mat", "rejectClassifier");

trPredicted = predict(rejectClassifier, train.values);
tsPredicted = predict(rejectClassifier, test.values);

train.predicted = convertCharsToStrings(trPredicted);
test.predicted = convertCharsToStrings(tsPredicted);

classification.confchart(train, test);

