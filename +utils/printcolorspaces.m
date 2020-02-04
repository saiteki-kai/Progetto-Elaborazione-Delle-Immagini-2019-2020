function printcolorspaces(im)
%PRINT_COLOR_SPACES Shows different color spaces of an image.

rgb = im;
ycbcr = rgb2ycbcr(im);
hsv = rgb2hsv(im);
lab = rgb2lab(im);
gray = rgb2gray(im);

figure;
subplot(5, 4, 1); imshow(ycbcr);
subplot(5, 4, 2); plot(imhist(ycbcr(:,:,1))); title("Y");
subplot(5, 4, 3); plot(imhist(ycbcr(:,:,2))); title("Cb");
subplot(5, 4, 4); plot(imhist(ycbcr(:,:,3))); title("Cr");

subplot(5, 4, 5); imshow(hsv);
subplot(5, 4, 6); plot(imhist(hsv(:,:,1))); title("H");
subplot(5, 4, 7); plot(imhist(hsv(:,:,2))); title("S");
subplot(5, 4, 8); plot(imhist(hsv(:,:,3))); title("V");

subplot(5, 4, 9); imshow(rgb);
subplot(5, 4, 10); plot(imhist(rgb(:,:,1))); title("R");
subplot(5, 4, 11); plot(imhist(rgb(:,:,2))); title("G");
subplot(5, 4, 12); plot(imhist(rgb(:,:,3))); title("B");

subplot(5, 4, 13); imshow(lab);
subplot(5, 4, 14); plot(imhist(lab(:,:,1))); title("L");
subplot(5, 4, 15); plot(imhist(lab(:,:,2))); title("A");
subplot(5, 4, 16); plot(imhist(lab(:,:,3))); title("B");

subplot(5, 4, 17); imshow(gray);
subplot(5, 4, 18); plot(imhist(gray)); title("Gray");
end