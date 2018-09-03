clc
clear all
train_data_folder='case2+case3 large train original';
validate_data_folder='case2+case3 large test original';%case3 adhist + norm new 224
[train,validate]=training_data(train_data_folder,validate_data_folder);
model_folder_saved='C:\Users\NeuroBeast\Desktop\sliding_window_method\trained models\20180831';
gpuDevice(2);
%netwidth=48;
%netwidthstr=num2str(netwidth);
epoches=250;epoches_str=num2str(epoches);
learnrate=0.1;
learnrate_str=num2str(learnrate);
options = training_options('adam',learnrate,1e-6,250,epoches,2,validate);
beta=1;beta_str=num2str(beta);
%fb_loss_layer=Fb_loss_v3('fb classification',beta);
%notes=strcat('fb loss fb=',beta_str,'_epoches',epoches_str,'_learnrate',learnrate_str,'_netwidth',netwidthstr);
%% model 1
netwidth=48;
netwidthstr=num2str(netwidth);
notes=strcat('_netwidth',netwidthstr);
[lgraph,networkname]=resnet8_Unet_v1_attention_v1_2_new_new(2,netwidth,448,448,beta);
[net1,infor]= trainNetwork(train,lgraph,options);
% 
modelname=strcat(networkname,notes,'_3.mat');
model=fullfile(model_folder_saved,modelname);
save (model,'net1','infor');
%% model 2
[lgraph,networkname]=resnet8_Unet_v1_attention_v1_2_new_new(2,netwidth,448,448,beta);
[net1,infor]= trainNetwork(train,lgraph,options);
% 
modelname=strcat(networkname,notes,'_4.mat');
model=fullfile(model_folder_saved,modelname);
save (model,'net1','infor');
%% model 3
[lgraph,networkname]=resnet8_Unet_v1_attention_v1_4_new_new(2,netwidth,448,448,beta);
[net1,infor]= trainNetwork(train,lgraph,options);
% 
modelname=strcat(networkname,notes,'_3.mat');
model=fullfile(model_folder_saved,modelname);
save (model,'net1','infor');
%% model 4
[lgraph,networkname]=resnet8_Unet_v1_attention_v1_5_new_new(2,netwidth,448,448,beta);
[net1,infor]= trainNetwork(train,lgraph,options);
% 
modelname=strcat(networkname,notes,'_3.mat');
model=fullfile(model_folder_saved,modelname);
save (model,'net1','infor');
