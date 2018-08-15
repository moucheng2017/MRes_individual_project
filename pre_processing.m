%pre-processing images
%{
options=1;
switch options
    case 1        
end
%}
folder_path='C:\Users\NeuroBeast\Desktop\us + masks\case3\US\adhist new';
%folder_path=strcat(folder_path,casename);
all_files = dir(fullfile(folder_path,'\*.png'));
all_files = {all_files.name}';
amount=length(all_files);
for i =1:amount
    file_name=all_files{i};
    img=fullfile(folder_path,file_name);
    img=imread(img);
    %img=imresize(img,[580 562]);
    [heigh,width,channels]=size(img);
    if i==1
        sum_matrix=img;
    else
        sum_matrix=[sum_matrix;img];
    end
end
%
mean_value=mean2(sum_matrix)
standard_devia=std2(sum_matrix);
%{
folder_path='C:\Users\NeuroBeast\Desktop\case2+3 US preprocessing\adhist';
%folder_path=strcat(folder_path,casename);
all_files = dir(fullfile(folder_path,'\*.png'));
all_files = {all_files.name}';
amount=length(all_files);
for j=1:amount
    file_name=all_files{j};
    [FILEPATH,img_name,EXT] =fileparts(file_name);
    img=fullfile(folder_path,file_name);
    img=imread(img); 
    img=(img-mean_value);
    img_name=strcat('adhis_norm_case2_',img_name,'.png');
    figure
    imshow(img)
    img_name = fullfile(folder_path,img_name);
    imwrite(img,img_name);
end
%}
disp('End')