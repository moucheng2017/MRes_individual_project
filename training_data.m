function [train,validate]=training_data(train_data_folder,validate_data_folder)
% data preparation
classNames = ["tumour"; "background"];
pixelLabelID = [255 255 255;0 0 0];
ladir_train=strcat('C:\Users\NeuroBeast\Desktop\',train_data_folder,'\labels');
imdir_train=strcat('C:\Users\NeuroBeast\Desktop\',train_data_folder,'\patches');
imds_train = imageDatastore(imdir_train);
pxds_train = pixelLabelDatastore(ladir_train,classNames,pixelLabelID);
% data augmentation:
imageAugmenter = imageDataAugmenter('RandRotation',[-30 30],...
                                    'RandYReflection',true,...
                                    'RandXReflection',true,...
                                    'RandXScale',[0.3 4],...
                                    'RandYScale',[0.3 4]);
train = pixelLabelImageDatastore(imds_train,pxds_train,'DataAugmentation',imageAugmenter);
% validation
ladir_validate=strcat('C:\Users\NeuroBeast\Desktop\',validate_data_folder,'\labels');
imdir_validate=strcat('C:\Users\NeuroBeast\Desktop\',validate_data_folder,'\patches');
imds_validate =imageDatastore(imdir_validate);
pxds_validate = pixelLabelDatastore(ladir_validate,classNames,pixelLabelID);
validate = pixelLabelImageDatastore(imds_validate,pxds_validate);
end