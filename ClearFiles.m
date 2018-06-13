% clear all mat files
clc
clear all
folder = uigetdir;
file_extension='*.jpg';
%cases={'Grey matter';'Tumour';'Others';'White matter'};
cases={'healthy';'tumour';'others'};
%cases = {'White matter';'Grey matter';'Tumour';'Sulcus';'Others'};
for j=1:length(cases)
    case_temp=cases{j};
    folder_temp=strcat(folder,'\',case_temp);
    addpath(folder_temp);
    files_to_be_deleted = fullfile(folder_temp,'\*.jpg');
    for k=1:length(files_to_be_deleted)
        file_temp=files_to_be_deleted{k};
        img_temp=imread(file_temp);
        %...
    end
    delete (files_to_be_deleted);
    fprintf('deleting...');
    fprintf('\n\n');
end
%{

for i=10:10:100
    i_string=num2str(i);
    folder_sub_h = strcat(folder,'\patches_',i_string,'\Healthy');
    files_h = fullfile(folder_sub_h,file_extension);
    delete (files_h);
    folder_sub_t = strcat(folder,'\patches_',i_string,'\Tumour');
    files_t = fullfile(folder_sub_t,file_extension);
    delete (files_t);
    folder_sub_o = strcat(folder,'\patches_',i_string,'\Others');
    files_o = fullfile(folder_sub_o,file_extension);
    delete (files_o);
end
%}

%files_to_be_deleted1 = fullfile(folder,'*.mat');
%files_to_be_deleted2 = fullfile(folder,'*.jpg');
%files_to_be_deleted3 = fullfile(folder,'*.jpeg');
%delete (files_to_be_deleted1)
%delete (files_to_be_deleted2)
%delete (files_to_be_deleted3)


disp('end')