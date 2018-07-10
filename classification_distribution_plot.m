% plot distribution of classification results of patches
clc
clear all
model_folder= '../trained models/11062018';
addpath(model_folder);
model_name = 'Googlenet_case1_20_80_50%sliding_high_intensity.mat';
model_file=fullfile(model_folder,model_name);
load (model_file);
neural_net = googlenetUS;
% prepare the empty 
score_tumour=[];
score_healthy=[];
score_others=[];
entropies=[];
pred_tumour=0;
pred_healthy=0;
pred_others=0;
amount_e_abovethreshold=0;
%read images and classify
type=' easy';
foldernanme=strcat('case1video1',type,' healthy patches testing');
patches_folder =strcat('C:\Users\NeuroBeast\Desktop\',foldernanme,'\Healthy');
allpatches=dir(fullfile(patches_folder,'*.jpg'));
allpatches={allpatches.name};
for i =1:length(allpatches)
    patchname=allpatches{i};
    img_file=fullfile(patches_folder,patchname);
    img=imread(img_file);
    [pred,score] = classify(neural_net,img);
    score_tumour(end+1) = score(3); 
    score_healthy(end+1) = score(1); 
    score_others(end+1) = score(2); 
    %e=score(3)+score(2);
    %e=-(1*(1-score(1))*(log(score(1))));
    e=-(score(3)*log2(score(3))+score(2)*log2(score(2))+(score(1))*log2(score(1)));
    if (e > 0)
        uncertainty = e;
        amount_e_abovethreshold=amount_e_abovethreshold+1;
    else
        uncertainty = 0;
    end 
    
    %uncertainty=-(score(3)*(log(3)/log(score(3)))+score(2)*(log(3)/log(score(2)))+score(1)*(log(3)/log(score(1))));
    entropies(end+1) = uncertainty; 
    if pred == 'Tumour' 
        fprintf('patch tumour is processing...');
        pred_tumour=pred_tumour+1;
    elseif pred == 'Healthy'
        fprintf('patch healthy is processing...');
        pred_healthy=pred_healthy+1;
    elseif pred == 'Others'
        fprintf('patch others is processing...');
        pred_others=pred_others+1;
    end  
    fprintf('\n\n');
end

%{
f1=figure;
histogram(score_tumour,10)
tumour_tilte = strcat('histogram of tumour scores',' ',type,'.jpg');
title(tumour_tilte)
saveas(f1,tumour_tilte);
f2=figure;
histogram(score_healthy,10);
healthy_tilte = strcat('histogram of healthy scores',' ',type,'.jpg');
title(healthy_tilte)
saveas(f2,healthy_tilte);
f3=figure;
histogram(score_others,10)
others_tilte = strcat('histogram of others scores',' ',type,'.jpg');
title(others_tilte)
saveas(f3,others_tilte);
%}
f4=figure;
histogram(entropies,10)
entropy_tilte = strcat('histogram of entropies',' ',type,'.jpg');
title(entropy_tilte)
saveas(f4,entropy_tilte);
ratio=100*amount_e_abovethreshold/length(entropies);
fprintf('%d out of %d entropies are above the threshold, %d percentage',amount_e_abovethreshold,length(entropies),ratio);
disp('End')