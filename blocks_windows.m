% create a sliding windwos to hover over the whole image for classification
% with distinct blocks:
clc
clear all
%% load right model:
%model_folder= '../trained models/11062018';
%model_folder= '../trained models/18062018';
%model_folder= '../trained models/11062018';
model_folder= '../trained models/resnet16';
addpath(model_folder);
%% change parameters:
% choose fine tuned neural model:
model_name = 'resnet16_v5_w96_case1video4_3.mat';
model_file=fullfile(model_folder,model_name);
load (model_file);
neural_net = net;
% change the fine tuned neural model name:
[path,model_info,ext]=fileparts(model_name);
%net_infor = strcat(net_type,'_',classes,'classes','_trained on',training_dataset,'_',training_patches_size,'_with_',training_patches_sliding,'sliding');
% change the overlapping pixels of neighbouring patches:
size_range_low=30;
size_range_low_str=num2str(size_range_low);
size_range_high=20;
size_range_high_str=num2str(size_range_high);
size_intermidiate=1;
%test_imgs_path = uigetdir;
test_imgs_path='C:\Users\NeuroBeast\Desktop\images_high_resolution\Testing\US';
addpath(test_imgs_path);
% choose testing images to be tested according to their indexes:
%indexes = {'001';'204';'209';'211'};%case1video1
indexes={'0313';'0976';'1041';'1183'};%case1video4
%indexes={'0116';'0120';'0143';'0161'};%case2
%% Main programme:
% testing US images indexes:
classiy_fun = @(block) classify_US(block,neural_net);%3 classes
%classiy_fun = @(block) classify_US_5classes(block,neural_net); % 5 classes
result_storing_path='C:\Users\NeuroBeast\Desktop\result 20180704';
for i=1:length(indexes)
    %classified={};
    index=indexes{i};
    test_name_read=strcat('case1_Coronal+00',index,'-000.jpg');%casevideo4
    test_name_write=strcat('case1_case1_Coronal+00',index);%case1video4 
    %test_name_read=strcat('case1_video10',index,'.jpeg');%case1video1 
    %test_name_write=strcat('case1_video10',index);%case1video1 
    %test_name_read=strcat('case200000000000',index,'.jpeg');%case2
    %test_name_write=strcat('case200000000000',index);%case2
    test_fullname = fullfile(test_imgs_path,test_name_read);
    test_file=imread(test_fullname);
    [height,width,dim]=size(test_file);
    %result=zeros(height,width,dim);
    test_file=imresize(test_file,[height width]);
    %for s=size_range_low%:size_intermidiate:size_range_high 
        %{
        if (s<=10)
        % for x direction strips:
        classified_US=blockproc(test_file,[s 3*s],classiy_fun);
        if s == size_range_low
        [processed_height,processed_width,dim]=size(classified_US);
        processed=zeros(processed_height,processed_width,dim);
        processed=processed+classified_US;
        else
            processed=processed+classified_US;
        end
        classified{end+1}=classified_US; 
        % for y direction strips:
        classified_US=blockproc(test_file,[3*s s],classiy_fun);
        processed=processed+classified_US;
        classified{end+1}=classified_US;         
        elseif (s>10 && s<=15)
        % for x direction strips:
        classified_US=blockproc(test_file,[s 2*s],classiy_fun);
        processed=processed+classified_US;
        classified{end+1}=classified_US; 
        % for y direction strips:
        classified_US=blockproc(test_file,[2*s s],classiy_fun);
        processed=processed+classified_US;
        classified{end+1}=classified_US;          
        elseif (s>=20)
        %}
        %only for squares
        classified_US=blockproc(test_file,[s s],classiy_fun);
        %{
        if s == size_range_low
        [processed_height,processed_width,dim]=size(classified_US);
        processed=zeros(processed_height,processed_width,dim);
        processed=processed+classified_US;
        else
            processed=processed+classified_US;
        end
        classified{end+1}=classified_US;
        %end
        %}
        fprintf('Current image index is: %d',i);
        fprintf('\n');
        fprintf('Current box number is: %d',s);
        fprintf('\n');
    %end
    %result_average=processed/(length(classified));
    % change here:
    block_infor = sprintf('_block size %d',s);
    %result_average_name=strcat('labels_',test_name_write,'_',model_info,'_average_between_',size_range_low_str,'_',size_range_high_str,'.jpg');  
    store_file_average_sum=fullfile(result_storing_path,result_average_name); 
    imwrite(result_average,store_file_average_sum);
    figure
    imshow(result_average)    
end

disp('End')
