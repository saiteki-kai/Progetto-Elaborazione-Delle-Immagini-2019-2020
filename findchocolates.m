function [centers, radius] = findchocolates(im, mask, shape)
%FINDCHOCOLATES 
% prende in input l'immagine già segmentata
% e la sua maschera binaria
% ritorna i centri e il raggio dei cioccolatini
% stimati in base al tipo di scatola

props = regionprops(mask, 'MajorAxisLength', 'MinorAxisLength');

if shape == "rettangolare"
   [centers, radii] = handleRectangleBoxes(im, mask, props, 0.75);
else
   [centers, radii] = handleSquareBoxes(im, mask, props, 0.35);
end

m = mean(radii);
d = std(radii);
radius = m - 2 * d;
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

[centers, radii] = circleFilter(image, mask, centers, radii, metrics, [rmin, rmax]);
end

function [centers, radii] = handleSquareBoxes(image, mask, props, alfa)
% rmax = 45;
% rmin = 15;
rmax = fix(props.MinorAxisLength / (8 - alfa));
rmin = fix(rmax / 3);

ycbcr = rgb2ycbcr(image);
Cb = ycbcr(:,:,2);
Cb = (~mask) + Cb;
Cb = adapthisteq(Cb);

[centers, radii, metrics] = imfindcircles(Cb, [rmin rmax], ...
    'Method', 'TwoStage', ...
    'Sensitivity', 0.85, ...
    'EdgeThreshold', 0.1, ...
    'ObjectPolarity', 'dark');

[centers1, radii1] = circleFilter(image, centers, radii, metrics, [rmin, rmax]); 

hsv = rgb2hsv(image);
s = hsv(:,:,2);
s = (~mask) + s;
s = adapthisteq(s);

[centers, radii, metrics] = imfindcircles(s, [rmin rmax], ...
    'Method', 'TwoStage', ...
    'Sensitivity', 0.9, ...
    'EdgeThreshold', 0.1, ...
    'ObjectPolarity', 'dark');

[centers2, radii2] = circleFilter(image, mask, centers, radii, metrics, [rmin, rmax]);

centers = [centers1; centers2];
radii = [radii1; radii2];

[centers, radii] = removeOverlap(centers, radii, [rmin, rmax], 1);
radii = radii + 5;
end

function [centers, radii] = circleFilter(im, ~, centers, radii, metrics, range)
% CIRCLEFILTER
% ritorna i centri e raggi dei cerchi
% che sono i presunti cioccolatini
% rimuove i cerchi esterni alla scatola
% rimuove i cerchi con certa metrica < 0.1
% rimuove i cerchi overlappati

centers = centers(metrics > 0.2, :); %0.1
radii = radii(metrics > 0.2); %0.1

% erodo un pò di scatola
hsv = rgb2hsv(box);
bw = hsv(:,:,2) > 0.5;
bw = imclose(bw, strel('disk', fix(range(2))));
bw = imerode(bw, strel('disk', fix(range(1))));

% tutti i cerchi (x,y) che non appartengono alla scatola li tolgo
[centers, radii] = removeExternals(im, bw, centers, radii, range(1));

% aggiusto dimensioni dei raggi con media e varianza
m = mean(radii);
% d = std(radii);
radii = m * ones(length(radii), 1); % - 2 * d;

% tolgo gli overlap
[centers, radii] = removeOverlap(centers, radii, [range(1), range(2)], 1);
end

function [centers, radii] = removeExternals(~, mask, centers, radii, r)
%REMOVEEXTERNALS
% ritorna i centri e i raggi dei cerchi
% che non hanno più del 10% di bianco al loro interno
% se più del 10% cerchio è bianco allora lo elimino
% serve per scartare gli eventuali cerchi fuori dalla scatola

%gray = rgb2gray((im .* mask) + (~mask));

v = false(length(centers), 1);
for k = 1 : length(centers)
    circle = utils.cropcircle(mask, centers(k, 1), centers(k, 2), r);
    N = length(circle)^2;
    n = sum(circle == 1, 'all');
    if n <= N/10
        v(k) = 1;
    end
end

centers = centers(v, :);
radii = radii(v);
end

function [centers, radii] = removeOverlap(centers, radii, ~, ~)
%REMOVEOVERLAP
% dati i centri e i raggi e un beta
% perogni cerchio (x1, y1) e raggio r1
% trovo i cerchi più vicini (x2, y2) ... (xn, yn) con raggio r2 ... rn
% distanza < 30 da (x1, y1)
% tale che d(r1, r2) < beta * (r1 + r2) 
% sostituisco i cerchi con (xm, ym) baricentro tra i centri
% e raggio medio rm tra i raggi dei due cerchi

new_centers = [];
new_radii = [];

for k = 1 : length(centers)
    other_centers = centers([1:k-1, k+1:length(centers)], :);
    other_radii = radii([1:k-1, k+1:length(centers)])';
    distances = vecnorm((other_centers - centers(k, :))');
    
    % minima distanza affinchè possa esserci overlap
    indexes = distances < 30;%2 * radii(k);
    
    if all(indexes == 0)
        new_centers = [new_centers; centers(k, :)];
        new_radii = [new_radii; radii(k)];
        continue;
    end
    
    found = false;
    for w = 1 : length(indexes)
        if indexes(w) == 0, continue, end  
        if distances(w) < (radii(k) + other_radii(w))
            newX = (centers(k, 1) + other_centers(w, 1)) / 2;
            newY = (centers(k, 2) + other_centers(w, 2)) / 2;
            new_centers = [new_centers; [newX, newY]];
            newr = (radii(k) + other_radii(w)) / 2;
            new_radii = [new_radii; newr];
            found = true;
            break;
        end
    end
    
end
centers = new_centers;
radii = new_radii;  
end
