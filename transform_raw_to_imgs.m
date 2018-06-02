clc
clear all
%% change files into pictures and store them 
folder = uigetdir;
%addpath(folder);addpath(folder_healthy);addpath(folder_tumour);addpath(folder_others);
%[~,folder_name] = fileparts(folder);
cases={'healthy';'tumour';'others'};
for j=1:length(cases)
    case_temp=cases{j};
    %case_temp_string = convertCharsToStrings(case_temp);
    folder_temp=strcat(folder,'\',case_temp);
    addpath(folder_temp);
    [~,folder_name_temp] = fileparts(folder_temp);
    folder_name_temp = convertCharsToStrings(folder_name_temp);
    path_temp = strcat(folder_temp,'\*.mat');
    files_temp = dir (path_temp);
    names_temp = {files_temp.name};
    for i = 1:length(files_temp)
    file = names_temp{i};
    file_temp = load(file);
    switch case_temp
        case 'others'
        patch_temp = file_temp.patch_others;
        case 'healthy'
        patch_temp = file_temp.patch_healthy;    
        case 'tumour'
        patch_temp = file_temp.patch_tumour;   
    end
    name_temp = sprintf('_img_%d.jpeg',i);
    name_temp = strcat(folder_name_temp,name_temp);
    fullname=fullfile(folder_temp,name_temp);
    fullname=convertStringsToChars(fullname);
    imwrite(patch_temp,fullname);
    fprintf('processing...');
    fprintf('\n\n');
    end
end
%folder_name = convertCharsToStrings(folder_name);

%path = strcat(folder,'\*.mat');
%files = dir (path);
%names = {files.name};
%{
for i = 1:length(files)
    file = names{i};
    file_string = convertCharsToStrings(file);
    file_temp = load(file);
    patch_temp = file_temp.patch_others;
    %path1 = 'C:\Users\NeuroBeast\Desktop\patches_multi_scales_high_resolution\';
    %path1 = 'C:\Users\NeuroBeast\Desktop\patches_30\';
    %path1 = 'C:\Users\NeuroBeast\Desktop\patches_40\';
    %path1 = 'C:\Users\NeuroBeast\Desktop\patches_20\';
    %path2 = strcat(folder,'\',folder_name);
    name_temp = sprintf('_img_%d.jpeg',i);
    name_temp = strcat(folder_name,name_temp);
    fullname=fullfile(folder,name_temp);
    fullname=convertStringsToChars(fullname);
    imwrite(patch_temp,fullname);
end
%}

disp('end')