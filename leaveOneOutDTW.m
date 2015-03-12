function metric = leaveOneOutDTW(Dataset_folder)
% leaveOneOutDTW(Dataset_folder)
% Dataset_folder: Name of the dataset folder that is to be used

if nargin < 1
    help('leaveOneOutDTW')
    return;
end

dataPoints = loadData(Dataset_folder);
k = 1;
accuracy = 0;
results = [];
targets = [];
for i=1:length(dataPoints)
    targets = [targets;dataPoints(i).class];
end

inputlen = length(dataPoints);

for i=1:inputlen
    trainData = dataPoints(:,[1:i-1,i+1:end])';
    trainTarget = targets([1:i-1,i+1:end],:);
    testData = dataPoints(:,i)';
    testTarget = targets(i,:);
    
    outputs = knnDTW(trainData,trainTarget,testData,k);
    
    for j=1:size(testTarget,1)
        if testTarget(j) == outputs(j)
            accuracy = accuracy + 1;
        end
    end
    
    results = [results;testTarget,outputs];
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