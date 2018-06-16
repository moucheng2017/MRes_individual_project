clc
clear all
%% alexnet:
net = alexnet;
layers = net.Layers;
layers(1)=imageInputLayer([227 227 3],'Name','inputlayer','Normalization','none');
layers(3)=leakyReluLayer(0.1,'Name','leaky_relu_1');
layers(7)=leakyReluLayer(0.1,'Name','leaky_relu_2');
layers(11)=leakyReluLayer(0.1,'Name','leaky_relu_3');
layers(13)=leakyReluLayer(0.1,'Name','leaky_relu_4');
layers(15)=leakyReluLayer(0.1,'Name','leaky_relu_5');
layers(18)=leakyReluLayer(0.1,'Name','leaky_relu_6');
layers(21)=leakyReluLayer(0.1,'Name','leaky_relu_7');
layers = layers(1:23);
neuralnet = [
    layers
    leakyReluLayer(0.1,'Name','leaky_relu_8')
    dropoutLayer(0.5,'Name','new_dropout')
    fullyConnectedLayer(3,'Name','new_fc','WeightLearnRateFactor',20,'BiasLearnRateFactor',20)
    softmaxLayer('Name','softmax')
    classificationLayer('Name','classoutput')
    ];
%% variables for optimization:
var1 = optimizableVariable('alpha_healthy',[-3 3]);
var2 = optimizableVariable('alpha_others',[-3 3]);
optimvars=[var1,var2];
%%
