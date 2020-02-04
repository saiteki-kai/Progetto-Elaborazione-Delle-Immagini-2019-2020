% APPROCCIO:
    % trovo la scatola (sse non è presente mi fermo)
    % determino se è quadrata o rettangolare
    % trovo i "presunti" cioccolatini
        % elimino i cerchi esterni alla scatola
        % elimino i cerchi overlappati
        % ricostruisco io alcuni cerchi
    % se la scatola è rettangolare
        % costruisco una griglia
        % classifico i cioccolatini come (1,2,3,4) classi:
            % - 1 bianchi
            % - 2 dorati
            % - 3 neri
            % - 4 rigetto
         % trovo eventuali posizioni errate
         % conto cioccolatini
         % conto bollini
    % se la scatola e quadrata
        % classifico i cioccolatini come (1,2) classi:
            % - 1 dorati
            % - 2 rigetto
        % conto cioccolatini
        % conto bollini
    % ritorno un valore logico 0-1
    % mostro gli eventuali errori trovati


% function iscomplaiant = main(path)
%     
%     image = im2double(imread(path));
%     
%     [r, c, ~] = size(image);
%     resized = imresize(image, 1/5);
%     
%     mask = find_box(resized);
%     mask = imresize(mask, [r c]);
%     
%     box = mask .* image;
%     
%     iscomplaiant = false;
% 
% end


% funzione soltanto a scopo di test

images = get_files('Acquisizioni/');
for i = 1:numel(images)
    im = imread(images{i});
    
    resized = imresize(im, 1/5, 'bilinear'); %%% why double doesn't work with bicubic, bilinear....
    resized = im2double(resized);
    
    mask = find_box(resized);
    box = resized .* mask;
    
    shape = shape_classifier(box, mask, 0);
    
%     if shape{1} == '2'
        [centers, radius] = find_chocolates(box, mask);
        showcircles(box, centers, radius, i);
%     end
end


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
        saveas(h, "./Test2/" + i + ".jpg");
        close(h);
    end
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
