clc
clear all
train_data_folder='case2+case3 large train original';
validate_data_folder='case2+case3 large test original';%case3 adhist + norm new 224
[train,validate]=training_data(train_data_folder,validate_data_folder);
tbl = countEachLabel(train);
totalNumberOfPixels = sum(tbl.PixelCount);
frequency = tbl.PixelCount / totalNumberOfPixels;
inverseFrequency = 1./frequency;
last_layer = pixelClassificationLayer('ClassNames',tbl.Name,'ClassWeights',inverseFrequency,'Name','classification');
first_layer = imageInputLayer([448 448 3],'Name','ImageInputLayer','Normalization','None');
model_folder_saved='C:\Users\NeuroBeast\Desktop\sliding_window_method\trained models\20180821';
gpuDevice(1);
%% model 1
epoches=300;epoches_str=num2str(epoches);
notes=strcat('fb = 1_',epoches_str,'epochs');%,'_NormalisationLayer'
options = training_options('adam',0.2,1e-5,250,epoches,2,validate);
[lgraph,networkname]=resnet8_Unet_v1_attention_v1_2_new(2,64,448,448,1);
[net1,infor] = trainNetwork(train,lgraph,options);
modelname=strcat(networkname,'_','train_',train_data_folder,'_','validate_',validate_data_folder,'_',notes,'.mat');
model=fullfile(model_folder_saved,modelname);
save (model,'net1','infor');
%% model 5
epoches=150;epoches_str=num2str(epoches);
notes=strcat('cross entropy loss_',epoches_str,'epochs');%,'_NormalisationLayer'
options = training_options('adam',0.1,1e-4,120,epoches,2,validate);
networkname='narrow 5 stages U net';
lgraph = createUnet(4,448,448,32);
lgraph=replaceLayer(lgraph,'Segmentation-Layer',last_layer);
[net1,infor] = trainNetwork(train,lgraph,options);
modelname=strcat(networkname,'_','train_',train_data_folder,'_','validate_',validate_data_folder,'_',notes,'.mat');
model=fullfile(model_folder_saved,modelname);
save (model,'net1','infor');
%% model 6
networkname='wide 5 stages U net';
lgraph = createUnet(3,448,448,96);
lgraph=replaceLayer(lgraph,'Segmentation-Layer',last_layer);
[net1,infor] = trainNetwork(train,lgraph,options);
modelname=strcat(networkname,'_','train_',train_data_folder,'_','validate_',validate_data_folder,'_',notes,'.mat');
model=fullfile(model_folder_saved,modelname);
save (model,'net1','infor');