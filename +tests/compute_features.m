close all;
clear;
clc;

labels = utils.readfile("Data/TrainingSet.labels");
images = utils.getfiles("Data/TrainingSet");

% the three classes
% labels = labels(1:330);
% images = images(1:330);

nImages = numel(images);

if ~exist("features.mat", 'file')
    cedd = zeros(nImages, 1);
    ghist = zeros(nImages, 1);
    glcm = zeros(nImages, 1);
    hom = zeros(nImages, 1);
    lbp = zeros(nImages, 1);
    stdev = zeros(nImages, 1);
    avg_col = zeros(nImages, 1);
    rgb_hist = zeros(nImages, 1);

    for i=1:nImages
        im = imread(images{i});
        im = histeq(im);
        
        cedd(i,:) = norm(utils.compute_CEDD(im));
        ghist(i) = norm(utils.compute_ghist(im));
        glcm(i) = norm(utils.compute_glcm(rgb2gray(im)));
        hom(i) = norm(utils.compute_glcm(rgb2gray(im)));
        lbp(i,:) = norm(utils.compute_lbp(rgb2gray(im)));
        stdev(i) = norm(utils.compute_stdev(im2double(im)));
        avg_col(i) = norm(utils.compute_average_color(im));
        rgb_hist(i) = norm(utils.compute_rgb_hist(im));
    end

    % Normalization
    ghist = normalize2(ghist);
    cedd = normalize2(cedd);
    glcm = normalize2(glcm);
    hom = normalize2(hom);
    lbp = normalize2(lbp);
    stdev = normalize2(stdev);
    avg_col = normalize2(avg_col);
    rgb_hist = normalize2(rgb_hist);
    
    save("features.mat", "cedd", "ghist", ...
         "glcm", "lbp", "stdev", "avg_col", "rgb_hist");
end

load("features.mat");

T = table(labels, cedd, avg_col, ghist, glcm, lbp, rgb_hist, stdev);

D = table2dataset(T);
C = cell2table(S([1:5, 111:115, 221:225], :)); % sample of the three classes


function out = normalize1(in)
    out = (in - mean(in)) ./ std(in);
end

function out = normalize2(in)
    out = (in - min(in)) ./ (max(in) - min(in));
end
