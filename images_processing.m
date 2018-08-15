clc
clear all
% navigate to the folder
%folder='C:\Users\NeuroBeast\Desktop\case2+3 US preprocessing\zero centred individually';
%folder='C:\Users\NeuroBeast\Desktop\case2+3 US preprocessing\heavy normalised individually';
folder = uigetdir;
addpath(folder);
files = dir(fullfile(folder,'*.png')); 
files = {files.name};
operation='13';
% choose operations on images:
% 1: sharp images
% 2: histogram equlisation
% 3: adaptive histogram equlisation
% 4: zero centering the images
% 5: flip the images, upside down for odd images; left-right for even
% images
% 6: enhance colours
% 7: 
% 9: normalize images
% 10: resize
% 11:
% 12:
% 13: create mask
% 14: clear scattered objects 
for i = 1:length(files)
    file = files{i};
    [FILEPATH,name,EXT] = fileparts(file);
    file=fullfile(folder,file);
   % file_temp=load(file);
    file_temp = imread(file);
    switch operation
        case '1'
            radius=10;
            amount=2;
            new_file = imsharpen(file_temp,'Radius',radius,'Amount',amount);
            radius_=num2str(radius);
            amount_=num2str(amount);
            filename=strcat(name,'.png');
           % filename=strcat('sharpend_',radius_,'_',amount_,'_',name,'.png');
            
        case '2'
            new_file = histeq(file_temp);
            filename=strcat('histeq_',name,'.png');
        case '3'
            file_temp=rgb2gray(file_temp) ;
            new_file =adapthisteq(file_temp,'NumTiles',[12 12]);
            %new_file =adapthisteq(file_temp,'NumTiles',[100 20],'ClipLimit',0.005,'Distribution','rayleigh','Alpha',0.8);
            new_file= cat(3,new_file,new_file,new_file);
            filename=strcat('adaphis_',name,'.png');
            
        case '5'
            new_file=fliplr(file_temp);
            filename = strcat(name,'.png');
            %{
            remainder=rem(i,2);
            if (remainder==1)
                new_file=flipud(file_temp);
                filename = strcat('flipup_',name,'.png');
            else
                new_file=fliplr(file_temp);
                filename = strcat('fliprl_',name,'.png');
            end
            %}
        case '6'
            file_temp= rgb2hsv(file_temp);
            [height,width,dims]=size(file_temp);
            for iii=1:height
                for jjj=1:width
                    file_temp(iii,jjj,2)=1;
                end
            end
            new_file = hsv2rgb(file_temp);
            
            filename = strcat('enhanced_',name,'.png');


        case '7'
            edgeThreshold = 0.5;
            amount = 0.5;
            new_file= localcontrast(file_temp, edgeThreshold, amount);
            filename = strcat('edgeenhanced_',name,'.png');
        case '8'
            file_temp=rgb2gray(file_temp) ;
            new_file = adapthisteq(file_temp,'clipLimit',0.02,'Distribution','rayleigh');
            new_file= cat(3,new_file,new_file,new_file);
            filename = strcat('adapthisteq_',name,'.png');
        case '9'
            %mean_value=mean2(file_temp);
            %mean_value=61.742;%case2 mean
            mean_value=70.6474;%case3 mean
            %median=median(file_temp);
            %standard_devia=std2(file_temp);
            new_file=(file_temp-mean_value);
            %new_file=2*new_file/standard_devia;
            filename = strcat('zero_centred_',name,'.png');
        case '10'
            %new_file=imcrop(file_temp,[0 0 560 580]);
            new_file=imresize(file_temp,[320 320]);
            filename = strcat(name,EXT);
        case '11'
            %file_temp=file_temp;
            file_temp=rgb2gray(file_temp);
            new_file= bwareaopen(file_temp,600,4);
            
            %new_file=cat(3,new_file,new_file);
            filename = strcat('small_objects_removed_',name,'.png');
        case '12'
            
            new_file=file_temp;
            [height,width,channels]=size(file_temp);
            for k =1:height
                for j=1:width
                    if (file_temp(i,k,1)>10)
                        new_file(i,k,1)=0;
                        new_file(i,k,2)=0;
                        new_file(i,k,3)=0;
                    else
                        new_file(i,k,1)=file_temp(i,k,1);
                        new_file(i,k,2)=file_temp(i,k,2);
                        new_file(i,k,3)=file_temp(i,k,3);                       
                    end
                end
            end
        case '13'
            %
            file_temp=rgb2gray(file_temp);
            [height,width]=size(file_temp);
            new_file=ones(height,width);
            for kkk=1:height
                for jjj=1:width
                    if (file_temp(kkk,jjj)<25)
                        new_file(kkk,jjj)=0;

           
                    else
                        new_file(kkk,jjj)=255;
  
                    end
                end
            end
            %filename = strcat(name,'.pbm');
            new_file=cat(3,new_file,new_file,new_file);
            filename = strcat(name,'.tif');
            %
            %{
            file_temp=logical(file_temp.new_file);
            n=cat(3,file_temp,file_temp);
            filename = strcat(name,'.tif');
            fullname = fullfile(folder,filename);
            imwrite(file_temp,fullname);
            %save(fullname,'new_file');
            %}
            
        case '14'
            file_temp=rgb2gray(file_temp);
            new_file = bwareaopen(file_temp,1500,4);
            filename = strcat('cleaned_',name,'.png');
            
    end
    %folder_store='C:\Users\NeuroBeast\Desktop\case2+3 US preprocessing';
    fullname = fullfile(folder,filename);
    %figure
    %imshow(new_file)
    imwrite(new_file,fullname);
    fprintf('processing ...')
    fprintf('\n\n');    
end


disp('end')