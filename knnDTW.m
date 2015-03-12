function outputs = knnDTW(input,targets,test,k)
% knnDTW(input,targets,test,k)
% input: Training Data Points. Time series
% targets: Target classes corresponding to the input data points
% test: Test Data Points
% k: Number of neighbours to consider

    outputs = zeros(size(test,1),1);
    for t=1:size(test,1)
        dist = [];
        for i=1:size(input,1)
            temp  =0;
            for j=1:size(input,2)
                temp = temp + dtw_c(input(i).points(:,j),test(t).points(:,j))^2;
            end
            dist = [dist sqrt(temp)];
        end
        [val,ind] = sort(dist);
        tempClasses = targets(ind(1:k));
        outputs(t) = mode(tempClasses);
    end
    
end