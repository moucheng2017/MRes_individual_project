%% training data
clc
clear all
training_folder = 'C:\Users\NeuroBeast\Desktop\small patches  299x299';
training_data_total = imageDatastore(training_folder,'IncludeSubfolders',true,'LabelSource','foldernames');
training_data_total = shuffle(training_data_total);
[train,validate] = splitEachLabel(training_data_total,790,'randomized');
%% data augmentation
imageAugmenter = imageDataAugmenter('RandRotation',[-30 30],...
                                    'RandYReflection',true,...
                                    'RandXReflection',true,...
                                    'RandXScale',[0.3 4],...
                                    'RandYScale',[0.3 4]);
augimdsTrain = augmentedImageDatastore([299 299],train, ...
    'DataAugmentation',imageAugmenter);
%% 
inputlayer=imageInputLayer([299 299 3],'Name','inputlayer','Normalization','none');
net = inceptionresnetv2;
lgraph = layerGraph(net);%figure('Units','normalized','Position',[0.1 0.1 0.8 0.8]);plot(lgraph);
lgraph=replaceLayer(lgraph,'input_1',inputlayer);
lgraph = removeLayers(lgraph, {'predictions_softmax','ClassificationLayer_predictions'});
%lgraph=replaceLayer(lgraph,'fc8',last_layer);
%% 
Layers = [
    dropoutLayer(0.6,'Name','dropoutlayer_new1')
    fullyConnectedLayer(100,'Name','fc_new_2')
    dropoutLayer(0.6,'Name','dropoutlayer_new2')
    fullyConnectedLayer(2,'Name','fc_new_3','WeightLearnRateFactor',10,'BiasLearnRateFactor',10)
    softmaxLayer('Name','softmax')
    classificationLayer('Name','classoutput')];
lgraph = addLayers(lgraph,Layers);
lgraph = connectLayers(lgraph,'predictions','dropoutlayer_new1');
%}
%% freeze layers
%
layers = lgraph.Layers;
connections = lgraph.Connections;
layers(1:767) = freezeWeights(layers(1:767));%block8_7_ac
lgraph = createLgraphUsingConnections(layers,connections);
%
%%
gpuDevice(1);
opts = trainingOptions('adam', ...
    'InitialLearnRate',0.01, ...
    'LearnRateSchedule','piecewise',...
    'LearnRateDropFactor',1e-5,...
    'LearnRateDropPeriod',120,...
    'MaxEpochs',150,...
    'MiniBatchSize',32,...
    'Verbose',true,...
    'GradientDecayFactor',0.9,...
    'SquaredGradientDecayFactor',0.999,...
    'Epsilon',0.01,...
    'ValidationData',validate,...
    'ValidationFrequency',50,...
    'ValidationPatience',Inf,...
    'ExecutionEnvironment','gpu',...
    'Plots','training-progress');
[inceptionv2resnetUS,info] = trainNetwork(augimdsTrain, lgraph, opts);
model_name='inceptionv2resnet_train_case2case3_40to80Patches_60%training_150epoches_767LayersFrozen.mat';
model_folder= '../trained models/20180828';
model=fullfile(model_folder,model_name);
save (model,'inceptionv2resnetUS','info')
%% vgg16
%{
inputlayer=imageInputLayer([224 224 3],'Name','inputlayer','Normalization','none');
net = vgg16;
lgraph = layerGraph(net);%figure('Units','normalized','Position',[0.1 0.1 0.8 0.8]);plot(lgraph);
lgraph=replaceLayer(lgraph,'input',inputlayer);
last_layer=fullyConnectedLayer(2,'Name','fc_2neurons');
lgraph=replaceLayer(lgraph,'fc8',last_layer);
%}


