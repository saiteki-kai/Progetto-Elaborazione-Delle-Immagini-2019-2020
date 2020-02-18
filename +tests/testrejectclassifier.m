[images, labels] = utils.readlabels("Data/reject-labels.csv", "Data/Cropped/");

for i=1:numel(images)
    im = imread(images{i});
    cedd = utils.compute_CEDD(im);
   
    load('reject-classifier.mat', 'rejectClassifier');
    predicted = predict(rejectClassifier, cedd);
    isreject = predicted{:};
    
    if isreject ~= labels(i)
       figure; 
       imshow(im); 
       title("T: " + labels(i) + ",  Pred: " + isreject);
       pause(1);
    end
    
    disp(i + "/" + numel(images));
    clc;
end