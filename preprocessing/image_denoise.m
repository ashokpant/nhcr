function  median_filtered_image = image_denoise(image)

% mask = ones(3) / 9;
% mean_filtered_image =im2uint8(imfilter(im2double(image), mask, 'replicate'));
% 

neighbourhood =[3,3];
median_filtered_image = medfilt2(image, neighbourhood);

