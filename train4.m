% fine tune on pre trained models
clc
clear all
train_data_folder='case3 active learning';
validate_data_folder='case3 adhist + norm new 224';
[train,validate]=training_data(train_data_folder,validate_data_folder);
%[lgraph,networkname]=attention_Unet_4stages_new(224,224,32);
beta=1.5;beta_str=num2str(beta);
network=load ('C:\Users\NeuroBeast\Desktop\sliding_window_method\trained models\20180815\attention_network_5stages_v1_2_new_train_case2 adhist + norm new 224_validate_case3 adhist + norm new 224_fb loss function v3 fb=1_ZeroCenteringAllInputImages.mat');
net=network.net1;
net = layerGraph(net);
layers = net.Layers;
layers(93:108) = freezeWeights(layers(93:108));
connections = net.Connections;
net = createLgraphUsingConnections(layers,connections);
networkname='fine_tune_trained_attention_network_5stages_v1_2_new';
%[lgraph,networkname]=resnet12_Unet_attention_v1_3_new(2,64,224,224,beta);
fb_loss_layer=Fb_loss_v3('fb classification',beta);
notes=strcat('fb loss function v3 fb=',beta_str,'frozen_93_108');
lgraph=replaceLayer(net,'fb classification',fb_loss_layer);%Segmentation-Layer
%%
gpuDevice(2);
options = training_options('sgdm',0.005,0.95,2,100,2,validate);
net1= trainNetwork(train,lgraph,options);
model_folder_saved='C:\Users\NeuroBeast\Desktop\sliding_window_method\trained models\20180817';
% model1
modelname=strcat(networkname,'_','train_',train_data_folder,'_','validate_',validate_data_folder,'_',notes,'.mat');
model=fullfile(model_folder_saved,modelname);
save (model,'net1');

