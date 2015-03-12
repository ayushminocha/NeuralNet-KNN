function output = testkNN(test,root,k,L)
% testkNN(test,root,k,L)
% test: Testing data points
% root: Root of the kd-tree
% k: Number of neighbours to consider
% L: 1 for L1 norm, 2 for L2 norm, 3 for L3 norm
%
% Outputs
% output: Nx2 matrix, where first column contains the smoothing output of
%         the tricube kernel and the second column is the class
%         corresponding to the mode of the k neighbouring classes
    
    output = zeros(size(test,1),2);
    for i=1:size(test,1)
        kNNlist = struct;
        kNNlist.nodes = [];
        kNNlist.dist = [];
        kNNlist = findKNN(root,test(i,:),kNNlist,k,L);
        kNNclasses = [];
        outVal = 0;
        lambda = max(kNNlist.dist) + max(kNNlist.dist)/10;
        for j=1:length(kNNlist.nodes)            
            kNNclasses = [kNNclasses kNNlist.nodes(j).target];
            
             if kNNlist.dist(j) < lambda
                 outVal = outVal + kNNlist.nodes(j).target*(1-(kNNlist.dist(j)/lambda)^3)^3;
             end                                           
        end
        
        output(i,1) = outVal/k;
        
        output(i,2) = mode(kNNclasses);
    end
    
end