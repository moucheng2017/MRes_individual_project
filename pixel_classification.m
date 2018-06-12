% pixel level classification
clc
clear all
%test_folder = uigetdir;
%path = test_folder;
%addpath(test_folder);
%test_files = dir(fullfile(test_folder,'*.jpeg')); 
%test_files = {test_files.name};
patch_size=20;
sliding=1; 
height=460;
width=550;
channels=3;
model_folder= '../trained models';
addpath(model_folder);
model_file=fullfile(model_folder,'resnet_multi_scales_patches.mat');
load (model_file)
net = resnetUS;
net_infor=' resnet';
test_imgs_path = 'C:\Users\NeuroBeast\Desktop\images_high_resolution\Testing\US';
% testing US images indexes:
results={};
indexes = {'001';'204';'209';'211'};
result_storing_path='C:\Users\NeuroBeast\Desktop\segmentation\pixel classification';
for i=2:length(indexes)
%i=1;
    label_pixel_classification=ones(height,width);
    label_pixel_classification=label_pixel_classification*3;
    index=indexes{i};
    test_name1=strcat('case1_video10',index,'.jpeg'); 
    test_name2=strcat('case1_video10',index); 
    test_fullname = fullfile(test_imgs_path,test_name1);
    test_file=imread(test_fullname);
    test_file=imresize(test_file,[460 555]);
tic
%for i = 1:length(test_files)
    %file_temp = imread(test_files{i});
    %[x_size,y_size,channels]=size(file_temp);
    %[height,width,channels]=size(test);
    result = ones(height,width,channels);
    x_steps = floor((width-patch_size)/sliding);
    y_steps = floor((height-patch_size)/sliding);
    for j =0:1:x_steps
        for k = 0:1:y_steps
            patch = imcrop(test_file,[j*sliding k*sliding patch_size patch_size]);
            rec = rectangle('Position',[j*sliding k*sliding patch_size patch_size],'EdgeColor','b','LineWidth',2);
            patch=imresize(patch,[224 224]);
            [pred,score] = classify(net,patch);
            x_co = j*sliding + 0.5*patch_size;
            y_co = k*sliding + 0.5*patch_size;
            %y_co = height - y_co;

        if pred == 'Tumour'   % malignant
            label_pixel_classification(y_co,x_co)=1;
            result(y_co,x_co,1)=1;
            result(y_co,x_co,2)=0;
            result(y_co,x_co,3)=0;            

        
        elseif pred == 'Healthy'
            label_pixel_classification(y_co,x_co)=-1;
            result(y_co,x_co,1)=0;
            result(y_co,x_co,2)=1;
            result(y_co,x_co,3)=0;
        else
            label_pixel_classification(y_co,x_co)=0;
            result(y_co,x_co,1)=0;
            result(y_co,x_co,2)=0;
            result(y_co,x_co,3)=1;
        end

            %left_corner_y=left_corner_y+sliding;
        end
        %left_corner_x=left_corner_x+sliding;
        fprintf('Current image index is: %d',i);
        fprintf('\n\n');
        fprintf('Current x step is: %d',j);
        fprintf('\n\n');
        fprintf('Current y step is: %d',k);
        fprintf('\n\n');
    end
    results{end+1}=result;
end
toc
%end
% parameters 
%results = {};
% main programme:
for l=1:length(results)
    index=indexes{l};
    test_name3=strcat('case1_video10',index);
    result_temp=results{l};
    figure
    imshow(result_temp)
    result_average_name=strcat(test_name3,net_infor,' pixel classification.jpg');
    store_file=fullfile(result_storing_path,result_average_name);
    result_average_name=char(result_average_name);
    imwrite(result_temp,store_file);
end
%label_file_name=strcat(test_name2,net_infor,'pixel classfication.mat');
%store_classified_labels=fullfile(result_storing_path,label_file_name);
%save(store_classified_labels,'label_pixel_classification')
