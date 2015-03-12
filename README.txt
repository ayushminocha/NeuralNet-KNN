README
------

To compile the mex code use:
mex trainMLP.cpp

Once the mex file is compiled it can be used to train MLP. This is to speed up the training. 
The same algorithm is also implemented in MATLAB, but it is very slow. The mex implementation can run 500,000 iterations in a few seconds.

To run the experiment use,

[result,output,metric] = experiment(Dataset_folder,method);
where the Dataset_folder is the name of the folder containing the dataset, and method can be:
'NN' : Neural Network
'kNN': K Nearest Neighbour
'unique' : Unique Algorithm

The output contains the result which has two columns, the first column is the target, and the second column is the corresponding output classes.
output variable contains, the output activations of NN, or the tricube regression values for knn.
metric contains the measures like accuracy, precision, recall, sensitivity, specificity, f-measure and the confusion matrix.

For usage of the any other function just use help:
help('trainMultiLayerPerceptron')

——————
Ayush Minocha
UID: 104410979
