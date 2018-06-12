% create a sliding windwos to hover over the whole image for classification
% with distinct blocks
clc
clear all
%% load right model:
model_folder= '../trained models';
addpath(model_folder);
%% change parameters:
% choose fine tuned neural model:
model_name = 'Googlenet_case1video4_high_entropy_balanced.mat';
model_file=fullfile(model_folder,model_name);
load (model_file);
neural_net = googlenetUS;
% change the fine tuned neural model name:
[path,model_info,ext]=fileparts(model_name);
%net_infor = strcat(net_type,'_',classes,'classes','_trained on',training_dataset,'_',training_patches_size,'_with_',training_patches_sliding,'sliding');
% change the overlapping pixels of neighbouring patches:
size_range_low=20;
size_range_low_str=num2str(size_range_low);
size_range_high=30;
size_range_high_str=num2str(size_range_high);
size_intermidiate=1;
%test_imgs_path = uigetdir;
test_imgs_path='C:\Users\NeuroBeast\Desktop\images_high_resolution\Testing\US';
addpath(test_imgs_path);
% choose testing images to be tested according to their indexes:
%indexes = {'001';'204';'209';'211'};%case1video1
indexes={'1183';'0313';'0976';'1041'};%case1video4
%% Main programme:
% testing US images indexes:
classiy_fun = @(block) classify_US(block,neural_net);%3 classes
%classiy_fun = @(block) classify_US_5classes(block,neural_net); % 5 classes
result_storing_path='C:\Users\NeuroBeast\Desktop\results';
for i=1:length(indexes)
    classified={};
    index=indexes{i};
    test_name1=strcat('case1_Coronal+00',index,'-000.jpg'); 
    test_name2=strcat('case1_Coronal+00',index); 
    %test_name1=strcat('case1_video10',index,'.jpeg'); 
    %test_name2=strcat('case1_video10',index); 
    test_fullname = fullfile(test_imgs_path,test_name1);
    test_file=imread(test_fullname);
    [height,width,dim]=size(test_file);
    result=zeros(height,width,dim);
    test_file=imresize(test_file,[height width]);
    for s=size_range_low:size_intermidiate:size_range_high
        classified_US=blockproc(test_file,[s s],classiy_fun);
        %classified_US = blockproc(test_file,[s s],classiy_fun,'BorderSize',[5 5],'PadPartialBlocks',false,'TrimBorder',true);
        %figure
        %imshow(classified_US);
        if s == size_range_low
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
        fprintf('Current box number is: %d',s);
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
    block_infor = sprintf('_block size %d',s);
    result_average_name=strcat(test_name2,'_',model_info,'_average_between_',size_range_low_str,'_',size_range_high_str,'.jpg');  
    store_file_average_sum=fullfile(result_storing_path,result_average_name); 
    imwrite(result_average,store_file_average_sum);
    figure
    imshow(result_average)    
end

disp('End')
