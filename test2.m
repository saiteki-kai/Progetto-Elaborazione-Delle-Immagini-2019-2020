
% function mask = find_box2(im)
% %FIND_BOX Find the box in the image.
% 
% %print_color_spaces(im);
% 
% %resized = histeq(im);
% %resized = imadjust(im, [0.1 0.99], [], 0.8);
% gray = rgb2gray(im); % GRAY
% %gray(:,:,1) = 0;
% %gray = gray(:,:,2);
% %gray = ycbcr2rgb(gray);
% %figure,imshowpair(gray(:,:,1), gray(:,:,2), 'montage');
% %gray = rgb2gray(gray);
% %figure, imhist(gray);
% 
% % Spiegare perchè una 5x5 (guarda l'immagine 1/5)..?
% sigma = 0.8; % 5x5 <- [0.8*2.5]*2+1 
% otsu = graythresh(gray); % Perchè otsu..?
% 
% % m = mean(gray, 'all');
% % me = std(gray, 1, 'all')^2;
% % 
% % lower = (m - me * sigma);
% % higher = (m + me * sigma);
% % 
% % plot(imhist(gray));
% % hold on;
% % 
% % xline(m * 255, 'r');
% % xline(lower * 255, 'y');
% % xline(lower * 0.4 * 255, 'y');
% % xline(higher * 255);
% 
% bw = edge(gray, 'canny', 0.2, sigma);
% 
% %figure, imshow(bw);
% bw = imdilate(bw, strel('disk', 11)); % 4
% bw = imfill(bw, 'holes');
% 
% bw = bwareafilt(bw, 1);
% bw = imopen(bw, strel('diamond', 3)); % 2
% 
% mask = bwconvhull(bw);
% end




% MM_ALL = compute_feature();
% T = readfile('masks_dataset/T_labels.list');
% plot(MM_ALL, [str2double(T)]);
% 
% function out = readfile(path)
%   f=fopen(path);
%   l = textscan(f,'%s');
%   out = l{:};
%   fclose(f);
% end
% 
% NSE(number of strong edges) > k
% function out = compute_NSE(im, k)
%     G = edge(im, 'canny', k, 0.8);
%     out = abs(G) > k;
%     out = sum(out(:));
% end
% 
% MM(mean of magnitudes)
% function out = compute_MM(im, k)
%     G = edge(im, 'canny', k, 0.8);
%     out = mean(G(:));
% end
% 
% 
% function out = compute_feature()
%     images = get_files('masks_dataset');
%     T = readfile('masks_dataset/T_labels.list');
%     feature = [];
%     for i = 1:numel(images)-3
%         im = im2double(imread(images{i}));
%         im = imresize(im, 1/5);
%         im = im > 0;
%         im = imopen(im, strel('disk', 5));
%         K = str2double(T{i});
%         feature = [feature; compute_MM(im, K)];
%     end
%     out = feature;
% end

%     low = 0;
%     high = 0; 
%     while 1
%         box = findbox(im, T, sigma);
%         MM = compute_MM(im, T);
%         
%         low = abs(min(MM_ALL(:)) - MM);
%         high = abs(max(MM_ALL(:)) - MM);
%         Diff = abs(mean(MM_ALL(:)) - MM);
%         
%         if Diff >= low && Diff <= high || T < 0.1 || T > 0.2
%             break;
%         end
% 
%         if Diff < low
%             T = T - 0.01;
%         elseif Diff > high
%             T = T + 0.01;
%         end
%         
%     end


% images = get_files('Acquisizioni');
% T = readfile('masks_dataset/T_labels.list');
% for i = 23:23%numel(images)
%     im2 = im2double(imread(images{i}));
%     box = findbox(im2, str2double(T{i}), 0.8);
%     
%     shape = shape_classifier((box .* im2), box, 1);
%     
%     if shape{1} == '1'
%         imwrite(box, ['masks_dataset/Rettangolari/' num2str(i) '.jpg']);
%     else
%         imwrite(box, ['masks_dataset/Quadrate/' num2str(i) '.jpg']);
%     end
% end
