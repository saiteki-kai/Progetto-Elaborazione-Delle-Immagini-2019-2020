function showcircles(image, centers, radii, i)
%SHOWCIRCLES disegna i cerchi
% mostro i cerchi trovati
% prendendo in input immagine sulla quale visualizzarli
% i centri e raggi
% indice i (soltanto a scopo di test) per salvare l'immagine

h = figure;
imshow(image); title("Image: " + i);
hold on;
viscircles(centers, ...
    radii, ...
    'EdgeColor', 'b', ...
    'LineWidth', 3); axis image;
pause(1);
close(h);
end