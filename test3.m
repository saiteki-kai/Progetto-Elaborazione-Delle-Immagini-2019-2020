
% chocos = get_files('B');
% for i = 1 : numel(chocos)-1
%     imshow(chocos{i});
%     im = imread(chocos{i});
%     c_nc_classifier(im, 1);
%     pause(1);
% end


images = get_files('Acquisizioni/');

for i = 1:numel(images)
    
    im = imread(images{i});
%   [r, c, ~] = size(im);
    resized = imresize(im, 1/5);
    
    mask = find_box(resized);
    resized = im2double(resized) .* mask;
    
    shape = shape_classifier(resized, mask, 0);
    if shape{1} == '1'
        continue;
    end
    
    props = regionprops(mask, 'MajorAxisLength', 'MinorAxisLength');
    rmax = fix(props.MinorAxisLength / (9)); %7.5 %9
    rmin = fix(rmax / 3);
    
    hsv = rgb2hsv(resized);
    ycbcr = rgb2ycbcr(resized);
    lab = rgb2lab(resized);
    gray = rgb2gray(resized);

    saturation = adapthisteq(hsv(:,:,2));
    gray = adapthisteq(gray);

    imDark = saturation;
    imBright = gray;

    [centersDark, radiiDark] = imfindcircles(imDark, [rmin rmax], ...
        'Method', 'TwoStage', ...
        'Sensitivity', 0.9, ... %0.9
        'EdgeThreshold', 0.1, ... % 0.1
        'ObjectPolarity', 'dark');

    [centersBright, radiiBright] = imfindcircles(imBright, [rmin rmax], ...
        'Method', 'TwoStage', ...
        'Sensitivity', 0.9, ...
        'EdgeThreshold', 0.1, ...
        'ObjectPolarity', 'bright');

    centers = centersDark;
    radii = radiiDark;
    
    m = mean(radii);
    d = std(radii);
    radii = m * ones(length(radii), 1) - 2 * d;
    radius = m - 2 * d;

%     h = figure;
%     imshow(imBright);title("Bright");
%     hold on;
%     viscircles(centersBright, 1.5 * m * ones(length(radiiBright), 1) - d, 'EdgeColor', 'r', 'LineWidth', 2); axis image;
%     saveas(h, "./Test/Bright/" + i + ".jpg");
%     close(h);

    h = figure;
    imshow(imDark);title("Dark");
    hold on;
    viscircles(centers, 1.5 * m * ones(length(centers), 1) - d, 'EdgeColor', 'b', 'LineWidth', 2); axis image;
%     saveas(h, "./Test/Dark/" + i + ".jpg");
    close(h);
    
    % vanno gestiti i cerchi e l'invarianza per scala
    centers = centers * 5;
    r = (rmax - rmin) * 5 - 20;
    
    % assumo di non avere cerchi che si intersecano
    % per più del 25% dell' area
    n_labels = 0;
    n_ferrero_rochers = 0;
    for j = 1:length(centers)
        choco = cropcircle(im, centers(j, :), r);
        
        %imwrite(choco, ['C/' num2str(i) '_' num2str(j) '.jpg']);
        
        choco_type = c_nc_classifier(choco, 0);
        
        % potrebbe non predirre il giusto risultato
        % vedere commenti c_nc_classifier ...
        if choco_type{1} == '1'
            n_ferrero_rochers = n_ferrero_rochers + 1;
            n_labels = n_labels + find_label(choco);
        else
            imshow(choco), title('rigetto');
            pause(1);
        end
    end
  
    % assumo che una scatola "quadrata"
    % per essere conforme abbia sempre
    % un numero di ferrero rocher pari a 24
    % con 24 bollini sopra ogiuno di essi
    if n_ferrero_rochers == 24
        if n_labels == 24
            res = 'CONFORME';
        else
            res = 'NON CONFORME';
        end
    else 
        res = 'NON CONFORME!';
    end
    
end

function cropped = cropcircle(image, center, r)
    %circle_mask = fspecial('disk', r) ~= 0;
    cropped = imcrop(image, [center(1)-r, center(2)-r, 2*r,2*r]);
end


% assumo che mi arrivi sempre un ferrero rocher e non qualcos altro
% assumo la regione più grande sia sempre il bollino
% erodo non più della metà del "raggio" dell'area del bollino
% cosi tutto ciò che è più piccolo sparirà mentre rimarrà il bollino
% se trovo più di una regione errore

% problema l'illuminazione se non ho davvero un bollino
% l'illuminazione potrebbe farmi credere di averlo trovato comunque

function out = find_label(image)
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
