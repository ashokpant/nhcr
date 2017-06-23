function [features] = extractFeaturesFromImage(image)
%image = preprocessed image

features = [];
% Geometric Feature Extraction
% Geometric Feature Extraction is based on the paper "M. Blumenstein, B.
% Verma, H. Basli, "A novel feature extraction technique for the
% recognition of segmented Handwritten characters", IEEE Proceeding of
% seventh International Conference on document Analysis and Recognition,
% 2003, vol 1,pp. 137-141."
% Given 36x36 image into 3x3 zones and extracts features for each zone

[row, col] = size(image);
zoneHeight = row / 3; % 12 pixels
zoneWidth = col / 3; % 12 pixels

zone11 = image(1:zoneHeight, 1:zoneWidth); %imshow(zone11);pause;
zone12 = image(1:zoneHeight, (zoneWidth + 1):2 * zoneWidth); %imshow(zone12);pause;
zone13 = image(1:zoneHeight, (2 * zoneWidth + 1):end); %imshow(zone13);pause;

zone21 = image((zoneHeight + 1):2 * zoneHeight, 1:zoneWidth); %imshow(zone21);pause;
zone22 = image((zoneHeight + 1):2 * zoneHeight, (zoneWidth + 1):2 * zoneWidth); %imshow(zone22);pause;
zone23 = image((zoneHeight + 1):2 * zoneHeight, (2 * zoneWidth + 1):end); %imshow(zone23);pause;

zone31 = image((2 * zoneHeight + 1):end, 1:zoneWidth); %imshow(zone31);pause;
zone32 = image((2 * zoneHeight + 1):end, (zoneWidth + 1):2 * zoneWidth); %imshow(zone32);pause;
zone33 = image((2 * zoneHeight + 1):end, (2 * zoneWidth + 1):end); %imshow(zone33);pause;

zone11Features = lineclassifier(zone11);
zone12Features = lineclassifier(zone12);
zone13Features = lineclassifier(zone13);

zone21Features = lineclassifier(zone21);
zone22Features = lineclassifier(zone22);
zone23Features = lineclassifier(zone23);

zone31Features = lineclassifier(zone31);
zone32Features = lineclassifier(zone32);
zone33Features = lineclassifier(zone33);

features = [zone11Features, zone12Features, zone13Features, zone21Features, zone22Features, zone23Features, zone31Features, zone32Features, zone33Features];

% Moment Invariants Features
% Normalized central moments are calculated from each image. These regional
% descriptors form seven elememt feature vector as there are seven moments
% invarients.Normalized Central Moments are independ of transalation,
% rotation, scalling and can be used in pattern identification.
moments = invmoments(image);
features = [features, moments];

% FFT Features
%  subplot(1,3,1),imshow(image1);
%  subplot(1,3,2),imshow(abs(fft2(image1)));
%  subplot(1,3,3),imshow(ifft2(abs(fft2(image1))));
%     maxFftCoeff=99;
%     imgFft=abs(fft2(image));
%     imgUniqueFft=sort(unique(imgFft),'descend');
%     fftFeatures=imgUniqueFft(1:maxFftCoeff);
%     features=[features,fftFeatures];

% Euler Number Feature
% Euler number is the difference between number of objects and number of
% holes present in given image. Euler number is extraced from whole image.
eulerNumber = bweuler(image);
features = [features, eulerNumber];

% Zoning Density Features
zoneArea = zoneHeight * zoneWidth;
zone11Density = double(sum(sum(zone11)) / zoneArea);
zone12Density = double(sum(sum(zone12)) / zoneArea);
zone13Density = double(sum(sum(zone13)) / zoneArea);
zone21Density = double(sum(sum(zone21)) / zoneArea);
zone22Density = double(sum(sum(zone22)) / zoneArea);
zone23Density = double(sum(sum(zone23)) / zoneArea);
zone31Density = double(sum(sum(zone31)) / zoneArea);
zone32Density = double(sum(sum(zone32)) / zoneArea);
zone33Density = double(sum(sum(zone33)) / zoneArea);
zoneFeautes = [zone11Density, zone12Density, zone13Density, zone21Density, zone22Density, zone23Density, zone31Density, zone32Density, zone33Density];

features = [features, zoneFeautes];

% Centroid of Image
% Centroid specifies the center of mass of the region. Note that the first element of Centroid is the horizontal coordinate (or x-coordinate) of the center of mass, and the second element is the vertical coordinate (or y-coordinate). All other elements of Centroid are in order of dimension.
x = ones(row, 1) * (1:col); % Matrix with each pixel set to its x coordinate
y = (1:row)'*ones(1,col);   % Matrix with each pixel set to its y coordinate

area = sum(sum(image));
meanx = sum(sum(double(image) .* x)) / area;
meany = sum(sum(double(image) .* y)) / area;

centroid = [meanx, meany];
features = [features, centroid];

% Eccentricity
e = eccentricity(image, centroid);
features = [features, e];
end