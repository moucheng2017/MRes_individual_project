% each sample is used to generate 4 patches
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

%prompt5='what is the type of patches? originial or preprocessed?';
type=' large original';

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
us_files = dir(fullfile(us_folder,'*.jpeg')); 
us_files = {us_files.name};
labels_files = dir(fullfile(labels_folder,'*.tif')); 
labels_files = {labels_files.name};
size_patch=400;
target_size=448;
size_str=num2str(size_patch);
%% Eidt here for patches sizes:
%count=1;
for i = 1:length(us_files)
    us=us_files{i};
    [f,usname,ext]=fileparts(us);
    labels=labels_files{i};
    us=imread(us);
    labels=imread(labels);
    %labels=labels_map;
    [height,width,channels]=size(us);
    patch1 = imcrop(us,[0 0 size_patch size_patch]);
    patch1=imresize(patch1,[target_size target_size]);
    patch2 = imcrop(us,[0 height-size_patch size_patch size_patch]);
    patch2=imresize(patch2,[target_size target_size]);
    patch3 = imcrop(us,[width-size_patch 0 size_patch size_patch]);
    patch3=imresize(patch3,[target_size target_size]);    
    patch4 = imcrop(us,[width-size_patch height-size_patch size_patch size_patch]);
    patch4=imresize(patch4,[target_size target_size]);    
    %
    patch_label_1 = imcrop(labels,[0 0 size_patch size_patch]);
    patch_label_1=imresize(patch_label_1,[target_size target_size]);
    patch_label_2 = imcrop(labels,[0 height-size_patch size_patch size_patch]);
    patch_label_2=imresize(patch_label_2,[target_size target_size]);
    patch_label_3 = imcrop(labels,[width-size_patch 0 size_patch size_patch]);
    patch_label_3=imresize(patch_label_3,[target_size target_size]);    
    patch_label_4 = imcrop(labels,[width-size_patch height-size_patch size_patch size_patch]);
    patch_label_4=imresize(patch_label_4,[target_size target_size]);
    %{

            patch = imcrop(us,[left_corner_up_x width-patch_y_size patch_x_size-1 patch_y_size-1]);
            patch_labels=imcrop(labels,[left_corner_up_x width-patch_y_size patch_x_size-1 patch_y_size-1]);
            patch=imresize(patch,[patch_x_size patch_y_size]);
            patch_labels=imresize(patch_labels,[patch_x_size patch_y_size]);

            patch = imcrop(us,[left_corner_up_x left_corner_up_y patch_x_size-1 patch_y_size-1]);
            patch_labels=imcrop(labels,[left_corner_up_x left_corner_up_y patch_x_size-1 patch_y_size-1]);
            patch=imresize(patch,[patch_x_size patch_y_size]);
     %}
            %count_str=num2str(count);
            %
            patch_name=strcat(usname,'_size_',size_str,'_',type,'_',case_video_infor,'_image_1.png');
            patch_name=fullfile(us_patches_folder,patch_name);
            patch_labels_name=strcat(usname,'_size_',size_str,'_',type,'_',case_video_infor,'_label_1.tif');
            patch_labels_name=fullfile(labels_patches_folder,patch_labels_name);
            imwrite(patch1,patch_name);
            imwrite(patch_label_1,patch_labels_name);
            %
            patch_name2=strcat(usname,'_size_',size_str,'_',type,'_',case_video_infor,'_image_2.png');
            patch_name2=fullfile(us_patches_folder,patch_name2);
            patch_labels_name2=strcat(usname,'_size_',size_str,'_',type,'_',case_video_infor,'_label_2.tif');
            patch_labels_name2=fullfile(labels_patches_folder,patch_labels_name2);
            imwrite(patch2,patch_name2);
            imwrite(patch_label_2,patch_labels_name2);
            %
            patch_name3=strcat(usname,'_size_',size_str,'_',type,'_',case_video_infor,'_image_3.png');
            patch_name3=fullfile(us_patches_folder,patch_name3);
            patch_labels_name3=strcat(usname,'_size_',size_str,'_',type,'_',case_video_infor,'_label_3.tif');
            patch_labels_name3=fullfile(labels_patches_folder,patch_labels_name3);
            imwrite(patch3,patch_name3);
            imwrite(patch_label_3,patch_labels_name3);            
            
            %
            patch_name4=strcat(usname,'_size_',size_str,'_',type,'_',case_video_infor,'_image_4.png');
            patch_name4=fullfile(us_patches_folder,patch_name4);
            patch_labels_name4=strcat(usname,'_size_',size_str,'_',type,'_',case_video_infor,'_label_4.tif');
            patch_labels_name4=fullfile(labels_patches_folder,patch_labels_name4);
            imwrite(patch4,patch_name4);
            imwrite(patch_label_4,patch_labels_name4);
            fprintf('processing...');
            fprintf('\n\n');

end
disp('End')