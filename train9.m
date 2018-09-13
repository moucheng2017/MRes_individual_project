clc
clear all
train_data_folder='case2+case3 large train original';
validate_data_folder='case2+case3 large test original';%case3 adhist + norm new 224
[train,validate]=training_data(train_data_folder,validate_data_folder);
model_folder_saved='C:\Users\NeuroBeast\Desktop\sliding_window_method\trained models\20180831';
gpuDevice(1);
%%
epoches=250;epoches_str=num2str(epoches);
learnrate=0.1;
learnrate_str=num2str(learnrate);
options = training_options('adam',learnrate,1e-5,250,epoches,2,validate);
tbl = countEachLabel(train);
totalNumberOfPixels = sum(tbl.PixelCount);
frequency = tbl.PixelCount / totalNumberOfPixels;
inverseFrequency = 1./frequency;
last_layer = pixelClassificationLayer('ClassNames',tbl.Name,'ClassWeights',inverseFrequency,'Name','classification');
beta=1;beta_str=num2str(beta);
fb_loss_layer=Fb_loss_v3('fb classification',beta);
%%
netwidth=48;
netwidthstr=num2str(netwidth);
%% model 1
[lgraph,networkname]=attention_Unet_5stages_v1_4_new_new(448,448,netwidth);
lgraph=replaceLayer(lgraph,'Segmentation-Layer',fb_loss_layer);
[net1,infor]= trainNetwork(train,lgraph,options);
%notes=strcat('_netwidth',netwidthstr);
modelname=strcat(networkname,'_fb_1_1.mat');
model=fullfile(model_folder_saved,modelname);
save (model,'net1','infor');
%% model 2
[lgraph,networkname]=attention_Unet_5stages_v1_4_new_new(448,448,netwidth);
lgraph=replaceLayer(lgraph,'Segmentation-Layer',fb_loss_layer);
[net1,infor]= trainNetwork(train,lgraph,options);
%notes=strcat('_netwidth',netwidthstr);
modelname=strcat(networkname,'_fb_1_2.mat');
model=fullfile(model_folder_saved,modelname);
save (model,'net1','infor');
%% model 3
[lgraph,networkname]=attention_Unet_5stages_v1_4_new_new(448,448,netwidth);
lgraph=replaceLayer(lgraph,'Segmentation-Layer',fb_loss_layer);
[net1,infor]= trainNetwork(train,lgraph,options);
%notes=strcat('_netwidth',netwidthstr);
modelname=strcat(networkname,'_fb_1_3.mat');
model=fullfile(model_folder_saved,modelname);
save (model,'net1','infor');