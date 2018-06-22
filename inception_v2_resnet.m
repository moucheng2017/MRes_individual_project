%% training data
clc
clear all
training_folder = uigetdir;
training_data_total = imageDatastore(training_folder,'IncludeSubfolders',true,'LabelSource','foldernames');
[train,validate] = splitEachLabel(training_data_total,7200,'randomized');
%[validate,test]=splitEachLabel(leftdata,1700,'randomized');
%% 
inputlayer=imageInputLayer([299 299 3],'Name','inputlayer','Normalization','none');
net = inceptionresnetv2;
lgraph = layerGraph(net);
lgraph=replaceLayer(lgraph,'input_1',inputlayer);
lgraph = removeLayers(lgraph, {'predictions_softmax','ClassificationLayer_predictions'});
Layers = [
    fullyConnectedLayer(1000,'Name','fc_new1')
    dropoutLayer(0.8,'Name','dropoutlayer_new1')
    fullyConnectedLayer(3,'Name','fc_3','WeightLearnRateFactor',10,'BiasLearnRateFactor',10)
    softmaxLayer('Name','softmax')
    classificationLayer('Name','classoutput')];
lgraph = addLayers(lgraph,Layers);
lgraph = connectLayers(lgraph,'predictions','fc_new1');
%figure
%plot(lgraph)
%% freeze layers
%{
layers = lgraph.Layers;
connections = lgraph.Connections;
layers(1:801) = freezeWeights(layers(1:801));%up tp block_8_9_ac
lgraph = createLgraphUsingConnections(layers,connections);
%}
%% data augmentation
imageAugmenter = imageDataAugmenter( ...
    'RandRotation',[-30 30],...
    'RandXReflection',true);
augimdsTrain = augmentedImageDatastore([299 299],train, ...
    'DataAugmentation',imageAugmenter);

%%
opts = trainingOptions('adam', ...
    'InitialLearnRate',0.001, ...
    'MaxEpochs',150,...
    'MiniBatchSize',32,...
    'Verbose',true,...
    'GradientDecayFactor',0.9,...
    'SquaredGradientDecayFactor',0.999,...
    'Epsilon',0.01,...
    'ValidationData',validate,...
    'ValidationFrequency',40,...
    'ValidationPatience',50,...
    'ExecutionEnvironment','multi-gpu',...
    'Plots','training-progress');

[inceptionv2resnetUS,info] = trainNetwork(augimdsTrain, lgraph, opts);
model_name='inceptionv2resnet_case1_7200_HighIntensity_NoFrozenWeights.mat';
model_folder= '../trained models/18062018';
model=fullfile(model_folder,model_name);
save (model,'inceptionv2resnetUS','info')
