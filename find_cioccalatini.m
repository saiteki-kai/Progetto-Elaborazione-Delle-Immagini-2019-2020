clear;
close all;

[images, ~] = readlists();

imgs = dir("Augmented");
imgs = imgs([imgs.isdir] == 0);
imgs = {imgs.name}';

%Provare su altre immagini
for i = 1:numel(images)  % 5, 31
im = imread(['Acquisizioni/' images{i}]);
im = im2double(im);

[h, w, ~] = size(im);
resized = imresize(im, 1/5);

resized = imadjust(resized, [], [], 0.5);
gray = rgb2lab(resized);
gray = gray(:,:,3);

sigma = 0.8;

% m = mean(gray, 'all');
% me = std(gray, 1, 'all')^2;
% 
% lower = (m - me * sigma);
% higher = (m + me * sigma);
% 
% plot(imhist(gray));
% hold on;
% 
% xline(m * 255, 'r');
% xline(lower * 255, 'y');
% xline(lower * 0.4 * 255, 'y');
% xline(higher * 255);

otsu = graythresh(gray);
[bw, x] = edge(gray, 'canny', 0.33 * otsu, sigma);
%figure,imshow(bw);
%bw2 = edge(gray(:,:,3), 'canny', [0.66 * m, 1.33 * m], 2); % 0.25

%imshowpair(bw1, bw, 'montage');
bw = imdilate(bw, strel('disk', 4)); % 4
bw = imfill(bw, 'holes');

bw = bwareafilt(bw, 1);
bw = imopen(bw, strel('diamond', 2)); % 2
%imshowpair(bw, bw2, 'falsecolor');

bw = bwconvhull(bw);
%figure, imshowpair(bwconvhull(bw), bwconvhull(bw2), 'falsecolor');

%subplot(8,8,i);
%figure,
imshow(resized .* bw);
%out = imresize(bw, [h w]);
%imwrite(im .* out, "Segmented/" + i + ".png");

%%%% RISCALARE LE MASCHEREEEE E NON LE IMMAGINI e scriverlo nel progetto!!!!!!
end