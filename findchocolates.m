% prende in input l'immagine già segmentata
% e la sua maschera binaria
% ritorna i centri e il raggio dei cioccolatini
% stimati in base al tipo di scatola

function [centers, radius] = findchocolates(image, mask, shape)
    
    props = regionprops(mask, ...
        'MajorAxisLength', ...
        'MinorAxisLength', ...
        'Eccentricity', ...
        'Centroid', ...
        'Orientation', ...
        'BoundingBox');
    
   if shape{1} == '2'
        [centers, radii] = handle_square_boxes(image, mask, props, 1.5);
   else
        [centers, radii] = handle_rectangle_boxes(image, mask, props, 0.75);
    end
    
    m = mean(radii);
    d = std(radii);
    radius = m - 2 * d;
end



% ------------------------------------------------------------------------



% fuzione che gestisce i cerchi delle scatole rettangolari

function [centers, radii] = handle_rectangle_boxes(image, mask, props, alfa)

    % oggetti più piccoli o più grandi di [rmin, rmax]
    % non verrebbero trovati ma contando poi i cioccolatini si vedrebbe
    % la mancanza di uno di essi quindi si riesce a risalire all' errore
    % se un intruso è di dimensioni pari al ciccolatino
    % sarà escluso dal classificatore
    % migliorare stime [rmin, rmax]
    
    rmax = fix(props.MinorAxisLength / (8 - alfa));
    rmin = fix(rmax / 3);
    
    % aumento il contrasto per trovare meglio i cerchi
    % perchè i cioccolatini cosi risultano
    % più scuri dello sfondo (che li circonda)
    % come tecnica per aumentare il contrasto uso equalizzazione
    % adattiva perchè i cioccolatini con saturazione scura
    % influenzano notevolmente il risultato
    % equalizzo per confontare meglio immagini con
    % condizioni di luci diverse
    
    hsv = rgb2hsv(image);
    Sat = hsv(:,:,2);
    imDark = (~mask) + Sat;
    imDark = adapthisteq(imDark);
    
    % trovo i cerchi con la trasformata di hough
    % threshold non più basso per non prendere troppo rumore
    % non più alto per non perdere i cerchi
    % pe le motivazioni sopra dette scelgo una
    % object polarity "dark"
    
    [centers, radii, metrics] = imfindcircles(imDark, [rmin rmax], ...
        'Method', 'TwoStage', ...
        'Sensitivity', 0.9, ...
        'EdgeThreshold', 0.1, ...
        'ObjectPolarity', 'dark');
    
    [centers, radii] = circlefilter(centers, radii, metrics, image, rmin, rmax);
end


% fuzione che gestisce i cerchi delle scatole quadrate

function [centers, radii] = handle_square_boxes(image, mask, props, alfa)
    rmax = 45;%45
    rmin = 15;%15
    
    ycbcr = rgb2ycbcr(image);
    Cb = ycbcr(:,:,2);
    imDark = (~mask) + Cb;
    imDark = adapthisteq(imDark);

    [centers, radii, metrics] = imfindcircles(imDark, [rmin rmax], ...
        'Method', 'TwoStage', ...
        'Sensitivity', 0.85, ...
        'EdgeThreshold', 0.1, ...
        'ObjectPolarity', 'dark');
    
    [centers1, radii1] = circlefilter(centers, radii, metrics, image, rmin, rmax); 
    
    hsv = rgb2hsv(image);
    Sat = hsv(:,:,2);
    imDark = (~mask) + Sat;
    imDark = adapthisteq(imDark);
    
    [centers, radii, metrics] = imfindcircles(imDark, [rmin rmax], ...
        'Method', 'TwoStage', ...
        'Sensitivity', 0.9, ...
        'EdgeThreshold', 0.1, ...
        'ObjectPolarity', 'dark');
    
    [centers2, radii2] = circlefilter(centers, radii, metrics, image, rmin, rmax);
    
    centers = [centers1; centers2];
    radii = [radii1; radii2];
    
    [centers, radii] = rmoverlap(centers, radii, 1);
end



% ------------------------------------------------------------------------



% ritorna i centri e raggi dei cerchi
% che sono i presunti cioccolatini
% rimuove i cerchi esterni alla scatola
% rimuove i cerchi con certa metrica < 0.1
% rimuove i cerchi overlappati

function [centers, radii] = circlefilter(centers, radii, metrics, image, rmin, rmax)
    
    % tutti i cerchi (x,y) che non rispettano una certa metrica li tolgo
     
    centers = centers(metrics > 0.1, :);
    radii = radii(metrics > 0.1);
    
    
    % erodo un pò di scatola
    
    hsv = rgb2hsv(image);
    I = hsv(:,:,2) > 0.5;
    I = imclose(I, strel('disk', rmax));
    I = imerode(I, strel('disk', fix(rmin/4)));
    I = I .* hsv(:,:,2);
    box_mask = I > 0;
    box_mask = imfill(box_mask, 'holes');
    box_mask = imerode(box_mask, strel('disk', 9));
    
    % (solo a scopo visivo)
    imDark = (~box_mask) + hsv(:,:,2);
    
    
    % tutti i cerchi (x,y) che non appartengono alla scatola li tolgo
    
    [centers, radii] = rmexterncircles(image, box_mask, centers, radii, rmin);
    
    
    % aggiusto dimensioni dei raggi
    % con media e varianza
    
    m = mean(radii);
    d = std(radii);
    radii = m * ones(length(radii), 1); % - 2 * d;
    
    
    % tolgo gli overlap
    
    [centers, radii] = rmoverlap(centers, radii, 1);
end


% ritorna una regione (quadrata) di un cerchio
% data l'immagine su cui effettuare l'operazione
% il centro in cui ritagliarla e il raggio

function cropped = cropcircle(image, center, r)
    %circle_mask = fspecial('disk', r) ~= 0;
    cropped = imcrop(image, [center(1)-r, center(2)-r, 2*r,2*r]);
end


% ritorna i centri e i raggi dei cerchi
% che non hanno più del 5% di bianco al loro interno
% se più del 5% cerchio è bianco allora lo elimino
% serve per scartare gli eventuali cerchi fuori dalla scatola

function [centers, radii] = rmexterncircles(image, mask, centers, radii, r)
    I = rgb2gray((image .* mask) + (~mask));
    v = false(length(centers), 1);
    for k = 1 : length(centers)
        circle = cropcircle(I, centers(k, :), r);
        N = length(circle)^2;
        n = sum(circle == 1, 'all');
        if n <= N/20
            v(k) = 1;
        end
    end
    centers = centers(v, :);
    radii = radii(v);
end


% dati i centri e i raggi e un beta
% perogni cerchio (x1, y1) e raggio r1
% trovo il cerchio più vicino (x2, y2) e raggio r2
% tale che d(r1, r2) < beta * (r1 + r2) 
% sostituisco i cerchi con (xm, ym) baricentro tra i centri
% e raggio medio rm tra i raggi dei due cerchi

function [centers, radii] = rmoverlap(centers, radii, beta)
    new_centers = zeros(length(centers), 2);
    new_radii = zeros(length(radii), 1);
    for k = 1:length(centers)
        other_centers = centers([1:k-1, k+1:length(centers)], :); 
        other_radii = radii([1:k-1, k+1:length(centers)])';
        distances = vecnorm((other_centers - centers(k, :))');
        [~, mind_i] = min(distances);
        if distances(mind_i) < beta * (radii(k) + other_radii(mind_i))
            new_centers(k, 1) = (centers(k, 1) + other_centers(mind_i, 1)) / 2;
            new_centers(k, 2) = (centers(k, 2) + other_centers(mind_i, 2)) / 2;
            new_radii(k, 1) = (radii(k) + other_radii(mind_i)) / 2;
        else
            new_centers(k, :) = centers(k, :);
            new_radii(k) = radii(k);
        end
    end
end

