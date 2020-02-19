function shape = getshape(mask)
%GETSHAPE

props = regionprops(mask, "Eccentricity");
eccentricity = props.Eccentricity;
shape = predict(eccentricity);

end

function out = predict(values)
%PREDICT

load("Data/shape-classifier.mat", "shapeclassifier");
predicted = pdist2(values, shapeclassifier.mr) < pdist2(values, shapeclassifier.mq);
if predicted == 1
    out = "rettangolare";
else
    out = "quadrata";
end
end
