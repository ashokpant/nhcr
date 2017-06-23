function config = setup()
    DATA_DIR = 'data';
    config.NUMERALS_IMG=strcat(DATA_DIR,'/numerals.jpg');
    config.VOWELS_IMG=strcat(DATA_DIR,'/vowels.jpg');
    config.CONSONANTS_IMG=strcat(DATA_DIR,'/consonants.jpg');

    config.SAMPLES_MAT_FILE=strcat(DATA_DIR,'/models/samples.mat');
      
    config.NUMERALS_MODEL_MLP = strcat(DATA_DIR,'/models/numerals_model_mlp.mat');
    config.VOWELS_MODEL_MLP = strcat(DATA_DIR,'/models/vowels_model_mlp.mat');
    config.CONSONANTS_MODEL_MLP = strcat(DATA_DIR,'/models/consonants_model_mlp.mat');
    
    config.NUMERALS_MODEL_RBF = strcat(DATA_DIR,'/models/numerals_model_rbf.mat');
    config.VOWELS_MODEL_RBF = strcat(DATA_DIR,'/models/vowels_model_rbf.mat');
    config.CONSONANTS_MODEL_RBF = strcat(DATA_DIR,'/models/consonants_model_rbf.mat');
end