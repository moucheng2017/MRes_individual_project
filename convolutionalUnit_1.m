function layers = convolutionalUnit_1(numF,stride,tag)
layers = [
    convolution2dLayer(3,numF,'Padding','same','Stride',stride,'Name',[tag,'conv1'])
    batchNormalizationLayer('Name',[tag,'BN1'])
    reluLayer('Name',[tag,'relu1'])
    dropoutLayer(0.4,'Name',[tag,'dropout_medium']);
    convolution2dLayer(3,numF,'Padding','same','Name',[tag,'conv2'])
    batchNormalizationLayer('Name',[tag,'BN2'])
    leakyReluLayer(0.01,'Name',[tag,'_leaky_relu2'])
    dropoutLayer(0.2,'Name',[tag,'dropout_medium_2'])];
end