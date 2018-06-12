clc
clear all
%% check normalization of input images
folder='C:\Users\NeuroBeast\Desktop\images_high_resolution\Training\US';
%file='case1_video10210.jpeg';
file = 'case1_Coronal+001041-000.jpg';
file=fullfile(folder,file);
img=imread(file);

figure 
imshow(img)

%processed_img = img/max(img(:));
%processed_img =uint8(255 .* ((double(img)-double(min(img(:)))) ./ double((max(img(:)-min(img(:)))))));

processed_img =((double(img)-double(min(img(:)))) ./ double((max(img(:)-min(img(:))))));
avg=mean2(processed_img);
sigma=std2(processed_img);
adjust_img=imadjust(img,[0 0.6],[0 1]);
figure
imshow(adjust_img)
%{
normalizedImage = uint8(255*mat2gray(img));
figure
imshow(normalizedImage);

%}
%% check similarity between healthy and tumour
%{
folder1='C:\Users\NeuroBeast\Desktop\multi_scale_3_classes_case1_without_empty_patches\Healthy';
file1='case1_Coronal+000000-000_patch_healthy_10_1615.jpg';
folder2='C:\Users\NeuroBeast\Desktop\high_resolution_patches_50%_sliding\patches_10\Tumour';
file2='patch_tumour_10_8.jpg';
file1=fullfile(folder1,file1);
file2=fullfile(folder2,file2);
img_healthy=imread(file1);
img_tumour=imread(file2);
mean_threshold = mean(img_healthy(:));
fprintf('mean intensity of healthy patch is %d',mean_threshold);
%{
figure
imhist(img_healthy)
hold on
imhist(img_tumour)
hold off
%}

%% check empty patches in healthy 
%{
healthy_folder_3classes='C:\Users\NeuroBeast\Desktop\multi_scale_3_classes_case1\Healthy';
healthy_files=dir(fullfile(healthy_folder_3classes,'*.jpg'));
healthy_files={healthy_files.name};
empty_patches=0;
for i=1:length(healthy_files)
    file=healthy_files{i};
    img_file=fullfile(healthy_folder_3classes,file);
    img=imread(img_file);
    mean_intensity=mean(img(:));
    if (mean_intensity<=mean_threshold)
        empty_patches=empty_patches+1;
    end
end
total=length(healthy_files);
percentage = 100*(empty_patches/total);
fprintf('There are %d empty patches, %d %patches.',empty_patches,percentage);
%}
%}
%}