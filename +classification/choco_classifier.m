function out = choco_classifier(image, show)
    init();
    predictChoco(image, show);
end


function init()
    create_descriptor_files();
    load('features.mat', 'features');
    labels = utils.readfile("Data/TrainingSet.labels");
    cv = cvpartition(labels,'Holdout',0.2);
    c = init_classifier(features, labels, cv);
    [tr, ts] = test_classifier(features, labels, cv, c);
    save('classifier.mat', 'c', 'tr', 'ts');
end

function predicted = predictChoco(image, show)
    load('classifier.mat', 'c');
    
    test_values = compute_descriptors(image);
    predicted = predict(c, test_values);
    
    if show == 1
        show_results(image, predicted);
    end
end

function show_results(image, test_predicted)
    label = "";

    if test_predicted{1} == '1'
        label = "Raffaello";
    elseif test_predicted{1} == '2'
        label = "Ferrero Rocher";
    elseif test_predicted{1} == '3'
        label = "Ferrero Noir";
    else
        label = "Rigetto";
    end
        
    figure(), imshow(image), title(label);
end

function out = compute_descriptors(image)
     out = utils.compute_CEDD(image);
end

function create_descriptor_files()  
  images = utils.getfiles("Data/TrainingSet");
  features = [];
  for n = 1 : numel(images)
    im = imread([images{n}]);
    features = [features; compute_descriptors(im)];
  end
  save('features.mat', 'features');
end

function out_classifier = init_classifier(descriptor, labels, cv)
    train_values = descriptor(cv.training,:);
    train_labels = labels(cv.training);
    test_values  = descriptor(cv.test,:);
    test_labels  = labels(cv.test);
    out_classifier = fitcknn(train_values, train_labels, 'NumNeighbors', 5);
end

function [train_perf, test_perf] = test_classifier(descriptor, labels, cv, classifier)
    train_values = descriptor(cv.training,:);
    train_labels = labels(cv.training);
    test_values  = descriptor(cv.test,:);
    test_labels  = labels(cv.test);

    train_predicted = predict(classifier, train_values);
    train_perf = classification.confmat(train_labels, train_predicted);

    
    test_predicted = predict(classifier, test_values);
    test_perf = classification.confmat(test_labels, test_predicted);
end
