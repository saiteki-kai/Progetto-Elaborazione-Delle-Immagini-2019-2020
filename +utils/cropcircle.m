function cropped = cropcircle(image, x, y, radius)
%CROPCIRCLE
% ritorna una regione (quadrata) di un cerchio
% data l'immagine su cui effettuare l'operazione
% il centro in cui ritagliarla e il raggio

radius = floor(radius);
mask = fspecial('disk', radius) ~= 0;
% semplicemente prima non usavamo la maschera!
image = padarray(image, [radius radius], 0);
rect = round([x, y, 2 * radius, 2 * radius]);

cropped = imcrop(image, rect);

% disp(rect);
% disp(size(mask));
% disp(size(cropped));

cropped = im2double(cropped) .* im2double(mask);
cropped = im2uint8(cropped);
end