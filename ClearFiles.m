%% select folder
clc
clear all
folder = uigetdir;
%file_extension='*.jpg';
%cases={'Grey matter';'Tumour';'Others';'White matter'};
cases={'Healthy';'Others';'Tumour'};
%case1video1:
%threshold_healthy =4.8726-0*1.058184;
%threshold_others = 2.92+0.5*2.755;
%case1video4:
mean_thresh = 25;
entropy_threshold_healthy =3.3179-0*1.9284;
entropy_threshold_others = 6.053232-0.5*1.03511;
%cases = {'White matter';'Grey matter';'Tumour';'Sulcus';'Others'};
%% clear all the files under threshold values

for j=1:length(cases)
    case_temp=cases{j};
    folder_temp=strcat(folder,'\',case_temp);
    addpath(folder_temp);
    all_files = dir(fullfile(folder_temp,'\*.jpg'));
    all_files = {all_files.name};
    switch case_temp
        case 'Healthy'
            threshold = entropy_threshold_healthy;
            for k=1:length(all_files)
                file_temp=all_files{k};
                img_temp=imread(file_temp);
                e_temp = entropy(img_temp);
                mean_temp = mean(img_temp(:));
                if (mean_temp <= mean_thresh)                
                %if (e_temp <= threshold)
                    file_to_be_deleted = fullfile(folder_temp,file_temp);
                    delete (file_to_be_deleted)
                    fprintf('deleting healthy...');
                    fprintf('\n\n');
                else
                    % pass
                end 
            end    
             
        case 'Tumour'
            threshold = entropy_threshold_healthy;
            for k=1:length(all_files)
                file_temp=all_files{k};
                img_temp=imread(file_temp);
                e_temp = entropy(img_temp);
                mean_temp = mean(img_temp(:));
                if (mean_temp <= mean_thresh)                
                %if (e_temp <= threshold)
                    file_to_be_deleted = fullfile(folder_temp,file_temp);
                    delete (file_to_be_deleted)
                    fprintf('deleting tumour...');
                    fprintf('\n\n');
                else
                    % pass
                end 
             end            
            
        case 'Others'
            threshold = entropy_threshold_others;
            for k=1:length(all_files)
                file_temp=all_files{k};
                img_temp=imread(file_temp);
                e_temp = entropy(img_temp);
                mean_temp = mean(img_temp(:));
                if (mean_temp <= mean_thresh)
                %if (e_temp <= threshold)
                    file_to_be_deleted = fullfile(folder_temp,file_temp);
                    delete (file_to_be_deleted)
                    fprintf('deleting others...');
                    fprintf('\n\n');
                else
                    % pass
                end 
            end 
    end
end

%% for deleting all files in the seleted folder:
%{
file_extension = 'jpg';%change here 
for j=1:length(cases)
    case_temp=cases{j};
    folder_temp=strcat(folder,'\',case_temp);
    addpath(folder_temp);
    files_extension = '\*.';
    files_extension = strcat(files_extension,file_extension);
    files_to_be_deleted = dir(fullfile(folder_temp,files_extension));
    files_to_be_deleted = {files_to_be_deleted.name};
    for i=1:length(files_to_be_deleted)
        file_tobedeleted=files_to_be_deleted{i};
        file_tobedeleted=fullfile(folder_temp,file_tobedeleted);
        delete (file_tobedeleted);
        fprintf('deleting...');
        fprintf('\n\n');
    end
    

end

%% for deleting cropped patches in different scales 
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
%}
disp('end')