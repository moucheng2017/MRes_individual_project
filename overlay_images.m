folder_us='C:\Users\NeuroBeast\Desktop\us + masks\case6\US';
folder_mask='C:\Users\NeuroBeast\Desktop\us + masks\case6\Labels';
saving_folder='C:\Users\NeuroBeast\Desktop\results 20180829';
%folder_mask=strcat('C:\Users\NeuroBeast\Desktop\results 20180829\',model_name);
addpath(folder_us);
addpath(folder_mask);
all_us = dir(fullfile(folder_us,'\*.png'));
all_us = {all_us.name}';
all_mask = dir(fullfile(folder_mask,'\*.png'));
all_mask = {all_mask.name}';
for i=1:length(all_us)
    us_name=all_us{i};
    mask_name=all_mask{i};
    us=imread(fullfile(folder_us,us_name));
    [height,width,channels]=size(us);
    [f,name1,ext]=fileparts(us_name);
    %[f2,name2,ext2]=fileparts(mask_name);
    %us = imcrop(us,[0 0 300 300]);
    %us =  imresize(us,[300 300]);
    mask=imread(fullfile(folder_mask,mask_name));
    mask=imresize(mask, [height width]);
    us_mask = us.*0.8+mask.*0.2;
    %figure
    %imshow(us_mask);
    name=strcat(saving_folder,'\overlayed_',name1,'.png');
    imwrite(us_mask,name)
    
end

disp('end')
%im1 = imread(fullfile(folder1,im1_name));
%[height,width,dim]=size(im1);
%im1 = imresize(im1,[460 555]);
%im2 = imread(fullfile(folder2,im2_name));
%img=imfuse(im2,im1,'blend');
%img = im1.*0.5+im2.*0.5;
%figure
%imshow(img);
%name = strcat('C:\Users\NeuroBeast\Desktop\result 20180801\','ground truth_',im1_name,'.png');
%imwrite(img,name)
%set(h,'AlphaData',0.6)

