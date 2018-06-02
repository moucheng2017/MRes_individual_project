% create a sliding windwos to hover over the whole image for classification
% with distinct blocks
clc
clear all
% load right model:
load ('googlenet_multi_scales_patches.mat')
neural_net = googlenetUS;
net_infor = ' googlenet';
overlapping=5;
% block windows on single image:
%file = 'test1.jpeg';
%path = 'C:\Users\NeuroBeast\Desktop\images_high_resolution\Training\Test';
%file_fullname = fullfile(path,file);
%img=imread(file_fullname);
% block windows on all testing images:
size_range_low=20;
size_range_high=40;
size_intermidiate=1;
test_imgs_path = uigetdir;
% testing US images indexes:
classiy_fun = @(block) classify_US(block,neural_net); 
indexes = {'001';'204';'209';'211'};
result_storing_path='C:\Users\NeuroBeast\Desktop\segmentation';
for i=1:length(indexes)
    classified={};
    result=zeros(460,555,3);
    height=460;
    width=550;
    index=indexes{i};
    %test_name1=strcat('case1_Coronal+00',index,'-000.jpg'); 
    %test_name2=strcat('case1_Coronal+00',index); 
    test_name1=strcat('case1_video10',index,'.jpeg'); 
    test_name2=strcat('case1_video10',index); 
    test_fullname = fullfile(test_imgs_path,test_name1);
    test_file=imread(test_fullname);
    test_file=imresize(test_file,[460 555]);
    for s=size_range_low:size_intermidiate:size_range_high
        %s_block=floor(s/2);
        
        m=floor(height/s);
        n=floor(width/s);
       classified_US=blockproc(test_file,[m n],classiy_fun);%no overlapping
        %classified_US = blockproc(test_file,[m n],classiy_fun,'BorderSize',[overlapping overlapping],'PadPartialBlocks',false,'TrimBorder',true);
        %figure
        %imshow(classified_US);
        block_infor = sprintf(' block size %d',s);
        title_name=strcat(test_name2,block_infor,net_infor,'.jpg');
        %title_name=strcat(title_name,block_infor);
        %title_name=strcat(title_name,net_infor);
        %title(title_name)
        
        if s == 20
        [processed_height,processed_width,dim]=size(classified_US);
        processed=zeros(processed_height,processed_width,dim);
        processed=processed+classified_US;
        else
            processed=processed+classified_US;
        end
        classified{end+1}=classified_US;
        
        %title_name_store=strcat(title_name,'.jpg');
        %store_file=fullfile(result_storing_path,title_name);
        %store_file=char(store_file);
        %imwrite(classified_US,store_file);
        fprintf('Current image index is: %d',i);
        fprintf('\n');
        fprintf('Current box size is: %d',s);
        fprintf('\n');
    end
    result_average=processed/length(classified);
    %figure
    %imshow(result);
    %figure
    %imshow(result_average);
    % change here:
    %{
    result_sum_name=strcat(test_name2,net_infor,' sum 20-30.jpg');
    store_file_result_sum=fullfile(result_storing_path,result_sum_name);
    store_file_result_sum=char(store_file_result_sum);
    imwrite(result,store_file_result_sum);
    %}
    % change here:
    result_average_name=strcat(test_name2,net_infor,' average 20-40 no overlapping.jpg');
    store_file_average_sum=fullfile(result_storing_path,result_average_name);
    result_average_name=char(result_average_name);
    imwrite(result_average,store_file_average_sum);
    figure
    imshow(result_average)
    
end

disp('End')
