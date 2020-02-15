% mostro i cerchi trovati
% prendendo in input immagine sulla quale visualizzarli
% i centri e raggi
% indice i (soltanto a scopo di test) per salvare l'immagine

function showcircles(image, centers, radii, i, folder, shape)
    h = figure;
    imshow(image); title("Dark");
    hold on;
    viscircles(centers, ...
        radii, ...
        'EdgeColor', 'b', ...
        'LineWidth', 3); axis image;
    if i ~= 0
        saveas(h, "Presentazione/findchocolates/" + shape + "/" + folder + "/" + i + ".jpg");
        close(h);
    end
end