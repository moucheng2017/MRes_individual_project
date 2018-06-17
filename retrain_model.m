clc
clear all
training_folder = uigetdir;
training_data_total = imageDatastore(training_folder,'IncludeSubfolders',true,'LabelSource','foldernames');
[train,validate] = splitEachLabel(training_data_total,40000,'randomized');
