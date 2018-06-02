clc
clear all
folder = uigetdir;
height = 224;
width = 224;
cases={'healthy';'tumour';'others'};
for j=1:length(cases)
    case_temp=cases{j};
    folder_temp=strcat(folder,'\',case_temp);
    addpath(folder_temp);
    [~,folder_name_temp] = fileparts(folder_temp);
    folder_name_temp = convertCharsToStrings(folder_name_temp);
    m_files = dir(fullfile(folder_temp,'*.jpeg')); 
    m_files = {m_files.name};
    for i = 1:length(m_files)
    file_temp = imread(m_files{i});
    new_file=imresize(file_temp,[height width]);
    fullname = fullfile(folder_temp,m_files{i});
    imwrite(new_file,fullname);
    fprintf('processing 2 ...')
    fprintf('\n\n');
    end
    fprintf('processing 1 ...')
    fprintf('\n\n');
end

disp('end')