function cropped = cropcircle(image, x, y, radius, keepcorners)
%CROPCIRCLE ritaglia l'immagine nel centro (x,y) dato un raggio
% ritorna una regione (quadrata) di un cerchio
% data l'immagine su cui effettuare l'operazione
% il centro in cui ritagliarla e il raggio

radius = floor(radius);

if keepcorners
    rect = round([x - radius, y - radius, 2 * radius, 2 * radius]);
    cropped = imcrop(image, rect);
else
    rect = round([x, y, 2 * radius, 2 * radius]);
    image = padarray(image, [radius radius], 0);
    cropped = imcrop(image, rect);
    mask = fspecial('disk', radius) ~= 0;
    cropped = im2double(cropped) .* im2double(mask);
    cropped = im2uint8(cropped);
end

end