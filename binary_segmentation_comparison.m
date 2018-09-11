% binary segemntation comparision
truth_folder = 'C:\Users\NeuroBeast\Desktop\us + masks\case6\labels';
segmentation_folder='resnet8_Unet_v1_attention_v1_4_new_netwidth48_1';
segmentation_folder = strcat('C:\Users\NeuroBeast\Desktop\results\',segmentation_folder);
truth_files = dir(fullfile(truth_folder,'*.tif')); 
truth_files = {truth_files.name};
segmentation_files = dir(fullfile(segmentation_folder,'*.tif')); 
segmentation_files = {segmentation_files.name};
classNames = ["tumour" "background"];
labelIDs   = [255 0];
pxdsTruth = pixelLabelDatastore(truth_folder, classNames, labelIDs);
pxdsResults = pixelLabelDatastore(segmentation_folder, classNames, labelIDs);
metrics = evaluateSemanticSegmentation(pxdsResults, pxdsTruth);

%{
mean_dice=0;
for i =1:length(truth_files)
    truth_file_name=truth_files{i};
    segmentation_file_name=segmentation_files{i};
    truth_file_name=fullfile(truth_folder,truth_file_name);
    segmentation_file_name=fullfile(segmentation_folder,segmentation_file_name);
    truth=imread(truth_file_name);
    segmentation=imread(segmentation_file_name);
    similarity = dice(truth,segmentation);
    mean_dice=mean_dice+similarity;
end
mean_dice=mean_dice/(length(truth_files));
fprintf('dice is %d',mean_dice);
%}