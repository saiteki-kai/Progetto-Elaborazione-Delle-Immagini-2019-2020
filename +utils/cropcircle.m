function cropped = cropcircle(image, x, y, radius)
%CROPCIRCLE
% ritorna una regione (quadrata) di un cerchio
% data l'immagine su cui effettuare l'operazione
% il centro in cui ritagliarla e il raggio

rect = [x - radius, y - radius, 2 * radius, 2 * radius];
cropped = imcrop(image, rect);
end