function samples = readClassSamples(config)
% Image Database Creation
% Date : 2012/02/11
% Author: Ashok Kumar Pant
% Institute of Science and Technology, Computer Science, Tribhuvan
% University, Nepal

if ~ exist('config', 'var')
    config = setup();
end

outputMatFile = config.SAMPLES_MAT_FILE;

if exist('outputMatFile', 'file')
    samples = load(outputMatFile);
    return;
end

optNumerals = loadImages(config.SAMPLE_OPTICAL_NUMERALS_DIR);
optVowels = loadImages(config.SAMPLE_OPTICAL_VOWELS_DIR);
optConsonants = loadImages(config.SAMPLE_OPTICAL_CONSONANTS_DIR);

handNumerals = loadImages(config.SAMPLE_HANDWRITTEN_NUMERALS_DIR);
handVowels = loadImages(config.SAMPLE_HANDWRITTEN_VOWELS_DIR);
handConsonants = loadImages(config.SAMPLE_HANDWRITTEN_CONSONANTS_DIR);

samples.numeralsOptical = optNumerals;
samples.vowelsOptical = optVowels;
samples.consonantsOptical = optConsonants;

samples.numeralsHandwritten = handNumerals;
samples.vowelsHandwritten = handVowels;
samples.consonantsHandwritten = handConsonants;

if exist('outputMatFile', 'var')
    save(outputMatFile, 'samples');
end
end

function images = loadImages(folderName)
dirOutput = dir(fullfile(folderName, '*.png'));
fileNames = {dirOutput.name};
images = containers.Map('KeyType', 'int32', 'ValueType', 'any');
for j = 1:numel(fileNames)
    [~, name, ~] = fileparts(fileNames{j});
    imgPath = strcat(folderName, fileNames{j});
    x = imread(imgPath);
    x = imresize(x, [36 36]);
    images(str2num(name)) = x;
end
end