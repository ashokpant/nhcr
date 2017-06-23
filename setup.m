function config = setup()
    addpath(genpath(pwd))
    config.NUMERALS='Numerals';
    config.VOWELS ='Vowels';
    config.CONSONANTS='Consonants';
    
    BASE_DIR = 'data';
    config.NUMERALS_DATASET_DIR=strcat(BASE_DIR,'/datasets/numerals/');
    config.VOWELS_DATASET_DIR=strcat(BASE_DIR,'/datasets/vowels/');
    config.CONSONANTS_DATASET_DIR=strcat(BASE_DIR,'/datasets/consonants/');

    OUTPUT_DIR=strcat(BASE_DIR,'/outputs');
    if ~exist(OUTPUT_DIR,'dir')
        mkdir(OUTPUT_DIR)
    end
    config.NUMERALS_DATASET=strcat(OUTPUT_DIR,'/numerals.mat');
    config.VOWELS_DATASET=strcat(OUTPUT_DIR,'/vowels.mat');
    config.CONSONANTS_DATASET=strcat(OUTPUT_DIR,'/consonants.mat');

    config.NUMERALS_DATASET_PP = strcat(OUTPUT_DIR,'/numerals_pp.mat');
    config.VOWELS_DATASET_PP = strcat(OUTPUT_DIR,'/vowels_pp.mat');
    config.CONSONANTS_DATASET_PP = strcat(OUTPUT_DIR,'/consonants_pp.mat');
    
    
    config.NUMERALS_DATASET_FE = strcat(OUTPUT_DIR,'/numerals_fe.mat');
    config.VOWELS_DATASET_FE = strcat(OUTPUT_DIR,'/vowels_fe.mat');
    config.CONSONANTS_DATASET_FE = strcat(OUTPUT_DIR,'/consonants_fe.mat');
    
    config.NUMERALS_DATASET_MODEL_MLP = strcat(OUTPUT_DIR,'/numerals_model_mlp.mat');
    config.VOWELS_DATASET_MODEL_MLP = strcat(OUTPUT_DIR,'/vowels_model_mlp.mat');
    config.CONSONANTS_DATASET_MODEL_MLP = strcat(OUTPUT_DIR,'/consonants_model_mlp.mat');
    
    config.NUMERALS_DATASET_MODEL_RBF = strcat(OUTPUT_DIR,'/numerals_model_rbf.mat');
    config.VOWELS_DATASET_MODEL_RBF = strcat(OUTPUT_DIR,'/vowels_model_rbf.mat');
    config.CONSONANTS_DATASET_MODEL_RBF = strcat(OUTPUT_DIR,'/consonants_model_rbf.mat');
    
    config.RESULTS_EXCEL_FILE=strcat(OUTPUT_DIR,'/results.csv');
    
    SAMPLE_CHARACTER_DIR=strcat(BASE_DIR,'/samples/');
    config.SAMPLE_OPTICAL_NUMERALS_DIR=strcat(SAMPLE_CHARACTER_DIR,'/optical/numerals/');
    config.SAMPLE_OPTICAL_VOWELS_DIR=strcat(SAMPLE_CHARACTER_DIR,'/optical/vowels/');
    config.SAMPLE_OPTICAL_CONSONANTS_DIR=strcat(SAMPLE_CHARACTER_DIR,'/optical/consonants/');
    
    config.SAMPLE_HANDWRITTEN_NUMERALS_DIR=strcat(SAMPLE_CHARACTER_DIR,'/handwritten/numerals/');
    config.SAMPLE_HANDWRITTEN_VOWELS_DIR=strcat(SAMPLE_CHARACTER_DIR,'/handwritten/vowels/');
    config.SAMPLE_HANDWRITTEN_CONSONANTS_DIR=strcat(SAMPLE_CHARACTER_DIR,'/handwritten/consonants/');
        
    config.SAMPLES_MAT_FILE=strcat(OUTPUT_DIR,'/samples.mat');
    
    config.BASE_DIR = BASE_DIR;
    config.OUTPUT_DIR= OUTPUT_DIR;
end