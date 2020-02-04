%     im = imread('/home/lfx/Desktop/Project/Latest Version/Images/34.jpg');
%     im = imread('/home/lfx/Desktop/Project/Expanded DataSet/BeppeSet/20191218_205047.jpg');
%     im = im2double(im);
%     mask = findbox(im);

function out = shape_classifier(image, mask, show)
%     create_descriptor_files();
%     load('features2.mat', 'features');
%     [images, labels]= readlists();
%     cv2 = cvpartition(labels,'Holdout',0.2);
%     c2 = init_classifier(features, labels, cv2);
%     [tr, ts] = test_classifier(features, labels, cv2, c2);
%     save('classifier2.mat', 'c2');

    load('classifier2.mat', 'c2');
    test_values = compute_descriptors(image, mask);
    out = predict(c2, test_values);
    
    if show ~= 0
        show_results(image, mask, out);
    end
end


function show_results(image, mask, test_predicted)
    label = "";
    if test_predicted{1} == '1'
        label = "Rectangle";
    else
        label = "Square";
    end
    subplot(1,2,1), imshow(image), title(label);
    subplot(1,2,2), imshow(mask), title(label);
end

function distances = signature(region)
    props = regionprops(region, 'Centroid');
    c = props.Centroid;
    [B, L] = bwboundaries(region,'noholes');
    B = [B{:}];
    maxd = 0;
    maxp = [0, 0];
    for i = 1:L
        d = sqrt((B(:,1) - c(1)).^2 + (B(:,2) - c(2)).^2);
        if d > maxd
            maxd = d;
            maxp = [B(i, 1), B(i, 2)];
        end
    end
    distances = sqrt((B(:,1) - maxp(1)).^2 + (B(:,2) - maxp(2)).^2);
    distances = normalize(distances);
end

function out = rectangle(region)
    props = regionprops(region, 'Area', 'BoundingBox');
    A = props.Area;
    x = props.BoundingBox;
    out = A / (x(3) * x(4));
end

function out = compute_descriptors(~, mask)
    mask = mask > 0.5;
    mask = imerode(mask, strel('square', 11));
    props = regionprops(mask, ...
    'BoundingBox', ...
    'MajorAxisLength', 'MinorAxisLength', ...
    'Orientation', ...
    'Solidity', 'Eccentricity', 'Circularity');
    rect = rectangle(mask);
    ecc = props.Eccentricity;
    ori = props.Orientation;
    sign = signature(mask);
%     cedd = compute_CEDD(image);
    out = ecc;
end

function create_descriptor_files()
  [images, labels] = readlists();
  
  nimages = numel(images);
  
  features = [];
  
  for n = 1 : nimages
    im = imread(['Images/' images{n}]);
    mask = imread(['Masks/' images{n}]);
    features = [features; compute_descriptors(im, mask)];
  end
  
  save('features2.mat', 'features');
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
  f=fopen('Masks/images.txt');
  z = textscan(f,'%s');
  fclose(f);
  images = z{:};

  f=fopen('Masks/labels.txt');
  l = textscan(f,'%s');
  labels = l{:};
  fclose(f);
end
