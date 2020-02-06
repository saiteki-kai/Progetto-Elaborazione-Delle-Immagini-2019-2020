close all;
clear all;
clc;

folders = ["Ferrero Rocher/", "Ferrero Noir/", "Rigetto/", "Raffaello/"];
output = ["mat/rocher-", "mat/noir-", "mat/rejection-", "mat/raffaello-"];

% vedi se usare un solo mat file o più per ogni classe... ⤴⤴⤴⤴
    
p = [];
for f=1:4  % 1:2:4 per confrontare rocher e rigetto
    images = utils.getfiles("Data/TrainingSet/" + folders(f));
    images = images(1:110);
    N = numel(images);

    F = zeros(N, 2); % features vector
       
    if ~exist(output(f) + "cedd.mat", 'file') 
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
        save(output(f) + "cedd.mat", "ncedd");
    end
    
    load(output(f) + "cedd.mat", "ncedd");
    
    %F = [nhist, ncedd];
    
    %legend('-DynamicLegend');
    %hold on;
    %plot(ncedd, 'DisplayName', output(f) + "cedd");
    %plot(nhist , 'DisplayName', folders(f) + 'hist');
    
    p = [p, ncedd];
end

% Confronti
figure; scatter(p(:,1), p(:,2)); xlabel('rocher'); ylabel('noir');
figure; scatter(p(:,1), p(:,3)); xlabel('rocher'); ylabel('rigetto');
figure; scatter(p(:,1), p(:,4)); xlabel('rocher'); ylabel('raffaello');

