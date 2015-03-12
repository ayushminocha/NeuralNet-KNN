function input = getFeatures(dataPoints,featNames)
% getFeatures(dataPoints,featNames)
% dataPoints: Data Points returned by the loadData() function
% featNames: A cell containing the names of features to be used.
%            Eg. {'mean','var'} for mean and variance
%            Supported Features: mean, var (variance), rms (root mean
%            square), min (minimum), max (maximum), skewness, kurtosis
%
% Outputs
% input: The generated input vector

    numFeat = length(featNames);
    input = [];

    for i=1:numFeat
        temp = [];
        if strcmp(featNames{i},'mean')
            for j=1:length(dataPoints)
                temp = [temp;mean(dataPoints(j).points(:,1)),mean(dataPoints(j).points(:,2))];            
            end
        elseif strcmp(featNames{i},'var')
            for j=1:length(dataPoints)
                temp = [temp;var(dataPoints(j).points(:,1)),var(dataPoints(j).points(:,2))];            
            end
        elseif strcmp(featNames{i},'rms')
            for j=1:length(dataPoints)
                temp = [temp;rms(dataPoints(j).points(:,1)),rms(dataPoints(j).points(:,2))];            
            end
        elseif strcmp(featNames{i},'min')
            for j=1:length(dataPoints)
                temp = [temp;min(dataPoints(j).points(:,1)),min(dataPoints(j).points(:,2))];            
            end
        elseif strcmp(featNames{i},'max')
            for j=1:length(dataPoints)
                temp = [temp;max(dataPoints(j).points(:,1)),max(dataPoints(j).points(:,2))];            
            end
        elseif strcmp(featNames{i},'skewness')
            for j=1:length(dataPoints)
                temp = [temp;skewness(dataPoints(j).points(:,1)),skewness(dataPoints(j).points(:,2))];            
            end
        elseif strcmp(featNames{i},'kurtosis')
            for j=1:length(dataPoints)
                temp = [temp;kurtosis(dataPoints(j).points(:,1)),kurtosis(dataPoints(j).points(:,2))];            
            end
        end
        input = [input temp];
    end

    for i=1:size(input,2)
        input(:,i) = input(:,i)/norm(input(:,i));  
    end

end