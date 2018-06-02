%% training
training_folder = uigetdir
training_data_total = imageDatastore(training_folder,'IncludeSubfolders',true,'LabelSource','foldernames');
[train,test] = splitEachLabel(training_data_total,200,40,'randomized');
% modify the network
net = alexnet;
layers=net.Layers;
layers = layers(1:end-2);
layers(end+1) = leakyReluLayer;
layers(end+1) = dropoutLayer(0.5);
layers(end+1) = fullyConnectedLayer(64, 'Name', 'fc_9');
layers(end+1) = leakyReluLayer;
layers(end+1) = dropoutLayer(0.5);
layers(end+1) = fullyConnectedLayer(3, 'Name', 'fc_10');
layers(end+1) = leakyReluLayer;
layers(end+1) = dropoutLayer(0.5);
layers(end+1) = fullyConnectedLayer(5, 'Name', 'fc_11');
layers(end+1) = softmaxLayer; 
layers(end+1) = classificationLayer;
% fine tune the learning rate
layers(end-2).WeightLearnRateFactor = 10; 
layers(end-2).WeightL2Factor = 1; 
layers(end-2).BiasLearnRateFactor = 20; 
layers(end-2).BiasL2Factor = 0; 
% options for training 
opts = trainingOptions('sgdm',...
    'Momentum',0.85079,...
    'InitialLearnRate',0.0044604,...
    'L2Regularization',0.0042445,...
    'MaxEpochs',500,...
    'MiniBatchSize',128,...
    'Verbose',true,...
    'Plots','training-progress');
[alexnetUS,info] = trainNetwork(train, layers, opts);
save ('Tuned_alexnet_US_patches.mat','alexnetUS')
