[images, labels] = utils.readlabels("Data/lbl_cioccolatini2.csv", "Data/Cioccolatini-Sbilanciato/");

nImages = numel(images);

hog = zeros(nImages, 10404);
lbpRGB = zeros(nImages, 9720);
% lbpHSV = zeros(nImages, 9720);
% lbpYCbCr = zeros(nImages, 9720);

if ~exist("Data/features.mat", "file")
    for i = 1 : nImages
        im = imread(images{i});
        
        im = imresize(im, [293, 293]);
        eq = histeq(im);
        
        hog(i, :) = utils.computehog(im);
        
%         ycbcr = rgb2ycbcr(eq);
%         hsv = rgb2hsv(eq);
        
%         H = utils.computelbp(hsv(:,:,1));
%         S = utils.computelbp(hsv(:,:,2));
%         V = utils.computelbp(hsv(:,:,3));
%         
%         Y = utils.computelbp(ycbcr(:,:,1));
%         Cb = utils.computelbp(ycbcr(:,:,2));
%         Cr = utils.computelbp(ycbcr(:,:,3));
        
        R = utils.computelbp(eq(:,:,1));
        G = utils.computelbp(eq(:,:,2));
        B = utils.computelbp(eq(:,:,3));
        
        lbpRGB(i, :) = [R G B];
%         lbpHSV(i, :) = [H S V];
%         lbpYCbCr(i, :) = [Y Cb Cr];
    end
    
%     save("Data/features.mat", "lbpRGB", "hog", "lbpHSV", "lbpYCbCr");    
    save("Data/features.mat", "lbpRGB", "hog");
else
%     load("Data/features.mat", "lbpRGB", "hog", "lbpHSV", "lbpYCbCr");
    load("Data/features.mat", "lbpRGB", "hog");
end

[train, test] = classification.partdata([lbpRGB hog], labels);

chococlassifier = fitcecoc(train.values, train.labels);
save("Data/choco-classifier.mat", "chococlassifier");

trPredicted = predict(chococlassifier, train.values);
tsPredicted = predict(chococlassifier, test.values);

train.predicted = convertCharsToStrings(trPredicted);
test.predicted = convertCharsToStrings(tsPredicted);
