function chocoType = getchocotype(im)
%GETCHOCOTYPE 

im = imresize(im, [293, 293]);
im2 = histeq(im);

hog = utils.computehog(im);

R = utils.computelbp(im2(:,:,1));
G = utils.computelbp(im2(:,:,2));
B = utils.computelbp(im2(:,:,3));
lbp = [R G B];

load("Data/choco-classifier.mat", "chococlassifier");
predicted = predict(chococlassifier, [lbp hog]);
chocoType = predicted{:};
end
