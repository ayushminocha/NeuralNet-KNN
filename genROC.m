function [tpr,fpr,thresh] = genROC(result,outputs)
    
    [tpr,fpr,thresh] = roc(result(:,1)',outputs');
    plotroc(result(:,1)',outputs');

end