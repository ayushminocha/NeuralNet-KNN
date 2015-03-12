function Model = trainSingleLayerPerceptron(input, target, options)
% trainSingleLayerPerceptron(input, target, options)
% input: Input data points used for training
% target: Target classes corresponding to the input data points
% options: struct of options including
%          options.T -> Number of Iterations (Default 100000)
%          options.eta -> Learning Rate (Default 0.4)
%          options.beta -> Activation function parameter (Default 0.5)
%          options.activationF -> Activation Function (Default 'sigmoid')
%          (Possible Values for options.activationF -> ['sigmoid','threshold'])
%
% Outputs
% Model: The generated model containing the learned weights and other
%        parameters

if nargin < 2
    help('trainSingleLayerPerceptron')
    return;
end

if nargin < 3
    options = struct;
end

optionFields = {'T','eta','beta','activationF'};
defaultOptions = {100,0.4,0.5,'sigmoid'};

for i=1:length(optionFields)
    if ~isfield(options,optionFields{i})
        options = setfield(options,optionFields{i},defaultOptions{i});
    end
end

Model = struct;
Model.beta = options.beta;
Model.activationF = options.activationF;

%%Initialization
%Weights = zeros(2,1);
Weights = rand(1,3)/100;
Weights = Weights';

input(:,3) = -1;
s = RandStream('mt19937ar','Seed',0);
indexOrder = randperm(s,39);
%%Training
for iter = 1:options.T
    for ordering = 1:size(input,1)
        inp = indexOrder(ordering);
        h = input(inp,:)*Weights;
        y = activationFunction(options.activationF,h,options);
        if y == inf
            ME = MException('trainSingleLayerPerceptron:noSuchActivationFunction','Activation function %s not found',options.activationF);
            throw(ME);
        end
        
        d = activationFunctionDerivative(options.activationF,y,options);
        if d == inf
            ME = MException('trainSingleLayerPerceptron:noSuchActivationFunction','Activation function %s not found',options.activationF);
            throw(ME);
        end
        
        for i=1:length(Weights)
            Weights(i,1) = Weights(i,1) - options.eta*(y-target(inp))*d*input(inp,i);
        end
    end
    s = RandStream('mt19937ar','Seed',iter);
    indexOrder = randperm(s,39);
end

Model.Weights = Weights;

end