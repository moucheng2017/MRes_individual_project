%% crop images:
%{
clc
clear all
training_folder = 'C:\Users\NeuroBeast\Desktop\images_high_resolution\Testing\US';
indexes = {'0001';'0204';'0209';'0211'};%case1video1
index=indexes{4};
us_name = strcat('case1_video1',index,'.jpeg');
us_fullname = fullfile(training_folder,us_name);
us = imread(us_fullname);
[J, rect] = imcrop(us);
[filepath,name,ext] = fileparts(us_name);
savename=strcat(name,'_easytestingSample1.jpg');
%}
savefolder='C:\Users\NeuroBeast\Desktop\case1video1 easy healthy areas testing';
%savefilename=fullfile(savefolder,savename);
%imwrite(J,savefilename);
%% divide cropped images into patches
patchfolder='C:\Users\NeuroBeast\Desktop\case1video1 easy healthy patches testing';
allfiles=dir(fullfile(savefolder,'*.jpg'));
allfiles={allfiles.name};
allpatches=dir(fullfile(patchfolder,'*.jpg'));
allpatches={allpatches.name};
count_patch=length(allpatches);
for patch_size=20:1:40
for i =1:length(allfiles)
    filename=allfiles{i};
    img_file=fullfile(savefolder,filename);
    img=imread(img_file);
    figure
    imshow(img)
    hold on
    [m,n,dim]=size(img);
    height=floor(m/patch_size);
    r_height=rem(m,patch_size);
    width=floor(n/patch_size);
    r_width=rem(n,patch_size);
    for j=0:height-1
        for k=0:width-1
            patch = imcrop(img,[k*patch_size j*patch_size patch_size patch_size]);
            rec = rectangle('Position',[k*patch_size j*patch_size patch_size patch_size],'EdgeColor','b','LineWidth',0.5);
            count_patch=count_patch+1;
            currentindex=num2str(count_patch);
            patch_name=strcat('easy_healthy_testing_patch_case1video1_',currentindex,'.jpg');
            patch_fullname = fullfile(patchfolder,patch_name);
            imwrite(patch,patch_fullname);
            fprintf('patch healthy is processing...');
            fprintf('\n\n');
        end
    end
    hold off
end
end

disp('End')
