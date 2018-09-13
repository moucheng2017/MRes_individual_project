% compare training
clc
clear all
% create stitched segmented images
% load net
model_folder= 'C:\Users\NeuroBeast\Desktop\comparison\skip connection in encoder or decoder\fb 2';
addpath(model_folder);
model_name_mat1 = 'resnet8_Unet_v1_attention_v1_4_new_new_netwidth48_fb_2_1.mat';
model_name_mat2 = 'resnet8_Unet_v2_attention_v1_4_new_new_netwidth48_fb_2_1.mat';
% model_name_mat3 = '5 Unet_w48__netwidth48_1.mat';
% model_name_mat4 = '5 Unet_w64__netwidth64_1.mat';
% model_name_mat5=  '5 Unet_w96__netwidth96_1.mat';
% model_name_mat6 = '5_stages_Unet_netwidth16_2.mat';
% model_name_mat7 = '5_stages_Unet_netwidth32_2.mat';
% model_name_mat8=  '5_stages_Unet_netwidth48_2.mat';
% model_name_mat9=  '5_stages_Unet_netwidth64_2.mat';
% model_name_mat10 = '5_stages_Unet_netwidth96_2.mat';
% model_name_mat11 = 'resnet8_Unet_v1_attention_v1_5_new_new_netwidth48_fb_1_2.mat';
% model_name_mat12 = 'resnet8_Unet_v1_attention_v1_5_new_new_netwidth48_fb_1_3.mat';
%[f_model,model_name,ext_model]=fileparts(model_name_mat);
%mkdir('C:\Users\NeuroBeast\Desktop\results 20180822',model_name);
model_file1=fullfile(model_folder,model_name_mat1);
network1=load (model_file1);
model_file2=fullfile(model_folder,model_name_mat2);
network2=load (model_file2);
% model_file3=fullfile(model_folder,model_name_mat3);
% network3=load (model_file3);
% model_file4=fullfile(model_folder,model_name_mat4);
% network4=load (model_file4);
% model_file5=fullfile(model_folder,model_name_mat5);
% network5=load (model_file5);
% model_file6=fullfile(model_folder,model_name_mat6);
% network6=load (model_file6);
% model_file7=fullfile(model_folder,model_name_mat7);
% network7=load (model_file7);
% model_file8=fullfile(model_folder,model_name_mat2);
% network8=load (model_file8);
% model_file9=fullfile(model_folder,model_name_mat9);
% network9=load (model_file9);
% model_file10=fullfile(model_folder,model_name_mat10);
% network10=load (model_file10);
% model_file11=fullfile(model_folder,model_name_mat11);
% network11=load (model_file11);
% model_file12=fullfile(model_folder,model_name_mat12);
% network12=load (model_file12);
%
information_1=network1.infor;
validation1_accuracy=information_1.ValidationAccuracy;
%
information_2=network2.infor;
validation2_accuracy=information_2.ValidationAccuracy;
%
% information_3=network3.infor;
% validation3_accuracy=information_3.ValidationAccuracy;
% %
% information_4=network4.infor;
% validation4_accuracy=information_4.ValidationAccuracy;
% % 
% information_5=network5.infor;
% validation5_accuracy=information_5.ValidationAccuracy;
% %
% information_6=network6.infor;
% validation6_accuracy=information_6.ValidationAccuracy;
% %
% information_7=network7.infor;
% validation7_accuracy=information_7.ValidationAccuracy;
% %
% information_8=network8.infor;
% validation8_accuracy=information_8.ValidationAccuracy;
% %
% information_9=network9.infor;
% validation9_accuracy=information_9.ValidationAccuracy;
% %
% information_10=network10.infor;
% validation10_accuracy=information_10.ValidationAccuracy;
% % 
% information_11=network11.infor;
% validation11_accuracy=information_11.ValidationAccuracy;
% %
% information_12=network12.infor;
% validation12_accuracy=information_12.ValidationAccuracy;
%
% average1=(validation1_accuracy+validation6_accuracy)./2;
% average2=(validation2_accuracy+validation7_accuracy)./2;
% average3=(validation3_accuracy+validation8_accuracy)./2;
% average4=(validation4_accuracy+validation9_accuracy)./2;
% average5=(validation5_accuracy+validation10_accuracy)./2;
f=figure;
smooth_index=0.001;
p1=plot(smooth(validation1_accuracy,smooth_index),'LineWidth',1.5,'Color','r');
hold on
p2=plot(smooth(validation2_accuracy,smooth_index),'LineWidth',1.5,'Color','b');
% p3=plot(smooth(validation3_accuracy,smooth_index),'LineWidth',1.5,'Color','g');
% p4=plot(smooth(validation4_accuracy,smooth_index),'LineWidth',1.5,'Color','y');
% p5=plot(smooth(validation10_accuracy,smooth_index),'LineWidth',1.5,'Color','m');
%p6=plot(smooth(validation10_accuracy,smooth_index),'LineWidth',1.5,'Color','k');
hold off
%ylim([70 90]);
xlim([5000 6500]);
leg=legend([p1 p2],{'beta=2, encoder','beta=2, encoder and decoder'});
leg.Location = 'south';
set(leg,'units','normalized');
%set(leg,'position','best');
figurename='Effect of added skip connections in decoder, beta = 2';
xlabel('Training iterations');
ylabel('Validation accuracy');
title(figurename);
figurenamefull=strcat(figurename,'.png');
saving_folder=model_folder;
figuresavename=fullfile(saving_folder,figurenamefull);
saveas(f,figuresavename);
disp('end')