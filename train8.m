clc
clear all
train_data_folder='case2+case3 large train original';
validate_data_folder='case2+case3 large test original';%case3 adhist + norm new 224
[train,validate]=training_data(train_data_folder,validate_data_folder);
model_folder_saved='C:\Users\NeuroBeast\Desktop\sliding_window_method\trained models\20180831';
gpuDevice(2);
%netwidth=48;
%netwidthstr=num2str(netwidth);
epoches=200;epoches_str=num2str(epoches);
learnrate=0.1;
learnrate_str=num2str(learnrate);
options = training_options('adam',learnrate,1e-6,250,epoches,2,validate);
%beta=1.25;beta_str=num2str(beta);
%fb_loss_layer=Fb_loss_v3('fb classification',beta);
%notes=strcat('fb loss fb=',beta_str,'_epoches',epoches_str,'_learnrate',learnrate_str,'_netwidth',netwidthstr);
%% model 1
tbl = countEachLabel(train);
totalNumberOfPixels = sum(tbl.PixelCount);
frequency = tbl.PixelCount / totalNumberOfPixels;
inverseFrequency = 1./frequency;
last_layer = pixelClassificationLayer('ClassNames',tbl.Name,'ClassWeights',inverseFrequency,'Name','classification');
netwidth=16;
netwidthstr=num2str(netwidth);
lgraph = createUnet(5,448,448,netwidth);
lgraph=replaceLayer(lgraph,'Segmentation-Layer',last_layer);
networkname = '5 Unet_w16_';
%[lgraph,networkname]=resnet8_Unet_v1_attention_v1_4_new_new(2,netwidth,448,448,beta);
[net1,infor]= trainNetwork(train,lgraph,options);
% 
notes=strcat('_netwidth',netwidthstr);
modelname=strcat(networkname,notes,'_2.mat');
model=fullfile(model_folder_saved,modelname);
save (model,'net1','infor');
%% model 2
netwidth=32;
netwidthstr=num2str(netwidth);
lgraph = createUnet(5,448,448,netwidth);
lgraph=replaceLayer(lgraph,'Segmentation-Layer',last_layer);
networkname = '5 Unet_w32_';
[net1,infor]= trainNetwork(train,lgraph,options);
% 
notes=strcat('_netwidth',netwidthstr);
modelname=strcat(networkname,notes,'_2.mat');
model=fullfile(model_folder_saved,modelname);
save (model,'net1','infor');
%% model 3
netwidth=48;
netwidthstr=num2str(netwidth);
lgraph = createUnet(5,448,448,netwidth);
lgraph=replaceLayer(lgraph,'Segmentation-Layer',last_layer);
networkname = '5 Unet_w48_';
[net1,infor]= trainNetwork(train,lgraph,options);
% 
notes=strcat('_netwidth',netwidthstr);
modelname=strcat(networkname,notes,'_2.mat');
model=fullfile(model_folder_saved,modelname);
save (model,'net1','infor');
%% model 4
netwidth=64;
netwidthstr=num2str(netwidth);
lgraph = createUnet(5,448,448,netwidth);
lgraph=replaceLayer(lgraph,'Segmentation-Layer',last_layer);
networkname = '5 Unet_w64_';
[net1,infor]= trainNetwork(train,lgraph,options);
% 
notes=strcat('_netwidth',netwidthstr);
modelname=strcat(networkname,notes,'_2.mat');
model=fullfile(model_folder_saved,modelname);
save (model,'net1','infor');
%% model 5
netwidth=96;
netwidthstr=num2str(netwidth);
lgraph = createUnet(5,448,448,netwidth);
lgraph=replaceLayer(lgraph,'Segmentation-Layer',last_layer);
networkname = '5 Unet_w96_';
[net1,infor]= trainNetwork(train,lgraph,options);
% 
notes=strcat('_netwidth',netwidthstr);
modelname=strcat(networkname,notes,'_2.mat');
model=fullfile(model_folder_saved,modelname);
save (model,'net1','infor');
%%
%{
tbl = countEachLabel(train);
totalNumberOfPixels = sum(tbl.PixelCount);
frequency = tbl.PixelCount / totalNumberOfPixels;
inverseFrequency = 1./frequency;
last_layer = pixelClassificationLayer('ClassNames',tbl.Name,'ClassWeights',inverseFrequency,'Name','classification');
first_layer = imageInputLayer([448 448 3],'Name','ImageInputLayer','Normalization','None');
%}