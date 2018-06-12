% delete patches with no information
% delete all empty patches in healthy patches
clc
clear all
folder = uigetdir;
%entropythreshold =3.592482+0.5*2.2992;
intensity_threshold = 25;
allfiles=dir(fullfile(folder,'*.jpg'));
allfiles={allfiles.name};
files_deleted = 0;
for i=1:length(allfiles)
    fprintf('processing...');
    fprintf('\n\n');
    file=allfiles{i};
    img_file=fullfile(folder,file);
    img=imread(img_file);
    meanintensity= mean(img(:));
    %e = entropy(img);
    if (meanintensity<intensity_threshold)
    %if (e<entropythreshold)
        delete (img_file);
        fprintf('one empty file found...');
        fprintf('\n\n');
        files_deleted = files_deleted +1;
    end
end

fprintf('%d empty files are deleted', files_deleted);