clc
clear all
%%
prompt1='which case is this?';
case_no = input(prompt1);
case_no=num2str(case_no);
if (case_no=='1')
prompt2='which video is this?';
video_no = input(prompt2);
video_no=num2str(video_no);
case_video_infor=strcat('case',case_no,'video',video_no);
else
case_video_infor=strcat('case',case_no);
end
prompt3='what size is the patch?';
patch_x_size = input(prompt3);
patch_y_size = patch_x_size;
size_str=num2str(patch_x_size);
prompt4='what is the sliding of patch?';
sliding_x = input(prompt4);
sliding_y = sliding_x;
%prompt5='what is the type of patches? originial or preprocessed?';
type=' testing';

%type=input(prompt5,'s');
us_folder=strcat('C:\Users\NeuroBeast\Desktop\us + masks\',case_video_infor,'\US');
labels_folder=strcat('C:\Users\NeuroBeast\Desktop\us + masks\',case_video_infor,'\Labels');
addpath(us_folder);
addpath(labels_folder);
%us_patches_folder='C:\Users\NeuroBeast\Desktop\case2 + case3 test\patches';
%labels_patches_folder='C:\Users\NeuroBeast\Desktop\case2 + case3 test\labels';
us_patches_folder=strcat('C:\Users\NeuroBeast\Desktop\',case_video_infor,type,'\patches');
labels_patches_folder=strcat('C:\Users\NeuroBeast\Desktop\',case_video_infor,type,'\labels');
%
us_files = dir(fullfile(us_folder,'*.png')); 
us_files = {us_files.name};
labels_files = dir(fullfile(labels_folder,'*.png')); 
labels_files = {labels_files.name};
%% Eidt here for patches sizes:
count=1;
for i = 1:length(us_files)
    us=us_files{i};
    labels=labels_files{i};
    us=imread(us);
    labels=imread(labels);
    %labels=labels_map;
    [height,width,channels]=size(labels);
    x_steps = floor((width-patch_x_size+1)/sliding_x);
    y_steps = floor((height-patch_y_size+1)/sliding_y);
    pxlabel=zeros(height,width);
    for m=0:x_steps
        
        for n=0:y_steps
            left_corner_up_x=m*sliding_x;
            %left_corner_down_x=left_corner_up_x+patch_x_size-1;
            left_corner_up_y=n*sliding_y;
            %left_corner_down_y=left_corner_up_y+patch_y_size-1;
            if (n ==y_steps)
            patch = imcrop(us,[left_corner_up_x width-patch_y_size patch_x_size-1 patch_y_size-1]);
            patch_labels=imcrop(labels,[left_corner_up_x width-patch_y_size patch_x_size-1 patch_y_size-1]);
            patch=imresize(patch,[patch_x_size patch_y_size]);
            patch_labels=imresize(patch_labels,[patch_x_size patch_y_size]);
            else
            patch = imcrop(us,[left_corner_up_x left_corner_up_y patch_x_size-1 patch_y_size-1]);
            patch_labels=imcrop(labels,[left_corner_up_x left_corner_up_y patch_x_size-1 patch_y_size-1]);
            patch=imresize(patch,[patch_x_size patch_y_size]);
            patch_labels=imresize(patch_labels,[patch_x_size patch_y_size]);
            end
            count_str=num2str(count);
            patch_name=strcat('size_',size_str,'_',type,'_',case_video_infor,'_image_',count_str,'.png');
            patch_name=fullfile(us_patches_folder,patch_name);
            patch_labels_name=strcat('size_',size_str,'_',type,'_',case_video_infor,'_label_',count_str,'.png');
            patch_labels_name=fullfile(labels_patches_folder,patch_labels_name);
            imwrite(patch,patch_name);
            imwrite(patch_labels,patch_labels_name);
            count=count+1;
            fprintf('processing...');
            fprintf('\n\n');
        end
    end
end
disp('End')