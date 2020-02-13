function [images, labels] = readlabels(path, folder)
    rows = readmatrix(path, 'OutputType', 'string', 'NumHeaderLines', 1);
    images = folder + rows(:, 1);
    labels = rows(:, 2:end);
end