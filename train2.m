clc
clear all
% data preparation
% classes pixels labels 
classNames = ["tumour";"background"];
pixelLabelID = [255 255 255;0 0 0];
% stage1
train_data_folder_stage1='case2 adhist + norm new 224';
ladir_train_stage1=strcat('C:\Users\NeuroBeast\Desktop\',train_data_folder_stage1,'\labels');
imdir_train_stage1=strcat('C:\Users\NeuroBeast\Desktop\',train_data_folder_stage1,'\patches');
imds_train_stage1 = imageDatastore(imdir_train_stage1);
pxds_train_stage1 = pixelLabelDatastore(ladir_train_stage1,classNames,pixelLabelID);
%{
C=read(pxds_train_stage1);
I = read(imds_train_stage1);
B = labeloverlay(I,C);
figure
imshow(B)
%}
%%
imageAugmenter = imageDataAugmenter('RandRotation',[-45 45],...
                                    'RandYReflection',true,...
                                    'RandXReflection',true,...
                                    'RandXScale',[0.3 4],...
                                    'RandYScale',[0.3 4]);
train_stage1 = pixelLabelImageDatastore(imds_train_stage1,pxds_train_stage1,'DataAugmentation',imageAugmenter);
%{
% stage2
train_data_folder_stage2='case2 original binary';
ladir_train_stage2=strcat('C:\Users\NeuroBeast\Desktop\',train_data_folder_stage2,'\labels');
imdir_train_stage2=strcat('C:\Users\NeuroBeast\Desktop\',train_data_folder_stage2,'\patches');
imds_train_stage2 = imageDatastore(imdir_train_stage2);
pxds_train_stage2 = pixelLabelDatastore(ladir_train_stage2,classNames,pixelLabelID);
train_stage2 = pixelLabelImageDatastore(imds_train_stage2,pxds_train_stage2);
%}
% validation
validate_data_folder='case3 adhist + norm new 224';
ladir_validate=strcat('C:\Users\NeuroBeast\Desktop\',validate_data_folder,'\labels');
imdir_validate=strcat('C:\Users\NeuroBeast\Desktop\',validate_data_folder,'\patches');
imds_validate =imageDatastore(imdir_validate);
pxds_validate = pixelLabelDatastore(ladir_validate,classNames,pixelLabelID);
validate = pixelLabelImageDatastore(imds_validate,pxds_validate);
%% balancing classes
%{
% stage1
tbl_stage1 = countEachLabel(pxds_train_stage1);
totalNumberOfPixels_stage1 = sum(tbl_stage1.PixelCount);
frequency_stage1 = tbl_stage1.PixelCount / totalNumberOfPixels_stage1;
inverseFrequency_stage1 = (1./frequency_stage1);
%inverseFrequency_stage1 = (1./frequency_stage1);
%layer_stage1 = pixelClassificationLayer('ClassNames',tbl_stage1.Name,'ClassWeights',inverseFrequency_stage1,'Name','classification_layer_stage1');
%}
% stage2
%{
tbl_stage2 = countEachLabel(pxds_train_stage2);
totalNumberOfPixels_stage2 = sum(tbl_stage2.PixelCount);
frequency_stage2 = tbl_stage2.PixelCount / totalNumberOfPixels_stage2;
inverseFrequency_stage2 = (1./frequency_stage2);
layer_stage2 = pixelClassificationLayer(...
      'ClassNames',tbl_stage2.Name,'ClassWeights',inverseFrequency_stage2,'Name','classification_layer_stage2');
  %}
%
%% U net
netwidth=64;
classes=2;
%[lgraph,networkname]=leaky_relu_Unet;
[lgraph,networkname]=vgg16_Unet(classes);
beta=0;
beta_str=num2str(beta);
fb_loss_layer=Fb_loss_v3('fb classification',beta);
%[lgraph,networkname]=resnet11_Unet_v8(classes,netwidth);
%[lgraph,networkname]=resnet16_Unet(classes,netwidth);
%stages=5;
%stages_str=num2str(stages);
%networkname=strcat(stages_str,' stages U net');
%lgraph = createUnet(stages);
%analyzeNetwork(lgraph);
larray=imageInputLayer([224 224 3],'Name','Input','Normalization','None');
lgraph=replaceLayer(lgraph,'input',larray);
%lgraph=replaceLayer(lgraph,'classification',layer_stage1);
lgraph=replaceLayer(lgraph,'classification',fb_loss_layer);
%analyzeNetwork(lgraph);
%}
%new_dice_co_loss_classification=Dice_coefficient_loss('dice_loss_classification');
%lgraph=replaceLayer(lgraph,'classification',new_dice_co_loss_classification);
%lgraph=replaceLayer(lgraph,'ImageInputLayer',larray);%for leaky relu only
%lgraph=replaceLayer(lgraph,'Segmentation-Layer',fb_loss_layer);%for leaky relu only
%}
%{
networkname='fcn8s';
imageSize = [448 448];
numClasses = 2;
lgraph = fcnLayers(imageSize,numClasses,'type','8s');
larray=imageInputLayer([448 448 3],'Name','Input','Normalization','None');
lgraph=replaceLayer(lgraph,'input',larray);
fb_loss_layer=Fb_loss('fb classification');
lgraph=replaceLayer(lgraph,'pixelLabels',fb_loss_layer);
%}
%{
imageSize = [224 224 3];
numClasses = 2;
model='vgg16';
lgraph = segnetLayers(imageSize,numClasses,model);
lgraph=replaceLayer(lgraph,'inputImage',larray);
lgraph=replaceLayer(lgraph,'pixelLabels',layer_stage1);
%}
%% training
gpuDevice(2);
%
% stage1:
opts1 = trainingOptions('adam', ...
    'InitialLearnRate',1e-2, ...
    'LearnRateSchedule','piecewise',...
    'LearnRateDropFactor',1e-4,...
    'LearnRateDropPeriod',400,...
    'MaxEpochs',600,...
    'Shuffle','every-epoch',...
    'MiniBatchSize',8,...
    'Verbose',true,...
    'GradientDecayFactor',0.9,...
    'SquaredGradientDecayFactor',0.999,...
    'Epsilon',0.1,...
    'ValidationData',validate,...
    'L2Regularization',0.005,...
    'GradientThresholdMethod','l2norm',...
    'GradientThreshold',0.05,...
    'ValidationFrequency',50,...
    'ValidationPatience',Inf,...
    'ExecutionEnvironment','gpu',... 
    'Plots','training-progress');
%net1 = trainNetwork(train_stage1,lgraph,opts1);
%}
%{
net1 = layerGraph(net1);
layers_stage1 = net1.Layers;
connections_stage1 = net1.Connections;
net1 = createLgraphUsingConnections(layers_stage1,connections_stage1);
%%
% stage2:
net1=replaceLayer(net1,'classification_layer_stage1',layer_stage2);
analyzeNetwork(net1);
%}
opts2 = trainingOptions('sgdm',...
    'InitialLearnRate',0.05,...
    'LearnRateSchedule','piecewise',...
    'LearnRateDropFactor',0.9,...
    'LearnRateDropPeriod',2,...
    'Momentum',0.9,...
    'MaxEpochs',1000,...
    'Shuffle','every-epoch',...
    'MiniBatchSize',8,...
    'Verbose',true,...
    'ValidationData',validate,...
    'ValidationFrequency',50,...
    'ValidationPatience',Inf,...
    'L2Regularization',0.005,...
    'GradientThresholdMethod','l2norm',...
    'GradientThreshold',0.05,...
    'ExecutionEnvironment','gpu',... 
    'Plots','training-progress');
net1 = trainNetwork(train_stage1,lgraph,opts1);
%
%%
%
model_folder_saved='C:\Users\NeuroBeast\Desktop\sliding_window_method\trained models\20180801';
%{
if (netwidth<64)
    wid_net='narrow';
elseif (netwidth>64)
    wid_net='wide';
else
    wid_net='normal';
end
%}
infor='normal';
notes=strcat('fb loss function v3 fb=',beta_str);
modelname=strcat(networkname,'_','train_',train_data_folder_stage1,'_','validate_',validate_data_folder,'_',notes,'.mat');
model=fullfile(model_folder_saved,modelname);
save (model,'net1','infor');
%
