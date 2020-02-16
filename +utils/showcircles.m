% mostro i cerchi trovati
% prendendo in input immagine sulla quale visualizzarli
% i centri e raggi
% indice i (soltanto a scopo di test) per salvare l'immagine

function showcircles(image, centers, radii, i, folder, shape)
    h = figure;
    imshow(image); title("Image: " + i);
    hold on;
    viscircles(centers, ...
        radii, ...
        'EdgeColor', 'b', ...
        'LineWidth', 3); axis image;
    pause(1);
    close(h);
%     if i ~= 0
%         saveas(h, "Presentazione/findchocolates/" + shape + "/" + folder + "/" + i + ".jpg");
%         close(h);
%     end
end