clc
clear all
img_folder = 'C:\Users\NeuroBeast\Desktop\images_high_resolution\Testing\US';
img_name = 'case1_Coronal+000313-000.jpg';
img_full = fullfile(img_folder,img_name);
img=imread(img_full);
[height,width,dim]=size(img);
gs_img=rgb2gray(img);
size(gs_img)
figure 
imshow(gs_img)
enhanced=imadjust(gs_img);
figure
imshow(enhanced)
size(enhanced)
%{
%% using denoising network
%{
net = denoisingNetwork('DnCNN');
img = img(:,:,1);
img=imresize(img,[50 50]);
denoised_img = denoiseImage(img, net);
%empty = zeros(height,width,dim);
%empty(:,:,1)=denoised_img;empty(:,:,1)=denoised_img;
denoised_img = imresize(denoised_img,[height width]);
figure
imshow(denoised_img)
imwrite(denoised_img,'C:\Users\NeuroBeast\Desktop\denoised_img_net.jpg')
%}
%% use filters:wiener filter
%result = wiener2(gs_img,[10 10]);
%Kmedian= medfilt2(gs_img,[3 3]);
%% use filters:
%result = medfilt2(gs_img);%median
%h = padarray(2,[2 2]) + fspecial('gaussian' ,[5 5],0.2);
%h=fspecial('average',[2 2]);
%h =fspecial('laplacian',0.3);
%h =fspecial('log',[3 3],0.2);
%h=fspecial('sharp');
result=imgaussfilt(img,500);
result = img-result;
%result = filter2(h,gs_img);%average
%result = cat(3, result, result, result);
%%
figure
imshow(result)
img_save_name=strcat('100_highpassfilter_',img_name);
savefile=fullfile(img_folder,img_save_name);
imwrite(result,savefile)
%}