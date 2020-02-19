[images, labels] = utils.readlabels("Data/lbl_forma.csv", "Data/Acquisizioni/");

nImages = numel(images);

eccentricity = zeros(nImages, 1);
for i = 1 : nImages
    im = imread(images{i});
    resized = imresize(im, 1/5);
    mask = findbox(resized);
    props = regionprops(mask, 'eccentricity');
    eccentricity(i) = props.Eccentricity;
end

[train, test] = classification.partdata(eccentricity, labels);

r = train.values(train.labels == "rettangolare");
q = train.values(train.labels == "quadrata");
shapeclassifier.mq = mean(q);
shapeclassifier.mr = mean(r);
save("Data/shape-classifier.mat", "shapeclassifier");

train.predicted = mypredict(train.values);
test.predicted = mypredict(test.values);

classification.confchart(train, test);


function labels = mypredict(values)
    load("Data/shape-classifier.mat", "shapeclassifier");
    predicted = pdist2(values, shapeclassifier.mr) < pdist2(values, shapeclassifier.mq);
    
    labels = [];
    for i=1:length(predicted)
        if predicted(i) == 1
            labels = [labels; "rettangolare"];
        else
            labels = [labels; "quadrata"];
        end
    end
end
