%% training data
clc
clear all
training_folder = uigetdir;
training_data_total = imageDatastore(training_folder,'IncludeSubfolders',true,'LabelSource','foldernames');
training_data_total = shuffle(training_data_total);
[train,leftdata] = splitEachLabel(training_data_total,6400,'randomized');
leftdata = shuffle(leftdata);
[validate,leftdata_2]=splitEachLabel(leftdata,3200,'randomized');
leftdata_2 = shuffle(leftdata_2);
[test,leftdata_3]=splitEachLabel(leftdata_2,650,'randomized');
%%
%{
model_folder= '../trained models/20180623';
addpath(model_folder);
model_name = 'resnet101_case1video4_20_40Patches50%Overlapping_60%training_30epochs.mat';
model_file=fullfile(model_folder,model_name);
load (model_file);
net = resnetUS;
lgraph = layerGraph(net);
%}
%inputlayer=imageInputLayer([224 224 3],'Name','inputlayer','Normalization','none');
%{
net = resnet101;
lgraph = layerGraph(net);
%lgraph=replaceLayer(lgraph,'data',inputlayer);
lgraph = removeLayers(lgraph, {'prob','ClassificationLayer_predictions'});
newLayers = [
    dropoutLayer(0.5,'Name','dropout_new_1')
    fullyConnectedLayer(1000,'Name','fc_new_1')
    dropoutLayer(0.5,'Name','dropout_new_2')
    fullyConnectedLayer(3,'Name','fc_new_3','WeightLearnRateFactor',10,'BiasLearnRateFactor',10)
    softmaxLayer('Name','softmax')
    classificationLayer('Name','classoutput')];
lgraph = addLayers(lgraph,newLayers);
lgraph = connectLayers(lgraph,'fc1000','dropout_new_1');
%% freeze layers
layers = lgraph.Layers;
connections = lgraph.Connections;
layers(1:79) = freezeWeights(layers(1:79));% up to res4b22;resnet101
%layers(1:90) = freezeWeights(layers(1:90));% up to first 8 blocks; half depth; resnet50
lgraph = createLgraphUsingConnections(layers,connections);
%}
%{
%% data augmentation
imageAugmenter = imageDataAugmenter('RandRotation',[-30 30],'RandYReflection',true);
%    'RandXReflection',true
augimdsTrain = augmentedImageDatastore([32 32],train, ...
    'DataAugmentation',imageAugmenter);
%%
opts = trainingOptions('adam', ...
    'InitialLearnRate',0.01, ...
    'LearnRateSchedule','piecewise',...
    'LearnRateDropFactor',0.1,...
    'LearnRateDropPeriod',100,...
    'MaxEpochs',450,...
    'MiniBatchSize',256,...
    'Verbose',true,...
    'GradientDecayFactor',0.9,...
    'SquaredGradientDecayFactor',0.999,...
    'Epsilon',0.01,...
    'ValidationData',validate,...
    'ValidationFrequency',50,...
    'ValidationPatience',Inf,...
    'ExecutionEnvironment','multi-gpu',...
    'CheckpointPath','C:\Users\NeuroBeast\Desktop\network_checkpoints_0704',...
    'Plots','training-progress');
%%
%}
    model_folder= '../trained models/resnet16';
    model_name = 'resnet16_v5_w96_case1video4_3.mat';
    model_file=fullfile(model_folder,model_name);
    load (model_file);
    neural_net = net;
    [FILEPATH,filename,ext] = fileparts(model_name);
    true_class=test.Labels;
    preds=classify(net,test);
    f=figure;
    plotconfusion(true_class,preds)
    title(filename)
    filename=strcat(filename,'.jpg');
    plot_name=strcat('C:\Users\NeuroBeast\Desktop\resnet16 results\',filename);
    saveas(f,plot_name);
%{
count=1;
for width=64:32:96
    count_str=num2str(count);
    neuralnet=resnet16_v5(width);
    [net,info] = trainNetwork(augimdsTrain,neuralnet,opts);
    width_str=num2str(width);
    model_name_saved=strcat('resnet16_v5_w',width_str,'_case1video4_',count_str,'.mat');
    model_folder_saved= '../trained models/resnet16';
    model=fullfile(model_folder_saved,model_name_saved);
    save (model,'net','info','test');
    %test
    [FILEPATH,filename,ext] = fileparts(model_name_saved);
    true_class=test.Labels;
    preds=classify(net,test);
    f=figure;
    plotconfusion(true_class,preds)
    title(filename)
    filename=strcat(filename,'.jpg');
    plot_name=strcat('C:\Users\NeuroBeast\Desktop\resnet16 results\',filename);
    saveas(f,plot_name);
    count=count+1;
end
%}
%
%{
count=1;
for width=32:32:96
    width_str=num2str(width);
    count_str=num2str(count);
    neuralnet=resnet16_v3(width);
    [net,info] = trainNetwork(augimdsTrain,neuralnet,opts);
    model_name_saved=strcat('resnet16_v3_w',width_str,'_case1video4_',count_str,'.mat');
    model_folder_saved= '../trained models/resnet16';
    model=fullfile(model_folder_saved,model_name_saved);
    save (model,'net','info','test');
    %test
    [FILEPATH,filename,ext] = fileparts(model_name_saved);
    true_class=test.Labels;
    preds=classify(net,test);
    f=figure;
    plotconfusion(true_class,preds)
    title(filename)
    filename=strcat(filename,'.jpg');
    plot_name=strcat('C:\Users\NeuroBeast\Desktop\resnet16 results\',filename);
    saveas(f,plot_name);
    count=count+1;
end
%}
%
%{
count=1;
for width=32:32:96
    count_str=num2str(count);
    neuralnet=resnet16_v1(width);
    [net,info] = trainNetwork(augimdsTrain,neuralnet,opts);
    model_name_saved=strcat('resnet16_v1_w',width,'_case1video4_',count_str,'.mat');
    model_folder_saved= '../trained models/resnet16';
    model=fullfile(model_folder_saved,model_name_saved);
    save (model,'net','info','test');
    %test
    [FILEPATH,filename,ext] = fileparts(model_name_saved);
    true_class=test.Labels;
    preds=classify(net,test);
    f=figure;
    plotconfusion(true_class,preds)
    title(filename)
    filename=strcat(filename,'.jpg');
    plot_name=strcat('C:\Users\NeuroBeast\Desktop\resnet16 results\',filename);
    saveas(f,plot_name);
    count=count+1;
end
%}
%{
count=1;
for width=32:32:96
    count_str=num2str(count);
    width_str=num2str(width);
    neuralnet=resnet16_v2(width);
    [net,info] = trainNetwork(augimdsTrain,neuralnet,opts);
    model_name_saved=strcat('resnet16_v2_w',width_str,'_case1video4_',count_str,'.mat');
    model_folder_saved= '../trained models/resnet16';
    model=fullfile(model_folder_saved,model_name_saved);
    save (model,'net','info','test');
    %test
    [FILEPATH,filename,ext] = fileparts(model_name_saved);
    true_class=test.Labels;
    preds=classify(net,test);
    f=figure;
    plotconfusion(true_class,preds)
    title(filename)
    filename=strcat(filename,'.jpg');
    plot_name=strcat('C:\Users\NeuroBeast\Desktop\resnet16 results\',filename);
    saveas(f,plot_name);
    count=count+1;
end
%}