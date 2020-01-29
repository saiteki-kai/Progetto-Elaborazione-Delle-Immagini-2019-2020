function mask = find_box(im)
%FIND_BOX Find the box in the image.

%print_color_spaces(im);

%resized = histeq(im);
%resized = imadjust(im, [0.1 0.99], [], 0.8);
gray = rgb2gray(im); % GRAY
%gray(:,:,1) = 0;
%gray = gray(:,:,2);
%gray = ycbcr2rgb(gray);
%figure,imshowpair(gray(:,:,1), gray(:,:,2), 'montage');
%gray = rgb2gray(gray);
%figure, imhist(gray);

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

bw = edge(gray, 'canny', 0.2, sigma);

%figure, imshow(bw);
bw = imdilate(bw, strel('disk', 11)); % 4
bw = imfill(bw, 'holes');

bw = bwareafilt(bw, 1);
bw = imopen(bw, strel('diamond', 3)); % 2

mask = bwconvhull(bw);
end