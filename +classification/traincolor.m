[images, labels] = utils.readlabels("Data/color-labels.csv", "Data/Cropped/");

nImages = numel(images);

qhist = zeros(nImages, 4096);
for i = 1 : nImages
    im = imread(images{i});
    qhist(i,:) = utils.compute_qhist(im);
end

[train, test] = classification.partdata(qhist, labels);

colorClassifier = fitcknn(train.values, train.labels, 'NumNeighbors', 5);
save("color-classifier.mat", "colorClassifier");

trPredicted = predict(colorClassifier, train.values);
tsPredicted = predict(colorClassifier, test.values);

train.predicted = convertCharsToStrings(trPredicted);
test.predicted = convertCharsToStrings(tsPredicted);

classification.confchart(train, test);

