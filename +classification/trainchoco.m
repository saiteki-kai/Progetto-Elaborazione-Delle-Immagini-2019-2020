[images, labels] = utils.readlabels("Data/TrainingSet2.csv", "Data/TrainingSet2/");

nImages = numel(images);

hog = zeros(nImages, 10404);
lbpRGB = zeros(nImages, 9720);
lbpHSV = zeros(nImages, 9720);
lbpYCbCr = zeros(nImages, 9720);

if ~exist("features.mat", "file")
    for i = 1 : nImages
        im = imread(images{i});
        
        im = imresize(im, [293, 293]);
        eq = histeq(im);
        
        hog(i, :) = utils.computehog(im);
        
        ycbcr = rgb2ycbcr(eq);
        hsv = rgb2hsv(eq);
        lab =  rgb2lab(eq);
        
        H = utils.computelbp(hsv(:,:,1));
        S = utils.computelbp(hsv(:,:,2));
        V = utils.computelbp(hsv(:,:,3));
        
        Y = utils.computelbp(ycbcr(:,:,1));
        Cb = utils.computelbp(ycbcr(:,:,2));
        Cr = utils.computelbp(ycbcr(:,:,3));
        
        R = utils.computelbp(eq(:,:,1));
        G = utils.computelbp(eq(:,:,2));
        B = utils.computelbp(eq(:,:,3));
        
        lbpRGB(i, :) = [R G B];
        lbpRGB(i, :) = [R G B];
        lbpHSV(i, :) = [H S V];
        lbpYCbCr(i, :) = [Y Cb Cr];
    end
    
    save("features.mat", "lbpRGB", "hog", "lbpHSV", "lbpYCbCr");
else
    load("features.mat", "lbpRGB", "hog", "lbpHSV", "lbpYCbCr");
end


[train, test] = classification.partdata([lbpRGBeq hog], labels);

chococlassifier = fitcecoc(train.values, train.labels);
save("choco-classifier.mat", "chococlassifier");

trPredicted = predict(chococlassifier, train.values);
tsPredicted = predict(chococlassifier, test.values);

train.predicted = convertCharsToStrings(trPredicted);
test.predicted = convertCharsToStrings(tsPredicted);
