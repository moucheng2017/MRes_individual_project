%visuliaze network
clc
clear all
model_folder= '../trained models';
addpath(model_folder);
model_name = 'resnet_case1video4_20_40_high_entropy_balanced.mat';
model_file=fullfile(model_folder,model_name);
load (model_file);
net = resnetUS;
layers=net.Layers;
layer = layers(348);
channels=1:10;

I = deepDreamImage(net,layer,channels, ...
    'PyramidLevels',1, ...
    'Verbose',0);

figure
for i = 1:25
    subplot(5,5,i)
    imshow(I(:,:,:,i))
end