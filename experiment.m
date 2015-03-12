function [result,output,metric] = experiment(Dataset_folder,method)
    dataPoints = loadData(Dataset_folder);
    inputs = [];
    targets = [];
    options = struct;
    options.T = 700000;          
    options.numHiddenLayers = 3;
    options.numNeurons = [4 4 1];
    options.eta = 0.2;
    options.beta = 0.5;
    options.k = 1;
    options.L = 1;
    
    nn_inputs = getFeatures(dataPoints,{'min','max'});
    %nn_inputs = getFeatures(dataPoints,{'min','max','mean'});
    knn_inputs = getFeatures(dataPoints,{'mean','var'});

    for i=1:length(dataPoints)
        targets = [targets;dataPoints(i).class];
    end
    
    if strcmp(method,'NN')
        [result,output,metric] = leaveOneOut(nn_inputs,targets,options);
    elseif strcmp(method,'kNN')
        [result,output,metric] = leaveOneOutKnn(knn_inputs,targets,options);
    elseif strcmp(method,'unique')
        [result,output,metric] = leaveOneOutCombination(nn_inputs,knn_inputs,targets,options);
    end

end