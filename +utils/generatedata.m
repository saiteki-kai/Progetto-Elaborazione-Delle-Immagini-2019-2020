function generatedata(im, centers, radius, folder, i)
%GENERATE_DATA

for k=1:length(centers)
    x = centers(k, 1);
    y = centers(k, 2);
    cropped = utils.cropcircle(im, x, y, radius);
    
    chocotype = classification.getchocotype(cropped);
    if chocotype == "ferrero_rocher"
        imwrite(cropped, "Data/" + folder + "/Ferrero Rocher/choco_" + i + "-" + k + ".jpg");
    elseif chocotype == "ferrero_noir"
        imwrite(cropped, "Data/" + folder + "/Ferrero Noir/choco_" + i + "-" + k + ".jpg");
    elseif chocotype == "raffaello"
        imwrite(cropped, "Data/" + folder + "/Raffaello/choco_" + i + "-" + k + ".jpg");
    else
        imwrite(cropped, "Data/" + folder + "/Rigetto/choco_" + i + "-" + k + ".jpg");
    end
end
end
