function color = getcolor(im)

qhist = utils.compute_qhist(im);
load("color-classifier.mat", "colorClassifier");
predicted = predict(colorClassifier, qhist);
color = predicted{:};

end