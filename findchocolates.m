function [centers, radius] = findchocolates(im, mask, shape)
%FINDCHOCOLATES 
% prende in input l'immagine già segmentata
% e la sua maschera binaria
% ritorna i centri e il raggio dei cioccolatini
% stimati in base al tipo di scatola

props = regionprops(mask, 'MajorAxisLength', 'MinorAxisLength');

hsv = rgb2hsv(im);
s = hsv(:,:,2);
s = (~mask) + s;
s = adapthisteq(s);

centersCb = [];
radiiCb = [];

if shape{1} == "rectangle"  % "1"
    rmax = fix(props.MinorAxisLength / (8 - 0.75));
    rmin = fix(rmax / 3);
    range = [rmin, rmax];
else
    rmax = 45; %45
    rmin = 15; %15
    range = [rmin, rmax];
    
    ycbcr = rgb2ycbcr(im);
    Cb = ycbcr(:,:,2);
    Cb = (~mask) + Cb;
    Cb = adapthisteq(Cb);
    
    [centersCb, radiiCb, metrics] = imfindcircles(Cb, range, ...
        'Method', 'TwoStage', ...
        'Sensitivity', 0.85, ...
        'EdgeThreshold', 0.1, ...
        'ObjectPolarity', 'dark');

    [centersCb, radiiCb] = circleFilter(im, centersCb, radiiCb, metrics, range);
end

[centersS, radiiS, metrics] = imfindcircles(s, range, ...
        'Method', 'TwoStage', ...
        'Sensitivity', 0.9, ...
        'EdgeThreshold', 0.1, ...
        'ObjectPolarity', 'dark');

[centersS, radiiS] = circleFilter(im, centersS, radiiS, metrics, range);

centers = [centersS; centersCb];
radii = [radiiS; radiiCb];

[centers, radii] = removeOverlap(centers, radii, range(1), 1);

m = mean(radii);
d = std(radii);
radius = m - 2 * d;

utils.showcircles(im, centers, radius, 0);
end

function [centers, radii] = handleRectangleBoxes(image, mask, props, alfa)
%handleRectangleBoxes
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
s = hsv(:,:,2);
s = ~mask + s;
s = adapthisteq(s);

% trovo i cerchi con la trasformata di hough
% threshold non più basso per non prendere troppo rumore
% non più alto per non perdere i cerchi
% pe le motivazioni sopra dette scelgo una
% object polarity "dark"

[centers, radii, metrics] = imfindcircles(s, [rmin rmax], ...
    'Method', 'TwoStage', ...
    'Sensitivity', 0.9, ...
    'EdgeThreshold', 0.1, ...
    'ObjectPolarity', 'dark');

[centers, radii] = circleFilter(centers, radii, metrics, image, rmin, rmax);
end

function [centers, radii] = handleSquareBoxes(image, mask)
rmax = 45;%45
rmin = 15;%15

ycbcr = rgb2ycbcr(image);
Cb = ycbcr(:,:,2);
Cb = (~mask) + Cb;
Cb = adapthisteq(Cb);

[centers, radii, metrics] = imfindcircles(Cb, [rmin rmax], ...
    'Method', 'TwoStage', ...
    'Sensitivity', 0.85, ...
    'EdgeThreshold', 0.1, ...
    'ObjectPolarity', 'dark');

[centers1, radii1] = circleFilter(centers, radii, metrics, image, [rmin, rmax]); 

hsv = rgb2hsv(image);
s = hsv(:,:,2);
s = (~mask) + s;
s = adapthisteq(s);

[centers, radii, metrics] = imfindcircles(s, [rmin rmax], ...
    'Method', 'TwoStage', ...
    'Sensitivity', 0.9, ...
    'EdgeThreshold', 0.1, ...
    'ObjectPolarity', 'dark');

[centers2, radii2] = circleFilter(centers, radii, metrics, image, [rmin, rmax]);

centers = [centers1; centers2];
radii = [radii1; radii2];

[centers, radii] = removeOverlap(centers, radii, 1);
end

function [centers, radii] = circleFilter(im, centers, radii, metrics, range)
% CIRCLEFILTER
% ritorna i centri e raggi dei cerchi
% che sono i presunti cioccolatini
% rimuove i cerchi esterni alla scatola
% rimuove i cerchi con certa metrica < 0.1
% rimuove i cerchi overlappati

centers = centers(metrics > 0.1, :);
radii = radii(metrics > 0.1);

% erodo un pò di scatola
hsv = rgb2hsv(im);
bw = hsv(:,:,2) > 0.5;
bw = imclose(bw, strel('disk', range(2)));
bw = imerode(bw, strel('disk', fix(range(1)/4)));
S = bw .* hsv(:,:,2);

mask = S > 0;
mask = imfill(mask, 'holes');
mask = imerode(mask, strel('disk', 9));

% (solo a scopo visivo)
% imDark = (~boxMask) + hsv(:,:,2);

% tutti i cerchi (x,y) che non appartengono alla scatola li tolgo
[centers, radii] = removeExternals(im, mask, centers, radii, range(1));

% aggiusto dimensioni dei raggi con media e varianza
m = mean(radii);
d = std(radii);
radii = m * ones(length(radii), 1); % - 2 * d;

% tolgo gli overlap
[centers, radii] = removeOverlap(centers, radii, range(1), 1);
end

function [centers, radii] = removeExternals(im, mask, centers, radii, r)
%REMOVEEXTERNALS
% ritorna i centri e i raggi dei cerchi
% che non hanno più del 5% di bianco al loro interno
% se più del 5% cerchio è bianco allora lo elimino
% serve per scartare gli eventuali cerchi fuori dalla scatola

gray = rgb2gray((im .* mask) + (~mask));

v = false(length(centers), 1);
for k = 1 : length(centers)
    circle = utils.cropcircle(gray, centers(k, 1), centers(k, 2), r);
    N = length(circle)^2;
    n = sum(circle == 1, 'all');
    if n <= N/20
        v(k) = 1;
    end
end

centers = centers(v, :);
radii = radii(v);
end

function [centers, radii] = removeOverlap(centers, radii, rmin, beta)
%REMOVEOVERLAP
% dati i centri e i raggi e un beta
% perogni cerchio (x1, y1) e raggio r1
% trovo il cerchio più vicino (x2, y2) e raggio r2
% tale che d(r1, r2) < beta * (r1 + r2) 
% sostituisco i cerchi con (xm, ym) baricentro tra i centri
% e raggio medio rm tra i raggi dei due cerchi

new_centers = [];
new_radii = [];

for k = 1 : length(centers)
    other_centers = centers([1:k-1, k+1:length(centers)], :); 
    other_radii = radii([1:k-1, k+1:length(centers)])';
    distances = vecnorm((other_centers - centers(k, :))');
    
    minDist = rmin * 2;
    indexes = distances < minDist;
    %disp("k:" + k + ", dists: " + distances(indexes));
    %disp(indexes);
    
%     viscircles(centers, radii, 'EdgeColor', 'b', 'LineWidth', 3); axis image;
%     viscircles(centers(k,:), radii(k), 'EdgeColor', 'm', 'LineWidth', 3);
%     viscircles(other_centers(indexes,:), other_radii(indexes), 'EdgeColor', 'y', 'LineWidth', 3); axis image;
    
    found = false;
    for w=1:length(indexes)
        if indexes(w) == 0, continue, end
        
        % viscircles(other_centers(w,:), other_radii(w) ./ 3, 'EdgeColor', 'g', 'LineWidth', 3); axis image;
        %pause(1);
                
        b = distances(w) < radii(k) + other_radii(w);
        %disp(distances(w) + " < " + (radii(k) + other_radii(w)) + " = " + b);
        
        if distances(w) < beta * (radii(k) + other_radii(w))
            newX = (centers(k, 1) + other_centers(w, 1)) / 2;
            newY = (centers(k, 2) + other_centers(w, 2)) / 2;
            new_centers = [new_centers; [newX, newY]];
            newr = (radii(k) + other_radii(w)) / 2;
            new_radii = [new_radii; newr];
            found = true;
            break;
        end
    end
    
    if ~found
        new_centers = [new_centers; centers(k, :)];
        new_radii = [new_radii; radii(k)];
    end
    
    %viscircles(new_centers, new_radii, 'EdgeColor', 'r', 'LineWidth', 3); axis image;
    
    %pause(1);
end
    centers = new_centers;
    radii = new_radii;  
end
