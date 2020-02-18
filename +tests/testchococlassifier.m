[images, labels] = utils.readlabels("Data/TrainingSet2.csv", "Data/TrainingSet2/");

for i=1:numel(images)
    im = imread(images{i});
    im = imresize(im, [293, 293]);
    
    hog = extractHOGFeatures(im, 'CellSize', [16 16]);
    
    im = histeq(im);
    
    R = utils.compute_lbp(im(:,:,1));
    G = utils.compute_lbp(im(:,:,2));
    B = utils.compute_lbp(im(:,:,3));
    
    lbp = [R G B];
    
    load('choco-classifier.mat', 'chococlassifier');
    predicted = predict(chococlassifier, [lbp hog]);
    chocoType = predicted{:};
    hog = extractHOGFeatures(im, 'CellSize', [16 16]);
    if chocoType ~= labels(i)
       figure; 
       imshow(im); 
       title("T: " + labels(i) + ",  Pred: " + convertCharsToStrings(chocoType));
       pause(1);
    end
    
    disp(i + "/" + numel(images));
    clc;
end