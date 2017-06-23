function writeResults(results, fileName)
datasetName = results.datasetName;
trainSize = num2str(results.numTrainSamples);
valSize = num2str(results.numValSamples);
testSize = num2str(results.numTestSamples);
recognitionAlgo = results.algo;
epoches = num2str(results.epoches);
hLayerNeurons = num2str(results.hLayerNeurons);
tTime = sprintf('%.2f', results.time);
avgAccuray = sprintf('%.2f', results.avgAccuracy);
errRate = sprintf('%.2f', results.errRate);
precisionMicro = sprintf('%.2f', results.precisionMicro);
recallMicro = sprintf('%.2f', results.recallMicro);
fscoreMicro = sprintf('%.2f', results.fscoreMicro);
precisionMacro = sprintf('%.2f', results.precisionMacro);
recallMacro = sprintf('%.2f', results.recallMacro);
fscoreMacro = sprintf('%.2f', results.fscoreMacro);
sep = ',';
if exist(fileName, 'file') == 0
    header = strcat('Database', sep, 'Training Samples', sep, 'Valiadation Samples', sep, ...
      'Testing Samples', sep, 'Recognition Algorithm', sep, 'Hidden Layer Neurons', sep, ...
      'No. of Epoches', sep, 'Training Time(sec)', sep, 'Avg. System Accuracy(%)', sep, 'System Error(%)', sep, ...
      'PrecesionMicro(%)', sep, 'RecallMicro(%)', sep, 'FscoreMicro(%)', sep, 'PrecesionMacro(%)', sep, ...
      'RecallMacro(%)', sep, 'FscoreMacro(%)');
 
    data = strcat(datasetName, sep, trainSize, sep, valSize, sep, ...
      testSize, sep, recognitionAlgo, sep, hLayerNeurons, sep, ...
      epoches, sep, tTime, sep, avgAccuray, sep, errRate, sep, ...
      precisionMicro, sep, recallMicro, sep, fscoreMicro, sep, precisionMacro, sep, ...
      recallMacro, sep, fscoreMacro);
 
    fid = fopen(fileName, 'w');
    fprintf(fid, '%s\n', header);
    fprintf(fid, '%s\n', data);
    fclose(fid);
else
    data = strcat(datasetName, sep, trainSize, sep, valSize, sep, ...
      testSize, sep, recognitionAlgo, sep, hLayerNeurons, sep, ...
      epoches, sep, tTime, sep, avgAccuray, sep, errRate, sep, ...
      precisionMicro, sep, recallMicro, sep, fscoreMicro, sep, precisionMacro, sep, ...
      recallMacro, sep, fscoreMacro);
 
    fid = fopen(fileName, 'a');
    fprintf(fid, '%s\n', data);
    fclose(fid);
end
end
