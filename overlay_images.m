folder1='C:\Users\NeuroBeast\Desktop\us + masks\case3\US\zero centred individually + adhist';
folder2='C:\Users\NeuroBeast\Desktop\us + masks\case3\Labels\binary class';
im1_name='adhist_zerocentred_case3video2000000000000021.png';
im2_name='binary_Coronal+000001-000.png';
im1 = imread(fullfile(folder1,im1_name));
[height,width,dim]=size(im1);
%im1 = imresize(im1,[460 555]);
im2 = imread(fullfile(folder2,im2_name));
img=imfuse(im2,im1,'blend');
%img = im1.*0.5+im2.*0.5;
figure
imshow(img);
name = strcat('C:\Users\NeuroBeast\Desktop\result 20180801\','ground truth_',im1_name,'.png');
imwrite(img,name)
%set(h,'AlphaData',0.6)

