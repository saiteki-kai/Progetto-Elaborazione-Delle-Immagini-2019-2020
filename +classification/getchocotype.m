function chocoType = getchocotype(im)
%GETCHOCOTYPE

im = imresize(im, [293, 293]);
im2 = histeq(im);

hog = computehog(im);

R = computelbp(im2(:,:,1));
G = computelbp(im2(:,:,2));
B = computelbp(im2(:,:,3));
lbp = [R G B];

load("choco-classifier.mat", "chococlassifier");
predicted = predict(chococlassifier, [lbp hog]);
chocoType = predicted{:};
end