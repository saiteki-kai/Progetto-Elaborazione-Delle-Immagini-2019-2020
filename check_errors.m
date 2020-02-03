function errors = check_errors(grid, radius, shape)
%CHECK_ERRORS ...

% maybe a struct ...
% la griglia serve solo per le rettangolari
% griglia come parametro opzionale
end



%     % vanno gestiti i cerchi e l'invarianza per scala
%     centers = centers * 5;
%     r = (rmax - rmin) * 5 - 20;
%     
%     % assumo di non avere cerchi che si intersecano
%     % per più del 25% dell' area
%     n_labels = 0;
%     n_ferrero_rochers = 0;
%     for j = 1:length(centers)
%         choco = cropcircle(im, centers(j, :), r);
%         
%         %imwrite(choco, ['C/' num2str(i) '_' num2str(j) '.jpg']);
%         
%         choco_type = c_nc_classifier(choco, 0);
%         
%         % potrebbe non predirre il giusto risultato
%         % vedere commenti c_nc_classifier ...
%         if choco_type{1} == '1'
%             n_ferrero_rochers = n_ferrero_rochers + 1;
%             n_labels = n_labels + find_label(choco);
%         else
%             imshow(choco), title('rigetto');
%             pause(1);
%         end
%     end
%     
%     % assumo che una scatola "quadrata"
%     % per essere conforme abbia sempre
%     % un numero di ferrero rocher pari a 24
%     % con 24 bollini sopra ogiuno di essi
%     if n_ferrero_rochers == 24
%         if n_labels == 24
%             res = 'CONFORME';
%         else
%             res = 'NON CONFORME';
%         end
%     else 
%         res = 'NON CONFORME!';
%     end

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
