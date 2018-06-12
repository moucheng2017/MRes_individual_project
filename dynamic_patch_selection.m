% dynamic patches selection
clc
clear all
%% 
folder='C:\Users\NeuroBeast\Desktop\dynamic_patch_experiment\case1video1';
addpath(folder);
files = dir(fullfile(folder,'*.jpg')); 
files = {files.name};
%% find the first patch within the target
s = 5;% initial patch size set up as 5 x 5;
step=1;
pixels_amount= s^2;
for i = 1:1%ength(files)
    x_first=0;
    y_step=0;
    xstep=1;
    ystep=1;
    file=imread(files{i});
    [height,width,dim]=size(file);
    height=1*height;
    width=1*width;
    file=imresize(file,[height width]);
    figure
    imshow(file)
    hold on
    %[height,width,dim]=size(file);
    x_steps_max=floor(width/s);
    y_steps_max=floor(height/s);
    while (xstep <= x_steps_max)
    patch = imcrop(file,[x_first y_step s s]);
    patch = ((double(patch)-double(min(patch(:)))) ./ double((max(patch(:)-min(patch(:))))));
    r_channel = patch(:,:,1);
    g_channel = patch(:,:,2);
    b_channel = patch(:,:,3);
    r_sum = sum(sum(r_channel));g_sum = sum(sum(g_channel));b_sum = sum(sum(b_channel));
    if (r_sum >= pixels_amount && g_sum >= pixels_amount)
        rec = rectangle('Position',[x_first y_step s s],'EdgeColor','b','LineWidth',2);
        patch = imcrop(file,[x_first y_step s s]);
        patch = ((double(patch)-double(min(patch(:)))) ./ double((max(patch(:)-min(patch(:))))));
        break
    else
        ystep=ystep+1;
        y_step=y_step+step;
    end
    
    if (ystep>y_steps_max) 
        ystep=1;
        xstep=xstep+1;
        x_first=x_first+step;
        y_step=0;
    else
        %pass
    end

    end
    hold off
end
%% move along the upborder
