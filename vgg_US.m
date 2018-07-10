%% training data
% vgg16
clc
clear all
training_folder = uigetdir;
training_data_total = imageDatastore(training_folder,'IncludeSubfolders',true,'LabelSource','foldernames');
training_data_total = shuffle(training_data_total);
[train,leftdata] = splitEachLabel(training_data_total,6744,'randomized');
%[train,validate] = splitEachLabel(training_data_total,7200,'randomized');
leftdata = shuffle(leftdata);
[validate,test]=splitEachLabel(leftdata,2248,'randomized');
%%
