folder='C:\Users\NeuroBeast\Desktop\semantic segmentation\labels';
m_files = dir(fullfile(folder,'*.mat')); 
m_files = {m_files.name};
for i =1:length(m_files)
    file=m_files{i};
    [path,name,ext]=fileparts(file);
    load (file);
    file=patch_labels;
    name=strcat(name,'_j.jpg');
    fullname = fullfile(folder,name);
    imwrite(file,fullname);
    
end