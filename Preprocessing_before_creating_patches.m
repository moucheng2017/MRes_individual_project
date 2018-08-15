clc
clear all
%% pre-processing: enhance the colours for each class:
%training_folder = 'C:\Users\NeuroBeast\Desktop\images_high_resolution\Testing\ground truth\case1video4';
us_folder='C:\Users\NeuroBeast\Desktop\us + masks\case1video4\ground truth';
us_files = dir(fullfile(us_folder,'*.jpg')); 
us_files = {us_files.name};
path = us_folder;
addpath(us_folder);
m_files = dir(fullfile(us_folder,'*.jpg')); 
m_files = {m_files.name};
%% case1video4
%{
for iii = 1:length(m_files)
    filename=m_files{iii};
    ground_truth = imread(filename);
    %us_folder ='C:\Users\NeuroBeast\Desktop\semantic case1video4';
    %addpath(us_folder);
    us_file = fullfile(us_folder,filename);
    us = imread(us_file);
    hsv_ground_truth = rgb2hsv(ground_truth);
    [height,width,channel_size]= size(hsv_ground_truth);
    %modified_ground_truth = zeros(height,width,channel_size);
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
    processed_img = processed_img*255;

    %figure
    %imshow(processed_img)
    R_channel_processed = processed_img(:,:,1);r=mean2(R_channel_processed);r_std=std2(R_channel_processed);
    G_channel_processed = processed_img(:,:,2);g=mean2(G_channel_processed);g_std=std2(G_channel_processed);
    B_channel_processed = processed_img(:,:,2);b=mean2(B_channel_processed);b_std=std2(B_channel_processed);

for i = 1:height
    for j = 1:width
        %{
        if ((us(i,j,1)<5 && us(i,j,2)<5 && us(i,j,3)<5))
            processed_img(i,j,1)=0;
            processed_img(i,j,2)=0;
            processed_img(i,j,3)=0; 
       %}
        % white matter
        if (processed_img(i,j,1)< 120  &&processed_img(i,j,1)>50  && processed_img(i,j,2)<80 && processed_img(i,j,2)>40 && processed_img(i,j,3)<5)
            processed_img(i,j,1)=0;
            processed_img(i,j,2)=255;
            processed_img(i,j,3)=0; 
        %  matter
        elseif (processed_img(i,j,1)<5 && processed_img(i,j,2)> 50  && processed_img(i,j,3)>50)
            processed_img(i,j,1)=0;
            processed_img(i,j,2)=255;
            processed_img(i,j,3)=0;
        % sulcus
        elseif (processed_img(i,j,1)> 60 && processed_img(i,j,1)<80 &&processed_img(i,j,2)> 70 &&processed_img(i,j,2)< 90 &&processed_img(i,j,3)< 1)
            processed_img(i,j,1)=0;
            processed_img(i,j,2)=0;
            processed_img(i,j,3)=255;
        elseif (processed_img(i,j,1)> 70 && processed_img(i,j,2)> 70 &&processed_img(i,j,2)< 1)
            processed_img(i,j,1)=0;
            processed_img(i,j,2)=0;
            processed_img(i,j,3)=255;
        elseif (processed_img(i,j,1)> 80 && processed_img(i,j,2)> 80)
            processed_img(i,j,1)=0;
            processed_img(i,j,2)=0;
            processed_img(i,j,3)=255;
        % sulcus
        elseif (processed_img(i,j,1)> 40 && processed_img(i,j,2)> 40 && processed_img(i,j,2)< 1)
            processed_img(i,j,1)=0;
            processed_img(i,j,2)=0;
            processed_img(i,j,3)=255;            
        % tumour 
        elseif (processed_img(i,j,1)< 20 && processed_img(i,j,3)<22 && processed_img(i,j,2)>50)
            processed_img(i,j,1)=255;
            processed_img(i,j,2)=0;
            processed_img(i,j,3)=0;
            %{
        elseif (processed_img(i,j,1)< 20 &&  processed_img(i,j,2) >70 && processed_img(i,j,2) <110  && processed_img(i,j,3)<10)
            processed_img(i,j,1)=255;
            processed_img(i,j,2)=0;
            processed_img(i,j,3)=0;
        % tumour
        elseif (processed_img(i,j,1)< 10 && processed_img(i,j,2) >110  && processed_img(i,j,3)<15)
            processed_img(i,j,1)=255;
            processed_img(i,j,2)=0;
            processed_img(i,j,3)=0;
 %}
        % artifacts
        elseif (processed_img(i,j,1)> 50 && processed_img(i,j,2) < 5)
            processed_img(i,j,1)=0;
            processed_img(i,j,2)=0;
            processed_img(i,j,3)=255;
        elseif (processed_img(i,j,1)> 90 && processed_img(i,j,2) > 20 && processed_img(i,j,3)>80)
            processed_img(i,j,1)=0;
            processed_img(i,j,2)=0;
            processed_img(i,j,3)=255;        
        % others            
         else 
            processed_img(i,j,1)=0;
            processed_img(i,j,2)=0;
            processed_img(i,j,3)=0;
         end
    end
    
end

     [FILEPATH,name,EXT] =fileparts(filename);
     labelfilename=strcat(name,'_after.png');
     figure
     imshow(processed_img)
     fullname = fullfile(path,labelfilename);
     imwrite(processed_img,fullname);

end
%}
%% case1video1
%{
for iii = 1:length(m_files)
    filename=m_files{iii};
    filename = fullfile(us_folder,filename);
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
%}
%% case 2
for iii = 1:length(m_files)
    filename=m_files{iii};
    ground_truth = imread(filename);
    %us_folder ='C:\Users\NeuroBeast\Desktop\semantic case1video4';
    %addpath(us_folder);
    us_file = fullfile(us_folder,filename);
    us = imread(us_file);
    hsv_ground_truth = rgb2hsv(ground_truth);
    [height,width,channel_size]= size(hsv_ground_truth);
    %modified_ground_truth = zeros(height,width,channel_size);
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
     [FILEPATH,name,EXT] =fileparts(filename);
     labelfilename=strcat('enhanced',name,'.png');
     figure
     imshow(processed_img)
     fullname = fullfile(path,labelfilename);
     imwrite(processed_img,fullname);
    %processed_img = processed_img*255;
    %figure
    %imshow(processed_img)
    %{
    R_channel_processed = processed_img(:,:,1);r=mean2(R_channel_processed);r_std=std2(R_channel_processed);
    G_channel_processed = processed_img(:,:,2);g=mean2(G_channel_processed);g_std=std2(G_channel_processed);
    B_channel_processed = processed_img(:,:,2);b=mean2(B_channel_processed);b_std=std2(B_channel_processed);
%}
    %{
for i = 1:height
    for j = 1:width
        %{
        if ((us(i,j,1)<5 && us(i,j,2)<5 && us(i,j,3)<5))
            processed_img(i,j,1)=0;
            processed_img(i,j,2)=0;
            processed_img(i,j,3)=0; 
       %}
        % red 
        %
        if (processed_img(i,j,1)> 70 && processed_img(i,j,2)< 40 && processed_img(i,j,2)< 6)
            processed_img(i,j,1)=0;
            processed_img(i,j,2)=0;
            processed_img(i,j,3)=255;
            %
        % necrosis
        elseif (processed_img(i,j,1)>= 100 && processed_img(i,j,1)<= 150 && processed_img(i,j,2)>= 80 && processed_img(i,j,2)<= 100 && processed_img(i,j,3)<= 10)
            processed_img(i,j,1)=255;
            processed_img(i,j,2)=0;
            processed_img(i,j,3)=0;
        elseif (processed_img(i,j,1)>= 60 && processed_img(i,j,2)>= 40 && processed_img(i,j,2)<= 80 && processed_img(i,j,3)<= 15)
            processed_img(i,j,1)=255;
            processed_img(i,j,2)=0;
            processed_img(i,j,3)=0;

            %
        % sulcus
        elseif (processed_img(i,j,1)> 80 && processed_img(i,j,2)> 80 && processed_img(i,j,2)> 10)
            processed_img(i,j,1)=255;
            processed_img(i,j,2)=255;
            processed_img(i,j,3)=0; 
            %{
        elseif (processed_img(i,j,1)> 120 && processed_img(i,j,2)> 120 && processed_img(i,j,2)> 20)
            processed_img(i,j,1)=0;
            processed_img(i,j,2)=0;
            processed_img(i,j,3)=255;
            %}
        % odemma
        elseif (processed_img(i,j,1)<20 && processed_img(i,j,2)< 20 && processed_img(i,j,3)> 60)
            processed_img(i,j,1)=0;
            processed_img(i,j,2)=0;
            processed_img(i,j,3)=255;
            %{
        % white matter
        elseif (processed_img(i,j,1)< 120  &&processed_img(i,j,1)>50  && processed_img(i,j,2)<80 && processed_img(i,j,2)>40 && processed_img(i,j,3)<5)
            processed_img(i,j,1)=0;
            processed_img(i,j,2)=255;
            processed_img(i,j,3)=0; 
            %}
        % grey matter
        elseif (processed_img(i,j,1)<5 && processed_img(i,j,2)> 50  && processed_img(i,j,3)>50)
            processed_img(i,j,1)=0;
            processed_img(i,j,2)=255;
            processed_img(i,j,3)=0;
        % tumour 
        elseif (processed_img(i,j,1)< 20 && processed_img(i,j,3)<22 && processed_img(i,j,2)>50)
            processed_img(i,j,1)=255;
            processed_img(i,j,2)=0;
            processed_img(i,j,3)=0;
            %{
        elseif (processed_img(i,j,1)< 20 &&  processed_img(i,j,2) >70 && processed_img(i,j,2) <110  && processed_img(i,j,3)<10)
            processed_img(i,j,1)=255;
            processed_img(i,j,2)=0;
            processed_img(i,j,3)=0;
        % tumour
        elseif (processed_img(i,j,1)< 10 && processed_img(i,j,2) >110  && processed_img(i,j,3)<15)
            processed_img(i,j,1)=255;
            processed_img(i,j,2)=0;
            processed_img(i,j,3)=0;
 %}
        % artifacts
        elseif (processed_img(i,j,1)> 50 && processed_img(i,j,2) < 5)
            processed_img(i,j,1)=255;
            processed_img(i,j,2)=0;
            processed_img(i,j,3)=255;
        elseif (processed_img(i,j,1)> 90 && processed_img(i,j,2) > 20 && processed_img(i,j,3)>80)
            processed_img(i,j,1)=255;
            processed_img(i,j,2)=0;
            processed_img(i,j,3)=255;        
        % others            
         else 
            processed_img(i,j,1)=0;
            processed_img(i,j,2)=0;
            processed_img(i,j,3)=0;
         end
    end
    
end
    

     [FILEPATH,name,EXT] =fileparts(filename);
     labelfilename=strcat('multi-classes',name,'.png');
     figure
     imshow(processed_img)
     fullname = fullfile(path,labelfilename);
     %imwrite(processed_img,fullname);
%}
end
    %
%% case 3
%{
for iii = 1:length(m_files)
    filename=m_files{iii};
    ground_truth = imread(filename);
    %us_folder ='C:\Users\NeuroBeast\Desktop\semantic case1video4';
    %addpath(us_folder);
    us_file = fullfile(us_folder,filename);
    us = imread(us_file);
    hsv_ground_truth = rgb2hsv(ground_truth);
    [height,width,channel_size]= size(hsv_ground_truth);
    %modified_ground_truth = zeros(height,width,channel_size);
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
    processed_img = processed_img*255;
    %figure
    %imshow(processed_img)
    %{
     [FILEPATH,name,EXT] =fileparts(filename);
     labelfilename=strcat(name,'after.png');
     figure
     imshow(processed_img)
     fullname = fullfile(path,labelfilename);
     imwrite(processed_img,fullname)
%}
for i = 1:height
    for j = 1:width
        %{
        if ((us(i,j,1)<5 && us(i,j,2)<5 && us(i,j,3)<5))
            processed_img(i,j,1)=0;
            processed_img(i,j,2)=0;
            processed_img(i,j,3)=0; 
       %}
        % sulcus
        if (processed_img(i,j,1)> 40 && processed_img(i,j,2)> 40)
            processed_img(i,j,1)=0;
            processed_img(i,j,2)=0;
            processed_img(i,j,3)=255; 
        % white matter
        elseif (processed_img(i,j,1)< 100  && processed_img(i,j,1)>50  && processed_img(i,j,2)<80 && processed_img(i,j,2)>40 && processed_img(i,j,3)<5)
            processed_img(i,j,1)=0;
            processed_img(i,j,2)=255;
            processed_img(i,j,3)=0; 
        %  matter
        elseif (processed_img(i,j,1)<10 && processed_img(i,j,2)> 50  && processed_img(i,j,3)>50)
            processed_img(i,j,1)=0;
            processed_img(i,j,2)=255;
            processed_img(i,j,3)=0;
           
        % tumour 
        elseif (processed_img(i,j,1)< 20 && processed_img(i,j,3)<22 && processed_img(i,j,2)>50)
            processed_img(i,j,1)=255;
            processed_img(i,j,2)=0;
            processed_img(i,j,3)=0;
            %{
        elseif (processed_img(i,j,1)< 20 &&  processed_img(i,j,2) >70 && processed_img(i,j,2) <110  && processed_img(i,j,3)<10)
            processed_img(i,j,1)=255;
            processed_img(i,j,2)=0;
            processed_img(i,j,3)=0;
        % tumour
        elseif (processed_img(i,j,1)< 10 && processed_img(i,j,2) >110  && processed_img(i,j,3)<15)
            processed_img(i,j,1)=255;
            processed_img(i,j,2)=0;
            processed_img(i,j,3)=0;
 %}
        %{
        %artifacts
        elseif (processed_img(i,j,1)> 50 && processed_img(i,j,2) < 5)
            processed_img(i,j,1)=0;
            processed_img(i,j,2)=0;
            processed_img(i,j,3)=255;
        elseif (processed_img(i,j,1)> 90 && processed_img(i,j,2) > 20 && processed_img(i,j,3)>80)
            processed_img(i,j,1)=0;
            processed_img(i,j,2)=0;
            processed_img(i,j,3)=255;   
     %}
        % others            
         else 
            processed_img(i,j,1)=0;
            processed_img(i,j,2)=0;
            processed_img(i,j,3)=255;
         end
    end
    
end

     [FILEPATH,name,EXT] =fileparts(filename);
     labelfilename=strcat(name,'.png');
     figure
     imshow(processed_img)
     fullname = fullfile(path,labelfilename);
%     imwrite(processed_img,fullname);
end
%}