clc
clear all
%function
% segnet
%{
imageSize = [224, 224, 3];
numClasses = 4;
lgraph = segnetLayers(imageSize,numClasses,'vgg16');
%}
imageSize = [224 224];
numClasses = 4;
lgraph = fcnLayers(imageSize,numClasses,'type','8s');
analyzeNetwork(lgraph)