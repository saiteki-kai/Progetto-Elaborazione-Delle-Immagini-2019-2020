function generatedata(im, centers, radius, folder, i)
%GENERATE_DATA

for k=1:length(centers)
    x = centers(k, 1);
    y = centers(k, 2);
    cropped = utils.cropcircle(im, x, y, radius);
    imwrite(cropped, "Data/" + folder + "/choco_" + i + "-" + k + ".jpg");
end
end
