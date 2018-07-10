clc
clear all
% create training patches/labels for semantic segmentation
%us_folder='C:\Users\NeuroBeast\Desktop\semantic segmentation\training patches';
labels_folder='C:\Users\NeuroBeast\Desktop\semantic segmentation\labels';
%addpath(us_folder);
addpath(labels_folder);
%us_files = dir(fullfile(us_folder,'*.jpeg')); 
%us_files = {us_files.name};
labels_files = dir(fullfile(labels_folder,'*.png')); 
labels_files = {labels_files.name};
%%
patch_x_size=224;
patch_y_size=224;
sliding_x=20;
sliding_y=20;
count=1;
for i = 1:length(labels_files)
    %us=us_files{i};
    labels=labels_files{i};
    %load (labels);
    %us=imread(us);
    labels=imread(labels);
    %labels=labels_map;
    [height,width,channels]=size(labels);
    x_steps = floor((width-patch_x_size+1)/sliding_x);
    y_steps = floor((height-patch_y_size+1)/sliding_y);
    pxlabel=zeros(height,width);
    for m=1:x_steps
        for n=1:y_steps
            left_corner_up_x=m*sliding_x;
            left_corner_down_x=left_corner_up_x+patch_x_size-1;
            left_corner_up_y=n*sliding_y;
            left_corner_down_y=left_corner_up_y+patch_y_size-1;
            %patch = imcrop(us,[left_corner_up_x left_corner_up_y patch_x_size-1 patch_y_size-1]);
            patch_labels=imcrop(labels,[left_corner_up_x left_corner_up_y patch_x_size-1 patch_y_size-1]);
            %patch_labels=labels(left_corner_up_y:left_corner_down_y,left_corner_up_x:left_corner_down_x);
            count_str=num2str(count);
            %patch_name=strcat('image_',count_str,'.jpg');
            %patch_name=fullfile(us_folder,patch_name);
            patch_labels_name=strcat('label_',count_str,'.png');
            patch_labels_name=fullfile(labels_folder,patch_labels_name);
            %save(patch_labels_name,'patch_labels');
            %imwrite(patch,patch_name);
            imwrite(patch_labels,patch_labels_name);
            count=count+1;
            fprintf('processing...');
            fprintf('\n\n');
        end
    end
end