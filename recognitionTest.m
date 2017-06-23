function recognitionTest(imageFile)
clear; clc; close all;
disp('Testing Input Image (numerals only - for now)');
config = setup();

if ~exist('imageFile','var')
    imageFile = strcat(config.BASE_DIR, '/three.png');
end

mlpModel = load(config.NUMERALS_DATASET_MODEL_MLP);
mlpModel = mlpModel.model;
rbfModel = load(config.NUMERALS_DATASET_MODEL_RBF);
rbfModel = rbfModel.model;
labels = mlpModel.labels;
samples = load(config.SAMPLES_MAT_FILE); %readClassSamples(config);
samples = samples.samples;

image = imread(imageFile);
img = preprocessingImage(image);
features = extractFeaturesFromImage(img);

output1 = sim(mlpModel.net, features');
[value1, index1] = max(output1);

output2 = sim(rbfModel.net, features');
[value2, index2] = max(output2);

text1 = strcat(labels(index1), ' : ', num2str(value1));
text2 = strcat(labels(index2), ' : ', num2str(value2));

figure('units', 'normalized', 'outerposition', [0 0 0.3 0.3]);
subplot(1, 3, 1); axis([0 36 0 36]); axis('off'); imshow(image); title('Input');
subplot(1, 3, 2); axis([0 36 0 36]); axis('off'); imshow(samples.numeralsOptical(index1 - 1)); text(1, 40, text1, 'FontSize', 14); title('MLP Output');
subplot(1, 3, 3); axis([0 36 0 36]); axis('off'); imshow(samples.numeralsOptical(index2 - 1)); text(1, 40, text2, 'FontSize', 14); title('RBF Output');
end
