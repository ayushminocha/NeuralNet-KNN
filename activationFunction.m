function a = activationFunction(method,h,options)
% activationFunction(method,h,options)
% method: Activation Function Method
% h: Input
% options: Options given to the trainMultiLayerPerceptron function

    a = [];
    if strcmp(method,'threshold')
        n = length(h);
        for i=1:n
            if h(i)>0
                a = [a 1];
            else
                a = [a 0];
            end
        end        
    elseif strcmp(method,'sigmoid')
        n = length(h);
        for i=1:n
            a = [a 1/(1+exp(-1*options.beta*h(i)))];
        end         
    else
        a = inf;
    end            
    
end