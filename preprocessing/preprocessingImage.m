function image = preprocessingImage(img)
% image : input image
% Date : 2012/02/15
% Author: Ashok Kumar Pant
% Institute of Science and Technology, Computer Science, Tribhuvan
% University, Nepal
    
% Color normalize
if numel(size(img)) == 3
    img = rgb2gray(img);
end

% Noise Removal (Median Filter)
img = image_denoise(img);
img = img(2:end-1,2:end-1); %remove corner pixels

%Image Binarization (Otsu's Methos)
% Otsu's method of  image thresholding is a nonparametric and
% unsupervised method of automatic thresholding. An optimal threshold is
% selected by the discriminant criterian, i.e., by maximizing the
% separability of the resultant classes in gray levels.
img = image_binarization(img);

% Image Inversion (black background white forgraound)
% Normally,acquired images have white background and black foregroun
img = image_inversion(img);

% Universe of discourse of an image
img = universe_of_discourse(img);

% Image dilate
se=strel('square',2);
img=imdilate(img,se);

% Size Normalization (36x36)
img = size_normalization(img,[36 36]);

% Image Thinning (skeletonization)
img = image_thinning(img);
image = img;

