clc
clear all
load ('resnet_multi_scale_patches.mat');
neural_net = resnetUS;
testing_folder = uigetdir;
testing_data_total = imageDatastore(testing_folder,'IncludeSubfolders',true,'LabelSource','foldernames');
[train,test] = splitEachLabel(testing_data_total,1,173,'randomized');
%test = imageDatastore(testing_folder,'IncludeSubfolders',true,'LabelSource','foldernames');

real = test.Labels;

[preds,scores] = classify(neural_net,test);
numCorrect = nnz(preds == real);
fracCorrect = numCorrect/numel(preds);
conf = confusionmat(real,preds);
[conf,categories] = confusionmat(real,preds);

figure
heatmap(categories,categories,conf)
title('weights frozen resnet trained on multi scales testing on 40x40')
