% create a sliding windwos to hover over the whole image for classification
% with distinct blocks
clc
clear all
%% load right model:
model_folder= '../trained models/14062018';
addpath(model_folder);
%% change parameters:
% choose fine tuned neural model:
model_name = 'Googlenet_case1_high_entropy_balanced_non_DataZeroCentering.mat';
model_file=fullfile(model_folder,model_name);
load (model_file);
neural_net = googlenetUS;
% change the fine tuned neural model name:
[path,model_info,ext]=fileparts(model_name);
%net_infor = strcat(net_type,'_',classes,'classes','_trained on',training_dataset,'_',training_patches_size,'_with_',training_patches_sliding,'sliding');
% change the overlapping pixels of neighbouring patches:
size_range_low=15;
size_range_low_str=num2str(size_range_low);
size_range_high=30;
size_range_high_str=num2str(size_range_high);
size_intermidiate=1;
%test_imgs_path = uigetdir;
test_imgs_path='C:\Users\NeuroBeast\Desktop\images_high_resolution\Testing\US';
addpath(test_imgs_path);
% choose testing images to be tested according to their indexes:
%indexes = {'001';'204';'209';'211'};%case1video1
indexes={'0313';'0976';'1041';'1183'};%case1video4
%% Main programme:
% testing US images indexes:
classiy_fun = @(block) classify_US(block,neural_net);%3 classes
%classiy_fun = @(block) classify_US_5classes(block,neural_net); % 5 classes
result_storing_path='C:\Users\NeuroBeast\Desktop\results16062018';
for i=1:length(indexes)
    classified={};
    index=indexes{i};
    test_name_read=strcat('case1_Coronal+00',index,'-000.jpg');%casevideo4
    test_name_write=strcat('case1_case1_Coronal+00',index);%case1video4 
    %test_name_read=strcat('case1_video10',index,'.jpeg');%case1video1 
    %test_name_write=strcat('case1_video10',index);%case1video1 
    test_fullname = fullfile(test_imgs_path,test_name_read);
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
        fprintf('Current image index is: %d',i);
        fprintf('\n');
        fprintf('Current box number is: %d',s);
        fprintf('\n');
    end
    % x strips:
    classified_US_x1=blockproc(test_file,[10 20],classiy_fun);
    processed=processed+classified_US_x1;
    classified_US_x2=blockproc(test_file,[12 24],classiy_fun);
    processed=processed+classified_US_x2;
    classified_US_x3=blockproc(test_file,[8 24],classiy_fun);
    processed=processed+classified_US_x3;
    classified_US_x4=blockproc(test_file,[10 30],classiy_fun);
    processed=processed+classified_US_x4;    
    classified_US_x5=blockproc(test_file,[20 60],classiy_fun);
    processed=processed+classified_US_x5;   
    classified_US_x6=blockproc(test_file,[15 30],classiy_fun);
    processed=processed+classified_US_x6;    
    classified_US_x7=blockproc(test_file,[15 45],classiy_fun);
    processed=processed+classified_US_x7;
    classified_US_x8=blockproc(test_file,[30 60],classiy_fun);
    processed=processed+classified_US_x8;    
    % y strips:
    classified_US_y1=blockproc(test_file,[20 10],classiy_fun);
    processed=processed+classified_US_y1;
    classified_US_y2=blockproc(test_file,[24 12],classiy_fun);
    processed=processed+classified_US_y2; 
    classified_US_y3=blockproc(test_file,[24 8],classiy_fun);
    processed=processed+classified_US_y3;
    classified_US_y4=blockproc(test_file,[30 10],classiy_fun);
    processed=processed+classified_US_y4;    
    classified_US_y5=blockproc(test_file,[60 20],classiy_fun);
    processed=processed+classified_US_y5; 
    classified_US_y6=blockproc(test_file,[30 15],classiy_fun);
    processed=processed+classified_US_y6;    
    classified_US_y7=blockproc(test_file,[45 15],classiy_fun);
    processed=processed+classified_US_y7; 
    classified_US_y8=blockproc(test_file,[60 30],classiy_fun);
    processed=processed+classified_US_y8;
    result_average=processed/(length(classified)+16);
    % change here:
    block_infor = sprintf('_block size %d',s);
    result_average_name=strcat('labels_high_entropy_',test_name_write,'_',model_info,'_average_between_',size_range_low_str,'_',size_range_high_str,'.jpg');  
    store_file_average_sum=fullfile(result_storing_path,result_average_name); 
    imwrite(result_average,store_file_average_sum);
    figure
    imshow(result_average)    
end

disp('End')
