function [net,networkname]=leaky_relu_Unet()
networkname='leaky_relu_Unet';
% 1: use leaky rely
net = createUnet(4);
%stage2 down
net = disconnectLayers(net,'Encoder-Stage-2-ReLU-1','Encoder-Stage-2-Conv-2');
drop2=dropoutLayer(0.1,'Name','dropout-stage2');
net = addLayers(net,drop2);
net = connectLayers(net,'Encoder-Stage-2-ReLU-1','dropout-stage2');
net = connectLayers(net,'dropout-stage2','Encoder-Stage-2-Conv-2');
%stage3 down
net = disconnectLayers(net,'Encoder-Stage-3-ReLU-1','Encoder-Stage-3-Conv-2');
drop3=dropoutLayer(0.2,'Name','dropout-stage3');
net = addLayers(net,drop3);
net = connectLayers(net,'Encoder-Stage-3-ReLU-1','dropout-stage3');
net = connectLayers(net,'dropout-stage3','Encoder-Stage-3-Conv-2');
%stage4 down
net = disconnectLayers(net,'Encoder-Stage-4-ReLU-1','Encoder-Stage-4-Conv-2');
drop4=dropoutLayer(0.3,'Name','dropout-stage4');
net = addLayers(net,drop4);
net = connectLayers(net,'Encoder-Stage-4-ReLU-1','dropout-stage4');
net = connectLayers(net,'dropout-stage4','Encoder-Stage-4-Conv-2');
%stage1 up
net = disconnectLayers(net,'Decoder-Stage-1-ReLU-1','Decoder-Stage-1-Conv-2');
drop5=dropoutLayer(0.3,'Name','dropout-de-stage1');
net = addLayers(net,drop5);
net = connectLayers(net,'Decoder-Stage-1-ReLU-1','dropout-de-stage1');
net = connectLayers(net,'dropout-de-stage1','Decoder-Stage-1-Conv-2');
%stage2 up
net = disconnectLayers(net,'Decoder-Stage-2-ReLU-1','Decoder-Stage-2-Conv-2');
drop6=dropoutLayer(0.3,'Name','dropout-de-stage2');
net = addLayers(net,drop6);
net = connectLayers(net,'Decoder-Stage-2-ReLU-1','dropout-de-stage2');
net = connectLayers(net,'dropout-de-stage2','Decoder-Stage-2-Conv-2');
%stage3 up
net = disconnectLayers(net,'Decoder-Stage-3-ReLU-1','Decoder-Stage-3-Conv-2');
drop7=dropoutLayer(0.3,'Name','dropout-de-stage3');
net = addLayers(net,drop7);
net = connectLayers(net,'Decoder-Stage-3-ReLU-1','dropout-de-stage3');
net = connectLayers(net,'dropout-de-stage3','Decoder-Stage-3-Conv-2');
%stage4 up
net = disconnectLayers(net,'Decoder-Stage-4-ReLU-1','Decoder-Stage-4-Conv-2');
drop8=dropoutLayer(0.3,'Name','dropout-de-stage4');
net = addLayers(net,drop8);
net = connectLayers(net,'Decoder-Stage-4-ReLU-1','dropout-de-stage4');
net = connectLayers(net,'dropout-de-stage4','Decoder-Stage-4-Conv-2');
%final layers
net = disconnectLayers(net,'Decoder-Stage-4-ReLU-2','Final-ConvolutionLayer');
drop9=dropoutLayer(0.5,'Name','dropout-final');
net = addLayers(net,drop9);
net = connectLayers(net,'Decoder-Stage-4-ReLU-2','dropout-final');
net = connectLayers(net,'dropout-final','Final-ConvolutionLayer');
%
leakyrelulayer1=leakyReluLayer(0.01,'Name','leaky_1');
net = replaceLayer(net,'Encoder-Stage-1-ReLU-1',leakyrelulayer1);
leakyrelulayer2=leakyReluLayer(0.01,'Name','leaky_2');
net = replaceLayer(net,'Encoder-Stage-1-ReLU-2',leakyrelulayer2);
leakyrelulayer3=leakyReluLayer(0.01,'Name','leaky_3');
net = replaceLayer(net,'Encoder-Stage-2-ReLU-1',leakyrelulayer3);
leakyrelulayer4=leakyReluLayer(0.01,'Name','leaky_4');
net = replaceLayer(net,'Encoder-Stage-2-ReLU-2',leakyrelulayer4);
leakyrelulayer5=leakyReluLayer(0.01,'Name','leaky_5');
net = replaceLayer(net,'Encoder-Stage-3-ReLU-1',leakyrelulayer5);
leakyrelulayer6=leakyReluLayer(0.01,'Name','leaky_6');
net = replaceLayer(net,'Encoder-Stage-3-ReLU-2',leakyrelulayer6);
leakyrelulayer7=leakyReluLayer(0.01,'Name','leaky_7');
net = replaceLayer(net,'Encoder-Stage-4-ReLU-1',leakyrelulayer7);
leakyrelulayer8=leakyReluLayer(0.01,'Name','leaky_8');
net = replaceLayer(net,'Encoder-Stage-4-ReLU-2',leakyrelulayer8);
leakyrelulayer9=leakyReluLayer(0.01,'Name','leaky_9');
net = replaceLayer(net,'Bridge-ReLU-1',leakyrelulayer9);
leakyrelulayer10=leakyReluLayer(0.01,'Name','leaky_10');
net = replaceLayer(net,'Bridge-ReLU-2',leakyrelulayer10);
leakyrelulayer11=leakyReluLayer(0.01,'Name','leaky_11');
net = replaceLayer(net,'Decoder-Stage-1-UpReLU',leakyrelulayer11);
leakyrelulayer12=leakyReluLayer(0.01,'Name','leaky_12');
net = replaceLayer(net,'Decoder-Stage-1-ReLU-1',leakyrelulayer12);
leakyrelulayer13=leakyReluLayer(0.01,'Name','leaky_13');
net = replaceLayer(net,'Decoder-Stage-1-ReLU-2',leakyrelulayer13);
leakyrelulayer14=leakyReluLayer(0.01,'Name','leaky_14');
net = replaceLayer(net,'Decoder-Stage-2-UpReLU',leakyrelulayer14);
leakyrelulayer15=leakyReluLayer(0.01,'Name','leaky_15');
net = replaceLayer(net,'Decoder-Stage-2-ReLU-1',leakyrelulayer15);
leakyrelulayer16=leakyReluLayer(0.01,'Name','leaky_16');
net = replaceLayer(net,'Decoder-Stage-2-ReLU-2',leakyrelulayer16);
leakyrelulayer17=leakyReluLayer(0.01,'Name','leaky_17');
net = replaceLayer(net,'Decoder-Stage-3-UpReLU',leakyrelulayer17);
leakyrelulayer18=leakyReluLayer(0.01,'Name','leaky_18');
net = replaceLayer(net,'Decoder-Stage-3-ReLU-1',leakyrelulayer18);
leakyrelulayer19=leakyReluLayer(0.01,'Name','leaky_19');
net = replaceLayer(net,'Decoder-Stage-3-ReLU-2',leakyrelulayer19);
leakyrelulayer20=leakyReluLayer(0.01,'Name','leaky_20');
net = replaceLayer(net,'Decoder-Stage-4-UpReLU',leakyrelulayer20);
leakyrelulayer21=leakyReluLayer(0.01,'Name','leaky_21');
net = replaceLayer(net,'Decoder-Stage-4-ReLU-1',leakyrelulayer21);
leakyrelulayer22=leakyReluLayer(0.01,'Name','leaky_22');
net = replaceLayer(net,'Decoder-Stage-4-ReLU-2',leakyrelulayer22);
%{
conv_pooling1=convolution2dLayer([2 2],56,'Padding','same','Stride',2,'Name','conv1_transition');
net = replaceLayer(net,'Encoder-Stage-1-MaxPool',conv_pooling1);
conv_pooling2=convolution2dLayer([2 2],128,'Padding','same','Stride',2,'Name','conv2_transition');
net = replaceLayer(net,'Encoder-Stage-2-MaxPool',conv_pooling2);
conv_pooling3=convolution2dLayer([2 2],256,'Padding','same','Stride',2,'Name','conv3_transition');
net = replaceLayer(net,'Encoder-Stage-3-MaxPool',conv_pooling3);
conv_pooling4=convolution2dLayer([2 2],512,'Padding','same','Stride',2,'Name','conv4_transition');
net = replaceLayer(net,'Encoder-Stage-4-MaxPool',conv_pooling4);
%}
% add batch normalization layers
%
net = disconnectLayers(net,'Encoder-Stage-2-Conv-1','leaky_3');
batch_norm1=batchNormalizationLayer('Name','batch-norm-stage2-1');
net = addLayers(net,batch_norm1);
net = connectLayers(net,'Encoder-Stage-2-Conv-1','batch-norm-stage2-1');
net = connectLayers(net,'batch-norm-stage2-1','leaky_3');
%
net = disconnectLayers(net,'Encoder-Stage-2-Conv-2','leaky_4');
batch_norm2=batchNormalizationLayer('Name','batch-norm-stage2-2');
net = addLayers(net,batch_norm2);
net = connectLayers(net,'Encoder-Stage-2-Conv-2','batch-norm-stage2-2');
net = connectLayers(net,'batch-norm-stage2-2','leaky_4');
%
%
net = disconnectLayers(net,'Encoder-Stage-3-Conv-1','leaky_5');
batch_norm3=batchNormalizationLayer('Name','batch-norm-stage3-1');
net = addLayers(net,batch_norm3);
net = connectLayers(net,'Encoder-Stage-3-Conv-1','batch-norm-stage3-1');
net = connectLayers(net,'batch-norm-stage3-1','leaky_5');
%
net = disconnectLayers(net,'Encoder-Stage-3-Conv-2','leaky_6');
batch_norm4=batchNormalizationLayer('Name','batch-norm-stage3-2');
net = addLayers(net,batch_norm4);
net = connectLayers(net,'Encoder-Stage-3-Conv-2','batch-norm-stage3-2');
net = connectLayers(net,'batch-norm-stage3-2','leaky_6');
%
net = disconnectLayers(net,'Encoder-Stage-4-Conv-1','leaky_7');
batch_norm5=batchNormalizationLayer('Name','batch-norm-stage4-1');
net = addLayers(net,batch_norm5);
net = connectLayers(net,'Encoder-Stage-4-Conv-1','batch-norm-stage4-1');
net = connectLayers(net,'batch-norm-stage4-1','leaky_7');
%
net = disconnectLayers(net,'Encoder-Stage-4-Conv-2','leaky_8');
batch_norm6=batchNormalizationLayer('Name','batch-norm-stage4-2');
net = addLayers(net,batch_norm6);
net = connectLayers(net,'Encoder-Stage-4-Conv-2','batch-norm-stage4-2');
net = connectLayers(net,'batch-norm-stage4-2','leaky_8');
%
net = disconnectLayers(net,'Bridge-Conv-1','leaky_9');
batch_norm7=batchNormalizationLayer('Name','batch-norm-bridge-1');
net = addLayers(net,batch_norm7);
net = connectLayers(net,'Bridge-Conv-1','batch-norm-bridge-1');
net = connectLayers(net,'batch-norm-bridge-1','leaky_9');
%
net = disconnectLayers(net,'Bridge-Conv-2','leaky_10');
batch_norm8=batchNormalizationLayer('Name','batch-norm-bridge-2');
net = addLayers(net,batch_norm8);
net = connectLayers(net,'Bridge-Conv-2','batch-norm-bridge-2');
net = connectLayers(net,'batch-norm-bridge-2','leaky_10');
%
net = disconnectLayers(net,'Decoder-Stage-1-UpConv','leaky_11');
batch_norm9=batchNormalizationLayer('Name','batch-norm-decoder-upconv1');
net = addLayers(net,batch_norm9);
net = connectLayers(net,'Decoder-Stage-1-UpConv','batch-norm-decoder-upconv1');
net = connectLayers(net,'batch-norm-decoder-upconv1','leaky_11');
%
net = disconnectLayers(net,'Decoder-Stage-1-Conv-1','leaky_12');
batch_norm10=batchNormalizationLayer('Name','batch-norm-decoder-stage1-conv1');
net = addLayers(net,batch_norm10);
net = connectLayers(net,'Decoder-Stage-1-Conv-1','batch-norm-decoder-stage1-conv1');
net = connectLayers(net,'batch-norm-decoder-stage1-conv1','leaky_12');
%
net = disconnectLayers(net,'Decoder-Stage-1-Conv-2','leaky_13');
batch_norm11=batchNormalizationLayer('Name','batch-norm-decoder-stage1-conv2');
net = addLayers(net,batch_norm11);
net = connectLayers(net,'Decoder-Stage-1-Conv-2','batch-norm-decoder-stage1-conv2');
net = connectLayers(net,'batch-norm-decoder-stage1-conv2','leaky_13');
%
net = disconnectLayers(net,'Decoder-Stage-2-UpConv','leaky_14');
batch_norm12=batchNormalizationLayer('Name','batch-norm-decoder-stage2-upconv');
net = addLayers(net,batch_norm12);
net = connectLayers(net,'Decoder-Stage-2-UpConv','batch-norm-decoder-stage2-upconv');
net = connectLayers(net,'batch-norm-decoder-stage2-upconv','leaky_14');
%
net = disconnectLayers(net,'Decoder-Stage-2-Conv-1','leaky_15');
batch_norm13=batchNormalizationLayer('Name','batch-norm-decoder-stage2-conv1');
net = addLayers(net,batch_norm13);
net = connectLayers(net,'Decoder-Stage-2-Conv-1','batch-norm-decoder-stage2-conv1');
net = connectLayers(net,'batch-norm-decoder-stage2-conv1','leaky_15');
%
net = disconnectLayers(net,'Decoder-Stage-2-Conv-2','leaky_16');
batch_norm14=batchNormalizationLayer('Name','batch-norm-decoder-stage2-conv2');
net = addLayers(net,batch_norm14);
net = connectLayers(net,'Decoder-Stage-2-Conv-2','batch-norm-decoder-stage2-conv2');
net = connectLayers(net,'batch-norm-decoder-stage2-conv2','leaky_16');
%
net = disconnectLayers(net,'Decoder-Stage-3-UpConv','leaky_17');
batch_norm15=batchNormalizationLayer('Name','batch-norm-decoder-stage3-upconv');
net = addLayers(net,batch_norm15);
net = connectLayers(net,'Decoder-Stage-3-UpConv','batch-norm-decoder-stage3-upconv');
net = connectLayers(net,'batch-norm-decoder-stage3-upconv','leaky_17');
%
net = disconnectLayers(net,'Decoder-Stage-3-Conv-1','leaky_18');
batch_norm16=batchNormalizationLayer('Name','batch-norm-decoder-stage3-conv1');
net = addLayers(net,batch_norm16);
net = connectLayers(net,'Decoder-Stage-3-Conv-1','batch-norm-decoder-stage3-conv1');
net = connectLayers(net,'batch-norm-decoder-stage3-conv1','leaky_18');
%
net = disconnectLayers(net,'Decoder-Stage-3-Conv-2','leaky_19');
batch_norm17=batchNormalizationLayer('Name','batch-norm-decoder-stage3-conv2');
net = addLayers(net,batch_norm17);
net = connectLayers(net,'Decoder-Stage-3-Conv-2','batch-norm-decoder-stage3-conv2');
net = connectLayers(net,'batch-norm-decoder-stage3-conv2','leaky_19');
%
net = disconnectLayers(net,'Decoder-Stage-4-UpConv','leaky_20');
batch_norm18=batchNormalizationLayer('Name','batch-norm-decoder-stage4-upconv');
net = addLayers(net,batch_norm18);
net = connectLayers(net,'Decoder-Stage-4-UpConv','batch-norm-decoder-stage4-upconv');
net = connectLayers(net,'batch-norm-decoder-stage4-upconv','leaky_20');
net = disconnectLayers(net,'Decoder-Stage-4-Conv-1','leaky_21');
batch_norm19=batchNormalizationLayer('Name','batch-norm-decoder-stage4-conv1');
net = addLayers(net,batch_norm19);
net = connectLayers(net,'Decoder-Stage-4-Conv-1','batch-norm-decoder-stage4-conv1');
net = connectLayers(net,'batch-norm-decoder-stage4-conv1','leaky_21');
%
net = disconnectLayers(net,'Decoder-Stage-4-Conv-2','leaky_22');
batch_norm20=batchNormalizationLayer('Name','batch-norm-decoder-stage4-conv2');
net = addLayers(net,batch_norm20);
net = connectLayers(net,'Decoder-Stage-4-Conv-2','batch-norm-decoder-stage4-conv2');
net = connectLayers(net,'batch-norm-decoder-stage4-conv2','leaky_22');
%
%analyzeNetwork(net);
end