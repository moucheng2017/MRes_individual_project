%check if there are empty patches:
folder = uigetdir;
addpath(folder);
[~,folder_name] = fileparts(folder);
folder_name = convertCharsToStrings(folder_name);
path = strcat(folder,'\*.mat');
files = dir (path);
names = {files.name};
empty_files_amount = 0;
empty_files = {};
for i = 1:length(files)
    file = names{i};
    file_string = convertCharsToStrings(file);
    file_temp = load(file);
    patch_temp = file_temp.patch;
    if isempty(patch_temp) 
        empty_file_temp = strcat(file_string,' is empty, will be deleted');
        sprintf(empty_file_temp);
        empty_files{end+1}=file_string;
        empty_files_amount = empty_files_amount + 1;
    end
end
sprintf('%d files are empty',empty_files_amount)
empty_files=empty_files';
save ('empty_files_names.mat','empty_files')
disp('end')