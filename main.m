disp('Nepali Handwritten Character Recognition')
disp('-----------------------------------------')
mode = 'Numerals'; % Numerals, Vowels, Consonants
reExtractFeatures = false;

disp('Setting up the configurations ...')
  config = setup();

switch(mode)
    case 'Numerals'
        disp('Operation mode: Numerals')
        datasetDir = config.NUMERALS_DATASET_DIR;
        datasetName = config.NUMERALS;
        datasetMatFile = config.NUMERALS_DATASET;
        preprocessedMatFile = config.NUMERALS_DATASET_PP;
        featuresMatFile = config.NUMERALS_DATASET_FE;
        mlpModelMatFile = config.NUMERALS_DATASET_MODEL_MLP;
        rbfModelMatFile = config.NUMERALS_DATASET_MODEL_RBF;
    case 'Vowels'
        disp('Operation mode: Vowels')
        datasetDir = config.VOWELS_DATASET_DIR;
        datasetName = config.VOWELS;
        datasetMatFile = config.VOWELS_DATASET;
        preprocessedMatFile = config.VOWELS_DATASET_PP;
        featuresMatFile = config.VOWELS_DATASET_FE;
        mlpModelMatFile = config.VOWELS_DATASET_MODEL_MLP;
        rbfModelMatFile = config.VOWELS_DATASET_MODEL_RBF;
    case 'Consonants'
        disp('Operation mode: Consonants')
        datasetDir = config.CONSONANTS_DATASET_DIR;
        datasetName = config.CONSONANTS;
        datasetMatFile = config.CONSONANTS_DATASET;
        preprocessedMatFile = config.CONSONANTS_DATASET_PP;
        featuresMatFile = config.CONSONANTS_DATASET_FE;
        mlpModelMatFile = config.CONSONANTS_DATASET_MODEL_MLP;
        rbfModelMatFile = config.CONSONANTS_DATASET_MODEL_RBF;
end

  disp('Creating calss samples ...')
  samples = readClassSamples(config);
  
if (reExtractFeatures || ~ exist(featuresMatFile, 'file'))
    disp('Creating the dataset ...')
      dataset = createDataset(datasetDir, datasetName, datasetMatFile);

    disp('Preprocessing the images ...')
      datasetPP = preprocessing(dataset, preprocessedMatFile);
 
    disp('Extracting features ...')
      datasetFE = extractFeatures(datasetPP, featuresMatFile);
else
    disp('Loading features ...')
      datasetFE = load(featuresMatFile);
    datasetFE = datasetFE.dataset;
end

disp('Preparing for training ...')
  features = prepareForTrain(datasetFE, 0.8, 0.2);

disp('Trainig MLP ...')
  modelMLP = mlp(features, mlpModelMatFile, config.RESULTS_EXCEL_FILE);

disp('Trainig RBF ...')
  modelRBF = rbf(features, rbfModelMatFile, config.RESULTS_EXCEL_FILE);
