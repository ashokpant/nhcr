%% Preprocessing Demo
% Ashok Kumar Pant
% ashokpant87@gmail.com
% Date: 5 Apr 2012
addpath(genpath(pwd))
%% Read Image
img_rgb = imread('data/ka.jpg');
figure('units', 'normalized', 'outerposition', [0 0 0.5 0.5]);
subplot(3, 3, 1), imshow(img_rgb);
imshow(img_rgb);
title('Given Image','FontSize',14);
%% 1. RGB to Gray Scale Conversion
img_gray = rgb2gray(img_rgb);
subplot(3, 3, 2), imshow(img_gray);
title('Gray Image', 'FontSize', 14);
  axis square;
%% 2. Noise Removal
img_denoised = medfilt2(img_gray);
img_denoised = img_denoised(2:end - 1, 2:end - 1); % remove corner pixels
subplot(3, 3, 3), imshow(img_denoised);
title('Denoised Image', 'FontSize', 14);
%% 3.  Image Binarization
img_binarized = im2bw(img_denoised);
subplot(3, 3, 4), imshow(img_binarized);
title('Binarized Image', 'FontSize', 14);
%% 4.  Image Inversion
img_inverted = ~ img_binarized;
subplot(3, 3, 5), imshow(img_inverted);
title('Inverted Image', 'FontSize', 14);
%% 5. Universe of Discourse
img_discoursed = universe_of_discourse(img_inverted);
subplot(3, 3, 6), imshow(img_discoursed);
title('Discoursed Image', 'FontSize', 14);
%% 6. Size Normalization
img_normalized = imresize(img_discoursed, [36 36]);
subplot(3, 3, 7), imshow(img_normalized);
title('Resized Image (36x36)', 'FontSize', 14);
%% 7. Image Skeletonization
img_skeletonized = bwmorph(img_normalized, 'skel', 'inf');
subplot(3, 3, 8), imshow(img_skeletonized);
title('Skeletonized Image', 'FontSize', 14);