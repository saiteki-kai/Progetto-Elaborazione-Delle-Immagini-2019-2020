[images, ~] = utils.readlabels("Data/TrainingSet.csv", "Data/TrainingSet/");
for i = 1:numel(images)
    im = imread(images{i});
    [r,~,~] = size(im);
    cropped = utils.cropcircle(im, r/2, r/2, r/2-1);
    imwrite(cropped, "Data/Cropped/choco" + i + ".jpg");
end
