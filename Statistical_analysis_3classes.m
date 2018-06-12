clc
clear all
%% Read the segmented image and find the corresponding US image
% navigate to the folder of segmented images
fprintf('Please navigate to the folder where the segmented images are stored, be careful of the overlapping paramters.');
fprintf('\n\n');
bordertrim=0;
bordertrim_str=num2str(bordertrim);
%stats = strcat('results pixel classification googlenet 20 100.xls');
segmentation_path = uigetdir;
segmented_files = dir(fullfile(segmentation_path,'*.jpg'));
segmented_files = {segmented_files.name};
model_infor='3 classes googlenet 20-100 50%sliding';
% prepare to store statistical analysis
SegmentationNames = {};
TumourAccuracies=[];
TumourSensitivities=[];
TumourSpecificities=[];
HealthyAccuracies=[];
HealthySensitivities=[];
HealthySpecificities=[];
OthersAccuracies=[];
OthersSensitivities=[];
OthersSpecificities=[];
% Here will add a for loop
for i =1:length(segmented_files)
segmentation_file_name = segmented_files{i};
[filepath,segmentation_file_name_noextension,ext]=fileparts(segmentation_file_name);
SegmentationNames =[SegmentationNames,{segmentation_file_name_noextension}];
%segmentation_file_name='case1_Coronal+000313_Googlenet_multi_scales_20_100_50'%_case1_allImages__block size 20_average_between_10_20
line_locations = strfind(segmentation_file_name,'_');
first_space_location = line_locations(2);
segmentation_name = segmentation_file_name(1:first_space_location-1);
US_index = segmentation_name(first_space_location-4:first_space_location-1);
case_index = segmentation_name(5);
ground_truth_name=strcat('case',case_index,'_Coronal+00',US_index,'-000.jpg');
ground_truth_folder_path = 'C:\Users\NeuroBeast\Desktop\images_high_resolution\Testing';
ground_truth_folder = strcat('GroundTruth','_',bordertrim_str,'pixels_TrimBorder');
ground_truth_folder_path_full = strcat(ground_truth_folder_path,'\',ground_truth_folder);
ground_truth_file_full = fullfile(ground_truth_folder_path_full,ground_truth_name);
segmentation_file = imread(fullfile(segmentation_path,segmentation_file_name));
[height,width,dim]=size(segmentation_file);
ground_truth_file = imread(ground_truth_file_full);
stats = strcat(segmentation_file_name_noextension,'_',bordertrim_str,'overlapping',model_infor,'.xls');
%% Prepare empty folders to store results
% tumour:
tumour_ground_truth=0;
tumour_segmentation=0;
GroundTruthTumour_SegmentationTumour=0;%ground_truth first, segmentation second
GroundTruthTumour_SegmentationHealthy=0;
GroundTruthTumour_SegmentationOthers=0;
GroundTruthTumour_SegmentationNotClear=0;
% healthy:
healthy_ground_truth=0;
healthy_segmentation=0;
GroundTruthHealthy_SegmentationTumour=0;
GroundTruthHealthy_SegmentationHealthy=0;
GroundTruthHealthy_SegmentationOthers=0;
GroundTruthHealthy_SegmentationNotClear=0;
% others:
others_ground_truth=0;
others_segmentation=0;
GroundTruthOthers_SegmentationOthers=0;
GroundTruthOthers_SegmentationHealthy=0;
GroundTruthOthers_SegmentationTumour=0;
GroundTruthOthers_SegmentationNotClear=0;

%% Create labels maps of US image and ground truth image:
% 1: tumour; 2: healthy; 3: others
labels_ground_truth=zeros(height,width);
labels_segmentation=zeros(height,width);
R_channel_groundtruth = ground_truth_file(:,:,1);r_ground_truth=mean2(R_channel_groundtruth);std_r_ground_truth=std2(R_channel_groundtruth);
G_channel_groundtruth = ground_truth_file(:,:,2);g_ground_truth=mean2(G_channel_groundtruth);std_g_ground_truth=std2(G_channel_groundtruth);
B_channel_groundtruth = ground_truth_file(:,:,3);b_ground_truth=mean2(B_channel_groundtruth);std_b_ground_truth=std2(B_channel_groundtruth);
R_channel_US = segmentation_file(:,:,1);r_US=mean2(R_channel_US);std_r_US=std2(R_channel_US);
G_channel_US = segmentation_file(:,:,2);g_US=mean2(G_channel_US);std_g_US=std2(G_channel_US);
B_channel_US = segmentation_file(:,:,3);b_US=mean2(B_channel_US);std_b_US=std2(B_channel_US);
for j=1:1:height
    for k=1:1:width
        if (ground_truth_file(j,k,1)> (r_ground_truth-0*std_r_ground_truth) && ground_truth_file(j,k,2)< (g_ground_truth+2*std_g_ground_truth) && ground_truth_file(j,k,3)< (b_ground_truth+2*std_b_ground_truth))
            labels_ground_truth(j,k)=1;%tumour
            tumour_ground_truth=tumour_ground_truth+1;
        elseif (ground_truth_file(j,k,1)< (r_ground_truth+2*std_r_ground_truth) && ground_truth_file(j,k,2)> (g_ground_truth-0*std_g_ground_truth) && ground_truth_file(j,k,3)< (b_ground_truth+2*std_b_ground_truth))
            labels_ground_truth(j,k)=2;
            healthy_ground_truth=healthy_ground_truth+1;
        elseif (ground_truth_file(j,k,1)< (r_ground_truth+2*std_r_ground_truth) && ground_truth_file(j,k,2)< (g_ground_truth+2*std_g_ground_truth) && ground_truth_file(j,k,3)> (b_ground_truth-0*std_g_ground_truth))
            labels_ground_truth(j,k)=3;
            others_ground_truth=others_ground_truth+1;
        else
            labels_ground_truth(j,k)=4;%empty
        end
    end
end

for jj=1:1:height
    for kk=1:1:width
        if (segmentation_file(jj,kk,1)> (r_US-0*std_r_US) && segmentation_file(jj,kk,2)< (g_US+2*std_g_US) && segmentation_file(jj,kk,3)< (b_US+2*std_b_US))
            labels_segmentation(jj,kk)=1;
            tumour_segmentation=tumour_segmentation+1;
        elseif (segmentation_file(jj,kk,1)< (r_US+2*std_r_US) && segmentation_file(jj,kk,2)> (g_US-0*std_g_US) && segmentation_file(jj,kk,3)< (b_US+2*std_b_US))
            labels_segmentation(jj,kk)=2;
            healthy_segmentation = healthy_segmentation+1;
        elseif (segmentation_file(jj,kk,1)< (r_US+2*std_r_US) && segmentation_file(jj,kk,2)< (g_US+2*std_g_US) && segmentation_file(jj,kk,3)> (b_US-0*std_b_US))
            labels_segmentation(jj,kk)=3;
            others_segmentation=others_segmentation+1;
        else
            labels_segmentation(jj,kk)=4;
        end
    end
end

%% Compare the labels at pixel level
for m=1:1:height
    for n =1:1:width
        segmentation_pixel_label = labels_segmentation(m,n);
        ground_truth_pixel_label = labels_ground_truth(m,n);
        if (ground_truth_pixel_label ==1 && segmentation_pixel_label ==1)
            GroundTruthTumour_SegmentationTumour=GroundTruthTumour_SegmentationTumour+1;
        elseif (ground_truth_pixel_label ==1 && segmentation_pixel_label ==2)
            GroundTruthTumour_SegmentationHealthy=GroundTruthTumour_SegmentationHealthy+1;
        elseif (ground_truth_pixel_label ==1 && segmentation_pixel_label ==3)
            GroundTruthTumour_SegmentationOthers=GroundTruthTumour_SegmentationOthers+1;
        elseif (ground_truth_pixel_label ==2 && segmentation_pixel_label ==1)
            GroundTruthHealthy_SegmentationTumour=GroundTruthHealthy_SegmentationTumour+1;
        elseif (ground_truth_pixel_label ==2 && segmentation_pixel_label ==2)
            GroundTruthHealthy_SegmentationHealthy=GroundTruthHealthy_SegmentationHealthy+1;
        elseif (ground_truth_pixel_label ==2 && segmentation_pixel_label ==3)
            GroundTruthHealthy_SegmentationOthers=GroundTruthHealthy_SegmentationOthers+1;
        elseif (ground_truth_pixel_label ==3 && segmentation_pixel_label ==1)
            GroundTruthOthers_SegmentationTumour=GroundTruthOthers_SegmentationTumour+1;
        elseif (ground_truth_pixel_label ==3 && segmentation_pixel_label ==2)
            GroundTruthOthers_SegmentationHealthy=GroundTruthOthers_SegmentationHealthy+1;
        elseif (ground_truth_pixel_label ==3 && segmentation_pixel_label ==3)
            GroundTruthOthers_SegmentationOthers=GroundTruthOthers_SegmentationOthers+1;
        else
            %pass
        end
    end
end

%% Visualize the labels comparisons:
comparisons_matrix_percentage = [GroundTruthTumour_SegmentationTumour/tumour_ground_truth GroundTruthTumour_SegmentationHealthy/tumour_ground_truth GroundTruthTumour_SegmentationOthers/tumour_ground_truth;GroundTruthHealthy_SegmentationTumour/healthy_ground_truth GroundTruthHealthy_SegmentationHealthy/healthy_ground_truth GroundTruthHealthy_SegmentationOthers/healthy_ground_truth;GroundTruthOthers_SegmentationTumour/others_ground_truth GroundTruthOthers_SegmentationHealthy/others_ground_truth GroundTruthOthers_SegmentationOthers/others_ground_truth];
xvalues={'Tumour','Healthy','Others'};
yvalues={'Tumour','Healthy','Others'};
f=figure;
heatmap(xvalues,yvalues,comparisons_matrix_percentage);
titlename=segmentation_file_name_noextension(1:20);
%title(titlename);
%title = segmentation_file_name_noextension;
results_folder='C:\Users\NeuroBeast\Desktop\results_stats';
heat_map_picture_name=strcat('heat map','_',segmentation_file_name_noextension,'.jpg');
heat_map_file_full=fullfile(results_folder,heat_map_picture_name);
saveas(f,heat_map_file_full);
message=strcat(segmentation_file_name_noextension,'','is processing...');
fprintf(message)
fprintf('\n\n')
%% Statistical analysis:
% tumour:
Tumour_TP=GroundTruthTumour_SegmentationTumour;
Tumour_FP=GroundTruthHealthy_SegmentationTumour+GroundTruthOthers_SegmentationTumour;
Tumour_TN=GroundTruthOthers_SegmentationOthers+GroundTruthOthers_SegmentationHealthy+GroundTruthHealthy_SegmentationHealthy+GroundTruthHealthy_SegmentationOthers;
Tumour_FN=GroundTruthTumour_SegmentationHealthy+GroundTruthTumour_SegmentationOthers;
Tumour_accuracy= (Tumour_TP+Tumour_TN)/(Tumour_TP+Tumour_TN+Tumour_FN+Tumour_TN);
Tumour_sensitivity=Tumour_TP/(Tumour_TP+Tumour_FN);
Tumour_specificity=Tumour_TN/(Tumour_TN+Tumour_FP);
TumourAccuracies(end+1)=Tumour_accuracy;
TumourSensitivities(end+1)=Tumour_sensitivity;
TumourSpecificities(end+1)=Tumour_specificity;
% healthy:
Healthy_TP=GroundTruthHealthy_SegmentationHealthy;
Healthy_FP=GroundTruthTumour_SegmentationHealthy+GroundTruthOthers_SegmentationHealthy;
Healthy_TN=GroundTruthOthers_SegmentationTumour+GroundTruthOthers_SegmentationOthers+GroundTruthTumour_SegmentationOthers+GroundTruthTumour_SegmentationTumour;
Healthy_FN=GroundTruthHealthy_SegmentationTumour+GroundTruthHealthy_SegmentationOthers;
Healthy_accuracy= (Healthy_TP+Healthy_TN)/(Healthy_TP+Healthy_TN+Healthy_FN+Healthy_TN);
Healthy_sensitivity=Healthy_TP/(Healthy_TP+Healthy_FN);
Healthy_specificity=Healthy_TN/(Healthy_TN+Healthy_FP);
HealthyAccuracies(end+1)=Healthy_accuracy;
HealthySensitivities(end+1)=Healthy_sensitivity;
HealthySpecificities(end+1)=Healthy_specificity;
% others:
Others_TP=GroundTruthOthers_SegmentationOthers;
Others_FP=GroundTruthTumour_SegmentationOthers+GroundTruthHealthy_SegmentationOthers;
Others_TN=GroundTruthTumour_SegmentationTumour+GroundTruthTumour_SegmentationHealthy+GroundTruthHealthy_SegmentationHealthy+GroundTruthHealthy_SegmentationTumour;
Others_FN=GroundTruthOthers_SegmentationTumour+GroundTruthOthers_SegmentationHealthy;
Others_accuracy= (Others_TP+Others_TN)/(Others_TP+Others_TN+Others_FN+Others_TN);
Others_sensitivity=Others_TP/(Others_TP+Others_FN);
Others_specificity=Others_TN/(Others_TN+Others_FP);
OthersAccuracies(end+1)=Others_accuracy;
OthersSensitivities(end+1)=Others_sensitivity;
OthersSpecificities(end+1)=Others_specificity;
end
%% write the table of statistical analysis into xls file:
SegmentationNames = SegmentationNames';
TumourAccuracies = TumourAccuracies';
TumourSensitivities=TumourSensitivities';
TumourSpecificities=TumourSpecificities';
HealthyAccuracies=HealthyAccuracies';
HealthySensitivities=HealthySensitivities';
HealthySpecificities=HealthySpecificities';
OthersAccuracies=OthersAccuracies';
OthersSensitivities=OthersSensitivities';
OthersSpecificities=OthersSpecificities';

T=table(SegmentationNames,TumourAccuracies,TumourSensitivities,TumourSpecificities,HealthyAccuracies,HealthySensitivities,HealthySpecificities,OthersAccuracies,OthersSensitivities,OthersSpecificities);
T_file_full=fullfile(results_folder,stats);
writetable(T,T_file_full);

disp('End')