clc
clear all
% create stitched segmented images
% load net
model_folder= 'C:\Users\NeuroBeast\Desktop\comparison\beta values\4';
addpath(model_folder);
model_name_mat = 'resnet8_Unet_v1_attention_v1_5_new_new_netwidth48_fb_1_2.mat';
[f_model,model_name,ext_model]=fileparts(model_name_mat);
mkdir('C:\Users\NeuroBeast\Desktop\results',model_name);
model_file=fullfile(model_folder,model_name_mat);
network=load (model_file);
net=network.net1;
%%
%classificationlayer='classoutput';
classificationlayer='fb classification';
% test images:
test_folder='case6';
test_folder=strcat('C:\Users\NeuroBeast\Desktop\us + masks\',test_folder,'\US');
%test_folder='C:\Users\NeuroBeast\Desktop\nerves test\patches';
addpath(test_folder);
all_imgs = dir(fullfile(test_folder,'\*.png'));
all_imgs = {all_imgs.name}';
all_files=all_imgs;
%%
for i =1:length(all_files)
    img_name=all_files{i};
    [f,test_name,ext]=fileparts(img_name);
    img=fullfile(test_folder,img_name);
    img=imread(img);
    %img=imresize(img,[320 320]);
    [height,width,channels]=size(img);
    %patch=imcrop(img,[0 0 448 300]);
    patch=imresize(img,[448 448]);
    %patch=imresize(img,[224 224]);
    final_activations=activations(net,patch,classificationlayer);
    final_activations=imresize(final_activations,[300 300]);
    %test=final_activations(:,:,1);
    test=cat(3,final_activations(:,:,1),final_activations(:,:,2),final_activations(:,:,2));
    segmentation=ones(300,300);
    %[test_height,test_width,test_channels]=size(test);
    for ii=1:300
        for jj=1:300
            if (test(ii,jj,1)>=0.5)
                segmentation(ii,jj)=255;
                %test(ii,jj,2)=0;
                %test(ii,jj,3)=0;
            else
                segmentation(ii,jj)=0;
                %test(ii,jj,1)=0;
                %test(ii,jj,2)=0;
                %test(ii,jj,3)=0;
            end
        end
    end
    %
    %figure
    %imshow(test)
    saving_folder=strcat('C:\Users\NeuroBeast\Desktop\results\',model_name);
    saving_file_name=strcat('mask_',test_name,'.tif');
    name=fullfile(saving_folder,saving_file_name);
    %name = strcat('C:\Users\NeuroBeast\Desktop\results 20180822\',test_name,'_',model_name,'.png');
    imwrite(segmentation,name);
end
disp('end')
