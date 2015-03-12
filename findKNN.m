function kNNlist = findKNN(node,input,kNNlist,k,L)
% findKNN(node,input,kNNlist,k,L)
% node: Root of the kdTree
% input: Input data point whose k nearest neighbours are to be founf
% kNNlist: list contaning the nearest neighbours. Initial Assignment as
%          follows: kNNlist = struct;
%                   kNNlist.nodes = [];
%                   kNNlist.dist = [];
% k: Number of neighbours to consider
% L: 1 for L1 norm, 2 for L2 norm and 3 for L3 norm

    if isempty(node)
        return;
    end
    
    if input(:,node.splitFeature) < node.node(:,node.splitFeature)
        kNNlist = findKNN(node.leftChild,input,kNNlist,k,L);
        
        if length(kNNlist.nodes) < k
            kNNlist.nodes = [kNNlist.nodes node];
            kNNlist.dist = [kNNlist.dist dist(node.node,input,L)];
            
            kNNlist = findKNN(node.rightChild,input,kNNlist,k,L);
        else
            [val,ind] = max(kNNlist.dist);
            inputDist = dist(node.node,input,L);
            if val > inputDist
                kNNlist.nodes(ind) = node;
                kNNlist.dist(ind) = inputDist;
            end
            
            [val,ind] = max(kNNlist.dist);
            hyperplaneDist = abs(node.node(:,node.splitFeature) - input(:,node.splitFeature));
            if hyperplaneDist < val
                kNNlist = findKNN(node.rightChild,input,kNNlist,k,L);
            end
            
        end
        
    else
        kNNlist = findKNN(node.rightChild,input,kNNlist,k,L);
        
        if length(kNNlist.nodes) < k
            kNNlist.nodes = [kNNlist.nodes node];
            kNNlist.dist = [kNNlist.dist dist(node.node,input,L)];
            
            kNNlist = findKNN(node.leftChild,input,kNNlist,k,L);
        else
            [val,ind] = max(kNNlist.dist);
            inputDist = dist(node.node,input,L);
            if val > inputDist
                kNNlist.nodes(ind) = node;
                kNNlist.dist(ind) = inputDist;
            end
            
            [val,ind] = max(kNNlist.dist);
            hyperplaneDist = abs(node.node(:,node.splitFeature) - input(:,node.splitFeature));
            if hyperplaneDist < val
                kNNlist = findKNN(node.leftChild,input,kNNlist,k,L);
            end
        end
    end
    


end