function mask = findbox(im)
%FIND_BOX

im = rgb2gray(im);

HIGH_THRESHOLD = 0.137; % scelta sperimentalmente 0.137
SIGMA = 0.8; % dato N = 5 sigma ricavata da N = (2.5 * sigma) * 2 - 1

bw = edge(im, 'canny', HIGH_THRESHOLD, SIGMA);

bw = imdilate(bw, strel('disk', 3));
bw = imfill(bw, 'holes');
bw = imopen(bw, strel('disk', 9));
bw = bwareafilt(bw, 1);

mask = bwconvhull(bw);
end

