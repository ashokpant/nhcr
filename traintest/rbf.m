function model = rbf(features, outputMatFile, resultFile)
%RBF Training and Testing
%Radial Basis Function Neural Network


goal=0.001;  % default=0.0
spread= 100; % default =1.0, 15
maxRbfNeurons=100;
dispFreq=25;
trainInputs = features.inputs(:, features.trainInd);
trainTargets = features.targets(:, features.trainInd);

tic;
[net,tr]=newrb(trainInputs,trainTargets,goal,spread,maxRbfNeurons,dispFreq);
trainTime=toc;

% Test the Network
testInputs = features.inputs(:, features.testInd);
testTargets = features.targets(:, features.testInd);
outputs = sim(net, testInputs);
results = evaluation(testTargets, outputs);

results.time = trainTime;
results.epoches = tr.epoch(end);
results.hLayerNeurons = maxRbfNeurons;
results.datasetName = features.name;
results.numTrainSamples = numel(features.trainInd);
results.numValSamples = numel(features.valInd);
results.numTestSamples = numel(features.testInd);
results.algo = 'RBF';

printResults(results);
if (exist('resultFile', 'var'))
    writeResults(results, resultFile);
end
% View the Network
% view(net)

% Plots
% figure, plotroc(targets,outputs)
% figure, plotperform(tr)
% figure, plottrainstate(tr)
% figure, plotconfusion(targets,outputs)
% figure, ploterrhist(errors)
% figure, plotregression(targets,outputs)

model.name = features.name;
model.net = net;
model.results = results;
model.labels = features.labels;
model.numClasses = features.numClasses;

if (exist('outputMatFile', 'var'))
    save(outputMatFile, 'model');
end
end