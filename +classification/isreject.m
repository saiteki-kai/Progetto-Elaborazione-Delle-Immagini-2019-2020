function label = isreject(im)

R = utils.compute_lbp(im(:,:,1));
G = utils.compute_lbp(im(:,:,2));
B = utils.compute_lbp(im(:,:,3));
lbp = [R G B];    

load('reject-classifier.mat', 'rejectClassifier');
predicted = predict(rejectClassifier, lbp);
label = predicted{:};

end