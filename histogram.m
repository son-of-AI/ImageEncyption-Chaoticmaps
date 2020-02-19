figure
a = imread('encypted_iiest.jpg');
subplot(3,2,1)
imhist(a)
title('histogram 2D map');
b = imread('encrypted_image.jpg');
subplot(3,2,2)
imhist(b)
title('Histogram of 3D');
