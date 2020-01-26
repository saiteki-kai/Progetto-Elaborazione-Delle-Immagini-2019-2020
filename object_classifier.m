function out = object_classifier(image, show)
%     create_descriptor_files();
%     load('features.mat', 'features');
%     [images, labels]= readlists();
%     cv = cvpartition(labels,'Holdout',0.2);
%     c = init_classifier(features, labels, cv);
%     [tr, ts] = test_classifier(features, labels, cv, c);
%     save('classifier.mat', 'c');

    load('classifier.mat', 'c');
    
    test_values = compute_descriptors(image);
    out = predict(c, test_values);
    
    if show == 1
        show_results(image, out);
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
    end
        
    figure(), imshow(image), title(label);
end

function out = compute_descriptors(image)
     out = compute_CEDD(image);
end

function create_descriptor_files()
  [images, labels] = readlists();
  
  nimages = numel(images);
  
  features = [];
  
  for n = 1 : nimages
    im = imread(['Cioccolatini/' images{n}]);
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
    train_perf = confmat(train_labels, train_predicted);

    test_predicted = predict(classifier, test_values);
    test_perf = confmat(test_labels, test_predicted);
end

function [images,labels]=readlists()
  f=fopen('Cioccolatini/images.list');
  z = textscan(f,'%s');
  fclose(f);
  images = z{:};

  f=fopen('Cioccolatini/labels.list');
  l = textscan(f,'%s');
  labels = l{:};
  fclose(f);
end
