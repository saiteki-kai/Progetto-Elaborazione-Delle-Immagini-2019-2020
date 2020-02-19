function [centers, radius] = findchocolates(im, mask, shape)
%FINDCHOCOLATES trova i cioccolatini
% prende in input l'immagine già segmentata
% e la sua maschera binaria
% ritorna i centri e il raggio dei cioccolatini
% stimati in base al tipo di scatola

props = regionprops(mask, 'MinorAxisLength');
minorAxis = props.MinorAxisLength;

if shape == "rettangolare"
   [centers, radius] = handlerectangle(im, mask, minorAxis);
else
   [centers, radius] = handlesquare(im, mask, minorAxis);
end
end

function [centers, radius] = handlerectangle(im, mask, minorAxis)
%HANDLERECTANGLE

% stimo range rmax e rmin con l'asse minore
rmax = fix(minorAxis / (8 - 0.75));
rmin = fix(rmax / 3);
alpha = 0.7;

hsv = rgb2hsv(im);
s = hsv(:,:,2);
s = ~mask + s;
s = adapthisteq(s);

[centers, radii, metrics] = imfindcircles(s, [rmin rmax], ...
    'Method', 'TwoStage', ...
    'Sensitivity', 0.9, ...
    'EdgeThreshold', 0.1, ...
    'ObjectPolarity', 'dark');

[centers, radius] = circlefilter(im, centers, radii, metrics, [rmin rmax], alpha);
end

function [centers, radius] = handlesquare(im, mask, minorAxis)

% stimo range rmax e rmin con l'asse minore
rmax = fix(minorAxis / 8);
rmin = fix(rmax / 3);
alpha = 0.45;

ycbcr = rgb2ycbcr(im);
Cb = ycbcr(:,:,2);
Cb = ~mask + Cb;
Cb = adapthisteq(Cb);

[centers, radii, metrics] = imfindcircles(Cb, [rmin rmax], ...
    'Method', 'TwoStage', ...
    'Sensitivity', 0.85, ...
    'EdgeThreshold', 0.1, ...
    'ObjectPolarity', 'dark');

[centers1, radius1] = circlefilter(im, centers, radii, metrics, [rmin rmax], alpha); 

hsv = rgb2hsv(im);
s = hsv(:,:,2);
s = ~mask + s;
s = adapthisteq(s);

[centers, radii, metrics] = imfindcircles(s, [rmin rmax], ...
    'Method', 'TwoStage', ...
    'Sensitivity', 0.85, ... 
    'EdgeThreshold', 0.1, ...
    'ObjectPolarity', 'dark');

[centers2, radius2] = circlefilter(im, centers, radii, metrics, [rmin rmax], alpha);

centers = [centers1; centers2];
radii = [radius1; radius2];

radius = mean(radii);

[centers, radius] = removeoverlap(centers, radius, alpha);
end

function [centers, radius] = circlefilter(im, centers, radii, metrics, range, k)
% CIRCLEFILTER

% rimuovo i cerchi che non rispettano una certa metrica
centers = centers(metrics > 0.2, :);
radii = radii(metrics > 0.2);

% erosione bordo della scatola
hsv = rgb2hsv(im);
bw = hsv(:,:,2) > 0.5;
bw = imclose(bw, strel('disk', fix(range(2))));
bw = imerode(bw, strel('disk', fix(range(1))));

% rimozione cerchi sul bordo della scatola
[centers, radii] = removeexternals(bw, centers, radii, range(1));

% aggiusto dimensioni dei raggi (media)
radius = mean(radii);

% rimozione overlap
[centers, radius] = removeoverlap(centers, radius, k);
end

function [centers, radii] = removeexternals(mask, centers, radii, rmin)
%REMOVEEXTERNALS rimuove i cerchi(immagine croppata) con il 15% percento
% di pixel neri(valore 0)

keep = false(length(centers), 1);
for k = 1 : length(centers)
    circle = utils.cropcircle(mask, centers(k, 1), centers(k, 2), rmin, true);
    
    N = length(circle)^2;
    n = sum(circle == 0, 'all');
    if n/N <= 0.15
        keep(k) = 1;
    end  
    
end

centers = centers(keep, :);
radii = radii(keep);
end

function [centers, radius] = removeoverlap(centers, radius, alpha)
%REMOVEOVERLAP rimpiazza i cerchi vicini,
% vicinanza espressa tramite (alpha * 2 * radius),
% mediano tali cerchi

newCenters = [];
toRemove = [];
for k = 1 : length(centers)
    otherCenters = centers([1:k-1, k+1:length(centers)], :);
    distances = vecnorm((otherCenters - centers(k, :))');

    overlap = distances < alpha * 2 * radius; 
    
    if sum(overlap(:)) ~= 0
        ovCenters = otherCenters(overlap, :);

        toRemove = [toRemove; ovCenters; centers(k, :)]; 
        mCenter = mean([ovCenters; centers(k, :)]);
        newCenters = [newCenters; mCenter];
    end
end

if ~isempty(toRemove)
    centers = centers(~ismember(centers, toRemove, 'rows'), :);
end

if ~isempty(newCenters)
    centers = [centers; unique(newCenters, 'rows')];
end

end
