function Model = trainMultiLayerPerceptronMATLAB(input, target, options)
% trainMultiLayerPerceptron(input, targets, options)
% input: input vector of length Nx2, N is the number of datapoints
% target: target vector of length Nx1
% options: struct of options including
%          options.T -> Number of Iterations (Default 100)
%          options.eta -> Learning Rate (Default 0.4)
%          options.numHiddenLayers -> Number of layers in the MLP (Default 2)
%          options.numNeurons -> 1XnumLayers array containing the number of neurons in each layer (Default [2 1])
%          options.beta -> Activation function parameter (Default 0.5)
%          options.activationF -> Activation Function (Default 'sigmoid')
%          (Possible Values for options.activationF -> ['sigmoid','threshold'])

if nargin < 2
    help('trainMultiLayerPerceptron')
    return;
end

%%Initialize options
if nargin < 3
    options = struct;
end

optionFields = {'T','eta','numHiddenLayers','numNeurons','beta','activationF'};
defaultOptions = {1000,0.4,2,[2 1],0.5,'sigmoid'};

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

%%Initialization

Weights = cell(1,options.numHiddenLayers-1); 
Activations = cell(1,options.numHiddenLayers);
Delta = cell(1,options.numHiddenLayers);

for i=1:length(Weights)
     Weights{i} = rand(options.numNeurons(i)+1,options.numNeurons(i+1))./10;     %%plus 1 for the bias
end

%%Add bias input
input(:,size(input,2)+1) = -1;

s = RandStream('mt19937ar','Seed',0);
indexOrder = randperm(s,size(input,1));

%%Training
for iter = 1:options.T
    for ordering = 1:size(input,1)
        %%Find Activations
        inp = indexOrder(ordering);
        Activations{1} = input(inp,:); %%First layer activations are the inputs
        
        for levels = 2:options.numHiddenLayers
             h = Activations{levels-1}*Weights{levels-1};
             Activations{levels} = activationFunction(options.activationF,h,options);
             Delta{levels} = zeros(size(Activations{levels})); %%Initializing Delta to be of the same size as the Activations = numNeurons in each layer
             Activations{levels} = [Activations{levels} -1];  %%Adding the values for the Bias           
             if Activations{levels} == inf
                 ME = MException('trainSingleLayerPerceptron:noSuchActivationFunction','Activation function %s not found',options.activationF);
                 throw(ME);
             end
        end
        
        %%Update weights using Back Propagation
        %%Weight update for the last set of weights connecting the hidden layer
        %%with the output layer
        for i=1:options.numNeurons(options.numHiddenLayers-1)+1
            for j=1:options.numNeurons(options.numHiddenLayers)
                Delta{options.numHiddenLayers}(j) = (Activations{options.numHiddenLayers}(j) - target(inp,j)) * Activations{options.numHiddenLayers}(j) * (1 - Activations{options.numHiddenLayers}(j));
                Weights{length(Weights)}(i,j) = Weights{length(Weights)}(i,j) - options.eta*Delta{options.numHiddenLayers}(j)*Activations{options.numHiddenLayers-1}(i);
            end
        end
        
        for levels = length(Weights)-1:-1:1
            %%Weight update rule for other layers
            for i=1:options.numNeurons(levels)+1
                for j=1:options.numNeurons(levels+1)
                    Delta{levels+1}(j) = Activations{levels+1}(j) * (1 - Activations{levels+1}(j)) * (Weights{levels+1}(j,:) * Delta{levels+2}');
                    Weights{levels}(i,j) = Weights{levels}(i,j) - options.eta*Delta{levels+1}(j)*Activations{levels}(i);
                end
            end
        end
    end
    s = RandStream('mt19937ar','Seed',iter);
    indexOrder = randperm(s,size(input,1));
end

Model.Weights = Weights;

end