%% pre-processing: enhance the colours for each class:
% white: artifacts;
% black: background;
% green: tumour;
% yellow: sulcus;
% cyan: halthy tissues.

training_folder = uigetdir;
path = training_folder;
addpath(training_folder);
m_files = dir(fullfile(training_folder,'*.jpg')); 
m_files = {m_files.name};


for iii = 1:length(m_files)
    ground_truth = imread(m_files{iii});
    %ground_truth = imread('case1_Coronal+000209-000.jpg');
    figure
    imshow(ground_truth)
    % transform images to hsv 
    hsv_ground_truth = rgb2hsv(ground_truth);
    [x_size,y_size,channel_size]= size(hsv_ground_truth);
    h_channel = hsv_ground_truth(:,:,1);
    s_channel = hsv_ground_truth(:,:,2);
    v_channel = hsv_ground_truth(:,:,3);
    modified_ground_truth = zeros(x_size,y_size,channel_size);
    % maximise v values to enhance the colours of all classes
    for i = 1:x_size
        for j = 1:y_size
            hsv_ground_truth(i,j,2)=1;
        end
    end
    figure
    imshow(hsv_ground_truth)
    % transform enhanced hsv images back to rgb
    processed_img = hsv2rgb(hsv_ground_truth);
    figure
    imshow(processed_img)
R_channel_processed = processed_img(:,:,1);r=mean2(R_channel_processed);
G_channel_processed = processed_img(:,:,2);g=mean2(G_channel_processed);
B_channel_processed = processed_img(:,:,2);b=mean2(B_channel_processed);

for ii = 1:x_size
    for jj = 1:y_size
        if (processed_img(ii,jj,1)<r && processed_img(ii,jj,2)<g && processed_img(ii,jj,3)<b)
            processed_img(ii,jj,1)=0;
            processed_img(ii,jj,2)=0;
            processed_img(ii,jj,3)=0; 
        elseif (processed_img(ii,jj,1)> r && processed_img(ii,jj,2)>g && processed_img(ii,jj,3)<b)
            processed_img(ii,jj,1)=1;
            processed_img(ii,jj,2)=1;
            processed_img(ii,jj,3)=0;
        elseif (processed_img(ii,jj,1)<r && processed_img(ii,jj,2)>g && processed_img(ii,jj,3)>b)
            processed_img(ii,jj,1)=0;
            processed_img(ii,jj,2)=1;
            processed_img(ii,jj,3)=1;
        elseif (processed_img(ii,jj,1)< r && processed_img(ii,jj,2)>g && processed_img(ii,jj,3)<b)
            processed_img(ii,jj,1)=0;
            processed_img(ii,jj,2)=1;
            processed_img(ii,jj,3)=0; 
        else
            processed_img(ii,jj,1)=1;
            processed_img(ii,jj,2)=1;
            processed_img(ii,jj,3)=1;             
        end
    end
end
     figure
     imshow(processed_ground_truth)
     fullname = fullfile(path,m_files{iii});
     imwrite(processed_ground_truth,fullname);
end