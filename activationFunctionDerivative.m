function d = activationFunctionDerivative(method,a,options)
% activationFunctionDerivative(method,a,options)
% method: Activation Function Method
% a: Activation of the neuron
% options: Options given to the trainMultiLayerPerceptron function

    d = inf;
    if strcmp(method,'threshold')
        d = 1;
    elseif strcmp(method,'sigmoid')
        d = a*(1-a);
    end
    
end