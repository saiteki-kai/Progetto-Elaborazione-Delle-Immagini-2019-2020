clear;
close all;

images = get_files("Acquisizioni");

for i = 40:40 %numel(images)
im = imread(images{i});
im = im2double(im);

[box, mask] = find_box(im);

end