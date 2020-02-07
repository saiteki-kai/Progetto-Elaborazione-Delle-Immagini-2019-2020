close all;
clear all;
clc;

labels = utils.readfile("Data/TrainingSet.labels");
images = utils.getfiles("Data/TrainingSet/");
N = numel(images);

F = zeros(N, 2); % features vector

if ~exist("cedd.mat", 'file') 
    cedd = zeros(N, 1);
    hist = zeros(N, 1);

    for i=1:N
        im = imread(images{i});
        c = utils.compute_CEDD(im);
        cedd(i) = norm(c);
        % hist(i) = norm(imhist(im));
    end

    % Normalization
    % nhist = (hist - min(hist)) ./ (max(hist) - min(hist));
    ncedd = (cedd - min(cedd)) ./ (max(cedd) - min(cedd));
    save("cedd.mat", "ncedd");
end

load("cedd.mat", "ncedd");

%F = [nhist, ncedd];

%legend('-DynamicLegend');
%hold on;
%plot(ncedd, 'DisplayName', output(f) + "cedd");
%plot(nhist , 'DisplayName', folders(f) + 'hist');

