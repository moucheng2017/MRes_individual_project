%%
%visuliaze network
clc
clear all
imgs_savefolder='C:\Users\NeuroBeast\Desktop\results 20180829';
model_folder= '../trained models/20180828';
addpath(model_folder);
model_name = 'new_resnet8_Unet_v1_attention_v1_4_new_new_train_case2+case3 large train original_validate_case2+case3 large test original_fb loss fb=1.25_epoches250_learnrate0.1_netwidth48.mat';
[FILEPATH,NAME,EXT] = fileparts(model_name);
model_file=fullfile(model_folder,model_name);
load (model_file);
net = net1;
alllayers=net.Layers;
%im=imread('C:\Users\NeuroBeast\Desktop\images_high_resolution\Testing\US\case1_video10001.jpeg');
im=imread('C:\Users\NeuroBeast\Desktop\us + masks\case3\US\case3video2000000000000112.jpeg');
[height,width,channels]=size(im);
%im=imcrop(im,[0 0 448 448]);
im=imresize(im,[448 448]);
%
%% layers to be visuliazed
attention={'bridge_attention_dotproduct';'s4_attention_dotproduct';'s3_attention_dotproduct';'s2_attention_dotproduct'};
attention4={'bridge_attention_dotproduct';'d4_attention_dotproduct';'d3_attention_dotproduct';'d2_attention_dotproduct'};

%%
layers_type=attention4;
for i = 1:length(layers_type)
    layer_temp=layers_type{i};
    act = activations(net,im,layer_temp,'OutputAs','channels');
    act_size=size(act);
    act_layer = reshape(act,act_size(1),act_size(2),1,act_size(3));
    [maxValue,maxValueIndex] = max(max(max(act_layer)));
    act_layer = act_layer(:,:,:,maxValueIndex);
    %channel=3;channel_str=num2str(channel);
    %act_layer = act_layer(:,:,:,channel);
    %act_layer = mean(act_layer,4);%mean value
    act_greyimage = mat2gray(act_layer);
    act_greyimage = imadjust(act_greyimage);
    %act_greyimage=cat(3,act_greyimage,0*act_greyimage,0*act_greyimage);
    act_greyimage =imresize(act_greyimage,[height width]);
    %act_greyimage=255.*act_greyimage./act_greyimage;
    %act_greyimage=cat(3,act_greyimage,0*act_greyimage,0*act_greyimage);
    act_greyimage=cat(3,act_greyimage,0*act_greyimage,0*act_greyimage);
    f=figure;
    %montage(act_greyimage);
    imshow(act_greyimage);
    title(layer_temp);
    saved_name=strcat('case3_112_',layer_temp,'.png');
    saved_name=fullfile(imgs_savefolder,saved_name);
    saveas(f,saved_name);
    %{
    % only for one channel
    channel=1;
    chan_string=num2str(channel);
    name_enhanced_activations_channel=strcat('activations of channel',chan_string,'of',layer_temp);
    f2=figure;
    channel_img=act_enhanced(:,:,:,channel);
    channel_img=imresize(channel_img,[224 224]);
    imshow(channel_img);
    title(name_enhanced_activations_channel);
    saved_name2=strcat(name_enhanced_activations_channel,'.jpg');
    %saved_name2=fullfile(imgs_savefolder,saved_name2);
    %saveas(f2,saved_name2);
    %}
end



