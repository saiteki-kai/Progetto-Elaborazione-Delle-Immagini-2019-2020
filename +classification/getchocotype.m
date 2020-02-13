function chocoType = getchocotype(im)
%GETCHOCOTYPE

color = classification.getcolor(im);

cedd = utils.compute_CEDD(im);
load('choco-classifier.mat', 'chococlassifier');
predicted = predict(chococlassifier, cedd);
chocoType = predicted{:};



end