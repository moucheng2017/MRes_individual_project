clc
clear all
%% Active learning framework
% to be filled...
%% backbone network and initialize the network

basenet=resnet101;
net = layerGraph(basenet);
net = removeLayers(net, {'prob','ClassificationLayer_predictions'});
newLayers = [
    fullyConnectedLayer(1000,'Name','fc_new_1')
    dropoutLayer(0.5,'Name','dropout_new_2')
    fullyConnectedLayer(3,'Name','fc_new_3','WeightLearnRateFactor',10,'BiasLearnRateFactor',10)
    softmaxLayer('Name','softmax')
    classificationLayer('Name','classoutput')];
net = addLayers(net,newLayers);
net = connectLayers(net,'fc1000','fc_new_1');
layers = net.Layers;
connections = net.Connections;
layers(1:311) = freezeWeights(layers(1:311));% up to res4b22;resnet101
net = createLgraphUsingConnections(layers,connections);
InitializationTraining_folder = 'C:\Users\NeuroBeast\Desktop\initialization data';
data_initialize = imageDatastore(InitializationTraining_folder,'IncludeSubfolders',true,'LabelSource','foldernames');
data_initialize = shuffle(data_initialize);
[train_initialize,leftdata_initialize] = splitEachLabel(data_initialize,640,'randomized');
opts = trainingOptions('adam', ...
    'InitialLearnRate',0.0003, ...
    'MaxEpochs',2,...
    'MiniBatchSize',64,...
    'Verbose',true,...
    'GradientDecayFactor',0.9,...
    'SquaredGradientDecayFactor',0.999,...
    'Epsilon',0.01,...
    'ExecutionEnvironment','multi-gpu',...
    'CheckpointPath','C:\Users\NeuroBeast\Desktop\network_checkpoints',...
    'Plots','training-progress');
[net,info] = trainNetwork(train_initialize,net,opts);
save ('basenet.mat','net');
%}
%load ('basenet.mat');
%% training data selection 
training_folder_index='1';
training_folder_route='C:\Users\NeuroBeast\Desktop';
trainingfoldrename='case1video1 training';
training_folder_route=strcat(training_folder_route,'\',trainingfoldrename,training_folder_index);
training_batch1=imageDatastore(training_folder_route,'IncludeSubfolders',true,'LabelSource','foldernames');
training_batch1 = shuffle(training_batch1);
[train,leftdata_01] = splitEachLabel(training_batch1,1280,'randomized');
leftdata_01 = shuffle(leftdata_01);
[validate,test]=splitEachLabel(leftdata_01,640,'randomized');
%% test on all training data batch 
%[preds,scores] = classify(net,train);
train_files=train.Files;
train_labels=train.Labels;
train_backup=train;
count_RightTraining=0;
count_WrongTraining=0;
for i=1:length(train_files)
    train_file=train_files{i};
    train_label=train_labels{i};
    [pred,score] = classify(net,train_file);
    if (pred==train_label)
        count_RightTraining=count_RightTraining+1;
        if i==1
            [corret_training,train_backup] = splitEachLabel(train_backup,1);
        else
            [corret_training_temp,train_backup] = splitEachLabel(train_backup,1);           
        end
    else
        count_WrongTraining=count_WrongTraining+1;
        if i==1
            [wrong_training,train_backup]=splitEachLabel(train_backup,1);
        else
        end
    end
end

accuracy = sum(train_labels == preds)/numel(train_labels);


disp('End')