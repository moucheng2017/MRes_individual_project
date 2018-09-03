% This is written to create patches for case1video4 with 3 classes.
clc
clear all
%% Define parameters for patches:
% find the images folder:
training_path = 'C:\Users\NeuroBeast\Desktop\us + masks';
effective_area=1;
% change here:
target_folder = 'small patches';
training_size_x=224;
training_size_y=224;
patient_index = '3';
% for ultrasound images:
us_folder=strcat('C:\Users\NeuroBeast\Desktop\us + masks\case',patient_index,'\US');
label_folder=strcat('C:\Users\NeuroBeast\Desktop\us + masks\case',patient_index,'\Labels');
us_files = dir(fullfile(us_folder,'*.jpeg')); 
label_files = dir(fullfile(label_folder,'*.tif'));
us_files = {us_files.name};
label_files = {label_files.name};
% for label images:
cases={'Healthy';'Tumour'};
patch_scale = 'square';%rectangle_x: rectangle along x direction;
%% main programme
%for s=27:27
for s = 40:20:80
switch patch_scale
    case 'rectanglex'
        %patch_x_size = 3*s;% for s=10:5:20
        patch_x_size = 2*s;% for s=15:5:30
        patch_y_size = s;
        if (s<25)
            sliding_x = patch_x_size;
            sliding_y = patch_y_size;
        else
            sliding_x = 10;
            sliding_y = 0.5*patch_y_size;
        end
    case 'rectangley'
        patch_x_size = s;
        patch_y_size = 2*s;%for s=15:5:30
        %patch_y_size = 3*s;%for s =10:5:20
        if (s<=30)
            sliding_x = patch_x_size;
            sliding_y = patch_y_size;
        else
            sliding_x = 0.5*patch_x_size;
            sliding_y = 10;
        end
        
    case 'square'
        patch_x_size = s;
        patch_y_size = s; 
        %
        if (s < 50)
            sliding_x = 0.5*s;%patch_x_size*0.5;
            sliding_y = 0.5*s;%patch_y_size*0.5;
        else
            sliding_x = s;%patch_x_size*0.5;
            sliding_y = s;%patch_y_size*0.5;
        end
        %
end
amount_patches_healthy=1;
amount_patches_tumour=1;
% transform the ground truth to hsv:
for no = 1:length(us_files)
%index=indexes{no};
%read ground truth files:
ground_truth_name=label_files{no}; 
[filepath,ground_truth_name_no_extension,extension]=fileparts(ground_truth_name);
ground_truth_fullname = fullfile(label_folder,ground_truth_name);
truth=imread(ground_truth_fullname);
[height,width,dim]=size(truth);
x_steps = floor((width-patch_x_size+1)/sliding_x);
y_steps = floor((height-patch_y_size+1)/sliding_y);
pixels_amount = (patch_x_size)*(patch_y_size);%pixels amount
%read original US files: 
us_name=us_files{no};
us_fullname = fullfile(us_folder,us_name);
us = imread(us_fullname);
figure
imshow(us);
hold on
folder_healthy_multiscale=strcat('C:\Users\NeuroBeast\Desktop\',target_folder,'\Healthy');
folder_tumour_multiscale=strcat('C:\Users\NeuroBeast\Desktop\',target_folder,'\Tumour');
for m=0:x_steps
    for n=0:y_steps
        patch = imcrop(truth,[2+m*sliding_x 2+n*sliding_y patch_x_size patch_y_size]);
        r_channel = patch(:,:,1);mean_r=mean2(r_channel);
        if (mean_r<=1*effective_area)
        amount_patches_healthy=amount_patches_healthy+1;    
        if (rem(amount_patches_healthy,9)==0) 
        patch_temp = imcrop(us,[2+m*sliding_x 2+n*sliding_y patch_x_size patch_y_size]);
        patch_healthy = patch_temp;
        rec = rectangle('Position',[2+m*sliding_x 2+n*sliding_y patch_x_size patch_y_size],'EdgeColor','b','LineWidth',0.5);
        patch_healthy=imresize(patch_healthy,[training_size_x training_size_y]);
        healthy_file_name = sprintf('patch_healthy_x%d_y%d_%d.png',patch_x_size,patch_y_size,amount_patches_healthy);
        healthy_file_name = strcat('case',patient_index,'_',patch_scale,'_',healthy_file_name);
        healthy_file_name=strcat(ground_truth_name_no_extension,'_',healthy_file_name);
        fullname_healthy_multi=fullfile(folder_healthy_multiscale,healthy_file_name);
        imwrite(patch_healthy,fullname_healthy_multi);
        fprintf('patch healthy %d is processing...',amount_patches_healthy);
        fprintf('\n\n');
        end
        elseif (mean_r>=255*0.9)
        patch_temp = imcrop(us,[2+m*sliding_x 2+n*sliding_y patch_x_size patch_y_size]);
        patch_tumour = patch_temp;
        rec = rectangle('Position',[2+m*sliding_x 2+n*sliding_y patch_x_size patch_y_size],'EdgeColor','r','LineWidth',0.5);
        patch_tumour=imresize(patch_tumour,[training_size_x training_size_y]);
        tumour_file_name = sprintf('patch_tumour_x%d_y%d_%d.png',patch_x_size,patch_y_size,amount_patches_tumour);
        tumour_file_name = strcat('case',patient_index,'_',patch_scale,'_',tumour_file_name);
        tumour_file_name=strcat(ground_truth_name_no_extension,'_',tumour_file_name);
        fullname_tumour_multi=fullfile(folder_tumour_multiscale,tumour_file_name);
        imwrite(patch_tumour,fullname_tumour_multi);
        amount_patches_tumour=amount_patches_tumour+1;
        fprintf('patch tumour %d is processing...',amount_patches_tumour);
        fprintf('\n\n');        
        end
    end
end
hold off

end
end

disp('End')