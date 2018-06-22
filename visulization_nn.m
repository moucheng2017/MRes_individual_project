%%
%visuliaze network
clc
clear all
imgs_savefolder='C:\Users\NeuroBeast\Desktop\visuliasing trained network';
model_folder= '../trained models/18062018';
addpath(model_folder);
model_name = 'Googlenet_case1_8500_square_highintensity_balanced_NoFrozenWeights.mat';
model_file=fullfile(model_folder,model_name);
load (model_file);
net = googlenetUS;
alllayers=net.Layers;
%im=imread('C:\Users\NeuroBeast\Desktop\images_high_resolution\Testing\US\case1_video10001.jpeg');
im=imread('C:\Users\NeuroBeast\Desktop\images_high_resolution\Testing\US\case1_Coronal+000976-000.jpg');
im=imresize(im,[224 224]);
%% layers to be visuliazed
conv_first_layers={'conv1-7x7_s2';'conv2-3x3_reduce';};
conv_blocks = {'inception_3a-3x3_reduce';'inception_3a-3x3';...
               'inception_3b-3x3_reduce';'inception_3b-3x3';...
               'inception_4a-3x3_reduce';'inception_4a-3x3';...
               'inception_4b-3x3_reduce';'inception_4b-3x3';...
               'inception_4c-3x3_reduce';'inception_4c-3x3';...
               'inception_4d-3x3_reduce';'inception_4d-3x3';...
               'inception_4e-3x3_reduce';'inception_4e-3x3';...
               'inception_5a-3x3_reduce';'inception_5a-3x3';...
               'inception_5b-3x3_reduce';'inception_5b-3x3'};
fcl_layers={'loss3-classifier';'fcl_new1';'dropoutlayer_new1';'fc';'softmax';'classoutput'};
%%
layers_type=conv_first_layers;
for i = 1:length(layers_type)
    layer_temp=layers_type{i};
    act = activations(net,im,layer_temp,'OutputAs','channels');
    act_size=size(act);
    act_layer = reshape(act,act_size(1),act_size(2),1,act_size(3));
    act_greyimage = mat2gray(act_layer);
    f0=figure;
    montage(act_greyimage);
    name_activations=strcat(layer_temp);
    title(name_activations);
    saved_name0=strcat(name_activations,'.jpg');
    saved_name0=fullfile(imgs_savefolder,saved_name0);
    saveas(f0,saved_name0);
    tmp = act_greyimage(:);
    tmp = imadjust(tmp);
    act_enhanced = reshape(tmp,size(act_greyimage));
    % for all channels:
    f1=figure;
    montage(act_enhanced);
    name_enhanced_activations=strcat('enhanced',layer_temp);
    title(name_enhanced_activations);
    saved_name1=strcat(name_enhanced_activations,'.jpg');
    saved_name1=fullfile(imgs_savefolder,saved_name1);
    saveas(f1,saved_name1);
    %{
    % only for one channel
    channel=2;
    chan_string=num2str(channel);
    name_enhanced_activations_channel=strcat('activations of channel',chan_string,'of',layer_temp);
    f2=figure;
    imshow(act_enhanced(:,:,:,channel));
    title(name_enhanced_activations_channel);
    saved_name2=strcat(name_enhanced_activations_channel,'.jpg');
    saved_name2=fullfile(imgs_savefolder,saved_name2);
    saveas(f2,saved_name2);
    %}
end





