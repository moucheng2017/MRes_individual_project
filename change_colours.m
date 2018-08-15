% change colours
clc
clear all
folder='C:\Users\NeuroBeast\Desktop\us + masks\case1video4\ground truth';
files = dir(fullfile(folder,'*.png')); 
files = {files.name};
addpath(folder);
for ii = 1:length(files)
    filename=files{ii};
    img= imread(filename);
    [height,width,channel_size]= size(img);
    for i = 1:height
        for j = 1:width
            if (img(i,j,1)== 255 && img(i,j,2)== 0 && img(i,j,3)== 0)
                img(i,j,1)= 255;
                img(i,j,2)= 0;
                img(i,j,3)= 0;
                %{
            elseif (img(i,j,1)== 200 && img(i,j,2)== 150 && img(i,j,3)== 100)
                img(i,j,1)= 255;
                img(i,j,2)= 0;
                img(i,j,3)= 0;
                %}
            else
                img(i,j,1)= 0;
                img(i,j,2)= 0;
                img(i,j,3)= 0;
            end
    
        end

    end
    figure
    imshow(img)     
    name=filename(9:end);
    labelfilename=strcat('binaryclasses_',name);
    fullname = fullfile(folder,labelfilename);
    imwrite(img,fullname);    
    
end
