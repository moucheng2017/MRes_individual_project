function [layers,networkname]=resnet12_Unet_new(classes,netWidth,height,width,beta)
% 5 stages downsampling
% pre-activation residual blocks
networkname='resnet12_Unet_new';
% residual 18 
%classes=2;
%netWidth=32;
layers = [
    imageInputLayer([height width 3],'Name','input','Normalization','None')
    convolution2dLayer(3,netWidth,'Padding','same','Stride',1,'Name','convInp')
    %encoder s1
    residual_block(netWidth,'s1u1',1)
    residual_block(netWidth,'s1u2',0)
    %encoder s2
    residual_block(netWidth*2,'s2u1',1)
    residual_block(netWidth*2,'s2u2',0)
    %encoder s3
    residual_block(netWidth*4,'s3u1',1)
    residual_block(netWidth*4,'s3u2',0)   
    %encoder s4
    residual_block(netWidth*8,'s4u1',1)
    residual_block(netWidth*8,'s4u2',0) 
    % bridge
    maxPooling2dLayer(2,'Stride',2,'Padding',[0 0 0 0],'Name','bridge_maxpooling')
    batchNormalizationLayer('Name','bridge_BN1')  
    reluLayer('Name','bridge_relu1')
    convolution2dLayer(3,netWidth*16,'Padding','same','Stride',1,'Name','bridge_conv1')
    batchNormalizationLayer('Name','bridge_BN2')  
    reluLayer('Name','bridge_relu2')
    dropoutLayer(0.5,'Name','bridge_dropout1')
    convolution2dLayer(3,netWidth*16,'Padding','same','Stride',1,'Name','bridge_conv2') 
    batchNormalizationLayer('Name','bridge_upconv_BN')  
    reluLayer('Name','bridge_upconv_relu')
    dropoutLayer(0.5,'Name','bridge_upconv_dropout') 
    transposedConv2dLayer(2,netWidth*8,'Stride',2,'Name','bridge_upconv')
    depthConcatenationLayer(2,'Name','concat_bridge')
    % decoder 
    decoder_block(netWidth*8,'d4')
    decoder_block(netWidth*4,'d3')
    decoder_block(netWidth*2,'d2')
    decoder_block(netWidth*1,'d1')
    decoder_block(netWidth*0.5,'d0')
    %
    batchNormalizationLayer('Name','final_BN')  
    reluLayer('Name','final_relu')    
    convolution2dLayer([1 1],classes,'Padding','same','Stride',[1 1],'BiasL2Factor',10,'Name','final_conv');
    softmaxLayer('Name','softmax')
    Fb_loss_v3('fb classification',beta)
    ];
layers = layerGraph(layers);
layer=skip_connection(netWidth,2,'s1u1');
layers=addLayers(layers,layer);
layer=skip_connection(netWidth*2,2,'s2u1');
layers=addLayers(layers,layer);
layer=skip_connection(netWidth*4,2,'s3u1');
layers=addLayers(layers,layer);
layer=skip_connection(netWidth*8,2,'s4u1');
layers=addLayers(layers,layer);
layers=connect_skip_connections(layers,'convInp','s1u1');
layers=connect_skip_connections(layers,'s1u1','s1u2');
layers=connect_skip_connections(layers,'s1u2','s2u1');
layers=connect_skip_connections(layers,'s2u1','s2u2');
layers=connect_skip_connections(layers,'s2u2','s3u1');
layers=connect_skip_connections(layers,'s3u1','s3u2');
layers=connect_skip_connections(layers,'s3u2','s4u1');
layers=connect_skip_connections(layers,'s4u1','s4u2');
% connect bridge
layers=connectLayers(layers,'s4u2_add','concat_bridge/in2');
% connect long skip connections
layers=connectLayers(layers,'s3u2_add','d4_contac/in2');
layers=connectLayers(layers,'s2u2_add','d3_contac/in2');
layers=connectLayers(layers,'s1u2_add','d2_contac/in2');
layers=connectLayers(layers,'convInp','d1_contac/in2');
%analyzeNetwork(layers);
end