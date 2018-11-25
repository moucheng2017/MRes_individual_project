%% data analysis
% ground truth images:
truth_folder = 'C:\Users\NeuroBeast\Desktop\Full_attentional_FCN\us + masks\case6\labels';
truth_files = dir(fullfile(truth_folder,'*.tif')); 
truth_files = {truth_files.name};
classNames = ["tumour" "background"];
labelIDs   = [255 0];
pxdsTruth = pixelLabelDatastore(truth_folder, classNames, labelIDs);
% mother folder:
folder = 'C:\Users\NeuroBeast\Desktop\all models';
% list all sub folders:
d = dir(folder);
isub = [d(:).isdir]; 
nameFolds = {d(isub).name}';
nameFolds(ismember(nameFolds,{'.','..'})) = [];
folders_number=length(nameFolds);
%%
modelnames={};
GlobalAccuracy=[];
MeanAccuracy=[];
MeanIoU=[];
WeightedIoU=[];
MeanBFScore=[];
for i =1:folders_number
    subfolder = nameFolds{i};
    segmentation_folder=strcat(folder,'\',subfolder);
    segmentation_files = dir(fullfile(segmentation_folder,'*.tif')); 
    segmentation_files = {segmentation_files.name};
    pxdsResults = pixelLabelDatastore(segmentation_folder, classNames, labelIDs);
    metrics = evaluateSemanticSegmentation(pxdsResults, pxdsTruth);
    datametrics=metrics.DataSetMetrics;
    modelnames = [modelnames,{subfolder}];
    GlobalAccuracy(end+1)= datametrics{1,1};
    MeanAccuracy(end+1)= datametrics{1,2};
    MeanIoU(end+1)= datametrics{1,3};
    WeightedIoU(end+1)= datametrics{1,4};
    MeanBFScore(end+1)= datametrics{1,5};
    fprintf('processing...')
    fprintf('\n\n');  
end
modelnames =modelnames';
GlobalAccuracy=GlobalAccuracy';
MeanAccuracy=MeanAccuracy';
MeanIoU=MeanIoU';
WeightedIoU=WeightedIoU';
MeanBFScore=MeanBFScore';
T = table(modelnames,GlobalAccuracy,MeanAccuracy,MeanIoU,WeightedIoU,MeanBFScore);
tablefullname=fullfile(folder,'semantic_segmentation_results.xls');
writetable(T,tablefullname);
disp('End')