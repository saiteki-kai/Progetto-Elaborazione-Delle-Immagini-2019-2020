[images, labels] = utils.readlabels("Data/lbl_conformità.csv", "Data/Acquisizioni/");

predicted = zeros(64, 1, 'single');
for i=1:numel(images)
    disp("Immagine " + i);
    im = imread(images{i});
    predicted(i) = main(im);
end

gt = single(labels == "conforme");
[acc, rec, pre] = classification.cmetrics(gt, predicted);

disp("Accuracy: " + acc);
disp("Recall: " + rec);
disp("Precision: " + pre);

