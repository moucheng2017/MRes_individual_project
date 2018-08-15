function [lgraph,networkname]=vgg16_Unet(classes)
%u net using pretrained modified vgg16 backbone
%% encoder stage:
networkname='vgg16_unet';
net=vgg16;
lgraph=net.Layers;
lgraph=layerGraph(lgraph);
% replace all pooling layers with convolutional layers
lgraph = removeLayers(lgraph,{'conv5_1','relu5_1','conv5_2','relu5_2',...
                              'pool5','fc6','relu6','drop6',...
                              'fc7','relu7','drop7','fc8',...
                              'conv5_3','relu5_3',...
                              'prob','output'});
 %% Bridge:
bridge_conv1=convolution2dLayer([3 3],1024,'Padding','same','Stride',[1 1],'Name','bridge_conv1');lgraph = addLayers(lgraph, bridge_conv1);
batch_norm_bridge_1=batchNormalizationLayer('Name','batch-norm-bridge-1');lgraph = addLayers(lgraph,batch_norm_bridge_1);
leaky_bridge_conv1=leakyReluLayer(0.01,'Name','leaky_bridge_1');lgraph = addLayers(lgraph, leaky_bridge_conv1);
drop_bridge_1 = dropoutLayer(0.5,'Name','dropout-bridge-1');lgraph = addLayers(lgraph,drop_bridge_1);
bridge_conv2=convolution2dLayer([3 3],1024,'Padding','same','Stride',[1 1],'Name','bridge_conv2');lgraph = addLayers(lgraph, bridge_conv2);
leaky_bridge_conv2=leakyReluLayer(0.01,'Name','leaky_bridge_2');lgraph = addLayers(lgraph, leaky_bridge_conv2);
drop_bridge_2 = dropoutLayer(0.5,'Name','dropout-bridge-2');lgraph = addLayers(lgraph,drop_bridge_2);
batch_norm_bridge_2=batchNormalizationLayer('Name','batch-norm-bridge-2');lgraph = addLayers(lgraph,batch_norm_bridge_2);
upconv1 = transposedConv2dLayer([2 2],512,'Name','Upconv1','Stride',[2 2]);lgraph = addLayers(lgraph,upconv1);
concatenate1 = depthConcatenationLayer(2,'Name','concat_1');lgraph = addLayers(lgraph,concatenate1);
%
lgraph = connectLayers(lgraph,'pool4','bridge_conv1');
lgraph = connectLayers(lgraph,'bridge_conv1','batch-norm-bridge-1');
lgraph = connectLayers(lgraph,'batch-norm-bridge-1','leaky_bridge_1');
lgraph = connectLayers(lgraph,'leaky_bridge_1','dropout-bridge-1');
lgraph = connectLayers(lgraph,'dropout-bridge-1','bridge_conv2');
lgraph = connectLayers(lgraph,'bridge_conv2','batch-norm-bridge-2');
lgraph = connectLayers(lgraph,'batch-norm-bridge-2','leaky_bridge_2');
lgraph = connectLayers(lgraph,'leaky_bridge_2','dropout-bridge-2');
lgraph = connectLayers(lgraph,'dropout-bridge-2','Upconv1');
lgraph = connectLayers(lgraph,'Upconv1','concat_1/in1');
lgraph = connectLayers(lgraph,'relu4_3','concat_1/in2');
%% decoder stage:
%decoder stage1
decoder_s1_conv1=convolution2dLayer([3 3],512,'Padding','same','Stride',[1 1],'Name','de_stage1_conv1');
lgraph = addLayers(lgraph,decoder_s1_conv1);
leakyrelulayer_de_stage1_con1=leakyReluLayer(0.01,'Name','leaky_de_stage1_con1');
lgraph = addLayers(lgraph,leakyrelulayer_de_stage1_con1);
drop_de_s1_1 = dropoutLayer(0.2,'Name','dropout-de-stage1-1');
lgraph = addLayers(lgraph,drop_de_s1_1);
batch_norm_de_s1_con1=batchNormalizationLayer('Name','batch-norm-decoder-stage1-conv1');
lgraph = addLayers(lgraph,batch_norm_de_s1_con1);
upconv2 = transposedConv2dLayer([2 2],256,'Name','Upconv2','Stride',[2 2]);
lgraph = addLayers(lgraph,upconv2);
concatenate2 = depthConcatenationLayer(2,'Name','concat_2');
lgraph = addLayers(lgraph,concatenate2);
%
lgraph = connectLayers(lgraph,'concat_1','de_stage1_conv1');
lgraph = connectLayers(lgraph,'de_stage1_conv1','batch-norm-decoder-stage1-conv1');
lgraph = connectLayers(lgraph,'batch-norm-decoder-stage1-conv1','leaky_de_stage1_con1');
lgraph = connectLayers(lgraph,'leaky_de_stage1_con1','dropout-de-stage1-1');
lgraph = connectLayers(lgraph,'dropout-de-stage1-1','Upconv2');
lgraph = connectLayers(lgraph,'Upconv2','concat_2/in1');
lgraph = connectLayers(lgraph,'relu3_3','concat_2/in2');
%decoder stage2
decoder_s2_conv1=convolution2dLayer([3 3],256,'Padding','same','Stride',[1 1],'Name','de_stage2_conv1');
lgraph = addLayers(lgraph,decoder_s2_conv1);
leakyrelulayer_de_stage2_con1=leakyReluLayer(0.01,'Name','leaky_de_stage2_con1');
lgraph = addLayers(lgraph,leakyrelulayer_de_stage2_con1);
drop_de_s2_1 = dropoutLayer(0.2,'Name','dropout-de-stage2-1');
lgraph = addLayers(lgraph,drop_de_s2_1);
batch_norm_de_s2_con1=batchNormalizationLayer('Name','batch-norm-decoder-stage2-conv1');
lgraph = addLayers(lgraph,batch_norm_de_s2_con1);
upconv3 = transposedConv2dLayer([2 2],128,'Name','Upconv3','Stride',[2 2]);
lgraph = addLayers(lgraph,upconv3);
concatenate3 = depthConcatenationLayer(2,'Name','concat_3');
lgraph = addLayers(lgraph,concatenate3);
%
lgraph = connectLayers(lgraph,'concat_2','de_stage2_conv1');
lgraph = connectLayers(lgraph,'de_stage2_conv1','batch-norm-decoder-stage2-conv1');
lgraph = connectLayers(lgraph,'batch-norm-decoder-stage2-conv1','leaky_de_stage2_con1');
lgraph = connectLayers(lgraph,'leaky_de_stage2_con1','dropout-de-stage2-1');
lgraph = connectLayers(lgraph,'dropout-de-stage2-1','Upconv3');
lgraph = connectLayers(lgraph,'Upconv3','concat_3/in1');
lgraph = connectLayers(lgraph,'relu2_2','concat_3/in2');
% decoder stage3
decoder_s3_conv1=convolution2dLayer([3 3],128,'Padding','same','Stride',[1 1],'Name','de_stage3_conv1');
lgraph = addLayers(lgraph,decoder_s3_conv1);
leakyrelulayer_de_stage3_con1=leakyReluLayer(0.01,'Name','leaky_de_stage3_con1');
lgraph = addLayers(lgraph,leakyrelulayer_de_stage3_con1);
drop_de_s3_1 = dropoutLayer(0.2,'Name','dropout-de-stage3-1');
lgraph = addLayers(lgraph,drop_de_s3_1);
batch_norm_de_s3_con1=batchNormalizationLayer('Name','batch-norm-decoder-stage3-conv1');
lgraph = addLayers(lgraph,batch_norm_de_s3_con1);
upconv4 = transposedConv2dLayer([2 2],64,'Name','Upconv4','Stride',[2 2]);
lgraph = addLayers(lgraph,upconv4);
concatenate4 = depthConcatenationLayer(2,'Name','concat_4');
lgraph = addLayers(lgraph,concatenate4);
%
lgraph = connectLayers(lgraph,'concat_3','de_stage3_conv1');
lgraph = connectLayers(lgraph,'de_stage3_conv1','batch-norm-decoder-stage3-conv1');
lgraph = connectLayers(lgraph,'batch-norm-decoder-stage3-conv1','leaky_de_stage3_con1');
lgraph = connectLayers(lgraph,'leaky_de_stage3_con1','dropout-de-stage3-1');
lgraph = connectLayers(lgraph,'dropout-de-stage3-1','Upconv4');
lgraph = connectLayers(lgraph,'Upconv4','concat_4/in1');
lgraph = connectLayers(lgraph,'relu1_2','concat_4/in2');
%% stage 4
decoder_s4_conv1=convolution2dLayer([3 3],64,'Padding','same','Stride',[1 1],'Name','de_stage4_conv1');
lgraph = addLayers(lgraph,decoder_s4_conv1);
final_s4_conv=convolution2dLayer([1 1],classes,'Padding','same','Stride',[1 1],'Name','final_conv');
lgraph = addLayers(lgraph,final_s4_conv);
softmaxlayer = softmaxLayer('Name','softm');
lgraph = addLayers(lgraph,softmaxlayer);
classificationlayer = pixelClassificationLayer('Name','classification');
lgraph = addLayers(lgraph,classificationlayer);
batch_norm_final=batchNormalizationLayer('Name','batch-norm-final');
lgraph = addLayers(lgraph,batch_norm_final);
leaky_final=leakyReluLayer(0.01,'Name','leaky_final_stage');
lgraph = addLayers(lgraph, leaky_final);
drop_final = dropoutLayer(0.5,'Name','dropout-final-stage');
lgraph = addLayers(lgraph,drop_final);
%
lgraph = connectLayers(lgraph,'concat_4','de_stage4_conv1');
lgraph = connectLayers(lgraph,'de_stage4_conv1','batch-norm-final');
lgraph = connectLayers(lgraph,'batch-norm-final','leaky_final_stage');
lgraph = connectLayers(lgraph,'leaky_final_stage','dropout-final-stage');
lgraph = connectLayers(lgraph,'dropout-final-stage','final_conv');
lgraph = connectLayers(lgraph,'final_conv','softm');
lgraph = connectLayers(lgraph,'softm','classification');
%% add batch normalisation in encoder part
%stage2
lgraph = disconnectLayers(lgraph,'relu2_1','conv2_2');
drop_s2_1 = dropoutLayer(0.2,'Name','dropout-stage2-1');
lgraph = addLayers(lgraph,drop_s2_1);
batch_norm1=batchNormalizationLayer('Name','batch-norm-stage2-1');
lgraph = addLayers(lgraph,batch_norm1);
lgraph = disconnectLayers(lgraph,'relu2_2','pool2');
lgraph = disconnectLayers(lgraph,'relu2_2','concat_3/in2');
drop_s2_2 = dropoutLayer(0.2,'Name','dropout-stage2-2');
lgraph = addLayers(lgraph,drop_s2_2);
batch_norm2=batchNormalizationLayer('Name','batch-norm-stage2-2');
lgraph = addLayers(lgraph,batch_norm2);
%
lgraph = connectLayers(lgraph,'relu2_2','dropout-stage2-2');
lgraph = connectLayers(lgraph,'dropout-stage2-1','batch-norm-stage2-1');
lgraph = connectLayers(lgraph,'batch-norm-stage2-1','conv2_2');
lgraph = connectLayers(lgraph,'relu2_1','dropout-stage2-1');
lgraph = connectLayers(lgraph,'dropout-stage2-2','batch-norm-stage2-2');
lgraph = connectLayers(lgraph,'batch-norm-stage2-2','pool2');
lgraph = connectLayers(lgraph,'batch-norm-stage2-2','concat_3/in2');
% disconnect layers
%
lgraph = disconnectLayers(lgraph,'conv2_1','relu2_1');
lgraph = disconnectLayers(lgraph,'relu2_1','dropout-stage2-1');
lgraph = disconnectLayers(lgraph,'dropout-stage2-1','batch-norm-stage2-1');
lgraph = disconnectLayers(lgraph,'batch-norm-stage2-1','conv2_2');
lgraph = disconnectLayers(lgraph,'conv2_2','relu2_2');
lgraph = disconnectLayers(lgraph,'relu2_2','dropout-stage2-2');
lgraph = disconnectLayers(lgraph,'dropout-stage2-2','batch-norm-stage2-2');
lgraph = disconnectLayers(lgraph,'batch-norm-stage2-2','pool2');
lgraph = disconnectLayers(lgraph,'batch-norm-stage2-2','concat_3/in2');
% connect layers
lgraph = connectLayers(lgraph,'conv2_1','batch-norm-stage2-1');
lgraph = connectLayers(lgraph,'batch-norm-stage2-1','relu2_1');
lgraph = connectLayers(lgraph,'relu2_1','dropout-stage2-1');
lgraph = connectLayers(lgraph,'dropout-stage2-1','conv2_2');
lgraph = connectLayers(lgraph,'conv2_2','batch-norm-stage2-2');
lgraph = connectLayers(lgraph,'batch-norm-stage2-2','relu2_2');
lgraph = connectLayers(lgraph,'relu2_2','dropout-stage2-2');
lgraph = connectLayers(lgraph,'dropout-stage2-2','pool2');
lgraph = connectLayers(lgraph,'dropout-stage2-2','concat_3/in2');
%
% add batch normalisation stage3
lgraph = disconnectLayers(lgraph,'relu3_1','conv3_2');
drop_s3_1 = dropoutLayer(0.2,'Name','dropout-stage3-1');
lgraph = addLayers(lgraph,drop_s3_1);
lgraph = connectLayers(lgraph,'relu3_1','dropout-stage3-1');
batch_norm3=batchNormalizationLayer('Name','batch-norm-stage3-1');
lgraph = addLayers(lgraph,batch_norm3);
lgraph = connectLayers(lgraph,'dropout-stage3-1','batch-norm-stage3-1');
lgraph = connectLayers(lgraph,'batch-norm-stage3-1','conv3_2');
lgraph = removeLayers(lgraph,{'conv3_3','relu3_3'});
batch_norm4=batchNormalizationLayer('Name','batch-norm-stage3-2');
lgraph = addLayers(lgraph,batch_norm4);
drop_s3_2 = dropoutLayer(0.2,'Name','dropout-stage3-2');
lgraph = addLayers(lgraph,drop_s3_2);
lgraph = connectLayers(lgraph,'relu3_2','dropout-stage3-2');
lgraph = connectLayers(lgraph,'dropout-stage3-2','batch-norm-stage3-2');
lgraph = connectLayers(lgraph,'batch-norm-stage3-2','pool3');
lgraph = connectLayers(lgraph,'batch-norm-stage3-2','concat_2/in2');
% disconnect layers
%
lgraph = disconnectLayers(lgraph,'conv3_1','relu3_1');
lgraph = disconnectLayers(lgraph,'relu3_1','dropout-stage3-1');
lgraph = disconnectLayers(lgraph,'dropout-stage3-1','batch-norm-stage3-1');
lgraph = disconnectLayers(lgraph,'batch-norm-stage3-1','conv3_2');
lgraph = disconnectLayers(lgraph,'conv3_2','relu3_2');
lgraph = disconnectLayers(lgraph,'relu3_2','dropout-stage3-2');
lgraph = disconnectLayers(lgraph,'dropout-stage3-2','batch-norm-stage3-2');
lgraph = disconnectLayers(lgraph,'batch-norm-stage3-2','pool3');
lgraph = disconnectLayers(lgraph,'batch-norm-stage3-2','concat_2/in2');
% connect layers
lgraph = connectLayers(lgraph,'conv3_1','batch-norm-stage3-1');
lgraph = connectLayers(lgraph,'batch-norm-stage3-1','relu3_1');
lgraph = connectLayers(lgraph,'relu3_1','dropout-stage3-1');
lgraph = connectLayers(lgraph,'dropout-stage3-1','conv3_2');
lgraph = connectLayers(lgraph,'conv3_2','batch-norm-stage3-2');
lgraph = connectLayers(lgraph,'batch-norm-stage3-2','relu3_2');
lgraph = connectLayers(lgraph,'relu3_2','dropout-stage3-2');
lgraph = connectLayers(lgraph,'dropout-stage3-2','pool3');
lgraph = connectLayers(lgraph,'dropout-stage3-2','concat_2/in2');
%
% add batch normalisation stage4
lgraph = disconnectLayers(lgraph,'relu4_1','conv4_2');
drop_s4_1 = dropoutLayer(0.2,'Name','dropout-stage4-1');
lgraph = addLayers(lgraph,drop_s4_1);
lgraph = connectLayers(lgraph,'relu4_1','dropout-stage4-1');
batch_norm5=batchNormalizationLayer('Name','batch-norm-stage4-1');
lgraph = addLayers(lgraph,batch_norm5);
lgraph = connectLayers(lgraph,'dropout-stage4-1','batch-norm-stage4-1');
lgraph = connectLayers(lgraph,'batch-norm-stage4-1','conv4_2');
lgraph = removeLayers(lgraph,{'conv4_3','relu4_3'});
batch_norm6=batchNormalizationLayer('Name','batch-norm-stage4-2');
lgraph = addLayers(lgraph,batch_norm6);
drop_s4_2 = dropoutLayer(0.2,'Name','dropout-stage4-2');
lgraph = addLayers(lgraph,drop_s4_2);
lgraph = connectLayers(lgraph,'relu4_2','dropout-stage4-2');
lgraph = connectLayers(lgraph,'dropout-stage4-2','batch-norm-stage4-2');
lgraph = connectLayers(lgraph,'batch-norm-stage4-2','pool4');
lgraph = connectLayers(lgraph,'batch-norm-stage4-2','concat_1/in2');
% disconnect layers
%
lgraph = disconnectLayers(lgraph,'conv4_1','relu4_1');
lgraph = disconnectLayers(lgraph,'relu4_1','dropout-stage4-1');
lgraph = disconnectLayers(lgraph,'dropout-stage4-1','batch-norm-stage4-1');
lgraph = disconnectLayers(lgraph,'batch-norm-stage4-1','conv4_2');
lgraph = disconnectLayers(lgraph,'conv4_2','relu4_2');
lgraph = disconnectLayers(lgraph,'relu4_2','dropout-stage4-2');
lgraph = disconnectLayers(lgraph,'dropout-stage4-2','batch-norm-stage4-2');
lgraph = disconnectLayers(lgraph,'batch-norm-stage4-2','pool4');
lgraph = disconnectLayers(lgraph,'batch-norm-stage4-2','concat_1/in2');
% connect layers
lgraph = connectLayers(lgraph,'conv4_1','batch-norm-stage4-1');
lgraph = connectLayers(lgraph,'batch-norm-stage4-1','relu4_1');
lgraph = connectLayers(lgraph,'relu4_1','dropout-stage4-1');
lgraph = connectLayers(lgraph,'dropout-stage4-1','conv4_2');
lgraph = connectLayers(lgraph,'conv4_2','batch-norm-stage4-2');
lgraph = connectLayers(lgraph,'batch-norm-stage4-2','relu4_2');
lgraph = connectLayers(lgraph,'relu4_2','dropout-stage4-2');
lgraph = connectLayers(lgraph,'dropout-stage4-2','pool4');
lgraph = connectLayers(lgraph,'dropout-stage4-2','concat_1/in2');
%
analyzeNetwork(lgraph);
end