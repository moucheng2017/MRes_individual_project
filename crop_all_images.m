% crop all images to the same sizes
% This is for trimming all images to get rid of logo.
clc
clear all
folder = uigetdir;
path = folder;
addpath(path);
m_files = dir(fullfile(folder,'*.jpeg')); 
m_files = {m_files.name};
%overlapping=20;
%%
for i = 1:length(m_files)
    file_temp = imread(m_files{i});
    [height,width,channels]=size(file_temp);
    new_file = imcrop(file_temp,[0 70 width height-100]);
    fullname = fullfile(path,m_files{i});
    figure
    imshow(new_file);
    imwrite(new_file,fullname);
end

%{
I = imread('case1_Coronal+000209-000.jpg');
figure
imshow(I)
[y_size,x_size,channels]=size(I);
J = imcrop(I,[0 0 x_size y_size-30]);
figure 
imshow(J)
[yy_size,xx_size,cchannels]=size(J);
%}

disp('end')