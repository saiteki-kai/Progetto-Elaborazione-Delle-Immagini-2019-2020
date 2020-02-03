% prende in input l'immagine già segmentata
% e la sua maschera binaria
% ritorna i centri e il raggio dei cioccolatini
% stimati in base al tipo di scatola

function [centers, radius] = find_chocolates(image, mask)
    shape = shape_classifier(image, mask, 0);
    if shape{1} == '2'
        [centers, radii] = ...
            handle_square_boxes();
    else
        [centers, radii] = ...
            handle_rectangle_boxes(image, mask);
    end
    
    m = mean(radii);
    d = std(radii);
    radius = m - 2 * d;
end



% ------------------------------------------------------------------------



% fuzione che gestisce i cerchi delle scatole rettangolari

function [centers, radii] ...
    = handle_rectangle_boxes(image, mask)

    % oggetti più piccoli o più grandi di [rmin, rmax]
    % non verrebbero trovati ma contando poi i cioccolatini si vedrebbe
    % la mancanza di uno di essi quindi si riesce a risalire all' errore
    % se un intruso è di dimensioni pari al ciccolatino
    % sarà escluso dal classificatore
    % migliorare stime [rmin, rmax]
    
    props = regionprops(mask, ...
        'MajorAxisLength', ...
        'MinorAxisLength', ...
        'Eccentricity', ...
        'Centroid', ...
        'Orientation', ...
        'BoundingBox');
    alfa = 0.75;
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
    
    [centers, radii, metric] = imfindcircles(imDark, [rmin rmax], ...
        'Method', 'TwoStage', ...
        'Sensitivity', 0.9, ...
        'EdgeThreshold', 0.1, ...
        'ObjectPolarity', 'dark');
    
    
    % tutti i cerchi (x,y) che non rispettano una certa metrica li tolgo
    
    centers = centers(metric > 0.1, :);
    radii = radii(metric > 0.1);
    
    
    % erodo un pò di scatola
    
    I = hsv(:,:,2) > 0.5;
    I = imclose(I, strel('disk', rmax));
    I = imerode(I, strel('disk', fix(rmin/4)));
    I = I .* hsv(:,:,2);
    box_mask = I > 0;
    box_mask = imfill(box_mask, 'holes');
    box_mask = imerode(box_mask, strel('disk', 9));
    imDark = (~box_mask) + hsv(:,:,2);
    
    
    % tutti i cerchi (x,y) che non appartengono alla scatola li tolgo
    
    [centers, radii] = rmexterncircles(imDark, box_mask, centers, radii, rmin);
    
    
    % aggiusto dimensioni dei raggi
    % con media e varianza
    
    m = mean(radii);
    d = std(radii);
    radii = m * ones(length(radii), 1) - 2 * d;
    
    
    % tolgo gli overlap
    
    [centers, radii] = rmoverlap(centers, radii, 1);

end


% fuzione che gestisce i cerchi delle scatole quadrate

function [centers, radii] = handle_square_boxes()
    % ...
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



% ------------------------------------------------------------------------



% funzione soltanto a scopo di test

function test()
    images = get_files('Acquisizioni');
    for i = 1:numel(images)
        im = imread(images{i});
        resized = imresize(im, 1/5);

        mask = find_box(resized);
        resized = im2double(resized) .* mask;

        [centers, radii] = find_chocolates(image, mask);
        
        % se voglio salvare le immagini valore ~ 0
        showcircles(resized, centers, radii, 0);
    end
end


% mostro i cerchi trovati
% prendendo in input immagine sulla quale visualizzarli
% i centri e raggi
% indice i (soltanto a scopo di test) per salvare l'immagine

function showcircles(image, centers, radii, i)
    m = mean(radii);
    h = figure;
    imshow(image); title("Dark");
    hold on;
    viscircles(centers, ...
        m * ones(length(radii), 1), ...
        'EdgeColor', 'b', ...
        'LineWidth', 2); axis image;
    if i ~= 0
        saveas(h, "./Test/Dark/" + i + ".jpg");
    end
    close(h);
end


% mostra ellisse bounding box
% passandogli il vettore s calcolabile con regionprops(...)
% - bounding box
% - eccentricity, orientation, centroid
% - majoraxis, minoraxis

function showellipse(image, s)
    
    imshow(image);
    
    hold on;
    

    rectangle('Position', s.BoundingBox, 'EdgeColor', 'r');

    phi = linspace(0,2*pi,50);
    cosphi = cos(phi);
    sinphi = sin(phi);

    for k = 1:length(s)
        xbar = s(k).Centroid(1);
        ybar = s(k).Centroid(2);

        a = s(k).MajorAxisLength/2;
        b = s(k).MinorAxisLength/2;

        theta = pi*s(k).Orientation/180;
        R = [ cos(theta)   sin(theta)
             -sin(theta)   cos(theta)];

        xy = [a*cosphi; b*sinphi];
        xy = R*xy;

        x = xy(1,:) + xbar;
        y = xy(2,:) + ybar;

        plot(x,y,'r','LineWidth',2);
    end
    
    hold off

end





