%% training data
clc
clear all
training_folder = uigetdir;
training_data_total = imageDatastore(training_folder,'IncludeSubfolders',true,'LabelSource','foldernames');
[train,validate] = splitEachLabel(training_data_total,25489,'randomized');
%% train the old model
%{
model_folder= '../trained models';
addpath(model_folder);
model_file=fullfile(model_folder,'Googlenet_multi_scales_20_100_50%_case1_allImages.mat');
load (model_file);
net = googlenetUS;
%}
%% 
net = googlenet;
lgraph = layerGraph(net);
%figure('Units','normalized','Position',[0.1 0.1 0.8 0.8]);
%plot(lgraph)
lgraph = removeLayers(lgraph, {'prob','output'});
newLayers = [
    fullyConnectedLayer(1000,'Name','fc_new1')
    dropoutLayer(0.5,'Name','dropoutlayer_new1')
    fullyConnectedLayer(3,'Name','fc','WeightLearnRateFactor',10,'BiasLearnRateFactor',10)
    softmaxLayer('Name','softmax')
    classificationLayer('Name','classoutput')];
lgraph = addLayers(lgraph,newLayers);
lgraph = connectLayers(lgraph,'loss3-classifier','fc_new1');

%figure('Units','normalized','Position',[0.3 0.3 0.4 0.4]);
%plot(lgraph)
%ylim([0,10])
%% freeze layers
layers = lgraph.Layers;
connections = lgraph.Connections;
%layers(1:110) = freezeWeights(layers(1:110));
layers(1:96) = freezeWeights(layers(1:96));
lgraph = createLgraphUsingConnections(layers,connections);

%% data augmentation
%{
pixelRange = [-20 20];
imageAugmenter = imageDataAugmenter( ...
    'RandXReflection',true, ...
    'RandXTranslation',pixelRange, ...
    'RandYTranslation',pixelRange);
augimdsTrain = augmentedImageDatastore([224 224],train, ...
    'DataAugmentation',imageAugmenter);
%}
%%
%{
opts = trainingOptions('sgdm', ...
    'LearnRateSchedule','piecewise',...
    'InitialLearnRate',0.001, ...
    'MaxEpochs',1000,...
    'MiniBatchSize',128,...
    'LearnRateDropFactor',0.5,...
    'LearnRateDropPeriod',5,...
    'Verbose',true,...
    'ExecutionEnvironment','multi-gpu',...
    'Plots','training-progress');
%}

opts = trainingOptions('adam', ...
    'InitialLearnRate',0.001, ...
    'MaxEpochs',200,...
    'MiniBatchSize',256,...
    'Verbose',true,...
    'GradientDecayFactor',0.9,...
    'SquaredGradientDecayFactor',0.999,...
    'Epsilon',0.01,...
    'ExecutionEnvironment','multi-gpu',...
    'Plots','training-progress');

[googlenetUS,info] = trainNetwork(train, lgraph, opts);
%[googlenetUS,info] = trainNetwork(augimdsTrain, net, opts);% keep training the old model
model_name='Googlenet_case1_20_80_small_sliding_high_intensity_augmented.mat';
model_folder= '../trained models/11062018';
model=fullfile(model_folder,model_name);
save (model,'googlenetUS')
