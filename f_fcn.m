%function
% 
imageSize = [224 224];
numClasses = 2;
lgraph = fcnLayers(imageSize,numClasses,'type','8s');
analyzeNetwork(lgraph)