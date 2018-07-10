%% pre-processing: enhance the colours for each class:
training_folder = uigetdir;
path = training_folder;
addpath(training_folder);
m_files = dir(fullfile(training_folder,'*.jpg')); 
m_files = {m_files.name};
%% case1video4
%{
for iii = 1:length(m_files)
    filename=m_files{iii};
    ground_truth = imread(m_files{iii});
    us_folder ='C:\Users\NeuroBeast\Desktop\images_high_resolution\Testing\US';
    addpath(us_folder);
    us_file = fullfile(us_folder,filename);
    us = imread(us_file);
    hsv_ground_truth = rgb2hsv(ground_truth);
    [height,width,channel_size]= size(hsv_ground_truth);
    h_channel = hsv_ground_truth(:,:,1);
    s_channel = hsv_ground_truth(:,:,2);
    v_channel = hsv_ground_truth(:,:,3);
    modified_ground_truth = zeros(height,width,channel_size);
    % maximise v values to enhance the colours of all classes
    for m = 1:height
        for n = 1:width
            hsv_ground_truth(m,n,2)=1;
        end
    end
    %figure
    %imshow(hsv_ground_truth)
    % transform enhanced hsv images back to rgb
    processed_img = hsv2rgb(hsv_ground_truth);
    %figure
    %imshow(processed_img)
    R_channel_processed = processed_img(:,:,1);r=mean2(R_channel_processed);r_std=std2(R_channel_processed);
    G_channel_processed = processed_img(:,:,2);g=mean2(G_channel_processed);g_std=std2(G_channel_processed);
    B_channel_processed = processed_img(:,:,2);b=mean2(B_channel_processed);b_std=std2(B_channel_processed);

for i = 1:height
    for j = 1:width
        if ((us(i,j,1)+us(i,j,2)+us(i,j,3))/3<=25)
            processed_img(i,j,1)=0;
            processed_img(i,j,2)=0;
            processed_img(i,j,3)=0; 
        else
        % grey matter
         if (processed_img(i,j,1)< (r+0.5*r_std) && processed_img(i,j,2)>(g-1*g_std) && processed_img(i,j,3)>(b-0*b_std))
            processed_img(i,j,1)=0;
            processed_img(i,j,2)=1;
            processed_img(i,j,3)=0; 
        % white matter
         elseif (processed_img(i,j,1)> (r-0.2*r_std) && processed_img(i,j,2)< (g+0.6*g_std) && processed_img(i,j,3)<(b+0*b_std))
            processed_img(i,j,1)=0;
            processed_img(i,j,2)=0;
            processed_img(i,j,3)=0;
        % sulcus
         elseif (processed_img(i,j,1)> (r+0.5*r_std) && processed_img(i,j,2)> (g+0.3*g_std) && processed_img(i,j,3)<(b+0.5*b_std))
            processed_img(i,j,1)=0;
            processed_img(i,j,2)=0;
            processed_img(i,j,3)=1;
        % tumour
        elseif (processed_img(i,j,1)< (r-0*r_std) && processed_img(i,j,2) >(g+0*g_std) && processed_img(i,j,3)<(b+0*b_std))
            processed_img(i,j,1)=1;
            processed_img(i,j,2)=0;
            processed_img(i,j,3)=0;
        % others            
         else 
            processed_img(i,j,1)=0;
            processed_img(i,j,2)=0;
            processed_img(i,j,3)=1;
         end
        end
    end
end

     figure
     imshow(processed_img)
     fullname = fullfile(path,m_files{iii});
     %fullname=fullfile('C:\Users\NeuroBeast\Desktop',m_files{iii});
     imwrite(processed_img,fullname);
end
%}
%% case1video1
for iii = 1:length(m_files)
    filename=m_files{iii};
    img = imread(filename);
    %us_folder ='C:\Users\NeuroBeast\Desktop\images_high_resolution\Testing\US';
    %addpath(us_folder);
    %case_index=filename(18:20);
    %us_name=strcat('case1_video10',case_index,'.jpeg');
    %us_file = fullfile(us_folder,us_name);
    %us = imread(us_file);
    img = rgb2hsv(img);
    [height,width,channel_size]= size(img);
    %labels_map = zeros(height,width);
    
    % maximise v values to enhance the colours of all classes
    for m = 1:height
        for n = 1:width
            img(m,n,2)=1;
        end
    end
    
   
    % transform enhanced hsv images back to rgb
    img = hsv2rgb(img);
    figure
    imshow(img)
    R_channel_processed = img(:,:,1);r=mean2(R_channel_processed);r_std=std2(R_channel_processed);
    G_channel_processed = img(:,:,2);g=mean2(G_channel_processed);g_std=std2(G_channel_processed);
    B_channel_processed = img(:,:,2);b=mean2(B_channel_processed);b_std=std2(B_channel_processed);
 %}
for i = 1:height
    for j = 1:width
        %{
        if ((processed_img(i,j,1)+processed_img(i,j,2)+processed_img(i,j,3))/3<=5)
            processed_img(i,j,1)=0;
            processed_img(i,j,2)=0;
            processed_img(i,j,3)=0; 
            labels_map(i,j)=0;
        else
        %}
        % tumour
        if (img(i,j,1)< (r-0*r_std) && img(i,j,2) >(g-0*g_std) && img(i,j,3)<(b-0*b_std))
            img(i,j,1)=255;
            img(i,j,2)=0;
            img(i,j,3)=0;

            %labels_map(i,j)=0;
        % healthy
        elseif (img(i,j,1)< (r-0*r_std) && img(i,j,2) >(g-0*g_std) && img(i,j,3)>(b-0*b_std))
            img(i,j,1)=0;
            img(i,j,2)=255;
            img(i,j,3)=0; 
            %labels_map(i,j)=2;
            
        % sulcus
        elseif (img(i,j,1)> (r+0*r_std) && img(i,j,2)> (g+0*g_std) && img(i,j,3)<(b+0*b_std))
            img(i,j,1)=0;
            img(i,j,2)=0;
            img(i,j,3)=255;
            %labels_map(i,j)=3;
            
        % background
        elseif(img(i,j,1)< (r-0*r_std) && img(i,j,2) <(g-0*g_std) && img(i,j,3)<(b-0*b_std))
            img(i,j,1)=0;
            img(i,j,2)=0;
            img(i,j,3)=0;
            %labels_map(i,j)=1;

        % others            
        else 
            img(i,j,1)=0;
            img(i,j,2)=0;
            img(i,j,3)=255;
            %labels_map(i,j)=3;
         end
     end
end
     [FILEPATH,name,EXT] =fileparts(m_files{iii});
     labelfilename=strcat(name,'.png');
     %fulllabelname=fullfile(path,labelfilename);
     %imwrite(labels_map,fulllabelname);
     %save(fulllabelname,'labels_map');
     figure
     imshow(img)
     fullname = fullfile(path,labelfilename);
     %fullname=fullfile('C:\Users\NeuroBeast\Desktop',m_files{iii});
     imwrite(img,fullname);
end