function [train, test] = partdata(values, labels)
%PARTDATA divide i dati in train e test

cv = cvpartition(labels, "Holdout", 0.2);

train.values = values(cv.training,:);
train.labels = labels(cv.training);
test.values  = values(cv.test,:);
test.labels  = labels(cv.test);
end