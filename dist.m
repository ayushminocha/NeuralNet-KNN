function distance = dist(node,inp,L)
% dist(node,inp,L)
% node: The kdTree node from which the distance needs to be calculated. 
% inp: The input data point
% L: 1 for L1 norm, 2 for L2 norm and 3 for L3 norm

    distance = 0;
    
    if L == 1
        for i=1:size(node,2)
            distance = distance + abs(node(:,i) - inp(:,i));
        end
        
    elseif L == 2
        
        for i=1:size(node,2)
            distance = distance + (node(:,i) - inp(:,i))*(node(:,i) - inp(:,i));
        end
        
        distance = sqrt(distance);
    elseif L == 3
        for i=1:size(node,2)
            distance = distance + (node(:,i) - inp(:,i))^3;
        end
        
        distance = (distance)^(1/3);
    end


end