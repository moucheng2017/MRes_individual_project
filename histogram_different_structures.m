% analyse the histogram of different structures to prove thresholding
% intensities are not suitable for this task
clc
clear all
% plot different structures's histogram 
% read classes
labels_folder='C:\Users\NeuroBeast\Desktop\us + masks\case2\Labels';
% read us images
us_folder='C:\Users\NeuroBeast\Desktop\us + masks\case2\US';
% sort pixels into different classes
label_image='binaryclasses_case2000000000000000.tif';
us_image='case2000000000000000.jpeg';
%
label_img=imread(fullfile(labels_folder,label_image));
us_img=imread(fullfile(us_folder,us_image));
[height,width,dims]=size(label_img);
intensities_tumour=[];
intensities_healthy=[];
for i =1:height
    for j = 1:width-2
        if (label_img(i,j,1)==0)
            intensity=us_img(i,j,1);
            intensities_healthy=[intensities_healthy;intensity];
        else
            intensity=us_img(i,j,1);
            intensities_tumour=[intensities_tumour;intensity];
        end    
    end
end
histogram(intensities_healthy);
hold on
histogram(intensities_tumour);
hold off
axis([0 160 0 1e4])
[filepath,name,ext]=fileparts(us_image);
%title(name)
%filename=fullfile('C:\Users\NeuroBeast\Desktop\results 20180811',strcat('hist_',name,'.png'));
%saveas(figure,filename)
disp('End')