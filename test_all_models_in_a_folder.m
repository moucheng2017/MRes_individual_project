clc
clear all
model_folder= '../trained models/20180821';
addpath(model_folder);
all_models = dir(fullfile(model_folder,'\*.mat'));
all_models = {all_models.name}';
for i =1:length(all_models)
    model_name_mat=all_models{i};
    [f,model_name,ext]=fileparts(model_name_mat);
    model_file=fullfile(model_folder,model_name_mat);
    network=load (model_file);
    net=network.net1;
    test_model(net,model_name);
    fprintf('processing new model ...')
    fprintf('\n\n');  
end

