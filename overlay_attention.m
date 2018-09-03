us_name='C:\Users\NeuroBeast\Desktop\us + masks\case2\US\case2000000000000100.jpeg';
folder_mask=strcat('C:\Users\NeuroBeast\Desktop\results 20180829');
%addpath(folder_us);
addpath(folder_mask);
%all_us = dir(fullfile(folder_us,'\*.'));
%all_us = {all_us.name}';
all_mask = dir(fullfile(folder_mask,'\*.png'));
all_mask = {all_mask.name}';
for i=1:length(all_mask)
    mask_name=all_mask{i};
    us=imread(us_name);
    %[f,name1,ext]=fileparts(us_name);
    [f2,name2,ext2]=fileparts(mask_name);
    %us = imcrop(us,[0 0 448 448]);
    us =  imresize(us,[448 448]);
    mask=imread(fullfile(folder_mask,mask_name));
    mask=imresize(mask, [448 448]);
    us_mask = us.*0.2+mask.*0.8;
    figure
    imshow(us_mask);
    name=strcat(folder_mask,'\mask_',name2,'.png');
    imwrite(us_mask,name)
    
end


