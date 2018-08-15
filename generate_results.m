% results generation
modelsfolder='C:\Users\NeuroBeast\Desktop\sliding_window_method\trained models\20180801';
all_models = dir(fullfile(modelsfolder,'\*.mat'));
all_models = {all_models.name}';
for i =1:length(all_models)
    model_name=all_models{i};
    [name]=semantic_segmentation(model_name);
end
