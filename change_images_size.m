clc
clear all
% navigate to the folder
folder = uigetdir;
height = 32;
width = 32;
cases={'Healthy';'Others';'Tumour'};
for j=1:length(cases)
    case_temp=cases{j};
    folder_temp=strcat(folder,'\',case_temp);
    addpath(folder_temp);
    m_files = dir(fullfile(folder_temp,'*.jpg')); 
    m_files = {m_files.name};
    for i = 1:length(m_files)
    file_temp = imread(m_files{i});
    %file_temp=rgb2gray(file_temp);
    %new_file=imadjust(file_temp);
    %new_file = cat(3,new_file,new_file,new_file);
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