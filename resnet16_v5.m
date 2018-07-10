function lgraph=resnet16_v5(netWidth)
% fcl
%netWidth=16;
layers = [
    imageInputLayer([32 32 3],'Name','input')
    batchNormalizationLayer('Name','BNInp')
    reluLayer('Name','reluInp')
    convolution2dLayer(3,netWidth,'Padding','same','Name','convInp')
   
    convolutionalUnit(netWidth,1,'S1U1',0.3,'NormReluCon')
    additionLayer(2,'Name','add11')
    reluLayer('Name','relu11')
    dropoutLayer(0.3,'Name','dropout11');
    convolutionalUnit(netWidth,1,'S1U2',0.3,'NormReluCon')
    additionLayer(2,'Name','add12')
    reluLayer('Name','relu12')
    dropoutLayer(0.3,'Name','dropout12');
    
    convolutionalUnit(2*netWidth,2,'S2U1',0.4,'NormReluCon')
    additionLayer(2,'Name','add21')
    reluLayer('Name','relu21')
    dropoutLayer(0.4,'Name','dropout21');    
    convolutionalUnit(2*netWidth,1,'S2U2',0.4,'NormReluCon')
    additionLayer(2,'Name','add22')
    reluLayer('Name','relu22')
    dropoutLayer(0.4,'Name','dropout22');
    
    convolutionalUnit(4*netWidth,2,'S3U1',0.5,'NormReluCon')
    additionLayer(2,'Name','add31')
    reluLayer('Name','relu31')
    dropoutLayer(0.5,'Name','dropout31');
    convolutionalUnit(4*netWidth,1,'S3U2',0.5,'NormReluCon')
    additionLayer(2,'Name','add32')
    reluLayer('Name','relu32')
    dropoutLayer(0.5,'Name','dropout32');
    
    %averagePooling2dLayer(8,'Name','globalPool')
    fullyConnectedLayer(100,'Name','fcFinal_1')
    dropoutLayer(0.5,'Name','dropout_fcl_1')
    fullyConnectedLayer(100,'Name','fcFinal_2')
    dropoutLayer(0.5,'Name','dropout_fcl_2')
    fullyConnectedLayer(3,'Name','fcFinal_4')
    softmaxLayer('Name','softmax')
    classificationLayer('Name','classoutput')
    ];
lgraph = layerGraph(layers);
lgraph = connectLayers(lgraph,'convInp','add11/in2');
lgraph = connectLayers(lgraph,'dropout11','add12/in2');
skip1 = [
    convolution2dLayer(1,2*netWidth,'Stride',2,'Name','skipConv1')
    batchNormalizationLayer('Name','skipBN1')];
lgraph = addLayers(lgraph,skip1);
lgraph = connectLayers(lgraph,'dropout12','skipConv1');
lgraph = connectLayers(lgraph,'skipBN1','add21/in2');
lgraph = connectLayers(lgraph,'dropout21','add22/in2');
skip2 = [
    convolution2dLayer(1,4*netWidth,'Stride',2,'Name','skipConv2')
    batchNormalizationLayer('Name','skipBN2')];
lgraph = addLayers(lgraph,skip2);
lgraph = connectLayers(lgraph,'dropout22','skipConv2');
lgraph = connectLayers(lgraph,'skipBN2','add31/in2');
lgraph = connectLayers(lgraph,'dropout31','add32/in2');
%analyzeNetwork(lgraph);
end