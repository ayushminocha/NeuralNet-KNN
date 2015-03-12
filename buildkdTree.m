function newNode = buildkdTree(input,target,feat)
% buildkdTree(input,target,feat)
% input: Training Data to build the kdTree
% target: Target classes corresponding to the input data points
% feat: The dimension (feature) to be used for the split. Initial Value
% will be 1

[numData,numFeat] = size(input);

if feat == 0
    feat = numFeat;
end

if numData == 0
    newNode = null(1);
    return;
end

[val,indexes] = sort(input(:,feat));
input = input(indexes,:);
target = target(indexes,:);
median = ceil(numData/2);

leftChild = input(1:median-1,:);
rightChild = input(median+1:end,:);
leftTarget = target(1:median-1,:);
rightTarget = target(median+1:end,:);

newNode = kdTree;
newNode = newNode.addValue(input(median,:));
newNode = newNode.addSplitFeature(feat);
newNode = newNode.addTarget(target(median,:));
newNode = newNode.addLeftChild(buildkdTree(leftChild,leftTarget,mod(feat+1,numFeat)));
newNode = newNode.addRightChild(buildkdTree(rightChild,rightTarget,mod(feat+1,numFeat)));

end