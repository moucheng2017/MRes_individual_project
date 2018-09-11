% create a sliding windwos to hover over the whole image for classification
% with distinct blocks:
clc
clear all
%% load right model:
%model_folder= '../trained models/11062018';
%model_folder= '../trained models/18062018';
%model_folder= '../trained models/11062018';
model_folder= 'C:\Users\NeuroBeast\Desktop\comparison\sliding window';
addpath(model_folder);
%% change parameters:
% choose fine tuned neural model:
model_name = 'googlenet_111layersfrozen_2.mat';
model_file=fullfile(model_folder,model_name);
load (model_file);
neural_net = net;
% change the fine tuned neural model name:
[path,model_info,ext]=fileparts(model_name);
%net_infor = strcat(net_type,'_',classes,'classes','_trained on',training_dataset,'_',training_patches_size,'_with_',training_patches_sliding,'sliding');
% change the overlapping pixels of neighbouring patches:
size_range_low=40;
size_range_low_str=num2str(size_range_low);
size_range_high=80;
size_range_high_str=num2str(size_range_high);
size_intermidiate=10;
%test_imgs_path = uigetdir;
test_imgs_path='C:\Users\NeuroBeast\Desktop\us + masks\case6\US';
test_files = dir(fullfile(test_imgs_path,'*.png'));
test_files = {test_files.name};
addpath(test_imgs_path);
% choose testing images to be tested according to their indexes:
%indexes = {'001';'204';'209';'211'};%case1video1
%indexes={'0313';'0976';'1041';'1183'};%case1video4
%indexes={'0116';'0120';'0143';'0161'};%case2
%% Main programme:
classified={};
% testing US images indexes:
classiy_fun = @(block) classify_US(block,neural_net);%3 classes
%classiy_fun = @(block) classify_US_5classes(block,neural_net); % 5 classes
result_storing_path='C:\Users\NeuroBeast\Desktop\results';
for i=1:length(test_files)
    test_name_read=test_files{i};
    [filepath,test_name_write,ext]=fileparts(test_name_read);
    test_fullname = fullfile(test_imgs_path,test_name_read);
    test_file=imread(test_fullname);
    [height,width,dim]=size(test_file);
    for s=size_range_low:size_intermidiate:size_range_high          
        %}
        %only for squares
        classified_US=blockproc(test_file,[s s],classiy_fun);
        classified_US=imresize(classified_US,[300 300]);
        %
        if s == size_range_low
        [processed_height,processed_width,dim]=size(classified_US);
        processed=zeros(processed_height,processed_width,dim);
        processed=classified_US+processed;
        else
            processed=processed+classified_US;

        end
        classified{end+1}=classified_US;
        %
        fprintf('Current image index is: %d',i);
        fprintf('\n');
        fprintf('Current box number is: %d',s);
        fprintf('\n');
    end
    result_average=processed/(length(classified));
    [height,width,channels]=size(result_average);
    for h=1:height
        for w=1:width
            redchannel=result_average(:,:,1);
            meanvalue=mean2(redchannel);
            if (result_average(h,w,1)>=meanvalue)
                result_average(h,w,1)=1;
                result_average(h,w,2)=0;
                result_average(h,w,3)=0;
            else
                result_average(h,w,1)=0;
                result_average(h,w,2)=0;
                result_average(h,w,3)=0;
            end
        end
    end
    % change here:
    result_average_name=strcat('labels_',test_name_write,'_',model_info,'.png');  
    store_file_average_sum=fullfile(result_storing_path,result_average_name); 
    imwrite(result_average,store_file_average_sum);
    %figure
    %imshow(result_average)    
end
disp('End')
