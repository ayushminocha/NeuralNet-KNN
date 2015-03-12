function Model = trainMultiLayerPerceptron(input, target, options)
% trainMultiLayerPerceptron(input, targets, options)
% input: Input data points used for training
% target: Target classes corresponding to the input data points
% options: struct of options including
%          options.T -> Number of Iterations (Default 100000)
%          options.eta -> Learning Rate (Default 0.4)
%          options.numHiddenLayers -> Number of layers in the MLP (Default 2)
%          options.numNeurons -> 1XnumLayers array containing the number of neurons in each layer (Default [2 1])
%          options.beta -> Activation function parameter (Default 0.5)
%          options.activationF -> Activation Function (Default 'sigmoid')
%          (Possible Values for options.activationF -> ['sigmoid','threshold'])
%
% Outputs
% Model: The generated model containing the learned weights and other
%        parameters

if nargin < 2
    help('trainMultiLayerPerceptron')
    return;
end

%%Initialize options
if nargin < 3
    options = struct;
end

optionFields = {'T','eta','numHiddenLayers','numNeurons','beta','activationF'};
defaultOptions = {100000,0.4,2,[2 1],0.5,'sigmoid'};

for i=1:length(optionFields)
    if ~isfield(options,optionFields{i})
        options = setfield(options,optionFields{i},defaultOptions{i});
    end
end

Model = struct;
Model.numHiddenLayers = options.numHiddenLayers;
Model.numNeurons = options.numNeurons;
Model.beta = options.beta;
Model.activationF = options.activationF;
Model.Weights = trainMLP(input,target,options);

end