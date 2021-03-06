clc
clear all
%% vgg16net:
net = vgg16;
layers = net.Layers;
layers(1)=imageInputLayer([224 224 3],'Name','inputlayer','Normalization','none');
layers = layers(1:38);
neuralnet = [
    layers
    fullyConnectedLayer(3,'Name','new_fc','WeightLearnRateFactor',10,'BiasLearnRateFactor',10)
    softmaxLayer('Name','softmax')
    classificationLayer('Name','classoutput')
    ];
%% training data preparation:
training_folder = 'C:\Users\NeuroBeast\Desktop\case1video4 raw';
data_1 = imageDatastore(training_folder,'IncludeSubfolders',true,'LabelSource','foldernames');
data_1 = shuffle(data_1);
[training_1,left_1]=splitEachLabel(data_1,0.25,'randomized');
[training_1,validate_1,test_1] = splitEachLabel(training_1,0.5,0.25);
%% first training:
opts = trainingOptions('adam', ...
    'InitialLearnRate',0.001, ...
    'MaxEpochs',50,...
    'MiniBatchSize',64,...
    'Verbose',true,...
    'GradientDecayFactor',0.9,...
    'SquaredGradientDecayFactor',0.999,...
    'Epsilon',0.01,...
    'ValidationData',validate_1,...
    'ValidationFrequency',30,...
    'ValidationPatience',10,...
    'ExecutionEnvironment','multi-gpu',...
    'Plots','training-progress');
[neuralnet,info] = trainNetwork(training_1,neuralnet, opts);
%% first classification
[preds_1,scores_1] = classify(neuralnet,test_1);
test_1_real = test_1.Labels;
numCorrect_beforefinetuning = nnz(preds_1 == test_1_real);
fracCorrect_beforefinetuning = numCorrect_beforefinetuning/numel(preds_1);
conf_beforefinetuning = confusionmat(test_1_real,preds_1);
[conf_beforefinetuning,categories] = confusionmat(test_1_real,preds_1);
f=figure;
heatmap(categories,categories,conf_beforefinetuning);
titlename='vgg16 testing no fine tuning';
title(titlename);
heatmapsavedfile=strcat(titlename,'.jpg');
heat_map_file_full=fullfile('C:\Users\NeuroBeast\Desktop\results 18062018',heatmapsavedfile);
saveas(f,heat_map_file_full);


