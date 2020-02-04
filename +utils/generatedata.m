function generateData(im, centers, radius, folder, i)
%GENERATE_DATA

for k=1:length(centers)
    x = centers(k, 1);
    y = centers(k, 2);
    rect = [x - radius, y - radius, 2 * radius, 2 * radius];
    cropped = imcrop(im, rect);
    imwrite(cropped, "Data/" + folder + "/choco_" + i + "-" + k + ".jpg");
end

end