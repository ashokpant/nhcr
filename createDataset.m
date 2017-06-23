function dataset = createDataset(datasetPath, datasetName, outputMatFile)
% Image Database Creation
% Date : 2012/02/11
% Author: Ashok Kumar Pant
% Institute of Science and Technology, Computer Science, Tribhuvan
% University, Nepal

% Load images into matlab database
fileFolder = fullfile(datasetPath);
dirs = dir(fileFolder);
data = [];
iClass=1;
labels=containers.Map('KeyType','int32','ValueType','char');
for i=3:numel(dirs)
    if (dirs(i).isdir==1)
        dirOutput = dir(fullfile(fileFolder,dirs(i).name,'*.jpg'));
        fileNames = {dirOutput.name}';
        for j=1:numel(fileNames)
            x=imread(fullfile(fileFolder,dirs(i).name,fileNames{j}));
            datum.image = x;
            datum.class=iClass;
            data = [data; datum];
        end
        labels(iClass) = dirs(i).name;
        iClass=iClass+1;
    end
end

if exist('datasetName','var')
    dataset.name=datasetName;
end

dataset.numClasses=iClass-1;
dataset.data=data;
dataset.labels = labels;

if exist('outputMatFile','var')
    save(outputMatFile,'dataset');
end

