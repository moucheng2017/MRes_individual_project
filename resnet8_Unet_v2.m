function [layers,networkname]=resnet8_Unet_v2(classes,netWidth,height,width,beta)
% skip connections in decoder part
networkname='resnet8_Unet_v2';
% residual 18 
%classes=2;
%netWidth=32;
layers = [
    imageInputLayer([height width 3],'Name','input','Normalization','None')
    convolution2dLayer(3,netWidth,'Padding','same','Stride',1,'Name','convInp0')  
    reluLayer('Name','bridge_Inp')
    batchNormalizationLayer('Name','Inp_BN1')
    convolution2dLayer(3,netWidth,'Padding','same','Stride',1,'Name','convInp')
    %encoder s1
    residual_block(netWidth,'s1u1',1)
    %encoder s2
    residual_block(netWidth*2,'s2u1',1)
    %encoder s3
    residual_block(netWidth*4,'s3u1',1)
    %encoder s4
    residual_block(netWidth*8,'s4u1',1)
    % bridge
    %maxPooling2dLayer(2,'Stride',2,'Padding',[0 0 0 0],'Name','bridge_maxpooling')
    batchNormalizationLayer('Name','bridge_BN1')  
    reluLayer('Name','bridge_relu1')
    convolution2dLayer(3,netWidth*16,'Padding','same','Stride',2,'Name','bridge_conv1')
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
    residual_block_decoder(netWidth*8,'d4')
    residual_block_decoder(netWidth*4,'d3')
    residual_block_decoder(netWidth*2,'d2')
    residual_block_decoder(netWidth*1,'d1')
    residual_block_decoder(netWidth*0.5,'d0')
    %
    batchNormalizationLayer('Name','final_BN')  
    reluLayer('Name','final_relu')    
    convolution2dLayer([1 1],classes,'Padding','same','Stride',[1 1],'BiasL2Factor',10,'Name','final_conv');
    softmaxLayer('Name','softmax')
    Fb_loss_v3('fb classification',beta)
    ];
layers = layerGraph(layers);
% encoder skip connections
layer=skip_connection(netWidth,2,'s1u1');
layers=addLayers(layers,layer);
layer=skip_connection(netWidth*2,2,'s2u1');
layers=addLayers(layers,layer);
layer=skip_connection(netWidth*4,2,'s3u1');
layers=addLayers(layers,layer);
layer=skip_connection(netWidth*8,2,'s4u1');
layers=addLayers(layers,layer);
% decoder skip connections
layer=skip_connection_decoder(netWidth*1,2,'d1');
layers=addLayers(layers,layer);
layer=skip_connection_decoder(netWidth*1,2,'d2');
layers=addLayers(layers,layer);
layer=skip_connection_decoder(netWidth*2,2,'d3');
layers=addLayers(layers,layer);
layer=skip_connection_decoder(netWidth*4,2,'d4');
layers=addLayers(layers,layer);
% connect decoder
layers=connectLayers(layers,'concat_bridge','d4_skip_BN_decoder');
layers=connectLayers(layers,'d4_upconv_decoder','d4_add_decoder/in2');
layers=connectLayers(layers,'d4_contac','d3_skip_BN_decoder');
layers=connectLayers(layers,'d3_upconv_decoder','d3_add_decoder/in2');
layers=connectLayers(layers,'d3_contac','d2_skip_BN_decoder');
layers=connectLayers(layers,'d2_upconv_decoder','d2_add_decoder/in2');
layers=connectLayers(layers,'d2_contac','d1_skip_BN_decoder');
layers=connectLayers(layers,'d1_upconv_decoder','d1_add_decoder/in2');
% connect encoder
layers=connect_skip_connections(layers,'convInp','s1u1');
layers=connect_skip_connections(layers,'s1u1','s2u1');
layers=connect_skip_connections(layers,'s2u1','s3u1');
layers=connect_skip_connections(layers,'s3u1','s4u1');
% connect bridge
layers=connectLayers(layers,'s4u1_add','concat_bridge/in2');
% connect long skip connections
layers=connectLayers(layers,'s3u1_add','d4_contac/in2');
layers=connectLayers(layers,'s2u1_add','d3_contac/in2');
layers=connectLayers(layers,'s1u1_add','d2_contac/in2');
layers=connectLayers(layers,'convInp','d1_contac/in2');
%analyzeNetwork(layers);
end