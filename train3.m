clc
clear all
train_data_folder='case2 original';
validate_data_folder='case3 original';
[train,validate]=training_data(train_data_folder,validate_data_folder);
beta=1;beta_str=num2str(beta);
fb_loss_layer=Fb_loss_v3('fb classification',beta);
notes=strcat('fb classification v3 fb=',beta_str,'_300epochs');
[lgraph,networkname]=attention_Unet_5stages_v1_4_compatable(224,224,64);
%[lgraph,networkname]=resnet12_Unet_attention(2,64,224,224,1);
%[lgraph,networkname]=resnet8_Unet_attention_v1_4(2,64,224,224,beta);
lgraph=replaceLayer(lgraph,'Segmentation-Layer',fb_loss_layer);
gpuDevice(1);
options = training_options('adam',0.1,1e-2,150,300,4,validate);
net1= trainNetwork(train,lgraph,options);
model_folder_saved='C:\Users\NeuroBeast\Desktop\sliding_window_method\trained models\20180815';
modelname=strcat(networkname,'_','train_',train_data_folder,'_','validate_',validate_data_folder,'_',notes,'.mat');
model=fullfile(model_folder_saved,modelname);
save (model,'net1');

