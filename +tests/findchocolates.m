images = utils.getfiles('Acquisizioni/');

for i = 1:numel(images)
    im = imread(images{i});
    resized = imresize(im, 1/5);
    resized = im2double(resized);
    mask = findbox(resized);
    box = resized .* mask;
    shape = classification.getshape(mask);
    
    [centers, radius] = findchocolates(box, mask, shape);
    utils.showcircles(box, centers, radius * ones(size(centers, 1), 1), i, '5circles', shape);
end

%    props = regionprops(mask, 'MajorAxisLength', 'MinorAxisLength');
    
%     if shape == "rettangolare"
%         
%         rmax = fix(props.MinorAxisLength / (8 - 0.75));
%         rmin = fix(rmax / 3);
%         
%         %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %         imwrite(box, "Presentazione/findchocolates/" + shape + "/1box/"+i+".jpg");
% %         pause(1);
%         %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%         
%         hsv = rgb2hsv(box);
%         s = hsv(:,:,2);
%         
%         %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %         imwrite(s, "Presentazione/findchocolates/" + shape + "/2sat/"+i+".jpg");
% %         pause(1);
%         %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%         s = ~mask + s;
%         
%         %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %         imwrite(s, "Presentazione/findchocolates/" + shape + "/3~sat/"+i+".jpg");
% %         pause(1);
%         %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%         s = adapthisteq(s);
%         
%         %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %         imwrite(s, "Presentazione/findchocolates/" + shape + "/4~sateq/"+i+".jpg");
% %         pause(1);
%         %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%         
%         [centers, radii, metrics] = imfindcircles(s, [rmin rmax], ...
%                 'Method', 'TwoStage', ...
%                 'Sensitivity', 0.9, ...
%                 'EdgeThreshold', 0.1, ...
%                 'ObjectPolarity', 'dark');
%           
% %         %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %         utils.showcircles(s, centers, radii, i, '5circles', shape);
% %         pause(1);
% %         %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%         
%         [centers, radius] = circleFilter(...
%             s, box, mask, centers, radii, metrics, ...
%             [rmin rmax], i, shape, 1, 1.4); 
%     
%     else
%         disp("quadrata");
%         rmax = fix(props.MinorAxisLength / 8);
%         rmin = fix(rmax / 3);
%         
%         %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %         imwrite(box, "Presentazione/findchocolates/" + shape + "/1box/"+i+".jpg");
% %         pause(1);
%         %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%         
%         ycbcr = rgb2ycbcr(box);
%         Cb = ycbcr(:,:,2);
%         
%         %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %         imwrite(Cb, "Presentazione/findchocolates/" + shape + "/2cb/"+i+".jpg");
% %         pause(1);
%         %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%         
%         Cb = ~mask + Cb; 
%         
%         %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %         imwrite(Cb, "Presentazione/findchocolates/" + shape + "/3~cb/"+i+".jpg");
% %         pause(1);
%         %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%         
%         Cb = adapthisteq(Cb);
%         
%         %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %         imwrite(Cb, "Presentazione/findchocolates/" + shape + "/4~cbeq/"+i+".jpg");
% %         pause(1);
%         %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
%         [centers, radii, metrics] = imfindcircles(Cb, [rmin rmax], ...
%         'Method', 'TwoStage', ...
%         'Sensitivity', 0.85, ...
%         'EdgeThreshold', 0.1, ...%0.1
%         'ObjectPolarity', 'dark');
%         
%         %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %         utils.showcircles(Cb, centers, radii, i, '5circles', shape);
% %         pause(1);
%         %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%         
%         [centers1, radius1] = circleFilter(...
%             Cb, box, mask, centers, radii, metrics, ...
%             [rmin, rmax], i, shape, 1, 0.9);
% 
%         %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %         utils.showcircles(Cb, centers1, ...
% %             radius1 * ones(size(centers1, 1), 1), i, '11final', shape);
% %         pause(1);
%         %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%         
%         
%         hsv = rgb2hsv(box);
%         s = hsv(:,:,2);
%         
%         %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %         imwrite(s, "Presentazione/findchocolates/" + shape + "/12sat/"+i+".jpg");
% %         pause(1);
%         %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%         
%         s = ~mask + s;
%         
%         %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %         imwrite(s, "Presentazione/findchocolates/" + shape + "/13~sat/"+i+".jpg");
% %         pause(1);
%         %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%         
%         s = adapthisteq(s);
%         
%         %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %         imwrite(s, "Presentazione/findchocolates/" + shape + "/14~sateq/"+i+".jpg");
% %         pause(1);
%         %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%         
%         [centers, radii, metrics] = imfindcircles(s, [rmin rmax], ...
%         'Method', 'TwoStage', ...
%         'Sensitivity', 0.85, ...
%         'EdgeThreshold', 0.1, ...%0.05
%         'ObjectPolarity', 'dark');
%         
% %         utils.showcircles(s, centers, radii, 0, '5circles', shape);
% %         pause(1);
%         
%         %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %         utils.showcircles(s, centers, radii, i, '15circles', shape);
% %         pause(1);
%         %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%         
%         [centers2, radius2] = circleFilter(...
%             s, box, mask, centers, radii, metrics, ...
%             [rmin, rmax], i, shape, 2, 0.9);
%         
%         %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %         utils.showcircles(box, centers2, radius2 * ones(size(centers2, 1), 1), i, '21final', shape);
% %         pause(1);
%         %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%         
%         centers = [centers1; centers2];
%         radii = [radius1; radius2];
%         
%         %centers = unique(round(centers), 'rows');
%         radius = mean(radii);
%         
%         %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %         utils.showcircles(box, centers, radius * ones(size(centers, 1), 1), i, '22union', shape);
% %         pause(1);
%         %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%        
%         
%         
%         % da vedere questo parametro!
%         radius = mean(radii);
%         [centers, radius] = removeOverlap(centers, radius, 0.9);
    
%     m = mean(radii);
%     d = std(radii);
%     radius = m - 2 * d;
%     end
%     
%     if shape == "rettangolare"
%         %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%         utils.showcircles(box, centers, radius * ones(size(centers, 1), 1), 0, '11final', shape);
%         pause(1);
%         %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%     else
%         %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %         utils.showcircles(box, centers, radius * ones(size(centers, 1), 1), i, '23final', shape);
% %         pause(1);
%         %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%     end
%     
%     % utils.generatedata(im, centers*5, radius*5, 'BHO', i);
% end

% function [centers, radius] = circleFilter(...
%     s, box, ~, centers, radii, metrics, range, i, shape, number, K)
% 
%         centers = centers(metrics > 0.2, :);
%         radii = radii(metrics > 0.2);
%         
%         %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %         if number == 1
% %             utils.showcircles(s, centers, radii, i, '6metrics', shape);
% %             pause(1);
% %         else
% %             utils.showcircles(s, centers, radii, i, '16metrics', shape);
% %             pause(1);
% %         end
%         %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%         
%         hsv = rgb2hsv(box);
%         bw = hsv(:,:,2) > 0.5;
%         bw = imclose(bw, strel('disk', fix(range(2))));
%         bw = imerode(bw, strel('disk', fix(range(1))));
%         
%         %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %         if number == 1
% %            imwrite(bw .* box, "Presentazione/findchocolates/" + shape + "/7eroded/"+i+".jpg");
% %            pause(1);
% %         else
% %            imwrite(bw .* box, "Presentazione/findchocolates/" + shape + "/17eroded/"+i+".jpg");
% %             pause(1);
% %         end
%         %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%         
%         [centers, radii] = removeExternals(box, bw, centers, radii, range(1));
%         
%         %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %         if number == 1
% %             utils.showcircles(s, centers, radii, i, '8externals', shape);
% %             pause(1);
% %         else
% %             utils.showcircles(s, centers, radii, i, '18externals', shape);
% %             pause(1);
% %         end
%         %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%         
%         m = mean(radii);
%         radii = m * ones(length(radii), 1);
%         
%         %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %         if number == 1
% %             utils.showcircles(s, centers, radii, i, '9radii', shape);
% %             pause(1);
% %         else
% %             utils.showcircles(s, centers, radii, i, '19radii', shape);
% %             pause(1);
% %         end
%         %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%         
%         % centers, radii, range, 1
%         [centers, radius] = removeOverlap(centers, radii(1), K, box);
%         
%         %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %         if number == 1
% %             utils.showcircles(s, centers, radius * ones(size(centers, 1), 1), i, '10overlap', shape);
% %             pause(1);
% %         else
% %             utils.showcircles(s, centers, radius * ones(size(centers, 1), 1), i, '20overlap', shape);
% %             pause(1);
% %         end
%         %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% end
% 
% function [centers, radii] = removeExternals(~, mask, centers, radii, r)
% %REMOVEEXTERNALS
% % ritorna i centri e i raggi dei cerchi
% % che non hanno più del 10% di bianco al loro interno
% % se più del 10% cerchio è bianco allora lo elimino
% % serve per scartare gli eventuali cerchi fuori dalla scatola
% 
% %gray = rgb2gray((im .* mask) + (~mask));
% 
% v = false(length(centers), 1);
% for k = 1 : length(centers)
%     circle = utils.cropcircle(mask, centers(k, 1), centers(k, 2), r, false);
%     %circle1 = utils.cropcircle(im, centers(k, 1), centers(k, 2), r, false);
%     N = length(circle)^2;
%     n = sum(circle == 0, 'all');
%     if n <= N/10
%         v(k) = 1;
% %         imshow(circle);
% %         figure, imshow(circle1);
% %         pause(1);
% %     else
% %         imshow(circle);
% %         figure, imshow(circle1);
% %         pause(1);
%     end
% end
% 
% centers = centers(v, :);
% radii = radii(v);
% end
% 
% function [centers, radius] = removeOverlap(centers, radius, K, box)
% newcenters = [];
% toremove = [];
% for k = 1 : length(centers)
%     othercenters = centers([1:k-1, k+1:length(centers)], :);
%     distances = vecnorm((othercenters - centers(k, :))');
%     
%     % 0.7 per le rettangolari
%     % 0.45 per le quadrate
%     overlap = distances < K * radius; 
%     
%     imshow(box);
%     hold on;
%     scatter(centers(k, 1), centers(k, 2), 'filled', 'r');
%     scatter(othercenters(overlap, 1), othercenters(overlap, 2), 'filled', 'y'); 
%     viscircles(centers(k, :), ...
%     K * radius, 'EdgeColor', ...
%     'g', 'LineWidth', 2); axis image;
%     viscircles(centers(k, :), ...
%     radius, 'EdgeColor', ...
%     'r', 'LineWidth', 2); axis image;
%     viscircles(othercenters(overlap, :), ...
%     radius * ones(size(othercenters(overlap, :), 1), 1), 'EdgeColor', ...
%     'y', 'LineWidth', 2); axis image;
%     pause(1);
%     
%     if sum(overlap(:)) ~= 0
%         distances = distances(overlap);
%         ovcenters = othercenters(overlap, :);
% 
%         toremove = [toremove; ovcenters; centers(k, :)]; 
%         mcenter = mean([ovcenters; centers(k, :)]);
%         newcenters = [newcenters; mcenter];
%     end
% end
% 
% if ~isempty(toremove)
%     centers = centers(~ismember(centers, toremove, 'rows'), :);
% end
% if ~isempty(newcenters)
%     centers = [centers; unique(newcenters, 'rows')];
% end
% end







%     imshow(box);
%     hold on;
%     viscircles(centers(k, :), ...
%     radius, 'EdgeColor', ...
%     'r', 'LineWidth', 3); axis image;
%     viscircles(othercenters(overlap, :), ...
%     radius * ones(size(othercenters(overlap, :), 1), 1), 'EdgeColor', ...
%     'y', 'LineWidth', 3); axis image;
%     pause(0.3);

% imshow(box);
% hold on;
% viscircles(centers, ...
%     radius * ones(size(centers, 1), 1), 'EdgeColor', ...
%     'y', 'LineWidth', 3); axis image;
% viscircles(new_centers, ...
%     radius * ones(size(new_centers, 1), 1), 'EdgeColor', ...
%     'b', 'LineWidth', 3); axis image;
% pause(0.1);


% function [centers, radii] = removeOverlap(centers, radius, box)
% new_centers = [];
% new_radii = [];
% 
% % due volte raggio più K (distanza per essere nel vicinato)
% mind = 3 * radius + 20;
% posfine = zeros(length(centers), 1);
% cvicinati = [];
% dvicinati = [];
% for i = 1 : length(centers)
%     other_centers = centers([1:i-1, i+1:length(centers)], :);
%     distances = vecnorm((other_centers - centers(i, :))');
%     
%     dvicinato = round(distances(distances <= mind));
%     dvicinati = [dvicinati dvicinato];
%     
%     cvicinato = other_centers(distances <= mind, :);
%     cvicinati = [cvicinati; cvicinato];
%     
% %     imshow(box);
% %     hold on;
% %     viscircles(centers(i, :), ...
% %         radius, 'EdgeColor', ...
% %         'r', 'LineWidth', 3); axis image;
% %     cerchivicinato = other_centers(distances <= mind, :);
% %     viscircles(cerchivicinato, ...
% %         radius * ones(size(cerchivicinato, 1), 1), 'EdgeColor', ...
% %         'y', 'LineWidth', 3); axis image;
% %     pause(1);
%     
%     if i == 1
%         posfine(i) = length(dvicinato);
%     else
%         posfine(i) = posfine(i-1) + length(dvicinato);
%     end
% end
% 
% m = mode(dvicinati(:));
% s = std(dvicinati(:));
% 
% disp(m);
% disp(s);
% % disp(size(dvicinati));
% % disp(size(cvicinati));
% 
% newvicinati = [];
% for j = 1 : length(posfine)
%     if j == 1
%         dvicinato = dvicinati(1:posfine(j));
%         cvicinato = cvicinati(1:posfine(j), :);
%     else
%         dvicinato = dvicinati(posfine(j-1)+1:posfine(j));
%         cvicinato = cvicinati(posfine(j-1)+1:posfine(j), :);
%     end
%     
% %     imshow(box);
% %     hold on;
% %     viscircles(centers(j, :), ...
% %         radius, 'EdgeColor', ...
% %         'r', 'LineWidth', 3); axis image;
% %     viscircles(cvicinato, ...
% %         radius * ones(size(cvicinato, 1), 1), 'EdgeColor', ...
% %         'y', 'LineWidth', 3); axis image;
% %     pause(1);
%     
%     disp(dvicinato);
%     cond = dvicinato <= m + 4 & dvicinato >= m - 4;
%     cvicinato = cvicinato(cond, :);
%     
%     newvicinati = [newvicinati; cvicinato];
%     
%     %disp(cvicinato);
%     
% %     viscircles(cvicinato, ...
% %         radius * ones(size(cvicinato, 1), 1), 'EdgeColor', ...
% %         'g', 'LineWidth', 3); axis image;
% %     pause(1);
% end
% 
% imshow(box);
% hold on;
% viscircles(newvicinati, ...
%     radius * ones(size(newvicinati, 1), 1), 'EdgeColor', ...
%     'b', 'LineWidth', 3); axis image;
% pause(1);
% 
% 
% centers = new_centers;
% radii = new_radii;
% end







%         pbw = zeros(size(mask));
%         for l=1:length(centers)
%             pbw(round(centers(l,1)), round(centers(l,2))) = 1;
%         end
%         imshow(pbw);
%         [H, T, R] = hough(pbw);
%         coords = houghpeaks(H,200);
%           rhos   = R(coords(:,1));
%           thetas = T(coords(:,2));
%           
%           thetas = thetas*pi/180;
%           
%         figure,imshow(pbw)
%         hold on
%           X=[1:size(pbw,2)]; % tutti i valori delle coordinate x
%           for n = 1 : numel(rhos)
%             Y=(rhos(n)-X*cos(thetas(n)))/sin(thetas(n)); % valori delle coordinate y
%             % Si risolve su y l'equazione rho=x*cos(theta)+y*sin(theta) 
%             plot(X,Y,'r-', 'LineWidth', 1);
%           end
  
%         imagesc(H);
%         
%         return;

%         mask = imerode(mask, strel('disk', fix(0.25*m)));
%         
%         %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%         imwrite(mask .* box, "Presentazione/findchocolates/rettangolari/8eroded/"+i+".jpg");
%         pause(1);
%         %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%         [centers, radii] = removeExternals(box, mask, centers, radii, m);
%         
%         %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%         utils.showcircles(s, centers, radii, i, '9externals');
%         pause(1);
%         %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%        


%         imshow(box);
%         hold on;
%         idx = convhull(centers);
%         idx2 = boundary(centers, 1);
%        % scatter(centers(idx, 1), centers(idx, 2), 'y', 'filled');
%         plot(centers(idx2, 1), centers(idx2, 2), 'r', 'LineWidth', 3);
%         x = mean(centers(:, 1));
%         y = mean(centers(:, 2));
%         hold on;
%         scatter(x, y, 'c');
%         utils.showellipse(box, mask, false);
%        
%         pause(1);
        
%         [centers, radii] = removeExternals(box, mask, centers, radii, m);
%         
%         %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%         utils.showcircles(s, centers, radii, i, '9externals');
%         pause(1);
%         %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
