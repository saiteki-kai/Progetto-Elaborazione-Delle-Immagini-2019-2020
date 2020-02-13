
images = utils.getfiles('Data/CIAO/');
out = zeros(numel(images), 1);
for i = 1:numel(images)
    im = imread(images{i});
    
    chocotype = classification.choco_classifier(im, 0);
    
    if chocotype ~= "ferrero_rocher", continue, end
    
    [r, c, ch] = size(im);
    im = utils.cropcircle(im, r/2, c/2, r/2-1);
    
    hsv = rgb2hsv(im);
    lab = rgb2lab(im);
    
    S = hsv(:,:,2);
    b = lab(:,:,3);
    B = im(:,:,3);
    
    S = S > graythresh(S);
    b = (b + 128) / 255;
    b = b > graythresh(b);
    B = B < graythresh(B);
    
    I = ~(S | b | B);
    I = imdilate(I, strel('disk', 5));
    I = imfill(I, 'holes');
    % più grande possibile
    % minore del raggio del bollino più piccolo
    I = imerode(I, strel('disk', 15));
    I = bwareafilt(I, 1);
    
%     imwrite(I, "STAMPS/" + i + "stamp.jpg");
%     imwrite(im, "STAMPS/" + i + "choco.jpg");
    
    out(i) = sum(I(:));
    
%     h = figure;
%     subplot(1, 3, 1), imshow(S);
%     subplot(1, 3, 2), imshow(b);
%     subplot(1, 3, 3), imshow(S | b);
%     saveas(h, "./STAMPS/" + num2str(i) + ".jpg");
%     close(h);

    
%     h = figure;
%     subplot(1, 3, 1), imshow(S);
%     subplot(1, 3, 2), imagesc(b); axis image;
%     subplot(1, 3, 3), imshow(B);
%     saveas(h, "./STAMPS/" + num2str(i) + ".jpg");
%     close(h);
    
end