% change contrast
folder ='C:\Users\NeuroBeast\Desktop\images_high_resolution\Testing\US';
addpath(folder)
allfiles=dir(fullfile(folder,'*.jpg'));
allfiles={allfiles.name};
bits = 8;
for i =1:length(allfiles)
    img = imread(allfiles{i});
    img_po = img-mean(img(:));
    %img_po = histeq(img,bits);
    figure
    imshow(img_po)
    %img_po_name=sprintf('%dbits_HistogramEquliazed_of_',bits);
    img_po_name='zero_centering_';
    img_po_name=strcat(img_po_name,allfiles{i});
    img_po_name=fullfile(folder,img_po_name);
    imwrite(img_po,img_po_name)
end
