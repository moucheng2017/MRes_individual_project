netWidth = 64;
layers = [
    imageInputLayer([30 30 3],'Name','input')
    reluLayer('Name','reluInp')
    batchNormalizationLayer('Name','BNInp')
    convolution2dLayer(3,netWidth,'Padding','same','Name','convInp')
   
    convolutionalUnit(netWidth,1,'S1U1',0.3,'ReluNormCon')
    additionLayer(2,'Name','add11')
    reluLayer('Name','relu11')
    convolutionalUnit(netWidth,1,'S1U2',0.3,'ReluNormCon')
    additionLayer(2,'Name','add12')
    
    convolutionalUnit(2*netWidth,2,'S2U1',0.4,'ReluNormCon')
    additionLayer(2,'Name','add21')
    reluLayer('Name','relu21')
    convolutionalUnit(2*netWidth,1,'S2U2',0.4,'ReluNormCon')
    additionLayer(2,'Name','add22')

    
    convolutionalUnit(4*netWidth,2,'S3U1',0.5,'ReluNormCon')
    additionLayer(2,'Name','add31')
    reluLayer('Name','relu31')
    convolutionalUnit(4*netWidth,1,'S3U2',0.5,'ReluNormCon')
    additionLayer(2,'Name','add32')

    
    averagePooling2dLayer(8,'Name','globalPool')
    dropoutLayer(0.5,'Name','dropout_fcl')
    fullyConnectedLayer(100,'Name','fcFinal_1')
    fullyConnectedLayer(10,'Name','fcFinal_2')
    fullyConnectedLayer(3,'Name','fcFinal_3')
    softmaxLayer('Name','softmax')
    classificationLayer('Name','classoutput')
    ];
lgraph = layerGraph(layers);
lgraph = connectLayers(lgraph,'convInp','add11/in2');
lgraph = connectLayers(lgraph,'add11','add12/in2');
skip1 = [
    convolution2dLayer(1,2*netWidth,'Stride',2,'Name','skipConv1')
    batchNormalizationLayer('Name','skipBN1')];
lgraph = addLayers(lgraph,skip1);
lgraph = connectLayers(lgraph,'add12','skipConv1');
lgraph = connectLayers(lgraph,'skipBN1','add21/in2');
lgraph = connectLayers(lgraph,'add21','add22/in2');
skip2 = [
    convolution2dLayer(1,4*netWidth,'Stride',2,'Name','skipConv2')
    batchNormalizationLayer('Name','skipBN2')];
lgraph = addLayers(lgraph,skip2);
lgraph = connectLayers(lgraph,'add22','skipConv2');
lgraph = connectLayers(lgraph,'skipBN2','add31/in2');
lgraph = connectLayers(lgraph,'add31','add32/in2');
analyzeNetwork(lgraph);