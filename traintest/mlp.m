function model = mlp(features, outputMatFile, resultFile)
%MLP Training and Testing
%Feedforward BackpropagationNeural Network with gradient descent momentum and adaptive learning rate learning

% Create a Feedforward Pattern Recognition Network
% Feedforward network with one input layer, one hidden layer and
% one output layer.

hLayerNeurons = 80;

net = feedforwardnet(hLayerNeurons);

net.layers{1}.transferFcn = 'tansig'; % tansig(n) = 2/(1+exp(-2*n))-1
net.layers{2}.transferFcn = 'tansig';

% Setup Division of Data for Training, Validation, Testing
net.divideFcn = 'divideind';
net.divideMode = 'sample'; % Divide up every sample
net.divideParam.trainInd = features.trainInd;
net.divideParam.valInd = features.valInd;
net.divideParam.testInd = features.testInd;

net.trainFcn = 'traingdx'; % Gradiant descent momentum with variable learning rate

net.performFcn = 'mse'; % Mean squared error
% net.trainParam.goal = 0;
% net.trainParam.lr=0.01;
% net.trainParam.lr_inc=1.05;
% net.trainParam.lr_dec=0.7;
% net.trainParam.max_fail=6;
% net.trainParam.max_perf_inc=1.04;
% net.trainParam.mc=0.9;
% net.trainParam.min_grad=1e-10;
%net.trainParam.epochs = 1000;

net.trainParam.goal = 0;
net.trainParam.lr = 0.3;
net.trainParam.lr_inc = 1.05;
net.trainParam.lr_dec = 0.7;
net.trainParam.max_fail = 6;
net.trainParam.max_perf_inc = 1.04;
net.trainParam.mc = 0.9;
net.trainParam.min_grad = 1e-10;
net.trainParam.epochs = 1000;

net.plotFcns = {'plotroc', 'plotperform', 'plottrainstate', 'ploterrhist', ...
  'plotregression', 'plotfit', 'plotconfusion'};

% Train the Network
% [net,tr] = train(net,inputs,targets,'useGPU','yes');
[net, tr] = train(net, features.inputs, features.targets);

% Test the Network
testInputs = features.inputs(:, features.testInd);
testTargets = features.targets(:, features.testInd);
outputs = sim(net, testInputs);
results = evaluation(testTargets, outputs);

results.time = tr.time(end);
results.epoches = tr.epoch(end);
results.hLayerNeurons = hLayerNeurons;
results.datasetName = features.name;
results.numTrainSamples = numel(features.trainInd);
results.numValSamples = numel(features.valInd);
results.numTestSamples = numel(features.testInd);
results.algo = 'MLP';

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