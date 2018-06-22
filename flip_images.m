clc
clear all
% navigate to the folder
folder = uigetdir;
cases={'healthy';'tumour';'others'};
for j=1:length(cases)
    case_temp=cases{j};
    folder_temp=strcat(folder,'\',case_temp);
    addpath(folder_temp);
    m_files = dir(fullfile(folder_temp,'*.jpg')); 
    m_files = {m_files.name};
    for i = 1:length(m_files)
    m_file = m_files{i};
    file_temp = imread(m_file);
    new_file=fliplr(file_temp);
    m_file = strcat('flipped_',m_file);
    fullname = fullfile(folder_temp,m_file);
    imwrite(new_file,fullname);
    fprintf('processing 2 ...')
    fprintf('\n\n');
    end
    fprintf('processing 1 ...')
    fprintf('\n\n');
end

disp('end')