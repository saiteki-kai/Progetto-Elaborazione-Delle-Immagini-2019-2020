function printcolorimages(im)
rgb = im;
ycbcr = rgb2ycbcr(im);
hsv = rgb2hsv(im);
lab = rgb2lab(im);
gray = rgb2gray(im);

figure;
subplot(2, 3, 2); imshow(ycbcr);
subplot(2, 3, 4); imshow(ycbcr(:,:,1)); title("Y");
subplot(2, 3, 5); imshow(ycbcr(:,:,2)); title("Cb");
subplot(2, 3, 6); imshow(ycbcr(:,:,3)); title("Cr");

figure;
subplot(2, 3, 2); imshow(hsv);
subplot(2, 3, 4); imshow(hsv(:,:,1)); title("H");
subplot(2, 3, 5); imshow(hsv(:,:,2)); title("S");
subplot(2, 3, 6); imshow(hsv(:,:,3)); title("V");

figure;
subplot(2, 3, 2); imshow(rgb);
subplot(2, 3, 4); imshow(rgb(:,:,1)); title("R");
subplot(2, 3, 5); imshow(rgb(:,:,2)); title("G");
subplot(2, 3, 6); imshow(rgb(:,:,3)); title("B");

figure;
subplot(2, 3, 2); imshow(lab);
subplot(2, 3, 4); imagesc(lab(:,:,1)), axis image; title("L");
subplot(2, 3, 5); imagesc(lab(:,:,2)), axis image; title("A");
subplot(2, 3, 6); imagesc(lab(:,:,3)), axis image; title("B");

figure;
subplot(1, 2, 1); imshow(gray); title("Gray");
subplot(1, 2, 2); imshow(1 - gray); title("1 - Gray");

end