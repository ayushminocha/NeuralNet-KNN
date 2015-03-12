function [results,outputs,metric] = leaveOneOut(inputs,targets,options)
% leaveOneOut(inputs,targets,options)
% inputs: Input data points including training and testing
% targets: Target classes corresponding to the input data points
% options: Options for Neural Network
%
% Outputs
% results: matrix of targets (column 1) and generated output classes
%          (column 2)
% outputs: vector of the outputs generated by the neural network (between 0 and 1)
% metric: structure containing accuracy, precision, recall, sensitivity,
%         specificity, F-measure and Confusion Matrix

inputlen = size(inputs,1);

accuracy = 0;
results = []; %%Two column, one for target and second for output

outputs = [];

for i=1:inputlen
         
    trainData = inputs([1:i-1,i+1:end],:);
    trainTarget = targets([1:i-1,i+1:end],:);
    testData = inputs(i,:);
    testTarget = targets(i,:);        

    model = trainMultiLayerPerceptron(trainData, trainTarget, options);
    testOutput = testMultiLayerPerceptron(testData,testTarget,model);    
    
    outputs = [outputs;testOutput];
    
    for j=1:size(testOutput,1)
     
        if testOutput(j) >= 0.5
            testOutput(j) = 1;
        else
            testOutput(j) = 0;
        end 
        
        if testTarget(j) == testOutput(j)
            accuracy = accuracy + 1;
        end
    end

    results = [results;testTarget,testOutput];    
    
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