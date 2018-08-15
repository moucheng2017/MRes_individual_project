function lgraph=vgg8_Unet()
lgraph=vgg16_Unet;
% remove layers
lgraph = removeLayers(lgraph,{'pool3','conv4_1','batch-norm-stage4-1',...
                              'relu4_1','dropout-stage4-1','conv4_2','batch-norm-stage4-2','relu4_2','dropout-stage4-2',...
                              'concat_1','de_stage1_conv1','batch-norm-decoder-stage1-conv1','leaky_de_stage1_con1','dropout-de-stage1-1',...
                              'Upconv2'});
new_upconv1=transposedConv2dLayer([2 2],256,'Name','Upconv1','Stride',[2 2]);
new_bridge_conv1=convolution2dLayer([3 3],512,'Padding','same','Stride',[1 1],'Name','new_bridge_conv1');
new_bridge_conv2=convolution2dLayer([3 3],512,'Padding','same','Stride',[1 1],'Name','new_bridge_conv2');

lgraph = replaceLayer(lgraph,'bridge_conv1',new_bridge_conv1);
lgraph = replaceLayer(lgraph,'bridge_conv2',new_bridge_conv2);
lgraph = replaceLayer(lgraph,'Upconv1',new_upconv1);
lgraph = connectLayers(lgraph,'dropout-stage3-2','pool4');
lgraph = connectLayers(lgraph,'Upconv1','concat_2/in1');
%analyzeNetwork(lgraph);
end