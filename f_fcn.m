%function
% segnet
imageSize = [224 224];
numClasses = 4;
lgraph = fcnLayers(imageSize,numClasses,'type','8s');
analyzeNetwork(lgraph)