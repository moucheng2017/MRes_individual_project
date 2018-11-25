clc
clear all
% change here:
% model folder:
model_folder= 'C:\Users\NeuroBeast\Desktop\Full_attentional_FCN\Models';addpath(model_folder);
% test images:
test_folder='case6';
test_folder=strcat('C:\Users\NeuroBeast\Desktop\Full_attentional_FCN\us + masks\',test_folder,'\US');
addpath(test_folder);
%
all_imgs = dir(fullfile(test_folder,'\*.png'));
all_imgs = {all_imgs.name}';
all_files=all_imgs;
all_models = dir(fullfile(model_folder,'\*.mat'));
all_models = {all_models.name}';
%classificationlayer='fb classification';
for j =1:length(all_models)
    model_name_mat=all_models{j};
    [f,model_name,ext]=fileparts(model_name_mat);
    mkdir('C:\Users\NeuroBeast\Desktop\results',model_name);
    model_file=fullfile(model_folder,model_name_mat);
    network=load (model_file);
    net=network.net1;
    netlayers=net.Layers;
    classificationlayer=netlayers(end);
    classificationlayer=classificationlayer.Name;
    %classificationlayer='fb classification';
for i =1:length(all_files)
    img_name=all_files{i};
    [f,test_name,ext]=fileparts(img_name);
    img=fullfile(test_folder,img_name);
    img=imread(img);
    [height,width,channels]=size(img);
    patch=imresize(img,[448 448]);
    final_activations=activations(net,patch,classificationlayer);
    final_activations=imresize(final_activations,[300 300]);
    test = final_activations(:,:,1);
    segmentation=ones(300,300);
    for ii=1:300
        for jj=1:300
            if (test(ii,jj,1)>=0.5)
                segmentation(ii,jj)=255;
            else
                segmentation(ii,jj)=0;
            end
        end
    end
    %
    %figure
    %imshow(test)
    saving_folder=strcat('C:\Users\NeuroBeast\Desktop\results\',model_name);
    saving_file_name=strcat('mask_',test_name,'.tif');
    name=fullfile(saving_folder,saving_file_name);
    %name = strcat('C:\Users\NeuroBeast\Desktop\results 20180822\',test_name,'_',model_name,'.png');
    imwrite(segmentation,name);
    fprintf('processing...')
    fprintf('\n\n');  
end
    
    fprintf('processing new model ...')
    fprintf('\n\n');  
end

