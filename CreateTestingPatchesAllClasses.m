% Create testing patches for verifiying the fine-tuned model:
clc
clear all
%% Define parameters for patches:
% find the images folder:
imgs_path = uigetdir;
resolution='High';
effective_area=1;
% for reading files:
indexes = {'001';'204';'209';'211'};
% for classes of labels:
cases={'Healthy';'Tumour';'Others'};
%% main programme
%for s=20:10:40
s=50;
patch_size = s;
patch_size_char=char(patch_size);
sliding = patch_size*0.5;
patch_size_string = num2str(patch_size);
amount_patches_healthy=1;
amount_patches_tumour=1;
amount_patches_others=1;
%% Create patches
% transform the ground truth to hsv:
for no = 1:length(indexes)
% prepare to store locations of all effective patches for each input:
%tumour_co = {};healthy_co={};others_co={};
%tumour_patches = {};healthy_patches={};others_patches={};
index=indexes{no};
%read ground truth files:
ground_truth_name=strcat('case1_Coronal+000',index,'-000.jpg'); 
ground_truth_path = strcat(imgs_path,'\GroundTruth');
ground_truth_fullname = fullfile(ground_truth_path,ground_truth_name);
truth=imread(ground_truth_fullname);
[height,width,dim]=size(truth);
x_steps = fix((width-patch_size+1)/sliding);
y_steps = fix((height-patch_size+1)/sliding);
pixels_amount = (patch_size)*(patch_size);%pixels amount
%read original US files: 
us_name = strcat('case1_video10',index,'.jpeg');
us_path = strcat(imgs_path,'\US');
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
R_channel_processed = processed_truth(:,:,1);r=mean2(R_channel_processed);
G_channel_processed = processed_truth(:,:,2);g=mean2(G_channel_processed);
B_channel_processed = processed_truth(:,:,2);b=mean2(B_channel_processed);
processed_truth_h=ones(height,width,dim);
processed_truth_t=ones(height,width,dim);
processed_truth_o=ones(height,width,dim);
for c=1:length(cases) 
    label = cases{c};
    switch label
        case 'Healthy'
            folder_healthy = strcat('C:\Users\NeuroBeast\Desktop\',resolution,'_resolution_test');
            folder_healthy_1 = sprintf('%d',s);
            folder_healthy=strcat(folder_healthy,'\',folder_healthy_1,'\Healthy');
            for j=1:width
                for i =1:height
                    if (processed_truth(i,j,1)< r && processed_truth(i,j,2)>g && processed_truth(i,j,3)>b)
                        processed_truth_h(i,j,1)=0;
                        processed_truth_h(i,j,2)=1;
                        processed_truth_h(i,j,3)=1;
                    else
                        processed_truth_h(i,j,1)=0;
                        processed_truth_h(i,j,2)=0;
                        processed_truth_h(i,j,3)=0;
                    end
                end
            end
            %figure 
            %imshow(processed_truth_h)
            %hold on 
            for m=0:x_steps
                for n=0:y_steps
                    patch = imcrop(processed_truth_h,[2+m*sliding 2+n*sliding patch_size patch_size]);
                    r_channel = patch(:,:,1);
                    g_channel = patch(:,:,2);
                    b_channel = patch(:,:,3);
                    r_sum = sum(sum(r_channel));g_sum = sum(sum(g_channel));b_sum = sum(sum(b_channel));
                    if (g_sum >= pixels_amount*1*effective_area && b_sum >= pixels_amount*1*effective_area)
                    %rec = rectangle('Position',[2+m*sliding 2+n*sliding patch_size patch_size],'EdgeColor','b','LineWidth',2);
                    %current_healthy_patch_location = [2+m*sliding 2+n*sliding patch_size patch_size];
                    %healthy_co{end+1}=current_healthy_patch_location;
                    patch_healthy = imcrop(us,[2+m*sliding 2+n*sliding patch_size patch_size]);
                    %healthy_patches{end+1}=patch_healthy;
                    h_file_name = sprintf('patch_healthy_%d_%d.mat',patch_size,amount_patches_healthy);
                    fullname_h = fullfile(folder_healthy,h_file_name);
                    save(fullname_h,'patch_healthy');
                    amount_patches_healthy=amount_patches_healthy+1;
                    else
                        %pass
                        
                    end
                end
            end
            %hold off
        case 'Tumour'
             folder_tumour = strcat('C:\Users\NeuroBeast\Desktop\',resolution,'_resolution_test');
             folder_tumour_1 = sprintf('%d',s);
             folder_tumour=strcat(folder_tumour,'\',folder_tumour_1,'\Tumour');
             for j=1:width
                for i =1:height
                    if (processed_truth(i,j,1)< r && processed_truth(i,j,2)>g && processed_truth(i,j,3)<b)
                        processed_truth_t(i,j,1)=0;
                        processed_truth_t(i,j,2)=1;
                        processed_truth_t(i,j,3)=0;
                    else
                        processed_truth_t(i,j,1)=0;
                        processed_truth_t(i,j,2)=0;
                        processed_truth_t(i,j,3)=0;
                    end
                end
             end 
             %figure 
             %imshow(processed_truth_t)
             %hold on
             for m=0:x_steps
                for n=0:y_steps
                    patch = imcrop(processed_truth_t,[2+m*sliding 2+n*sliding patch_size patch_size]);
                    r_channel = patch(:,:,1);
                    g_channel = patch(:,:,2);
                    b_channel = patch(:,:,3);
                    r_sum = sum(sum(r_channel));g_sum = sum(sum(g_channel));b_sum = sum(sum(b_channel));
                    if (g_sum >= pixels_amount*1*effective_area)
                    %rec = rectangle('Position',[2+m*sliding 2+n*sliding patch_size patch_size],'EdgeColor','b','LineWidth',2);
                    %current_tumour_patch_location = [2+m*sliding 2+n*sliding patch_size patch_size];
                    %tumour_co{end+1}=current_tumour_patch_location; 
                    patch_tumour = imcrop(us,[2+m*sliding 2+n*sliding patch_size patch_size]);
                    %tumour_patches{end+1}=patch_tumour;
                    t_file_name = sprintf('patch_tumour_%d_%d.mat',patch_size,amount_patches_tumour);
                    fullname_t = fullfile(folder_tumour,t_file_name);
                    save(fullname_t,'patch_tumour');
                    amount_patches_tumour=amount_patches_tumour+1;                    
                    else
                        %pass
                    end
                end
             end             
             %hold off
        case 'Others'
            folder_others = strcat('C:\Users\NeuroBeast\Desktop\',resolution,'_resolution_test');
            folder_others_1 = sprintf('%d',s);
            folder_others=strcat(folder_others,'\',folder_others_1,'\Others');            
            for j=1:width
                for i =1:height
                    if (processed_truth(i,j,1)< r && processed_truth(i,j,2)>g && processed_truth(i,j,3)>b)
                        processed_truth_o(i,j,1)=0;
                        processed_truth_o(i,j,2)=0;
                        processed_truth_o(i,j,3)=0;
                    elseif (processed_truth(i,j,1)< r && processed_truth(i,j,2)>g && processed_truth(i,j,3)<b)
                        processed_truth_o(i,j,1)=0;
                        processed_truth_o(i,j,2)=0;
                        processed_truth_o(i,j,3)=0;
                    else
                        processed_truth_o(i,j,1)=1;
                        processed_truth_o(i,j,2)=0;
                        processed_truth_o(i,j,3)=0;                        
                    end
                end
            end
            %figure 
            %imshow(processed_truth_o)
            %hold on 
            for m=0:x_steps
                for n=0:y_steps
                    patch = imcrop(processed_truth_o,[2+m*sliding 2+n*sliding patch_size patch_size]);
                    r_channel = patch(:,:,1);
                    g_channel = patch(:,:,2);
                    b_channel = patch(:,:,3);
                    r_sum = sum(sum(r_channel));g_sum = sum(sum(g_channel));b_sum = sum(sum(b_channel));
                    if (r_sum >= pixels_amount*1*effective_area)
                    %rec = rectangle('Position',[2+m*sliding 2+n*sliding patch_size patch_size],'EdgeColor','b','LineWidth',2);
                    %current_others_patch_location = [2+m*sliding 2+n*sliding patch_size patch_size];
                    %others_co{end+1}=current_others_patch_location;    
                    patch_others = imcrop(us,[2+m*sliding 2+n*sliding patch_size patch_size]);
                    %others_patches{end+1}=patch_others;
                    o_file_name = sprintf('patch_others_%d_%d.mat',patch_size,amount_patches_others);
                    fullname_o = fullfile(folder_others,o_file_name);
                    save(fullname_o,'patch_others');
                    amount_patches_others=amount_patches_others+1;                   
                    else
                        %pass
                    end
                end
            end            
            %hold off
    end
end
end
disp('processing...')
%end



disp('End')