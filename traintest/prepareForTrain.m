function output = prepareForTrain(dataset, trainRatio, testRatio, valRatio)
numSamples = numel(dataset.data);

trainR = 1.0;
testR =  0.0;
valR =   0.0;

if nargin==2
    trainR = trainRatio;
end

if nargin==3
    trainR = trainRatio;
    testR = testRatio;
end

if nargin==4
    trainR = trainRatio;
    testR = testRatio;
    valR = valRatio;
end

dMode = '1'; %1.random (default), 2.inteleaved indices , 3.block of indices
switch dMode
    case '1'
        [trainInd,valInd,testInd] = dividerand(numSamples,trainR,valR,testR);
    case '2'
        [trainInd,valInd,testInd] = divideint(numSamples,trainR,valR,testR);
    case '3'
        [trainInd,valInd,testInd] = divideblock(numSamples,trainR,valR,testR);
end

inputs = [];
targets = [];
for i = 1:numSamples
    inputs = [inputs dataset.data(i).feature'];
    targets = [targets dataset.data(i).target'];
end

%[inputs,settings]=mapminmax(inputs);

output.name = dataset.name;
output.numClasses = dataset.numClasses;
output.labels = dataset.labels;
output.inputs = inputs;
output.targets = targets;
%output.settings= settings;
output.trainRatio = trainR;
output.valRatio = valR;
output.testRatio = testR;
output.trainInd = trainInd;
output.valInd = valInd;
output.testInd = testInd;
end