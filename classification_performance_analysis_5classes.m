%performance analysis 5 classes:
clc
clear all
%% Read the segmented image and find the corresponding US image
% navigate to the folder of segmented images
fprintf('Please navigate to the folder where the segmented images are stored, be careful of the overlapping paramters.');
fprintf('\n\n');
bordertrim=20;
bordertrim_str=num2str(bordertrim);
stats = strcat('results pixel classification googlenet 20 100.xls');
%stats = strcat('results_',bordertrim_str,'overlapping googlenet 20 100.xls');
segmentation_path = uigetdir;
segmented_files = dir(fullfile(segmentation_path,'*.jpg'));
segmented_files = {segmented_files.name};
% prepare to store statistical analysis
SegmentationNames = {};
TumourAccuracies=[];
TumourSensitivities=[];
TumourSpecificities=[];
WhitematterAccuracies=[];
WhitematterSensitivities=[];
WhitematterSpecificities=[];
GreymatterAccuracies=[];
GreymatterSensitivities=[];
GreymatterSpecificities=[];
SulcusAccuracies=[];
SulcusSensitivities=[];
SulcusSpecificities=[];
OthersAccuracies=[];
OthersSensitivities=[];
OthersSpecificities=[];
%% main programme:
for i =1:1:length(segmented_files)
    segmentation_file_name = segmented_files{i};
    [filepath,segmentation_file_name_noextension,ext]=fileparts(segmentation_file_name);
    SegmentationNames =[SegmentationNames,{segmentation_file_name_noextension}];
    spaces_locations = strfind(segmentation_file_name,' ');
    first_space_location = spaces_locations(1);
    segmentation_name = segmentation_file_name(1:first_space_location-1);
    US_index = segmentation_name(14:16);
    case_index = segmentation_name(5);
    ground_truth_name=strcat('case',case_index,'_Coronal+000',US_index,'-000.jpg');
    ground_truth_folder_path = 'C:\Users\NeuroBeast\Desktop\images_high_resolution\Testing';
    ground_truth_folder = strcat('GroundTruth','_',bordertrim_str,'pixels_TrimBorder');
    ground_truth_folder_path_full = strcat(ground_truth_folder_path,'\',ground_truth_folder);
    ground_truth_file_full = fullfile(ground_truth_folder_path_full,ground_truth_name);
    segmentation_file = imread(fullfile(segmentation_path,segmentation_file_name));
    [height,width,dim]=size(segmentation_file);
    ground_truth_file = imread(ground_truth_file_full);
    %% Prepare empty folders to store results
    % tumour:
    Tumour_ground_truth=0;
    tumour_segmentation=0;
    GroundTruthTumour_SegmentationTumour=0;%ground_truth first, segmentation second
    GroundTruthTumour_SegmentationWhitematter=0;
    GroundTruthTumour_SegmentationOthers=0;
    GroundTruthTumour_SegmentationSulcus=0;
    GroundTruthTumour_SegmentationGreymatter=0;
    % whitematter:
    Whitematter_ground_truth=0;
    Whitematter_segmentation=0;
    GroundTruthWhitematter_SegmentationTumour=0;
    GroundTruthWhitematter_SegmentationGreymatter=0;
    GroundTruthWhitematter_SegmentationOthers=0;
    GroundTruthWhitematter_SegmentationWhitematter=0;
    GroundTruthWhitematter_SegmentationSulcus=0;
    % Greymatter:
    Greymatter_ground_truth=0;
    Greymatter_segmentation=0;
    GroundTruthGreymatter_SegmentationTumour=0;
    GroundTruthGreymatter_SegmentationWhitematter=0;
    GroundTruthGreymatter_SegmentationOthers=0;
    GroundTruthGreymatter_SegmentationGreymatter=0;
    GroundTruthGreymatter_SegmentationSulcus=0;
    % Sulcus:
    Sulcus_ground_truth=0;
    Sulcus_segmentation=0;
    GroundTruthSulcus_SegmentationTumour=0;
    GroundTruthSulcus_SegmentationWhitematter=0;
    GroundTruthSulcus_SegmentationOthers=0;
    GroundTruthSulcus_SegmentationGreymatter=0;
    GroundTruthSulcus_SegmentationSulcus=0;
    % others:
    Others_ground_truth=0;
    others_segmentation=0;
    GroundTruthOthers_SegmentationOthers=0;
    GroundTruthOthers_SegmentationWhitematter=0;
    GroundTruthOthers_SegmentationGreymatter=0;
    GroundTruthOthers_SegmentationTumour=0;
    GroundTruthOthers_SegmentationSulcus=0;
    %% Create labels maps of US image and ground truth image:
    % 1: greymatter 2: whitematter; 3: sulcus 4:tumour 5:others
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
            %grey matter
            if (ground_truth_file(j,k,1)< (r_ground_truth+0.5*std_r_ground_truth) && ground_truth_file(j,k,2)> (g_ground_truth-1*std_g_ground_truth) && ground_truth_file(j,k,3)> (b_ground_truth+0*std_b_ground_truth))
                labels_ground_truth(j,k)=1;
                Greymatter_ground_truth=Greymatter_ground_truth+1;
            %white matter
            elseif (ground_truth_file(j,k,1)> (r_ground_truth-0.2*std_r_ground_truth) && ground_truth_file(j,k,2)< (g_ground_truth+0.6*std_g_ground_truth) && ground_truth_file(j,k,3)< (b_ground_truth+0*std_b_ground_truth))
                labels_ground_truth(j,k)=2;
                Whitematter_ground_truth=Whitematter_ground_truth+1;
            %sulcus
            elseif (ground_truth_file(j,k,1)> (r_ground_truth+0.5*std_r_ground_truth) && ground_truth_file(j,k,2)> (g_ground_truth+0.3*std_g_ground_truth) && ground_truth_file(j,k,3) < (b_ground_truth+0.5*std_b_ground_truth))
                labels_ground_truth(j,k)=3;
                Sulcus_ground_truth=Sulcus_ground_truth+1;
            %tumour
            elseif (ground_truth_file(j,k,1)< (r_ground_truth-0*std_r_ground_truth) && ground_truth_file(j,k,2)> (g_ground_truth+0*std_g_ground_truth) && ground_truth_file(j,k,3) < (b_ground_truth+0*std_b_ground_truth))
                labels_ground_truth(j,k)=4;
                Tumour_ground_truth=Tumour_ground_truth+1;            
            %others
            else
                labels_ground_truth(j,k)=5;
                Others_ground_truth=Others_ground_truth+1; 
            end
        end
    end

    for jj=1:1:height
        for kk=1:1:width
            % greymatter
            if (segmentation_file(jj,kk,1)< (r_US+0.5*std_r_US) && segmentation_file(jj,kk,2)> (g_US-1*std_g_US) && segmentation_file(jj,kk,3)> (b_US+0*std_b_US))
                labels_segmentation(jj,kk)=1;
                Greymatter_segmentation=Greymatter_segmentation+1;
            % whitematter
            elseif (segmentation_file(jj,kk,1)> (r_US-0.2*std_r_US) && segmentation_file(jj,kk,2) < (g_US+0.6*std_g_US) && segmentation_file(jj,kk,3)< (b_US+0*std_b_US))
                labels_segmentation(jj,kk)=2;
                Whitematter_segmentation = Whitematter_segmentation+1;
            % sulcus
            elseif (segmentation_file(jj,kk,1)> (r_US+0.5*std_r_US) && segmentation_file(jj,kk,2)> (g_US+0.3*std_g_US) && segmentation_file(jj,kk,3)< (b_US+0.5*std_b_US))
                labels_segmentation(jj,kk)=3;
                Sulcus_segmentation=Sulcus_segmentation+1;
            % tumour
            elseif (segmentation_file(j,k,1)< (r_US-0*std_r_US) && segmentation_file(j,k,2)> (g_US+0*std_g_US) && segmentation_file(j,k,3) < (b_US+0*std_b_US))
                labels_segmentation(jj,kk)=4;
                Tumour_segmentation=Tumour_segmentation+1;                
            % others
            else
                labels_segmentation(jj,kk)=5;
                Others_segmentation=Others_segmentation+1;                  
            end
        end
    end

    %% Compare the labels at pixel level
    for m=1:1:height
        for n =1:1:width
            segmentation_pixel_label = labels_segmentation(m,n);
            ground_truth_pixel_label = labels_ground_truth(m,n);
            % ground truth greymatter
            if (ground_truth_pixel_label ==1 && segmentation_pixel_label ==1)
                GroundTruthGreymatter_SegmentationGreymatter=GroundTruthGreymatter_SegmentationGreymatter+1;
            elseif (ground_truth_pixel_label ==1 && segmentation_pixel_label ==2)
                GroundTruthGreymatter_SegmentationWhitematter=GroundTruthGreymatter_SegmentationWhitematter+1;
            elseif (ground_truth_pixel_label ==1 && segmentation_pixel_label ==3)
                GroundTruthGreymatter_SegmentationSulcus=GroundTruthGreymatter_SegmentationSulcus+1;
            elseif (ground_truth_pixel_label ==1 && segmentation_pixel_label ==4)
                GroundTruthGreymatter_SegmentationTumour=GroundTruthGreymatter_SegmentationTumour+1;
            elseif (ground_truth_pixel_label ==1 && segmentation_pixel_label ==5)
                GroundTruthGreymatter_SegmentationOthers=GroundTruthGreymatter_SegmentationOthers+1;  
            % ground truth whitematter
            elseif (ground_truth_pixel_label ==2 && segmentation_pixel_label ==1)
                GroundTruthWhitematter_SegmentationGreymatter=GroundTruthWhitematter_SegmentationGreymatter+1;
            elseif (ground_truth_pixel_label ==2 && segmentation_pixel_label ==2)
                GroundTruthWhitematter_SegmentationWhitematter=GroundTruthWhitematter_SegmentationWhitematter+1;
            elseif (ground_truth_pixel_label ==2 && segmentation_pixel_label ==3)
                GroundTruthWhitematter_SegmentationSulcus=GroundTruthWhitematter_SegmentationSulcus+1;
            elseif (ground_truth_pixel_label ==2 && segmentation_pixel_label ==4)
                GroundTruthWhitematter_SegmentationTumour=GroundTruthWhitematter_SegmentationTumour+1;
            elseif (ground_truth_pixel_label ==2 && segmentation_pixel_label ==5)
                GroundTruthWhitematter_SegmentationOthers=GroundTruthWhitematter_SegmentationOthers+1;
            % ground truth sulcus
            elseif (ground_truth_pixel_label ==3 && segmentation_pixel_label ==1)
                GroundTruthSulcus_SegmentationGreymatter=GroundTruthSulcus_SegmentationGreymatter+1;
            elseif (ground_truth_pixel_label ==3 && segmentation_pixel_label ==2)
                GroundTruthSulcus_SegmentationWhitematter=GroundTruthSulcus_SegmentationWhitematter+1;
            elseif (ground_truth_pixel_label ==3 && segmentation_pixel_label ==3)
                GroundTruthSulcus_SegmentationSulcus=GroundTruthSulcus_SegmentationSulcus+1;
            elseif (ground_truth_pixel_label ==3 && segmentation_pixel_label ==4)
                GroundTruthSulcus_SegmentationTumour=GroundTruthSulcus_SegmentationTumour+1;
            elseif (ground_truth_pixel_label ==3 && segmentation_pixel_label ==5)
                GroundTruthSulcus_SegmentationOthers=GroundTruthSulcus_SegmentationOthers+1;
            % ground truth tumour
            elseif (ground_truth_pixel_label ==4 && segmentation_pixel_label ==1)
                GroundTruthTumour_SegmentationGreymatter=GroundTruthTumour_SegmentationGreymatter+1;
            elseif (ground_truth_pixel_label ==4 && segmentation_pixel_label ==2)
                GroundTruthTumour_SegmentationWhitematter=GroundTruthTumour_SegmentationWhitematter+1;
            elseif (ground_truth_pixel_label ==4 && segmentation_pixel_label ==3)
                GroundTruthTumour_SegmentationSulcus=GroundTruthTumour_SegmentationSulcus+1;
            elseif (ground_truth_pixel_label ==4 && segmentation_pixel_label ==4)
                GroundTruthTumour_SegmentationTumour=GroundTruthTumour_SegmentationTumour+1;
            elseif (ground_truth_pixel_label ==4 && segmentation_pixel_label ==5)
                GroundTruthTumour_SegmentationOthers=GroundTruthTumour_SegmentationOthers+1;            
            % ground truth others
            elseif (ground_truth_pixel_label ==5 && segmentation_pixel_label ==1)
                GroundTruthOthers_SegmentationGreymatter=GroundTruthOthers_SegmentationGreymatter+1;
            elseif (ground_truth_pixel_label ==5 && segmentation_pixel_label ==2)
                GroundTruthOthers_SegmentationWhitematter=GroundTruthOthers_SegmentationWhitematter+1;
            elseif (ground_truth_pixel_label ==5 && segmentation_pixel_label ==3)
                GroundTruthOthers_SegmentationSulcus=GroundTruthOthers_SegmentationSulcus+1;
            elseif (ground_truth_pixel_label ==5 && segmentation_pixel_label ==4)
                GroundTruthOthers_SegmentationTumour=GroundTruthOthers_SegmentationTumour+1;
            elseif (ground_truth_pixel_label ==5 && segmentation_pixel_label ==5)
                GroundTruthOthers_SegmentationOthers=GroundTruthOthers_SegmentationOthers+1;            
            else
                %pass
            end
        end
    end

    %% Visualize the labels comparisons:
    comparisons_matrix_percentage = [GroundTruthTumour_SegmentationTumour/Tumour_ground_truth GroundTruthTumour_SegmentationWhitematter/Tumour_ground_truth GroundTruthTumour_SegmentationGreymatter/Tumour_ground_truth GroundTruthTumour_SegmentationSulcus/Tumour_ground_truth GroundTruthTumour_SegmentationOthers/Tumour_ground_truth;...
        GroundTruthWhitematter_SegmentationTumour/Whitematter_ground_truth GroundTruthWhitematter_SegmentationWhitematter/Whitematter_ground_truth GroundTruthWhitematter_SegmentationGreymatter/Whitematter_ground_truth GroundTruthWhitematter_SegmentationSulcus/Whitematter_ground_truth GroundTruthWhitematter_SegmentationOthers/Whitematter_ground_truth;...
        GroundTruthGreymatter_SegmentationTumour/Greymatter_ground_truth GroundTruthGreymatter_SegmentationWhitematter/Greymatter_ground_truth GroundTruthGreymatter_SegmentationGreymatter/Greymatter_ground_truth GroundTruthGreymatter_SegmentationSulcus/Greymatter_ground_truth GroundTruthGreymatter_SegmentationOthers/Greymatter_ground_truth;...
        GroundTruthSulcus_SegmentationTumour/Sulcus_ground_truth GroundTruthSulcus_SegmentationWhitematter/Sulcus_ground_truth GroundTruthSulcus_SegmentationGreymatter/Sulcus_ground_truth GroundTruthSulcus_SegmentationSulcus/Sulcus_ground_truth GroundTruthSulcus_SegmentationOthers/Sulcus_ground_truth;...   
        GroundTruthOthers_SegmentationTumour/Others_ground_truth GroundTruthOthers_SegmentationWhitematter/Others_ground_truth GroundTruthOthers_SegmentationGreymatter/Others_ground_truth GroundTruthOthers_SegmentationSulcus/Others_ground_truth GroundTruthOthers_SegmentationOthers/Others_ground_truth];
    xvalues={'Tumour','Whitematter','Greymatter','Sulcus','Others'};
    yvalues={'Tumour','Whitematter','Greymatter','Sulcus','Others'};
    f=figure;
    heatmap(xvalues,yvalues,comparisons_matrix_percentage);
    h.Title = segmentation_file_name_noextension;
    results_folder='C:\Users\NeuroBeast\Desktop\segmentation case1\statistical analysis';
    heat_map_picture_name=strcat(segmentation_file_name_noextension,' case1 5 classes ','.jpg');
    heat_map_file_full=fullfile(results_folder,heat_map_picture_name);
    saveas(f,heat_map_file_full);
    message=strcat(segmentation_file_name_noextension,'','is processing...');
    fprintf(message)
    fprintf('\n\n')
    %% Statistical analysis:
    %{
    % tumour:
    Tumour_TP=GroundTruthTumour_SegmentationTumour;
    Tumour_FP=GroundTruthWhitematter_SegmentationTumour+GroundTruthOthers_SegmentationTumour;
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
    Healthy_FN=GroundTruthWhitematter_SegmentationTumour+GroundTruthHealthy_SegmentationOthers;
    Healthy_accuracy= (Healthy_TP+Healthy_TN)/(Healthy_TP+Healthy_TN+Healthy_FN+Healthy_TN);
    Healthy_sensitivity=Healthy_TP/(Healthy_TP+Healthy_FN);
    Healthy_specificity=Healthy_TN/(Healthy_TN+Healthy_FP);
    HealthyAccuracies(end+1)=Healthy_accuracy;
    HealthySensitivities(end+1)=Healthy_sensitivity;
    HealthySpecificities(end+1)=Healthy_specificity;
    % others:
    Others_TP=GroundTruthOthers_SegmentationOthers;
    Others_FP=GroundTruthTumour_SegmentationOthers+GroundTruthHealthy_SegmentationOthers;
    Others_TN=GroundTruthTumour_SegmentationTumour+GroundTruthTumour_SegmentationHealthy+GroundTruthHealthy_SegmentationHealthy+GroundTruthWhitematter_SegmentationTumour;
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
%}
disp('End')