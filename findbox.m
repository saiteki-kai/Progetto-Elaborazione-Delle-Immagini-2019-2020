function out = findbox(image)
%FIND_BOX

image = rgb2gray(image);

T_HIGH = 0.137; % scelta sperimentalmente 0.137
SIGMA = 0.8; % dato N = 5 sigma ricavata da N = (2.5 * sigma) * 2 - 1

bw = edge(image, 'canny', T_HIGH, SIGMA);

bw = imdilate(bw, strel('disk', 3));
bw = imfill(bw, 'holes');
bw = imopen(bw, strel('disk', 9));
bw = bwareafilt(bw, 1);

out = bwconvhull(bw);
end


