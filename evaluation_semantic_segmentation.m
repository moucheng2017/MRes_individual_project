clc
clear all
%% edit here:
folder='case1video4'; %testing images folder
%model_name_mat = 'fcn8_case1video4_100epochs_balanced.mat'; % tesing model
model_name_mat='fcn8_case1video4_100epochs_balanced_case1video1_balanced';
%%
tempdir='C:\Users\NeuroBeast\Desktop\results fcn\tempdir';
test_folder=strcat('C:\Users\NeuroBeast\Desktop\images_high_resolution\Testing\US\',folder);
groundtruth_folder=strcat('C:\Users\NeuroBeast\Desktop\images_high_resolution\Testing\ground truth\',folder);
test_images=imageDatastore(test_folder);
classNames = ["background",...
              "tumour",...
              "healthy",...
              "others"];
pixelLabelID = [0 0 0;...
                255 0 0;...
                0 255 0;...
                0 0 255];
pxdsTruth = pixelLabelDatastore(groundtruth_folder,classNames,pixelLabelID);
%%
model_folder= '../trained models/semantic segmentation';
addpath(model_folder);
model_file=fullfile(model_folder,model_name_mat);
network=load (model_file);
net=network.net;
pxdsResults = semanticseg(test_images,net,"WriteLocation",tempdir);
metrics = evaluateSemanticSegmentation(pxdsResults,pxdsTruth);
metrics.ClassMetrics
