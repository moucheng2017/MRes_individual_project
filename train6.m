clc
clear all
% later comprison with different pre-processing & different fb values
train_data_folder='case2+case3 large train';
validate_data_folder='case2+case3 large test';%case3 adhist + norm new 224
[train,validate]=training_data(train_data_folder,validate_data_folder);
gpuDevice(2);
epoches=250;epoches_str=num2str(epoches);
learnrate=0.1;learnrate_str=num2str(learnrate);
options = training_options('adam',learnrate,1e-5,250,epoches,2,validate);
model_folder_saved='C:\Users\NeuroBeast\Desktop\Full_attentional_FCN\Models';
netwidth=48;
netwidthstr=num2str(netwidth);
%% model 1
beta=1;beta_str=num2str(beta);
notes=strcat('_netwidth',netwidthstr);
[lgraph,networkname]=resnet8_Unet_v1_attention_v1_4_new_new(2,netwidth,448,448,beta);
[net,infor]= trainNetwork(train,lgraph,options);
modelname=strcat(networkname,notes,'_fb_',beta_str,'_1.mat');
model=fullfile(model_folder_saved,modelname);
save (model,'net','infor');
