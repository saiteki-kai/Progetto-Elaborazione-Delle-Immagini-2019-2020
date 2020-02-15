[images, labels] = utils.readlabels("Data/color-labels.csv", "Data/Cropped/");

for i=1:numel(images)
    im = imread(images{i});
    qhist = utils.compute_CEDD(im);
   
    load('color-classifier.mat', 'colorClassifier');
    predicted = predict(colorClassifier, qhist);
    chocoType = predicted{:};
    
    if chocoType ~= labels(i)
       figure; 
       imshow(im); 
       title("T: " + labels(i) + ",  Pred: " + convertCharsToStrings(chocoType));
       pause(1);
    end
    
    disp(i + "/" + numel(images));
    clc;
end