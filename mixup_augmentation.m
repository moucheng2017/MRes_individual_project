% data augmentation using mixup
clc
clear all
%%
folder = 'C:\Users\NeuroBeast\Desktop\us + masks\case2\Labels';
addpath(folder);
files = dir(fullfile(folder,'*.png')); 
files = {files.name};
%%
image1=9;image1_str=num2str(image1);
image2=10;image2_str=num2str(image2);
x = 0.3;x_str=num2str(x);
%%
file1=files{image1};
file2=files{image2};
file1=fullfile(folder,file1);
file2=fullfile(folder,file2);
im1=imread(file1);
im2=imread(file2);
new_img=x.*im1+(1-x).*im2;
figure
imshow(new_img);
filename=strcat('case2_label_synthetic_',image1_str,'_',image2_str,'_',x_str,'.png');
savefolder=strcat(folder,'\synthetic');
fullname=fullfile(savefolder,filename);
imwrite(new_img,fullname);