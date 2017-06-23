function  bwImage = image_binarization(image)

threshold=graythresh(image); % Otsu's method for finding global threshold
bwImage = im2bw(image,threshold);
