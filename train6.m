clc
clear all
train_data_folder='case2+case3 large train original';
validate_data_folder='case2+case3 large test original';%case3 adhist + norm new 224
[train,validate]=training_data(train_data_folder,validate_data_folder);
gpuDevice(2);
epoches=300;epoches_str=num2str(epoches);
options = training_options('adam',0.1,1e-4,200,epoches,2,validate);
model_folder_saved='C:\Users\NeuroBeast\Desktop\sliding_window_method\trained models\20180821';
beta=1.25;
beta_str=num2str(beta);
fb_loss_layer=Fb_loss_v3('fb classification',beta);
notes=strcat('fb loss fb=',beta_str,'_withNormalisationLayer','_epoches',epoches_str);
%% model 1
[lgraph,networkname]=attention_Unet_5stages_v1_2_new(448,448,64);
lgraph=replaceLayer(lgraph,'Segmentation-Layer',fb_loss_layer);%Segmentation-Layer
[net1,infor]= trainNetwork(train,lgraph,options);
% 
modelname=strcat(networkname,'_','train_',train_data_folder,'_','validate_',validate_data_folder,'_',notes,'.mat');
model=fullfile(model_folder_saved,modelname);
save (model,'net1','infor');
%% model 2
[lgraph,networkname]=attention_Unet_5stages_v1_3_new_new(448,448,64);
lgraph=replaceLayer(lgraph,'Segmentation-Layer',fb_loss_layer);%Segmentation-Layer
[net1,infor]= trainNetwork(train,lgraph,options);
% 
modelname=strcat(networkname,'_','train_',train_data_folder,'_','validate_',validate_data_folder,'_',notes,'.mat');
model=fullfile(model_folder_saved,modelname);
save (model,'net1','infor');
