%%
%visuliaze network
clc
clear all
imgs_savefolder='C:\Users\NeuroBeast\Desktop\results 20180815';
model_folder= '../trained models/20180811';
addpath(model_folder);
model_name = 'attention_network_5stages_v1_4_train_case2 adhist + norm new 224_validate_case3 adhist + norm new 224_fb loss function v3 fb=1.mat';
[FILEPATH,NAME,EXT] = fileparts(model_name);
model_file=fullfile(model_folder,model_name);
load (model_file);
net = net1;
alllayers=net.Layers;
%im=imread('C:\Users\NeuroBeast\Desktop\images_high_resolution\Testing\US\case1_video10001.jpeg');
im=imread('C:\Users\NeuroBeast\Desktop\us + masks\case3\US\zero_centred_adaphis_case3video2000000000000184.png');
im=imresize(im,[224 224]);
%% layers to be visuliazed
attention={'bridge_attention_dotproduct';'s4_attention_dotproduct';'s3_attention_dotproduct';'s2_attention_dotproduct';'s1_attention_dotproduct'};
attention4={'s4_attention_dotproduct';'s3_attention_dotproduct';};

%%
layers_type=attention4;
for i = 1:length(layers_type)
    layer_temp=layers_type{i};
    act = activations(net,im,layer_temp,'OutputAs','channels');
    act_size=size(act);
    act_layer = reshape(act,act_size(1),act_size(2),1,act_size(3));
    act_greyimage = mat2gray(act_layer);
    
    %f0=figure;
    %montage(act_greyimage);
    %name_activations=strcat(layer_temp);
    %title(name_activations);
    %saved_name0=strcat(name_activations,'.jpg');
    %saved_name0=fullfile(imgs_savefolder,saved_name0);
    %saveas(f0,saved_name0);
    tmp = act_greyimage(:);
    tmp = imadjust(tmp);
    act_enhanced = reshape(tmp,size(act_greyimage));
    % for all channels:
    %
    f1=figure;
    montage(act_enhanced);
    name_enhanced_activations=strcat(NAME,'_',layer_temp);
    title(name_enhanced_activations);
    saved_name1=strcat(name_enhanced_activations,'.jpg');
    saved_name1=fullfile(imgs_savefolder,saved_name1);
    saveas(f1,saved_name1);
    %}
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





