function [results,outputs,metric] = leaveOneOutKnn(inputs,targets,options)
% leaveOneOutKnn(inputs,targets,options)
% inputs: Input data points including training and testing
% targets: Target classes corresponding to the input data points
% options: Struct of options for kNN
%          options.k -> Number of neighbours to consider (Default 1)
%          options.L -> 1 for L1 norm, 2 for L2 norm, 3 for L3 norm (Default 2)
%
% Outputs
% results: matrix of targets (column 1) and generated output classes
%          (column 2)
% outputs: vector of the outputs generated by the tricube kernel (between 0 and 1)
% metric: structure containing accuracy, precision, recall, sensitivity,
%         specificity, F-measure and Confusion Matrix

if nargin < 2
    help('leaveOneOutKnn')
    return;
end

%%Initialize options
if nargin < 3
    options = struct;
end

optionFields = {'k','L'};
defaultOptions = {1,2};

for i=1:length(optionFields)
    if ~isfield(options,optionFields{i})
        options = setfield(options,optionFields{i},defaultOptions{i});
    end
end

inputlen = size(inputs,1);

accuracy = 0;
results = []; %%Two column, one for target and second for output

outputs = [];

for i=1:inputlen
    
    trainData = inputs([1:i-1,i+1:end],:);
    trainTarget = targets([1:i-1,i+1:end],:);
    testData = inputs(i,:);
    testTarget = targets(i,:);
    
    root = buildkdTree(trainData,trainTarget,1);
    testOutput = testkNN(testData,root,options.k,options.L);

    outputs = [outputs;testOutput(:,2)];
    
    for j=1:size(testOutput,1)

        if testTarget(j) == testOutput(j,2)
            accuracy = accuracy + 1;
        end
    end

    results = [results;testTarget,testOutput(:,2)];    
    
end

accuracy = accuracy/inputlen;
tempVar1 = sum(results,2);
tempVar2 = results(:,1) - results(:,2);

truePositives = length(find(tempVar1 == 2));
trueNegatives = length(find(tempVar1 == 0));
falsePositives = length(find(tempVar2 == -1));
falseNegatives = length(find(tempVar2 == 1));

sensitivity = truePositives/(truePositives + falseNegatives);
specificity = trueNegatives/(trueNegatives + falsePositives);
precision = truePositives/(truePositives + falsePositives);
recall = truePositives/(truePositives + falseNegatives);

metric = struct;
metric.accuracy = accuracy;
metric.precision = precision;
metric.recall = recall;
metric.sensitivity = sensitivity;
metric.specificity = specificity;
metric.Fmeasure = 2*(precision*recall)/(precision+recall);
metric.ConfMatrix = [truePositives,falseNegatives;falsePositives,trueNegatives];