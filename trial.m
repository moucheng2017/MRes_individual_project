clc
clear all
% example to crop image 
img = imread('C:\Users\NeuroBeast\Desktop\case1_Coronal+000313-000.jpg');
figure
imshow(img)
hold on
[x,y] = ginput(1);
rec = rectangle('Position',[x y 30 30],'EdgeColor','b','LineWidth',2);
img_part = imcrop(img,[x y 30 30]);
img_part = imresize(img_part,[224 224]);
hold off
%
model_folder= '../trained models';
addpath(model_folder);
model_name = 'resnet_case1video4_20_80_high_entropy02.mat';
model_file=fullfile(model_folder,model_name);
load (model_file);
net = resnetUS;
[pred,scores] = classify(net,img_part);

