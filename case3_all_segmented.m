clc
clear all
% create stitched segmented images
% load net
model_folder= '../trained models/20180730';
addpath(model_folder);
model_name_mat = 'resnet11_Unet_v8_train_case2 400 sharpend_validate_case3 400 sharpend_tumour binary fb=3.mat';
[f,model_name,ext]=fileparts(model_name_mat);
model_file=fullfile(model_folder,model_name_mat);
network=load (model_file);
net=network.net1;
%%
classificationlayer='fb classification';
%classificationlayer='classification_layer_stage1';
% test images:
test_folder=strcat('C:\Users\NeuroBeast\Desktop\case3 all');
addpath(test_folder);
all_imgs = dir(fullfile(test_folder,'\*.png'));
all_imgs = {all_imgs.name}';
all_files=all_imgs;
for i =1:length(all_files)
    img_name=all_files{i};
    [f,test_name,ext]=fileparts(img_name);
    img=fullfile(test_folder,img_name);
    img_original=imread(img);
    img=img_original;
    [height_ori,width_ori,channels]=size(img_original);
    %segmentation_whole=zeros(height,width,channels);
    %segmentation_whole=imread(segmentation_whole);
    xmin=0;
    ymin=0;
    width=224;
    height=224;
    for j=1:3
        if j ==1
        row1=ymin+1;
        row2=ymin+height;
        col1=xmin+1;
        col2=xmin+width;
        patch=imcrop(img_original,[xmin ymin width height]);
        [height_patch,width_patch,channels_patch]=size(patch);
        %segmented_patch=activations(net,patch,'classification_layer_stage1');
        segmented_patch=activations(net,patch,classificationlayer);
        %segmented_patch=segmented_patch(:,:,2)*255;
        segmented_patch=cat(3, segmented_patch(:,:,1), segmented_patch(:,:,2), segmented_patch(:,:,2));
        %segmented_patch=imresize(segmented_patch,[height_patch width_patch]);
        img(row1:row2,col1:col2,:)=segmented_patch;
        elseif j==3
            xmin=338;
            col1=xmin+1;
            col2=xmin+width;
            patch=imcrop(img_original,[xmin ymin width-1 height]);
            [height_patch,width_patch,channels_patch]=size(patch);
            %segmented_patch=activations(net,patch,'classification_layer_stage1');
            segmented_patch=activations(net,patch,classificationlayer);
            %segmented_patch=segmented_patch(:,:,2)*255;
            segmented_patch=cat(3, segmented_patch(:,:,1), segmented_patch(:,:,2), segmented_patch(:,:,2));
            %segmented_patch=imresize(segmented_patch,[height_patch width_patch]);
            img(row1:row2,col1:col2,:)=segmented_patch;  
        else
            col1=col1+224;
            col2=col2+224;
            xmin=xmin+224;
            patch=imcrop(img_original,[xmin ymin width-1 height]);
            [height_patch,width_patch,channels_patch]=size(patch);
            %segmented_patch=activations(net,patch,'classification_layer_stage1');
            segmented_patch=activations(net,patch,classificationlayer);
            %segmented_patch=segmented_patch(:,:,2)*255;
            segmented_patch=cat(3, segmented_patch(:,:,1), segmented_patch(:,:,2), segmented_patch(:,:,2));
            segmented_patch=imresize(segmented_patch,[height_patch width_patch]);           
            img(row1:row2,col1:col2,:)=segmented_patch;
            
        end
    end
    
    xmin=0;
    ymin=224;
    width=224;
    height=224;
    for j=5:7
        row1=ymin+1;
        row2=ymin+height;
        if j ==5

        col1=xmin+1;
        col2=xmin+width;
        patch=imcrop(img_original,[xmin ymin width height-1]);
        [height_patch,width_patch,channels_patch]=size(patch);
        %segmented_patch=activations(net,patch,'classification_layer_stage1');
        segmented_patch=activations(net,patch,classificationlayer);
         % segmented_patch=segmented_patch(:,:,2)*255;
        segmented_patch=cat(3, segmented_patch(:,:,1), segmented_patch(:,:,2), segmented_patch(:,:,2));
            %segmented_patch=imresize(segmented_patch,[height_patch width_patch]);        
        img(row1:row2,col1:col2,:)=segmented_patch;
        elseif j==7
            xmin=338;
            col1=xmin+1;
            col2=xmin+width;
            patch=imcrop(img_original,[xmin ymin width-1 height-1]);
            [height_patch,width_patch,channels_patch]=size(patch);
            %segmented_patch=activations(net,patch,'classification_layer_stage1');
            segmented_patch=activations(net,patch,classificationlayer);
            %segmented_patch=segmented_patch(:,:,2)*255;
            segmented_patch=cat(3, segmented_patch(:,:,1), segmented_patch(:,:,2), segmented_patch(:,:,2));
            %segmented_patch=imresize(segmented_patch,[height_patch width_patch]);            
            img(row1:row2,col1:col2,:)=segmented_patch;  
        else
            col1=col1+224;
            col2=col2+224;
            xmin=xmin+224;
            patch=imcrop(img_original,[xmin ymin width-1 height-1]);
            [height_patch,width_patch,channels_patch]=size(patch);
            %segmented_patch=activations(net,patch,'classification_layer_stage1');
            segmented_patch=activations(net,patch,classificationlayer);
            %segmented_patch=segmented_patch(:,:,2)*255;
            segmented_patch=cat(3, segmented_patch(:,:,1), segmented_patch(:,:,2), segmented_patch(:,:,2));
            %segmented_patch=imresize(segmented_patch,[height_patch width_patch]);            
            img(row1:row2,col1:col2,:)=segmented_patch; 
        end
    end
        xmin=0;
        ymin=356;
        width=224;
        height=224;
     for j=9:11
        row1=ymin+1;
        row2=ymin+height;
        if j ==9

        col1=xmin+1;
        col2=xmin+width;
        patch=imcrop(img_original,[xmin ymin width height-1]);
        [height_patch,width_patch,channels_patch]=size(patch);
        %segmented_patch=activations(net,patch,'classification_layer_stage1');
        segmented_patch=activations(net,patch,classificationlayer);
        %segmented_patch=segmented_patch(:,:,2)*255;
        segmented_patch=cat(3, segmented_patch(:,:,1), segmented_patch(:,:,2), segmented_patch(:,:,2));
        %segmented_patch=imresize(segmented_patch,[height_patch width_patch]);        
        img(row1:row2,col1:col2,:)=segmented_patch;
        elseif j==11
            xmin=338;
            col1=xmin+1;
            col2=xmin+width;
            patch=imcrop(img_original,[xmin ymin width-1 height-1]);
            [height_patch,width_patch,channels_patch]=size(patch);
            %segmented_patch=activations(net,patch,'classification_layer_stage1');
            segmented_patch=activations(net,patch,classificationlayer);
            %segmented_patch=segmented_patch(:,:,2)*255;
            segmented_patch=cat(3, segmented_patch(:,:,1), segmented_patch(:,:,2), segmented_patch(:,:,2));
            %segmented_patch=imresize(segmented_patch,[height_patch width_patch]);            
            img(row1:row2,col1:col2,:)=segmented_patch;  
        else
            col1=col1+224;
            col2=col2+224;
            xmin=xmin+224;
            patch=imcrop(img_original,[xmin ymin width-1 height-1]);
            [height_patch,width_patch,channels_patch]=size(patch);
            %segmented_patch=activations(net,patch,'classification_layer_stage1');
            segmented_patch=activations(net,patch,classificationlayer);
            %segmented_patch=segmented_patch(:,:,2)*255;
            segmented_patch=cat(3, segmented_patch(:,:,1), segmented_patch(:,:,2), segmented_patch(:,:,2));
            %segmented_patch=imresize(segmented_patch,[height_patch width_patch]);            
            img(row1:row2,col1:col2,:)=segmented_patch; 
        end       
        
     end
     %
     for ii=1:height_ori
         for jj=1:width_ori

             %
             if(img(ii,jj,2)>=0.9)
                 img(ii,jj,1)=255;
                 img(ii,jj,2)=0;
                 img(ii,jj,3)=0;
             else
                 img(ii,jj,1)=0;
                 img(ii,jj,2)=0;
                 img(ii,jj,3)=0;
             
             end
                 %
         end
     end
      %
    %figure
    %imshow(img)
    name = strcat('C:\Users\NeuroBeast\Desktop\results case 3\',model_name,'_',test_name,'.png');
    imwrite(img,name)
    
    
end

disp('End')