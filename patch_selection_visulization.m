% visuliaze filtered patches:
clc
clear all
%% Define parameters for patches:
% find the images folder:
training_path = 'C:\Users\NeuroBeast\Desktop\images_high_resolution\Training';
resolution='high';
casenumber = 'case1';
effective_area=1;
%sliding_percentage=0.5;
training_size_x=224;
training_size_y=224;
alpha_h = 10;
alpha_o = 0;
entropy_thresh_healthy_square=5.86-alpha_h*0.33;%case1video4
entropy_thresh_others_square=3.938-alpha_o*2.177;%case1video4
%entropy_thresh_healthy_square=4.834-alpha_h*1.08;%case1video1
%entropy_thresh_tumour_square=6.16489-alpha*2.7166;%case1video1
mean_threshold =10;
% for reading files:
%indexes = {'0000';'0006';'0027';'0203';'0210'};%case1video1
indexes = {'0158';'0429';'0856';'1226';'0340';'0505'};%case1video4
%cases = {'White matter';'Grey matter';'Tumour';'Others'};
cases={'Healthy';'Others'};
patch_scale = 'square';%rectangle_x: rectangle along x direction;
%% main programme
for s =10:10
%for s = 15:10:40
%for s=15:5:30
%for s = 10:5:20
switch patch_scale
    case 'rectangle_x'
        patch_x_size = 3*s;% for s=10:5:20
        %patch_x_size = 2*s;% for s=15:5:30
        patch_y_size = s;
        if (s<20)
            sliding_x = 0.5*patch_x_size;
            sliding_y = patch_y_size;
        else
            sliding_x = 10;
            sliding_y = 0.5*patch_y_size;
        end
            
    case 'rectangle_y'
        patch_x_size = s;
        %patch_y_size = 2*s;%for s=15:5:30
        patch_y_size = 3*s;%for s =10:5:20
        if (s<20)
            sliding_x = patch_x_size;
            sliding_y = patch_y_size*0.5;
        else
            sliding_x = 0.5*patch_x_size;
            sliding_y = 10;
        end
        
    case 'square'
        patch_x_size = s;
        patch_y_size = s;
        if (s < 30)
            sliding_x = 0.5*s;%patch_x_size*0.5;
            sliding_y = 0.5*s;%patch_y_size*0.5;
        else
            sliding_x = 0.5*patch_x_size;%patch_x_size*0.5;
            sliding_y = 0.5*patch_y_size;%patch_y_size*0.5;
        end
        
end

%sliding = 0.5*s;

amount_patches_healthy=1;
amount_patches_tumour=1;
amount_patches_others=1;
% transform the ground truth to hsv:
for no = 1:1%length(indexes)
index=indexes{no};
%read ground truth files:
ground_truth_name=strcat('case1_Coronal+00',index,'-000.jpg'); 
[filepath,ground_truth_name_no_extension,extension]=fileparts(ground_truth_name);
ground_truth_path = strcat(training_path,'\GroundTruth');
ground_truth_fullname = fullfile(ground_truth_path,ground_truth_name);
truth=imread(ground_truth_fullname);
[height,width,dim]=size(truth);
x_steps = floor((width-patch_x_size+1)/sliding_x);
y_steps = floor((height-patch_y_size+1)/sliding_y);
pixels_amount = (patch_x_size)*(patch_y_size);%pixels amount
%read original US files: 
us_name = strcat('case1_Coronal+00',index,'-000.jpg');% for case1video4
%us_name = strcat('case1_video1',index,'.jpeg');%for case1video1
us_path = strcat(training_path,'\US');
us_fullname = fullfile(us_path,us_name);
us = imread(us_fullname);
% transofrm the ground truth file into hsv file for enhancing colour:
hsv_img = rgb2hsv(truth);
for i = 1:height
   for j = 1:width
       hsv_img(i,j,2)=1;
   end
end
% transform the processed hsv back to rgb file:
processed_truth = hsv2rgb(hsv_img);
% calculate the mean values for rgb channels:
R_channel_processed = processed_truth(:,:,1);r=mean2(R_channel_processed);std_r_ground_truth=std2(R_channel_processed);
G_channel_processed = processed_truth(:,:,2);g=mean2(G_channel_processed);std_g_ground_truth=std2(G_channel_processed);
B_channel_processed = processed_truth(:,:,3);b=mean2(B_channel_processed);std_b_ground_truth=std2(B_channel_processed);
%processed_truth_h=ones(height,width,dim);
processed_truth_whitematter=ones(height,width,dim);
%processed_truth_sulcus=ones(height,width,dim);
processed_truth_t=ones(height,width,dim);
processed_truth_o=ones(height,width,dim);
processed_truth_h=ones(height,width,dim);
for c=1:2%length(cases) 
    label = cases{c};
    switch label
        case 'Healthy' %'Grey matter'
            for j=1:width
                for i =1:height
                    %green in case1video4 is greymatter
                    if (processed_truth(i,j,1)< (r+0.5*std_r_ground_truth) && processed_truth(i,j,2)>(g-1*std_g_ground_truth) && processed_truth(i,j,3)>(b-0*std_b_ground_truth))
                    
                    %green in case1video1 is healthy
                    %if (processed_truth(i,j,1)< (r+0*std_r_ground_truth) && processed_truth(i,j,2)>(g-0*std_g_ground_truth) && processed_truth(i,j,3)>(b-0*std_b_ground_truth))
                        processed_truth_h(i,j,1)=0;
                        processed_truth_h(i,j,2)=1;
                        processed_truth_h(i,j,3)=0;
                        
                       
                    %brown in case1video4 whitematter
                    elseif (processed_truth(i,j,1)> (r-0.5*std_r_ground_truth) && processed_truth(i,j,2)< (g+0.3*std_g_ground_truth) && processed_truth(i,j,3)< (b-0*std_b_ground_truth))
                        processed_truth_h(i,j,1)=0;
                        processed_truth_h(i,j,2)=1;
                        processed_truth_h(i,j,3)=0;  
                        %}
                    %{    
                    % yellow in case1video4 is sulcus
                    elseif (processed_truth(i,j,1)> (r+1*std_r_ground_truth) && processed_truth(i,j,2)>(g+0.5*std_g_ground_truth) && processed_truth(i,j,3)<(b-1*std_b_ground_truth))
                        processed_truth_h(i,j,1)=0;
                        processed_truth_h(i,j,2)=1;
                        processed_truth_h(i,j,3)=0;     
                     %}
                    else
                        processed_truth_h(i,j,1)=0;
                        processed_truth_h(i,j,2)=0;
                        processed_truth_h(i,j,3)=0;
                    end
                end
            end
            figure 
            imshow(truth)
            hold on 
            
            for m=0:x_steps
                for n=0:y_steps
                    patch = imcrop(processed_truth_h,[2+m*sliding_x 2+n*sliding_y patch_x_size patch_y_size]);
                    r_channel = patch(:,:,1);
                    g_channel = patch(:,:,2);
                    b_channel = patch(:,:,3);
                    r_sum = sum(sum(r_channel));g_sum = sum(sum(g_channel));b_sum = sum(sum(b_channel));
                    if (g_sum >= pixels_amount*1)
                    patch_temp = imcrop(us,[2+m*sliding_x 2+n*sliding_y patch_x_size patch_y_size]);
                    mean_patch = mean(patch_temp(:));
                    e_patch = entropy(patch_temp);
                    %if(mean_patch>mean_threshold)
                    if (e_patch > entropy_thresh_healthy_square)
                        rec = rectangle('Position',[2+m*sliding_x 2+n*sliding_y patch_x_size patch_y_size],'EdgeColor','g','LineWidth',0.5);
                        amount_patches_healthy=amount_patches_healthy+1;
                        fprintf('patch healthy %d is processing...',amount_patches_healthy);
                        fprintf('\n\n');
                    else
                        %pass
                    end
                    else
                        %pass
                        
                    end
                end
            end
            hold off
            %imwrite(us,'C:\Users\NeuroBeast\Desktop\results15062018\selection.jpg')

        case 'Others'
            for j=1:width
                for i =1:height 
                    %case1video1 healty
                    %{
                    if (processed_truth(i,j,1)< (r+0*std_r_ground_truth) && processed_truth(i,j,2)>(g+0*std_g_ground_truth) && processed_truth(i,j,3)>(b-0.5*std_b_ground_truth))
                        processed_truth_o(i,j,1)=0;
                        processed_truth_o(i,j,2)=0;
                        processed_truth_o(i,j,3)=0; 
                    %}
                      
                    
                    %case1video4 grey matter
                    if (processed_truth(i,j,1)< (r+0*std_r_ground_truth) && processed_truth(i,j,2)>(g-0.5*std_g_ground_truth) && processed_truth(i,j,3)>(b-0.5*std_b_ground_truth))
                        processed_truth_o(i,j,1)=0;
                        processed_truth_o(i,j,2)=0;
                        processed_truth_o(i,j,3)=0;
                    
                    %case1video4 white matter
                    elseif (processed_truth(i,j,1)> (r-0.5*std_r_ground_truth) && processed_truth(i,j,2)< (g+0.3*std_g_ground_truth) && processed_truth(i,j,3)< (b-0*std_b_ground_truth))
                        processed_truth_o(i,j,1)=0;
                        processed_truth_o(i,j,2)=0;
                        processed_truth_o(i,j,3)=0;
                    
                    %case1video4/case1video1 tumour:
                    elseif (processed_truth(i,j,1)< (r+0*std_r_ground_truth) && processed_truth(i,j,2)>(g-0*std_g_ground_truth) && processed_truth(i,j,3)<(b+0*std_b_ground_truth))
                        processed_truth_o(i,j,1)=0;
                        processed_truth_o(i,j,2)=0;
                        processed_truth_o(i,j,3)=0;
                    else
                        processed_truth_o(i,j,1)=0;
                        processed_truth_o(i,j,2)=0;
                        processed_truth_o(i,j,3)=1;                        
                    end
                end
            end
            figure 
            imshow(truth)
            hold on
            
            for m=0:x_steps
                for n=0:y_steps
                    patch = imcrop(processed_truth_o,[2+m*sliding_x 2+n*sliding_y patch_x_size patch_y_size]);
                    r_channel = patch(:,:,1);
                    g_channel = patch(:,:,2);
                    b_channel = patch(:,:,3);
                    r_sum = sum(sum(r_channel));g_sum = sum(sum(g_channel));b_sum = sum(sum(b_channel));
                    if (b_sum >= pixels_amount*1)    
                    patch_temp = imcrop(us,[2+m*sliding_x 2+n*sliding_y patch_x_size patch_y_size]);
                    mean_patch = mean(patch_temp(:));
                    e_patch = entropy(patch_temp);
                    %if(mean_patch>mean_threshold)
                    if (e_patch > entropy_thresh_others_square)
                        
                        rec = rectangle('Position',[2+m*sliding_x 2+n*sliding_y patch_x_size patch_y_size],'EdgeColor','r','LineWidth',0.5);  
                        fprintf('patch others %d is processing...',amount_patches_others);
                        fprintf('\n\n');                   
                    else
                        %pass
                    end

                    else
                        %pass
                    end
                end
            end            
            hold off
            %{
        case 'Tumour'
             for j=1:width
                for i =1:height
                    if (processed_truth(i,j,1)< (r+0*std_r_ground_truth) && processed_truth(i,j,2)>(g-0*std_g_ground_truth) && processed_truth(i,j,3)<(b+0*std_b_ground_truth))
                        processed_truth_t(i,j,1)=1;
                        processed_truth_t(i,j,2)=0;
                        processed_truth_t(i,j,3)=0;
                    else
                        processed_truth_t(i,j,1)=0;
                        processed_truth_t(i,j,2)=0;
                        processed_truth_t(i,j,3)=0;
                    end
                end
             end 
             figure 
             imshow(truth)
             hold on
             
             for m=0:x_steps
                for n=0:y_steps
                    patch = imcrop(processed_truth_t,[2+m*sliding_x 2+n*sliding_y patch_x_size patch_y_size]);
                    r_channel = patch(:,:,1);
                    g_channel = patch(:,:,2);
                    b_channel = patch(:,:,3);
                    r_sum = sum(sum(r_channel));g_sum = sum(sum(g_channel));b_sum = sum(sum(b_channel));
                    if (r_sum >= pixels_amount*1)
                    patch_temp = imcrop(us,[2+m*sliding_x 2+n*sliding_y patch_x_size patch_y_size]);
                    mean_patch = mean(patch_temp(:));
                    e_patch = entropy(patch_temp);
                    if(mean_patch>mean_threshold)
                    %if (e_patch > entropy_thresh_tumour_square)
                        patch_tumour = patch_temp;
                        rec = rectangle('Position',[2+m*sliding_x 2+n*sliding_y patch_x_size patch_y_size],'EdgeColor','r','LineWidth',0.5);
                        fprintf('patch tumour %d is processing...',amount_patches_tumour);
                        fprintf('\n\n');                    
                    else
                        %pass
                    end

                    else
                        %pass
                    end
                end
             end             
             hold off
             %}
    end
end
end
end
disp('End')