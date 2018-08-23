function test=test_model(net,model_name)
%model_name_mat = 'attention_network_5stages_v1_2_new_train_case2+case5 large original_validate_case3 large original_fb v3 fb=1.25_200epochs.mat';
%[f_model,model_name,ext_model]=fileparts(model_name);
mkdir('C:\Users\NeuroBeast\Desktop\results 20180822',model_name);

%%
classificationlayer='classification';
%classificationlayer='pixelLabels';
%classificationlayer='Segmentation-Layer';
%classificationlayer='fb classification';
% test images:
test_folder='case6';
test_folder=strcat('C:\Users\NeuroBeast\Desktop\us + masks\',test_folder,'\US');
%test_folder='C:\Users\NeuroBeast\Desktop\nerves test\patches';
addpath(test_folder);
all_imgs = dir(fullfile(test_folder,'\*.png'));
all_imgs = {all_imgs.name}';
all_files=all_imgs;
%%
test_patch_x=224;
test_patch_y=224;
cropped_testing_patch=320;
sliding=112;
mode=0;mode_str=num2str(mode);%1 for stiching; 0 for cropped whole image
%%
for i =1:length(all_files)
    img_name=all_files{i};
    [f,test_name,ext]=fileparts(img_name);
    img=fullfile(test_folder,img_name);
    img=imread(img);
    %img=imresize(img,[320 320]);
    [height,width,channels]=size(img);
    test=zeros(height,width,channels);
    x_steps=floor((width-test_patch_x)/sliding);
    y_steps=floor((height-test_patch_y)/sliding);
    switch mode
        case 1
    
    for j=0:x_steps
        for k =0:y_steps
            left_corner_up_x=j*sliding;
            left_corner_up_y=k*sliding;
            if (k==y_steps)
                patch=imcrop(img,[left_corner_up_x width-test_patch_y test_patch_x test_patch_y]);
                patch=imresize(patch,[test_patch_x test_patch_y]); 
            else
                patch=imcrop(img,[left_corner_up_x left_corner_up_y test_patch_x test_patch_y]);
                patch=imresize(patch,[test_patch_x test_patch_y]);
            end
            final_activations=activations(net,patch,classificationlayer);
            row1=left_corner_up_y+1;
            row2=left_corner_up_y+test_patch_y;
            col1=left_corner_up_x+1;
            col2=left_corner_up_x+test_patch_x;
            segmented_patch=cat(3, final_activations(:,:,1), final_activations(:,:,2), final_activations(:,:,2));
            test(row1:row2,col1:col2,:)=segmented_patch;
            [test_height,test_width,test_channels]=size(test);

        end
        
    end
    % segment the column edge
    %for 
    %end
    
        case 0
            patch=imcrop(img,[0 0 300 300]);
            patch=imresize(patch,[448 448]);
            %patch=imresize(img,[224 224]);
            final_activations=activations(net,patch,classificationlayer);
            final_activations=imresize(final_activations,[300 300]);
            test=cat(3,final_activations(:,:,1),final_activations(:,:,2),final_activations(:,:,2));
            [test_height,test_width,test_channels]=size(test);
        case 2
            
    end
    %
    for ii=1:test_height
        for jj=1:test_width
            if (test(ii,jj,1)>=0.5)
                test(ii,jj,1)=255;
                test(ii,jj,2)=0;
                test(ii,jj,3)=0;
            else
                test(ii,jj,1)=0;
                test(ii,jj,2)=0;
                test(ii,jj,3)=0;
            end
        end
    end
    %
    figure
    imshow(test)
    saving_folder=strcat('C:\Users\NeuroBeast\Desktop\results 20180822\',model_name);
    saving_file_name=strcat('mask_',test_name,'.png');
    name=fullfile(saving_folder,saving_file_name);
    imwrite(test,name);
    fprintf('processing new image ...')
    fprintf('\n\n');  
end