clear;
close all;

[images, ~] = readlists();

imgs = get_files("Augmented");

for i = 40:40%numel(images)
im = imread(['Acquisizioni/' images{i}]);
im = im2double(im);

[h, w, ~] = size(im);
resized = imresize(im, 1/5);

print_color_spaces(resized);

%resized = histeq(resized);
%resized = imadjust(resized, [0.1 0.99], [], 0.8);
gray = rgb2hsv(resized); % GRAY
gray(:,:,3) = 1;
%gray = gray(:,:,2);
gray = hsv2rgb(gray);
%figure,imshowpair(gray(:,:,1), gray(:,:,2), 'montage');
gray = rgb2gray(gray);
figure, imhist(gray);

% Spiegare perchè una 5x5 (guarda l'immagine 1/5)..?
sigma = 0.8; % 5x5 <- [0.8*2.5]*2+1 
otsu = graythresh(gray); % Perchè otsu..?

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

% 0.33 * otsu
[bw, x] = edge(gray, 'canny', [otsu/2, otsu], sigma);
%figure,imshow(bw);
%bw2 = edge(gray(:,:,3), 'canny', [0.66 * m, 1.33 * m], 2); % 0.25

figure, imshow(bw);
bw = imdilate(bw, strel('disk', 3)); % 4
bw = imfill(bw, 'holes');

bw = bwareafilt(bw, 1);
bw = imopen(bw, strel('diamond', 1)); % 2

bw = bwconvhull(bw);

%imshow(resized .* bw);
%out = imresize(bw, [h w]);
%imwrite(im .* out, "Segmented/" + i + ".png");

%%%% RISCALARE LE MASCHEREEEE E NON LE IMMAGINI e scriverlo nel progetto!!!!!!
end