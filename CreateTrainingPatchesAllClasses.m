% This is written to create patches for case1video4 with 3 classes.
clc
clear all
%% Define parameters for patches:
% find the images folder:
training_path = 'C:\Users\NeuroBeast\Desktop\us + masks';
effective_area=1;
% change here:
target_folder = 'small patches';
training_size_x=224;
training_size_y=224;
patient_index = '2';
% for reading files:
%indexes = {'0000';'0006';'0027';'0203';'0210'};%case1video1
%indexes = {'0158';'0429';'0856';'1226';'0340';'0505'};%case1video4
%cases = {'White matter';'Grey matter';'Tumour';'Others'};
% for ultrasound images:
us_folder=strcat('C:\Users\NeuroBeast\Desktop\us + masks\case',patient_index,'\US');
label_folder=strcat('C:\Users\NeuroBeast\Desktop\us + masks\case',patient_index,'\Labels');
us_files = dir(fullfile(us_folder,'*.jpeg')); 
label_files = dir(fullfile(label_folder,'*.tif'));
us_files = {us_files.name};
label_files = {label_files.name};
% for label images:
cases={'Healthy';'Tumour'};
%down_line_los=strfind(target_folder,'_');
%last_line_lo=down_line_los(end);
%patch_scale = target_folder(last_line_lo+1:length(target_folder));
patch_scale = 'square';%rectangle_x: rectangle along x direction;
%% main programme
%for s=27:27
for s = 20:10:80
switch patch_scale
    case 'rectanglex'
        %patch_x_size = 3*s;% for s=10:5:20
        patch_x_size = 2*s;% for s=15:5:30
        patch_y_size = s;
        if (s<25)
            sliding_x = patch_x_size;
            sliding_y = patch_y_size;
        else
            sliding_x = 10;
            sliding_y = 0.5*patch_y_size;
        end
    case 'rectangley'
        patch_x_size = s;
        patch_y_size = 2*s;%for s=15:5:30
        %patch_y_size = 3*s;%for s =10:5:20
        if (s<=30)
            sliding_x = patch_x_size;
            sliding_y = patch_y_size;
        else
            sliding_x = 0.5*patch_x_size;
            sliding_y = 10;
        end
        
    case 'square'
        patch_x_size = s;
        patch_y_size = s;  
        if (s <= 30)
            sliding_x = 10;%patch_x_size*0.5;
            sliding_y = 10;%patch_y_size*0.5;
        else
            sliding_x = 20;%patch_x_size*0.5;
            sliding_y = 20;%patch_y_size*0.5;
        end
end
amount_patches_healthy=1;
amount_patches_tumour=1;
amount_patches_others=1;
% transform the ground truth to hsv:
for no = 1:length(us_files)
%index=indexes{no};
%read ground truth files:
ground_truth_name=label_files{no}; 
[filepath,ground_truth_name_no_extension,extension]=fileparts(ground_truth_name);
ground_truth_fullname = fullfile(label_folder,ground_truth_name);
truth=imread(ground_truth_fullname);
[height,width,dim]=size(truth);
x_steps = floor((width-patch_x_size+1)/sliding_x);
y_steps = floor((height-patch_y_size+1)/sliding_y);
pixels_amount = (patch_x_size)*(patch_y_size);%pixels amount
%read original US files: 
us_name=us_files{no};
us_fullname = fullfile(us_folder,us_name);
us = imread(us_fullname);
imshow(us);
hold on
for c=1:length(cases) 
    label = cases{c};
    switch label
        case 'Healthy' 
            folder_healthy_multiscale=strcat('C:\Users\NeuroBeast\Desktop\',target_folder,'\Healthy');

            for m=0:x_steps
                for n=0:y_steps
                    patch = imcrop(truth,[2+m*sliding_x 2+n*sliding_y patch_x_size patch_y_size]);
                    r_channel = patch(:,:,1);mean_r=mean2(r_channel);
                    if (mean_r<=1*effective_area)
                    patch_temp = imcrop(us,[2+m*sliding_x 2+n*sliding_y patch_x_size patch_y_size]);
                    patch_healthy = patch_temp;
                    rec = rectangle('Position',[2+m*sliding_x 2+n*sliding_y patch_x_size patch_y_size],'EdgeColor','b','LineWidth',0.5);
                    patch_healthy=imresize(patch_healthy,[training_size_x training_size_y]);
                    healthy_file_name = sprintf('patch_healthy_x%d_y%d_%d.png',patch_x_size,patch_y_size,amount_patches_healthy);
                    healthy_file_name = strcat('case',patient_index,'_',patch_scale,'_',healthy_file_name);
                    healthy_file_name=strcat(ground_truth_name_no_extension,'_',healthy_file_name);
                    fullname_healthy_multi=fullfile(folder_healthy_multiscale,healthy_file_name);
                    imwrite(patch_healthy,fullname_healthy_multi);
                    amount_patches_healthy=amount_patches_healthy+1;
                    fprintf('patch healthy %d is processing...',amount_patches_healthy);
                    fprintf('\n\n');
                    else
                        %pass
                    end
                end
            end
            hold off

        case 'Tumour'
            folder_tumour_multiscale=strcat('C:\Users\NeuroBeast\Desktop\',target_folder,'\Tumour');
            for m=0:x_steps
                for n=0:y_steps
                    patch = imcrop(truth,[2+m*sliding_x 2+n*sliding_y patch_x_size patch_y_size]);
                    r_channel = patch(:,:,1);mean_r=mean2(r_channel);
                    if (mean_r>=255*effective_area)
                    patch_temp = imcrop(us,[2+m*sliding_x 2+n*sliding_y patch_x_size patch_y_size]);
                    patch_tumour = patch_temp;
                    rec = rectangle('Position',[2+m*sliding_x 2+n*sliding_y patch_x_size patch_y_size],'EdgeColor','r','LineWidth',0.5);
                    patch_tumour=imresize(patch_tumour,[training_size_x training_size_y]);
                    tumour_file_name = sprintf('patch_tumour_x%d_y%d_%d.png',patch_x_size,patch_y_size,amount_patches_tumour);
                    tumour_file_name = strcat('case',patient_index,'_',patch_scale,'_',tumour_file_name);
                    tumour_file_name=strcat(ground_truth_name_no_extension,'_',tumour_file_name);
                    fullname_tumour_multi=fullfile(folder_tumour_multiscale,tumour_file_name);
                    imwrite(patch_tumour,fullname_tumour_multi);
                    amount_patches_tumour=amount_patches_tumour+1;
                    fprintf('patch tumour %d is processing...',amount_patches_tumour);
                    fprintf('\n\n');
                    else
                        %pass
                    end
                end
             end             
             hold off
             
        case 'Others'
            folder_others_multiscale=strcat('C:\Users\NeuroBeast\Desktop\',target_folder,'\Others');
            for j=1:width
                for i =1:height 
                    %for dark area
                    if (processed_truth(i,j,1)< (r-0*std_r_ground_truth) && processed_truth(i,j,2)<(g-0*std_g_ground_truth) && processed_truth(i,j,3)<(b-0*std_b_ground_truth))
                        processed_truth_o(i,j,1)=0;
                        processed_truth_o(i,j,2)=0;
                        processed_truth_o(i,j,3)=0;
                      
                    %case1video1 healty
                    elseif (processed_truth(i,j,1)< (r+0*std_r_ground_truth) && processed_truth(i,j,2)>(g+0*std_g_ground_truth) && processed_truth(i,j,3)>(b-0.5*std_b_ground_truth))
                        processed_truth_o(i,j,1)=0;
                        processed_truth_o(i,j,2)=0;
                        processed_truth_o(i,j,3)=0;   
                     %}
                     %{
                    %case1video4 grey matter
                    elseif (processed_truth(i,j,1)< (r+0*std_r_ground_truth) && processed_truth(i,j,2)>(g-0.5*std_g_ground_truth) && processed_truth(i,j,3)>(b-0.5*std_b_ground_truth))
                        processed_truth_o(i,j,1)=0;
                        processed_truth_o(i,j,2)=0;
                        processed_truth_o(i,j,3)=0;
                    
                    %case1video4 white matter
                    elseif (processed_truth(i,j,1)> (r-0.5*std_r_ground_truth) && processed_truth(i,j,2)< (g+0.3*std_g_ground_truth) && processed_truth(i,j,3)< (b-0*std_b_ground_truth))
                        processed_truth_o(i,j,1)=0;
                        processed_truth_o(i,j,2)=0;
                        processed_truth_o(i,j,3)=0;
                    %}
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
                    if (b_sum >= pixels_amount*1*effective_area)    
                    patch_temp = imcrop(us,[2+m*sliding_x 2+n*sliding_y patch_x_size patch_y_size]);
                    mean_patch = mean(patch_temp(:));
                    %e_temp = entropy(patch_temp);
                    if (mean_patch >mean_threshold)
                    %if (e_temp > (6.053232-0.5*1.03511))
                        patch_others = patch_temp;
                        rec = rectangle('Position',[2+m*sliding_x 2+n*sliding_y patch_x_size patch_y_size],'EdgeColor','r','LineWidth',0.5);
                        patch_others = imresize(patch_others, [training_size_x training_size_y]);
                        o_file_name = sprintf('patch_others_x%d_y%d_%d.jpg',patch_x_size,patch_y_size,amount_patches_others);
                        o_file_name = strcat(patch_scale,'_',o_file_name);
                        o_file_name=strcat(ground_truth_name_no_extension,'_',o_file_name);
                        fullname_o_multi=fullfile(folder_others_multiscale,o_file_name);           
                        imwrite(patch_others,fullname_o_multi);           
                        amount_patches_others=amount_patches_others+1;   
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
            
    end
end
end
end
disp('End')
%% for multiclasses:
%overlapping_string=num2str(sliding_percentage*100);
%patch_size_string = num2str(patch_size);
%amount_patches_healthy=1;
%amount_patches_whitematter=1;
%amount_patches_sulcus=1;
            %{
            case 'White matter'
            %folder_whitematter = strcat('C:\Users\NeuroBeast\Desktop\','multi_scale_',overlapping_string,'%_sliding_patches_20_100_case1video4_4classes\White matter\',patch_size_string);
            %folder_whitematter_multiscale=strcat('C:\Users\NeuroBeast\Desktop\','multi_scale_',overlapping_string,'%_sliding_patches_20_100_case1video4_4classes\White matter');
            folder_whitematter_multiscale=strcat('C:\Users\NeuroBeast\Desktop\case1video4_08062018\White matter');
            for j=1:width
                for i =1:height
                    if (processed_truth(i,j,1)> (r-0.2*std_r_ground_truth) && processed_truth(i,j,2)< (g+0.6*std_g_ground_truth) && processed_truth(i,j,3)<b)
                        processed_truth_whitematter(i,j,1)=1;
                        processed_truth_whitematter(i,j,2)=1;
                        processed_truth_whitematter(i,j,3)=1;
                    else
                        processed_truth_whitematter(i,j,1)=0;
                        processed_truth_whitematter(i,j,2)=0;
                        processed_truth_whitematter(i,j,3)=0;
                    end
                end
            end
            figure 
            imshow(processed_truth_whitematter)
            hold on

            for m=0:x_steps
                for n=0:y_steps
                    patch = imcrop(processed_truth_whitematter,[2+m*sliding 2+n*sliding patch_size patch_size]);
                    r_channel = patch(:,:,1);
                    g_channel = patch(:,:,2);
                    b_channel = patch(:,:,3);
                    r_sum = sum(sum(r_channel));g_sum = sum(sum(g_channel));b_sum = sum(sum(b_channel));
                    if (g_sum >= pixels_amount*1*effective_area && r_sum >= pixels_amount*1*effective_area && b_sum >= pixels_amount*1*effective_area)
                    rec = rectangle('Position',[2+m*sliding 2+n*sliding patch_size patch_size],'EdgeColor','b','LineWidth',2);
                    patch_whitematter = imcrop(us,[2+m*sliding 2+n*sliding patch_size patch_size]);
                    patch_whitematter=imresize(patch_whitematter,[training_size_x training_size_y]);
                    whitematter_file_name = sprintf('patch_whitematter_%d_%d.jpg',patch_size,amount_patches_whitematter);
                    whitematter_file_name=strcat(ground_truth_name_no_extension,'_',casenumber,'_',whitematter_file_name);
                    %fullname_whitematter = fullfile(folder_whitematter,whitematter_file_name);
                    fullname_whitematter_multi=fullfile(folder_whitematter_multiscale,whitematter_file_name);
                    imwrite(patch_whitematter,fullname_whitematter_multi);
                    amount_patches_whitematter=amount_patches_whitematter+1;
                    fprintf('patch whitematter %d is processing...',amount_patches_whitematter);
                    fprintf('\n\n');
                    else
                        %pass

                    end
                end
            end
            hold off
            %}
            %{    
            case 'Sulcus'
            folder_sulcus = strcat('C:\Users\NeuroBeast\Desktop\',resolution,'_resolution_patches_',overlapping_string,'%_sliding\patches_',patch_size_string,'\Sulcus');
            folder_sulcus_multiscale=strcat('C:\Users\NeuroBeast\Desktop\','multi_scale_',overlapping_string,'%_sliding_patches_10_100_case1video4_4classes\Sulcus');
            for j=1:width
                for i =1:height
                    if (processed_truth(i,j,1)> (r+0.5*std_r_ground_truth) && processed_truth(i,j,2)>(g+0.3*std_g_ground_truth) && processed_truth(i,j,3)<(b+0.5*std_b_ground_truth))
                        processed_truth_sulcus(i,j,1)=1;
                        processed_truth_sulcus(i,j,2)=1;
                        processed_truth_sulcus(i,j,3)=0;
                    else
                        processed_truth_sulcus(i,j,1)=0;
                        processed_truth_sulcus(i,j,2)=0;
                        processed_truth_sulcus(i,j,3)=0;
                    end
                end
            end
            figure 
            imshow(processed_truth_sulcus)
            hold on

            for m=0:x_steps
                for n=0:y_steps
                    patch = imcrop(processed_truth_sulcus,[2+m*sliding 2+n*sliding patch_size patch_size]);
                    r_channel = patch(:,:,1);
                    g_channel = patch(:,:,2);
                    b_channel = patch(:,:,3);
                    r_sum = sum(sum(r_channel));g_sum = sum(sum(g_channel));b_sum = sum(sum(b_channel));
                    if (g_sum >= pixels_amount*1*effective_area && r_sum >= pixels_amount*1*effective_area)
                    rec = rectangle('Position',[2+m*sliding 2+n*sliding patch_size patch_size],'EdgeColor','b','LineWidth',2);
                    patch_sulcus = imcrop(us,[2+m*sliding 2+n*sliding patch_size patch_size]);
                    patch_sulcus=imresize(patch_sulcus,[training_size_x training_size_y]);
                    sulcus_file_name = sprintf('patch_sulcus_%d_%d.jpg',patch_size,amount_patches_sulcus);
                    sulcus_file_name=strcat(ground_truth_name_no_extension,'_',casenumber,'_',sulcus_file_name);
                    fullname_sulcus = fullfile(folder_sulcus,sulcus_file_name);
                    fullname_sulcus_multi=fullfile(folder_sulcus_multiscale,sulcus_file_name);
                    imwrite(patch_sulcus,fullname_sulcus_multi);
                    amount_patches_sulcus=amount_patches_sulcus+1;
                    fprintf('patch sulcus %d is processing...',amount_patches_sulcus);
                    fprintf('\n\n');
                    else
                        %pass

                    end
                end
            end
            hold off
            %}
            %{
            case 'Healthy'
            folder_healthy = strcat('C:\Users\NeuroBeast\Desktop\',resolution,'_resolution_patches_',overlapping_string,'%_sliding\patches_',patch_size_string,'\Healthy');
            folder_healthy_multiscale=strcat('C:\Users\NeuroBeast\Desktop\','multi_scale_',overlapping_string,'%_sliding_patches_20_100_case1video4_4classes\Healthy');
            for j=1:width
                for i =1:height
                    %green in case1video4 is greymatter
                    if (processed_truth(i,j,1)< (r+0.5*std_r_ground_truth) && processed_truth(i,j,2)>(g-1*std_g_ground_truth) && processed_truth(i,j,3)>(b-0*std_b_ground_truth))
                        processed_truth_h(i,j,1)=0;
                        processed_truth_h(i,j,2)=1;
                        processed_truth_h(i,j,3)=0;

                    % brown in case1video4 whitematter
                    elseif (processed_truth(i,j,1)> r && processed_truth(i,j,2)< g && processed_truth(i,j,3)<b)
                        processed_truth_h(i,j,1)=0;
                        processed_truth_h(i,j,2)=1;
                        processed_truth_h(i,j,3)=0;  

                    % yellow in case1video4 is sulcus
                    elseif (processed_truth(i,j,1)> (r+1*std_r_ground_truth) && processed_truth(i,j,2)>(g+0.5*std_g_ground_truth) && processed_truth(i,j,3)<(b-1*std_b_ground_truth))
                        processed_truth_h(i,j,1)=0;
                        processed_truth_h(i,j,2)=1;
                        processed_truth_h(i,j,3)=0;                          
                    else
                        processed_truth_h(i,j,1)=0;
                        processed_truth_h(i,j,2)=0;
                        processed_truth_h(i,j,3)=0;
                    end
                end
            end
            figure 
            imshow(processed_truth_h)
            hold on 
            for m=0:x_steps
                for n=0:y_steps
                    patch = imcrop(processed_truth_h,[2+m*sliding 2+n*sliding patch_size patch_size]);
                    r_channel = patch(:,:,1);
                    g_channel = patch(:,:,2);
                    b_channel = patch(:,:,3);
                    r_sum = sum(sum(r_channel));g_sum = sum(sum(g_channel));b_sum = sum(sum(b_channel));
                    if (g_sum >= pixels_amount*1*effective_area)
                    rec = rectangle('Position',[2+m*sliding 2+n*sliding patch_size patch_size],'EdgeColor','b','LineWidth',2);
                    %current_healthy_patch_location = [2+m*sliding 2+n*sliding patch_size patch_size];
                    %healthy_co{end+1}=current_healthy_patch_location;
                    patch_healthy = imcrop(us,[2+m*sliding 2+n*sliding patch_size patch_size]);
                    patch_healthy=imresize(patch_healthy,[training_size_x training_size_y]);
                    %healthy_patches{end+1}=patch_healthy;
                    h_file_name = sprintf('patch_healthy_%d_%d.jpg',patch_size,amount_patches_healthy);
                    h_file_name=strcat(ground_truth_name_no_extension,'_',h_file_name);
                    fullname_h = fullfile(folder_healthy,h_file_name);
                    fullname_h_multi=fullfile(folder_healthy_multiscale,h_file_name);
                    %save(fullname_h,'patch_healthy');
                    %imwrite(patch_healthy,fullname_h);
                    imwrite(patch_healthy,fullname_h_multi);
                    amount_patches_healthy=amount_patches_healthy+1;
                    fprintf('patch healthy %d is processing...',amount_patches_healthy);
                    fprintf('\n\n');
                    else
                        %pass

                    end
                end
            end
            hold off
            %}
%%
% transofrm the ground truth file into hsv file for enhancing colour:
%{
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
%}
%%
           %{
            for j=1:width
                for i =1:height
                    %green in case1video4 is greymatter
                    %if (processed_truth(i,j,1)< (r+0.5*std_r_ground_truth) && processed_truth(i,j,2)>(g-1*std_g_ground_truth) && processed_truth(i,j,3)>(b-0*std_b_ground_truth))
                    %green in case1video1 is healthy
                    if (processed_truth(i,j,1)< (r+0*std_r_ground_truth) && processed_truth(i,j,2)>(g-0*std_g_ground_truth) && processed_truth(i,j,3)>(b-0.5*std_b_ground_truth))
                        processed_truth_h(i,j,1)=0;
                        processed_truth_h(i,j,2)=1;
                        processed_truth_h(i,j,3)=0;
                     %{
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
            %figure
            %imshow(processed_truth_h)
            figure 
            imshow(truth)
            hold on 
            %}