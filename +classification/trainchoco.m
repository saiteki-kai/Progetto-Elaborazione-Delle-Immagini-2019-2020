[images, labels] = utils.readlabels("Data/TrainingSet2.csv", "Data/TrainingSet2/");

nImages = numel(images);

% max 293x293
% min 231x231
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



% function evalclassifier()
% metrics = zeros(30, 4);
% for i = 1 : 30
%     [train, test] = classification.partdata([lbpRGBeq hog], labels);
% 
%     chococlassifier = fitcecoc(train.values, train.labels);
%     save("choco-classifier.mat", "chococlassifier");
% 
%     trPredicted = predict(chococlassifier, train.values);
%     tsPredicted = predict(chococlassifier, test.values);
% 
%     train.predicted = convertCharsToStrings(trPredicted);
%     test.predicted = convertCharsToStrings(tsPredicted);
    
    %classification.confchart(train, test);
%     [acc, rec, prec, recRigetto] = classification.metrics(test.labels, test.predicted);
%     metrics(i, :) = [acc, rec, prec, recRigetto];
% end

% best = zeros(4, 1);
% avg = zeros(4, 1);
% worst = zeros(4, 1);
% 
% for i = 1:4
%     best(i) = max(metrics(:,i));
%     avg(i) = mean(metrics(:,i));
%     worst(i) = min(metrics(:,i));
% end
% 
% T = table(best, avg, worst);
% end

%     [hog_4x4, vis4x4] = extractHOGFeatures(im,'CellSize',[4 4]);
    %     [hog_8x8, vis8x8] = extractHOGFeatures(im,'CellSize',[8 8]);
    %     [hog_16x16, vis16x16] = extractHOGFeatures(im,'CellSize', [16 16]);
    %     [hog_32x32, vis32x32] = extractHOGFeatures(im,'CellSize', [32 32]);
    %      
    %     h =figure; 
    %     subplot(2,3,1:3); imshow(im);
    % 
    %     % Visualize the HOG features
    % 
    %     subplot(2,3,4);
    %     plot(vis4x4); 
    %     title({'CellSize = [4 4]'; ['Length = ' num2str(length(hog_4x4))]});
    % 
    %     subplot(2,3,5);
    %     plot(vis8x8); 
    %     title({'CellSize = [8 8]'; ['Length = ' num2str(length(hog_8x8))]});
    %     
    %     subplot(2,3,6);
    %     plot(vis16x16); 
    %     title({'CellSize = [16 16]'; ['Length = ' num2str(length(hog_16x16))]});
    % %     
    % %     close(h);