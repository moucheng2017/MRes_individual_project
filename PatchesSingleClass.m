% white: artifacts;
% black: background;
% green: tumour;
% yellow: sulcus;
% cyan: halthy tissues.
%%
% Choose which class to crop:
label = 'Healthy';
%label = 'Tumour';
%label = 'Others';
% choose patch size:
x_width = 300;
y_width = 300;
% Choose overlapping percentage between adjacent patches; 
overlapping = 0.5;
portion = 1-overlapping;
% Effective area in each patch (How much area in the patch should be covered by the class?):
target_percentage = 1;
% choose which US image to create patches:
index_US = '027';
% Read segmented US rgb image:
img_name = strcat('case1_Coronal+000',index_US,'-000.jpg');
img_path = 'C:\Users\NeuroBeast\Desktop\images_low_resolution';
img_fullname = fullfile(img_path,img_name);
img = imread(img_fullname);
%figure
%imshow(img)

% transform segmented US images to hsv:
hsv_img = rgb2hsv(img);
[x_size,y_size,channel_size]= size(hsv_img);
h_channel = hsv_img(:,:,1);
s_channel = hsv_img(:,:,2);
v_channel = hsv_img(:,:,3);
% maximise v values to enhance the colours of all classes:
for i = 1:x_size
   for j = 1:y_size
       hsv_img(i,j,2)=1;
       %hsv_img(i,j,3)=1;
   end
end
% transform enhanced hsv images back to rgb segmented US image:
processed_img = hsv2rgb(hsv_img);
[y_length,x_length,channels]=size(processed_img);
R_channel_processed = processed_img(:,:,1);r=mean2(R_channel_processed);
G_channel_processed = processed_img(:,:,2);g=mean2(G_channel_processed);
B_channel_processed = processed_img(:,:,2);b=mean2(B_channel_processed);
% Emphasize each colour. e.g. for "Tumour", it only keeps tumour by thresholding, and make all
% other areas as background.
for ii = 1:x_size
    for jj = 1:y_size
switch label
    case 'Tumour'
        if (processed_img(ii,jj,1)< r && processed_img(ii,jj,2)>g && processed_img(ii,jj,3)<b)
            processed_img(ii,jj,1)=0;
            processed_img(ii,jj,2)=1;
            processed_img(ii,jj,3)=0;
        else
            processed_img(ii,jj,1)=0;
            processed_img(ii,jj,2)=0;
            processed_img(ii,jj,3)=0;
        end
    case 'Healthy'
        if (processed_img(ii,jj,1)< r && processed_img(ii,jj,2)>g && processed_img(ii,jj,3)>b)
            processed_img(ii,jj,1)=0;
            processed_img(ii,jj,2)=1;
            processed_img(ii,jj,3)=1;
        else
            processed_img(ii,jj,1)=0;
            processed_img(ii,jj,2)=0;
            processed_img(ii,jj,3)=0;
        end
    case 'Others'
        if (processed_img(ii,jj,1)< r && processed_img(ii,jj,2)>g && processed_img(ii,jj,3)>b)
            processed_img(ii,jj,1)=0;
            processed_img(ii,jj,2)=0;
            processed_img(ii,jj,3)=0;
        elseif (processed_img(ii,jj,1)< r && processed_img(ii,jj,2)>g && processed_img(ii,jj,3)<b)
            processed_img(ii,jj,1)=0;
            processed_img(ii,jj,2)=0;
            processed_img(ii,jj,3)=0;
        else
            processed_img(ii,jj,1)=1;
            processed_img(ii,jj,2)=0;
            processed_img(ii,jj,3)=0;           
        end
end
    end
end
figure
imshow(processed_img)
hold on 
% prepare patches storages: 
patches_tumour = {};patches_healthy = {};patches_others = {};
tumour_co = {};healthy_co={};others_co={};
% Parameters setting:
x_starting = 0;  
y_starting = 0; 
left_corner_x = x_starting;
left_corner_y = y_starting;
padding_x = x_width*portion;
padding_y = y_width*portion;
amount_x = 0;
amount_y = 0;
% Calculate potential patches amount 
traveled_distance_y = y_width + y_starting;
traveled_distance_x = x_width + x_starting;
while (traveled_distance_y <= y_length)
    traveled_distance_y = traveled_distance_y + padding_y;
    amount_y = amount_y +1;
end

while (traveled_distance_x <= x_length)
    traveled_distance_x = traveled_distance_x + padding_x;
    amount_x = amount_x +1;    
end

% Draw the rectangle if the patch is suitable 
pixels = (x_width+1)*(y_width+1);%pixels amount
amount_rec = 0;
for i = 1:amount_x
    for j =1:amount_y
        patch_a = imcrop(processed_img,[left_corner_x left_corner_y x_width y_width]);
        r_channel = patch_a(:,:,1);
        g_channel = patch_a(:,:,2);
        b_channel = patch_a(:,:,3);
        r_sum = sum(sum(r_channel));g_sum = sum(sum(g_channel));b_sum = sum(sum(b_channel));
        switch label
            case 'Tumour'
                if (g_sum >= pixels*1*target_percentage)
                    rec = rectangle('Position',[left_corner_x left_corner_y x_width y_width],'EdgeColor','b','LineWidth',2);
                    amount_rec = amount_rec +1;
                    patches_tumour{end+1}=patch_a;
                    current_tumour_patch_location = [left_corner_x left_corner_y x_width y_width];
                    tumour_co{end+1}=current_tumour_patch_location;                    
                else
                    % pass
                end
            case 'Healthy'
                if (g_sum >= pixels*1*target_percentage && b_sum >= pixels*1*target_percentage)
                    rec = rectangle('Position',[left_corner_x left_corner_y x_width y_width],'EdgeColor','b','LineWidth',2);
                    amount_rec = amount_rec +1;
                    patches_healthy{end+1}=patch_a;
                    current_healthy_patch_location = [left_corner_x left_corner_y x_width y_width];
                    healthy_co{end+1}=current_healthy_patch_location;
                else
                    % pass
                end
            case 'Others'
                if (r_sum >= pixels*1*target_percentage && b_sum == 0 && g_sum ==0)
                    rec = rectangle('Position',[left_corner_x left_corner_y x_width y_width],'EdgeColor','b','LineWidth',2);
                    amount_rec = amount_rec +1;
                    patches_others{end+1}=patch_a;
                    current_others_patch_location = [left_corner_x left_corner_y x_width y_width];
                    others_co{end+1}=current_others_patch_location;
                else
                    %pass
                end               
        end
        left_corner_y = left_corner_y + padding_y;
    end
    left_corner_x = left_corner_x + padding_x;
    left_corner_y = y_starting;    
end
hold off
fprintf('Here are %d patches cropped.',amount_rec);
disp('End 1')
%% sort patches into right folders and store them:
us_name = strcat('case1_video10',index_US,'.jpeg');
us_fullname = fullfile(img_path,us_name);
us = imread(us_fullname);
%{
figure
imshow(us)
%}
% check amount of existed patches in folders:
patch_size = num2str(x_width);
folder_tumour = strcat('C:\Users\NeuroBeast\Desktop\patches_',patch_size);folder_tumour = strcat(folder_tumour,'\Tumour');
di_tumour = dir(strcat(folder_tumour,'\*.mat'));
if ~isempty(di_tumour)
    amount_patches_tumour = length(di_tumour);
elseif isempty(di_tumour)
    amount_patches_tumour = 0;
end
folder_healthy = strcat('C:\Users\NeuroBeast\Desktop\patches_',patch_size);folder_healthy = strcat(folder_healthy,'\Healthy');
di_healthy = dir(strcat(folder_healthy,'\*.mat'));
if ~isempty(di_healthy)
    amount_patches_healthy = length(di_healthy);
elseif isempty(di_healthy)
    amount_patches_healthy = 0;
end 
folder_others = strcat('C:\Users\NeuroBeast\Desktop\patches_',patch_size);folder_others = strcat(folder_others,'\Others');
di_others = dir(strcat(folder_others,'\*.mat'));
if ~isempty(di_others)
    amount_patches_others = length(di_others);
elseif isempty(di_others)
    amount_patches_others = 0;
end
% crop & store all tumours in US image
for t=1:length(tumour_co)
    amount_patches_tumour=amount_patches_tumour+1;
    tumour_temp = tumour_co{t};
    patch = imcrop(us,[tumour_temp(1) tumour_temp(2) tumour_temp(3) tumour_temp(4)]);
    t_file_name = sprintf('patch_tumour_%d.mat',amount_patches_tumour);
    fullname = fullfile(folder_tumour,t_file_name);
    save(fullname,'patch','tumour_temp');
end
% crop & store all healthy tissue in US image
for h=1:length(healthy_co)
    amount_patches_healthy=amount_patches_healthy+1;
    healthy_temp = healthy_co{h};
    patch = imcrop(us,[healthy_temp(1) healthy_temp(2) healthy_temp(3) healthy_temp(4)]);
    h_file_name = sprintf('patch_healthy_%d.mat',amount_patches_healthy);
    fullname = fullfile(folder_healthy,h_file_name);
    save(fullname,'patch','healthy_temp');
end
% crop & stores all others in US image
for s=1:length(others_co)
    amount_patches_others=amount_patches_others+1;
    others_temp = others_co{s};
    patch = imcrop(us,[others_temp(1) others_temp(2) others_temp(3) others_temp(4)]);
    o_file_name = sprintf('patch_others_%d.mat',amount_patches_others);
    fullname = fullfile(folder_others,o_file_name);
    save(fullname,'patch','others_temp');
end

disp('End 2')