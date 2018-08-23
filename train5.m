clc
clear all
train_data_folder='case2+case3 large train original';
validate_data_folder='case2+case3 large test original';%case3 adhist + norm new 224
[train,validate]=training_data(train_data_folder,validate_data_folder);
[lgraph,networkname]=attention_Unet_5stages_v1_2_new_new(448,448,64);
beta=1.5;beta_str=num2str(beta);
%[lgraph,networkname]=resnet8_Unet_v1_attention_v1_2_new(2,64,448,448,beta);
fb_loss_layer=Fb_loss_v3('fb classification',beta);
epoches=150;epoches_str=num2str(epoches);
notes=strcat('fb loss function v3 fb=',beta_str,'_',epoches_str,'epochs');%,'_NormalisationLayer'
lgraph=replaceLayer(lgraph,'Segmentation-Layer',fb_loss_layer);%Segmentation-Layer
%%
%
gpuDevice(1);
options = training_options('adam',0.1,1e-4,120,epoches,2,validate);
[net1,infor] = trainNetwork(train,lgraph,options);
model_folder_saved='C:\Users\NeuroBeast\Desktop\sliding_window_method\trained models\20180821';
% model1
modelname=strcat(networkname,'_','train_',train_data_folder,'_','validate_',validate_data_folder,'_',notes,'.mat');
model=fullfile(model_folder_saved,modelname);
save (model,'net1','infor');
%