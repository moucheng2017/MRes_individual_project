folder1='C:\Users\NeuroBeast\Desktop\segmentation\no overlapping';
folder2='C:\Users\NeuroBeast\Desktop\images_high_resolution\Testing\US';
im1 = imread(fullfile(folder1,'case1_video10001 googlenet average 20-30 no overlapping.jpg'));
[height,width,dim]=size(im1);
%im1 = imresize(im1,[460 555]);
im2 = imread(fullfile(folder2,'case1_video10001.jpeg'));
compare=imfuse(im1,im2,'blend','Scaling','independent');
figure
imshow(im1);
%set(h,'AlphaData',0.6)

