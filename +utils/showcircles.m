% mostro i cerchi trovati
% prendendo in input immagine sulla quale visualizzarli
% i centri e raggi
% indice i (soltanto a scopo di test) per salvare l'immagine

function showcircles(image, centers, radius, i)
    h = figure;
    imshow(image); title("Dark");
    hold on;
    viscircles(centers, ...
        radius * ones(length(centers), 1), ...
        'EdgeColor', 'b', ...
        'LineWidth', 3); axis image;
    if i ~= 0
        saveas(h, "./Test2/background(White)/" + i + ".jpg");
        close(h);
    end
end