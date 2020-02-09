%     vanno gestiti i cerchi e l'invarianza per scala
% 
%     assumo di non avere cerchi che si intersecano
%     per più del 25% dell' area
% 
%     potrebbe non predirre il giusto risultato
%     vedere commenti c_nc_classifier ...
% 
%     assumo che una scatola "quadrata"
%     per essere conforme abbia sempre
%     un numero di ferrero rocher pari a 24
%     con 24 bollini sopra ogiuno di essi
function errors = checkerrors(im, centers, radius)
%CHECK_ERRORS ...

% maybe a struct ...
% la griglia serve solo per le rettangolari
% griglia come parametro opzionale

if ~isinteger(im)
    error('L''immagine deve essere RGB');
end

centers = centers * 5;
radius = radius * 5;

[n, m, ~] = size(centers);

if n == 6 && m == 4
    % rectangular
    errors = checkrectangle(im, centers, radius);
else
    % squared
   % disp("square");
    errors = checksquared(im, centers, radius);
end
end


function errors = checksquared(im, centers, radius)
    n_labels = 0;
    n_ferrero_rochers = 0;
    errors = [];
    
    for i = 1 : length(centers)
        choco = utils.cropcircle(im, centers(i, 1), centers(i, 2), radius);
        choco_type = classification.choco_classifier(choco, 0);
        if choco_type{1} == "ferrero_rocher"
            n_ferrero_rochers = n_ferrero_rochers + 1;
            existlabel = find_label(choco);
            if existlabel == 1
                n_labels = n_labels + existlabel;
            else
                curr = [centers(i, 1), centers(i, 2)];
                errors = [errors; curr];
            end
        else
            curr = [centers(i, 1), centers(i, 2)];
            errors = [errors; curr];
        end
    end
end


function errors = checkrectangle(im, centers, radius)
    [n, m, ~] = size(centers);
    grid = zeros(n, m);
    for i = 1 : n
        for j = 1 : m
            choco = utils.cropcircle(im, centers(i, j, 1), centers(i, j, 2), radius);
            choco_type = classification.choco_classifier(choco, 0);
            grid(i, j) = encodetype(choco_type);
        end
    end
    
    true_grid1 = [
        2, 2, 2, 2, 2, 2;
        1, 1, 1, 1, 1, 1;
        1, 1, 1, 1, 1, 1;
        3, 3, 3, 3, 3, 3;
    ];

    true_grid2 = [
        3, 3, 3, 3, 3, 3;
        1, 1, 1, 1, 1, 1;
        1, 1, 1, 1, 1, 1;
        2, 2, 2, 2, 2, 2;
    ];

    p1 = grid == true_grid1';
    p2 = grid == true_grid2';
    
    if sum(p1 == 0, 'all') <= sum(p2 == 0, 'all')
        grid = p1;
    else
        grid = p2;
    end
    
    errors = [];
    for i = 1 : n
        for j = 1 : m
            if grid(i, j) == 0
                curr = [centers(i, j, 1) centers(i, j, 2)];
                errors = [errors; curr];
            end
        end
    end
end

function out = encodetype(chocotype)
   % disp(chocotype);
    if chocotype{1} == "ferrero_rocher"
        out = 1;
    elseif chocotype{1} == "ferrero_noir"
        out = 2;
    elseif chocotype{1} == "raffaello"
        out = 3;
    else
        out = 4;
    end
end


% assumo che mi arrivi sempre un ferrero rocher e non qualcos altro
% assumo la regione più grande sia sempre il bollino
% erodo non più della metà del "raggio" dell'area del bollino
% cosi tutto ciò che è più piccolo sparirà mentre rimarrà il bollino
% se trovo più di una regione errore.
% problema l'illuminazione se non ho davvero un bollino
% l'illuminazione potrebbe farmi credere di averlo trovato comunque
function out = find_label(image)

%     imDark = imadjust(saturation, [], [], 5);
%     imBright = gray;
%     imshow(imDark < 0.01);
    
    out = 0;
    image = imadjustn(image, [], [], 0.8);
    
    hsv = rgb2hsv(image);
    I = hsv(:,:,2);
    
    I = I < 0.3;
    I = imfill(I, 'holes');
    I = imerode(I, strel('disk', 19));
    bw = bwareafilt(I, 1);
    bw = imdilate(bw, strel('disk', 15));
    
    imshow(bw .* im2double(image));
    pause(1);
    
    [~, n] = bwlabel(I);
    if n == 1
        out = 1;
    end
end
