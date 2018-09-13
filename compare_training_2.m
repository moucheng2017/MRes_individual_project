% compare training
clc
clear all
% create stitched segmented images
% load net
% change here:
groups=2;
smooth_index = 0.001;
model_folder= 'C:\Users\NeuroBeast\Desktop\comparison\mixed_before_relu_or_after\4';
%
addpath(model_folder);
all_models = dir(fullfile(model_folder,'\*.mat'));
all_models = {all_models.name}';
number_models=length(all_models);
all_plots = [];
f = figure;
for i =1:groups
    if i ==1
    model_1 = all_models{1};
    model_2 = all_models{2};
    model_3 = all_models{3};
    %
    model_file1=fullfile(model_folder,model_1);
    network1=load (model_file1);
    model_file2=fullfile(model_folder,model_2);
    network2=load (model_file2);
    model_file3=fullfile(model_folder,model_3);
    network3=load (model_file3);
    %
    information_1=network1.infor;
    validation1_accuracy=information_1.ValidationAccuracy;
    %
    information_2=network2.infor;
    validation2_accuracy=information_2.ValidationAccuracy;
    %
    information_3=network3.infor;
    validation3_accuracy=information_3.ValidationAccuracy;
    average = (validation1_accuracy+validation2_accuracy+validation3_accuracy)./3;  
    else
    index_1 = (i-1).*3+1; 
    index_2 = (i-1).*3+2; 
    index_3 = (i-1).*3+3;
    model_1 = all_models{index_1};
    model_2 = all_models{index_2};
    model_3 = all_models{index_3};
    model_file1=fullfile(model_folder,model_1);
    network1=load (model_file1);
    model_file2=fullfile(model_folder,model_2);
    network2=load (model_file2);
    model_file3=fullfile(model_folder,model_3);
    network3=load (model_file3);
    information_1=network1.infor;
    validation1_accuracy=information_1.ValidationAccuracy;
    %
    information_2=network2.infor;
    validation2_accuracy=information_2.ValidationAccuracy;
    %
    information_3=network3.infor;
    validation3_accuracy=information_3.ValidationAccuracy;
    average = (validation1_accuracy+validation2_accuracy+validation3_accuracy)./3;
    end

    switch i
        case 1
            colour ='r';
        case 2
            colour ='b';
        case 3
            colour ='g';
        case 4
            colour ='y';
        case 5
            colour ='m';
        case 6
            colour ='k';
    end
    p = plot (smooth(average,smooth_index),'LineWidth',1.5,'Color',colour);
    hold on
    all_plots(end+1)=p;
    fprintf('processing...')
    fprintf('\n\n');  
end
hold off
%ylim([70 90]);
xlim([5000 6500]);
leg=legend(all_plots,{'Res-U-net with 4 after-relu mixed attention modules','Res-U-net with 4 pre-relu mixed attention modules'});
leg.Location = 'south';
set(leg,'units','normalized');
figurename='Comparision between pre-relu and after-relu attention in Res-U-net (4 attention modules)';
xlabel('Training iterations');
ylabel('Validation accuracy');
title(figurename);
figurenamefull=strcat(figurename,'.png');
saving_folder=model_folder;
figuresavename=fullfile(saving_folder,figurenamefull);
saveas(f,figuresavename);
disp('end')
