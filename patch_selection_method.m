clc
clear all
%% vgg16net:
net = vgg16;
layers = net.Layers;
layers(1)=imageInputLayer([224 224 3],'Name','inputlayer','Normalization','none');
layers(3)=leakyReluLayer(0.1,'Name','leaky_relu_1');
layers(5)=leakyReluLayer(0.1,'Name','leaky_relu_2');
layers(8)=leakyReluLayer(0.1,'Name','leaky_relu_3');
layers(10)=leakyReluLayer(0.1,'Name','leaky_relu_4');
layers(13)=leakyReluLayer(0.1,'Name','leaky_relu_5');
layers(15)=leakyReluLayer(0.1,'Name','leaky_relu_6');
layers(17)=leakyReluLayer(0.1,'Name','leaky_relu_7');
layers(20)=leakyReluLayer(0.1,'Name','leaky_relu_8');
layers(22)=leakyReluLayer(0.1,'Name','leaky_relu_9');
layers(24)=leakyReluLayer(0.1,'Name','leaky_relu_10');
layers(27)=leakyReluLayer(0.1,'Name','leaky_relu_11');
layers(29)=leakyReluLayer(0.1,'Name','leaky_relu_12');
layers(31)=leakyReluLayer(0.1,'Name','leaky_relu_13');
layers(34)=leakyReluLayer(0.1,'Name','leaky_relu_14');
layers = layers(1:39);
neuralnet = [
    layers
    dropoutLayer(0.5,'Name','new_dropout')
    fullyConnectedLayer(3,'Name','new_fc','WeightLearnRateFactor',10,'BiasLearnRateFactor',10)
    softmaxLayer('Name','softmax')
    classificationLayer('Name','classoutput')
    ];
%% variables for optimization:
%{
var1 = optimizableVariable('alpha_healthy',[-2 2]);
var2 = optimizableVariable('alpha_others',[-2 2]);
optimvars=[var1,var2];
%}
%% 
training_data_total = imageDatastore(training_folder,'IncludeSubfolders',true,'LabelSource','foldernames');