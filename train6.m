clc
clear all
% later comprison with different pre-processing & different fb values
train_data_folder='case2+case3 large train original';
validate_data_folder='case2+case3 large test original';%case3 adhist + norm new 224
[train,validate]=training_data(train_data_folder,validate_data_folder);
gpuDevice(2);
epoches=250;epoches_str=num2str(epoches);
learnrate=0.1;learnrate_str=num2str(learnrate);
options = training_options('adam',learnrate,1e-5,280,epoches,2,validate);
model_folder_saved='C:\Users\NeuroBeast\Desktop\sliding_window_method\trained models\20180831';
netwidth=48;
netwidthstr=num2str(netwidth);
%% model 1
beta=1;beta_str=num2str(beta);
notes=strcat('_netwidth',netwidthstr);
[lgraph,networkname]=resnet8_Unet_v1_attention_v1_5_new_new(2,netwidth,448,448,beta);
[net1,infor]= trainNetwork(train,lgraph,options);
modelname=strcat(networkname,notes,'_fb_',beta_str,'_1.mat');
model=fullfile(model_folder_saved,modelname);
save (model,'net1','infor');
%% model 2
beta=1;beta_str=num2str(beta);
notes=strcat('_netwidth',netwidthstr);
[lgraph,networkname]=resnet8_Unet_v1_attention_v1_5_new_new(2,netwidth,448,448,beta);
[net1,infor]= trainNetwork(train,lgraph,options);
modelname=strcat(networkname,notes,'_fb_',beta_str,'_2.mat');
model=fullfile(model_folder_saved,modelname);
save (model,'net1','infor');
%% model 3
beta=1;beta_str=num2str(beta);
notes=strcat('_netwidth',netwidthstr);
[lgraph,networkname]=resnet8_Unet_v1_attention_v1_3_new_new(2,netwidth,448,448,beta);
[net1,infor]= trainNetwork(train,lgraph,options);
modelname=strcat(networkname,notes,'_fb_',beta_str,'_2.mat');
model=fullfile(model_folder_saved,modelname);
save (model,'net1','infor');
%% model 4
beta=1;beta_str=num2str(beta);
notes=strcat('_netwidth',netwidthstr);
[lgraph,networkname]=resnet8_Unet_v1_attention_v1_3_new_new(2,netwidth,448,448,beta);
[net1,infor]= trainNetwork(train,lgraph,options);
modelname=strcat(networkname,notes,'_fb_',beta_str,'_3.mat');
model=fullfile(model_folder_saved,modelname);
save (model,'net1','infor');
%% model 5
beta=1;beta_str=num2str(beta);
notes=strcat('_netwidth',netwidthstr);
[lgraph,networkname]=resnet8_Unet_v1_attention_v1_2_new_new(2,netwidth,448,448,beta);
[net1,infor]= trainNetwork(train,lgraph,options);
modelname=strcat(networkname,notes,'_fb_',beta_str,'_2.mat');
model=fullfile(model_folder_saved,modelname);
save (model,'net1','infor');
%% model 6
beta=1;beta_str=num2str(beta);
notes=strcat('_netwidth',netwidthstr);
[lgraph,networkname]=resnet8_Unet_v1_attention_v1_2_new_new(2,netwidth,448,448,beta);
[net1,infor]= trainNetwork(train,lgraph,options);
modelname=strcat(networkname,notes,'_fb_',beta_str,'_3.mat');
model=fullfile(model_folder_saved,modelname);
save (model,'net1','infor');
%% model
%{
tbl = countEachLabel(train);
totalNumberOfPixels = sum(tbl.PixelCount);
frequency = tbl.PixelCount / totalNumberOfPixels;
inverseFrequency = 1./frequency;
last_layer = pixelClassificationLayer('ClassNames',tbl.Name,'ClassWeights',inverseFrequency,'Name','classification');
lgraph = createUnet(5,448,448,netwidth);
notes=strcat('_epoches',epoches_str,'_learnrate',learnrate_str,'_netwidth',netwidthstr);
networkname='5 stages Unet cross entropy';
lgraph=replaceLayer(lgraph,'Segmentation-Layer',last_layer);
[net1,infor]= trainNetwork(train,lgraph,options);
% 
modelname=strcat(networkname,'_','train_',train_data_folder,'_','validate_',validate_data_folder,'_',notes,'.mat');
model=fullfile(model_folder_saved,modelname);
save (model,'net1','infor');
%}