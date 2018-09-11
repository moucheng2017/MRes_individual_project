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
%%
netwidth=48;
netwidthstr=num2str(netwidth);
%% model 1
lgraph = createUnet(3,448,448,netwidth);
lgraph=replaceLayer(lgraph,'Segmentation-Layer',last_layer);
networkname='3 U-net';
[net1,infor]= trainNetwork(train,lgraph,options);
notes=strcat('_netwidth',netwidthstr);
modelname=strcat(networkname,notes,'_weighted_crossentropy_2.mat');
model=fullfile(model_folder_saved,modelname);
save (model,'net1','infor');
%% model 2
lgraph = createUnet(4,448,448,netwidth);
lgraph=replaceLayer(lgraph,'Segmentation-Layer',last_layer);
networkname='4 U-net';
[net1,infor]= trainNetwork(train,lgraph,options);
notes=strcat('_netwidth',netwidthstr);
modelname=strcat(networkname,notes,'_weighted_crossentropy_1.mat');
model=fullfile(model_folder_saved,modelname);
save (model,'net1','infor');
%% model 3
lgraph = createUnet(4,448,448,netwidth);
lgraph=replaceLayer(lgraph,'Segmentation-Layer',last_layer);
networkname='4 U-net';
[net1,infor]= trainNetwork(train,lgraph,options);
notes=strcat('_netwidth',netwidthstr);
modelname=strcat(networkname,notes,'_weighted_crossentropy_2.mat');
model=fullfile(model_folder_saved,modelname);
save (model,'net1','infor');
%% model 4
lgraph = createUnet(5,448,448,netwidth);
lgraph=replaceLayer(lgraph,'Segmentation-Layer',last_layer);
networkname='5 U-net';
[net1,infor]= trainNetwork(train,lgraph,options);
notes=strcat('_netwidth',netwidthstr);
modelname=strcat(networkname,notes,'_weighted_crossentropy_1.mat');
model=fullfile(model_folder_saved,modelname);
save (model,'net1','infor');
%% model 5
lgraph = createUnet(3,448,448,netwidth);
lgraph=replaceLayer(lgraph,'Segmentation-Layer',last_layer);
networkname='3 U-net';
[net1,infor]= trainNetwork(train,lgraph,options);
notes=strcat('_netwidth',netwidthstr);
modelname=strcat(networkname,notes,'_weighted_crossentropy_1.mat');
model=fullfile(model_folder_saved,modelname);
save (model,'net1','infor');